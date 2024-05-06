package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/charmbracelet/bubbles/table"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var columns = []table.Column{
	{Title: "Script", Width: 15},
	{Title: "Description", Width: 70},
}

var baseStyle = lipgloss.NewStyle().
	BorderStyle(lipgloss.NormalBorder()).
	BorderForeground(lipgloss.Color("240"))

type model struct {
	table table.Model
	dir   string
}

func (m model) Init() tea.Cmd { return nil }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "esc", "q", "ctrl+c":
			return m, tea.Quit
		case "enter":
			selectedScript := m.table.SelectedRow()[0]
			return m, tea.Batch(
				executeScript(selectedScript),
				// tea.Quit,
			)
		}
	}
	m.table, cmd = m.table.Update(msg)
	return m, cmd
}

func (m model) View() string {
	return baseStyle.Render(m.table.View()) + "\n"
}

func main() {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		fmt.Println("Error getting home directory:", err)
		os.Exit(1)
	}

	scriptsDir := filepath.Join(homeDir, "dev/scripts/shell")
	if _, err := os.Stat(scriptsDir); os.IsNotExist(err) {
		fmt.Println("Scripts directory does not exist:", scriptsDir)
		os.Exit(1)
	}

	scripts, err := listScripts(filepath.Join(scriptsDir, "*.sh"))
	if err != nil {
		fmt.Println("Error listing scripts:", err)
		os.Exit(1)
	}

	rows := make([]table.Row, len(scripts))
	for i, script := range scripts {
		rows[i] = table.Row{script.shortname, script.description}
	}

	t := table.New(
		table.WithColumns(columns),
		table.WithRows(rows),
		table.WithFocused(true),
		table.WithHeight(len(rows)),
	)

	s := table.DefaultStyles()
	s.Header = s.Header.
		BorderStyle(lipgloss.NormalBorder()).
		BorderForeground(lipgloss.Color("240")).
		BorderBottom(true).
		Bold(false)
	s.Selected = s.Selected.
		Foreground(lipgloss.Color("229")).
		Background(lipgloss.Color("57")).
		Bold(false)
	t.SetStyles(s)

	m := model{
		table: t,
		dir:   scriptsDir,
	}

	if _, err := tea.NewProgram(m).Run(); err != nil {
		fmt.Println("Error running program:", err)
		os.Exit(1)
	}
}

type scriptInfo struct {
	name, description, shortname string
}

func listScripts(pattern string) ([]scriptInfo, error) {
	matches, err := filepath.Glob(pattern)
	if err != nil {
		return nil, err
	}

	var scripts []scriptInfo
	for _, file := range matches {
		data, err := os.ReadFile(file)
		if err != nil {
			fmt.Println("Error reading file:", file)
			continue
		}

		lines := strings.Split(string(data), "\n")
		description := ""
		for _, line := range lines {
			if strings.HasPrefix(line, "# ") {
				description = line[2:]
				break
			}
		}

		scripts = append(scripts, scriptInfo{
			name:        filepath.Base(file),
			description: description,
			shortname:   strings.TrimSuffix(filepath.Base(file), filepath.Ext(file)),
		})
	}
	return scripts, nil
}

func executeScript(scriptName string) tea.Cmd {
	return func() tea.Msg {
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Println("Error getting home directory:", err)
			return nil
		}

		// Prepare the command to execute
		cmd := exec.Command("/bin/zsh", "-c", fmt.Sprintf("source %s; %s -h", filepath.Join(home, "dev/scripts/source.sh"), scriptName))

		out, err := cmd.StdoutPipe()
		if err != nil {
			fmt.Println("Error getting stdout pipe:", err)
			return nil
		}

		if err := cmd.Start(); err != nil {
			fmt.Println("Error starting command:", err)
			return nil
		}

		buf := bufio.NewReader(out)
		for {
			line, err := buf.ReadString('\n')
			if err != nil {
				break
			}
			tea.Println(line)
			// fmt.Printf("%s\n", line)
		}

		return nil
	}
}
