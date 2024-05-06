/// <reference types="bun" />

import { intro, outro, select, isCancel, cancel, text } from '@clack/prompts'
import path from 'node:path'
import c from 'picocolors'
import os from 'node:os'

try {
	main()
} catch (error) {
	console.error(error)
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

	const text = await new Response(proc.stdout).text()

	console.log(text)
}

async function main() {
	intro(c.bgCyan(c.black(' run script ')))

	const home = os.homedir()

	const scripts = path.join(home, 'dev/scripts/shell/')
	const glob = new Bun.Glob('*.sh')

	let data = [] as { value: string; label: string; hint?: string }[]

	for await (const file of glob.scan(scripts)) {
		const text = file.replace('.sh', '')
		let description = ''
		const fileContent = await Bun.file(`${scripts}${file}`).text()
		const lines = fileContent.split('\n')
		for (const line of lines) {
			if (line.match(/^#(?!.*!)/)) {
				description = line.replace(/#\??/, '').trim()
				break
			}
		}

		data.push({
			value: text,
			label: c.cyan(text),
			hint: c.italic(description)
		})
	}

	const script = await select({
		message: '',
		options: data
	}) as string

	if (isCancel(script)) {
		cancel('Operation cancelled')
		return process.exit(0)
	}

	const args = await text({
		message: 'args',
		placeholder: 'None'
	})

	if (isCancel(args)) {
		cancel('Operation cancelled')
		return process.exit(0)
	}

	await exec([script, args])

	outro('🏁')

	await new Promise((resolve) => setTimeout(resolve, 1000))
}
