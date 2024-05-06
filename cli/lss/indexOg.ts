/// <reference types="bun" />

import path from 'node:path'
import { Glob } from 'bun'
import os from 'node:os'
import gg from 'gluegun'

try {
	main()
} catch (error) {
	gg.print.error(error)
	process.exit(1)
}

const exec = async (cmd: string | string[]) => {
	if (!Array.isArray(cmd)) cmd = [cmd]

	const proc = Bun.spawn([
		'/bin/zsh',
		'-c',
		`source ${path.join(
			os.homedir(),
			'dev/scripts/',
			'source.sh'
		)} ; ${cmd.join(' ')}`
	])

	const text = await new Response(proc.stdout).text() //=>

	console.log(text) //=>
}

async function main() {
	const home = os.homedir()

	const scripts = path.join(home, 'dev/scripts/shell/')

	const glob = new Glob('*.sh')

	let data = [] as { text: string; description: string }[]

	for await (const file of glob.scan(scripts)) {
		const text = file.replace('.sh', '')

		let description = ''
		// Read the file, and get the first comment (# ... or #? ...) that isn't a shebang
		const fileContent = await Bun.file(`${scripts}${file}`).text()

		const lines = fileContent.split('\n')
		for (const line of lines) {
			if (line.match(/^#(?!.*!)/)) {
				description = line.replace(/#\??/, '').trim()
				break
			}
		}

		data.push({ text, description })
	}

	const longestText = data.reduce(
		(acc, cur) => (cur.text.length > acc ? cur.text.length : acc),
		0
	)
	const c = gg.print.colors.cyan
	const ital = gg.print.colors.italic
	const pad = (str: string) => ' '.repeat(longestText + 3 - str.length)

	const choices = data.map(({ text, description }) => {
		return c(text) + pad(text) + ital(description)
	})

	// multiple choice
	const scriptPrompt = {
		type: 'select',
		name: 'script',
		message: 'scripts',
		choices
	}

	const res = await gg.prompt.ask([scriptPrompt])
	const script = gg.print.colors.strip(res.script)

	const fn = script.toString().split(' ')[0]

	const argsPrompt = {
		type: 'input',
		name: 'args',
		message: 'args'
	}

	const { args } = await gg.prompt.ask([argsPrompt])

	await exec([fn, args])
}
