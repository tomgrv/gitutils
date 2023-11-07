/** @format */

import os from 'os'
import { simpleGit } from 'simple-git'
import chalk from 'chalk'
import fs from 'fs'
import { dirname, resolve } from 'path'
import { fileURLToPath } from 'url'
import path from 'path'

// Determine the machine type
let machine
switch (os.type()) {
    case 'Darwin':
        machine = 'Mac'
        break
    case 'Linux':
        machine = 'Linux'
        break
    case 'Windows_NT':
        machine = 'MinGw'
        break
    default:
        machine = `UNKNOWN:${os.type()}`
}

// Display the machine type
console.log(chalk.yellow(`Machine: ${machine}`))

// Initialize git
const git = simpleGit(process.cwd())

// Configure repo for Mac
if (machine === 'Mac') {
    console.log(chalk.blue('Configuring git for Mac...'))
    // Add your Mac-specific configuration here
}

// Configure repo for Linux
if (machine === 'Linux') {
    console.log(chalk.blue('Configuring git for Linux...'))
    // Add your Linux-specific configuration here
}

// Configure repo for MinGw/Windows
if (machine === 'MinGw') {
    console.log(chalk.blue('Configuring git for MinGw...'))
    git.addConfig('core.filemode', 'false')
    git.addConfig('credential.helper', 'wincred')
}

// Configure git globally for all platforms
console.log(chalk.blue('Configuring git globally for all platforms...'))

// Add your string based configuration here
git.addConfig('core.editor', 'code --wait')
git.addConfig('core.autocrlf', 'input')

// Get the directory of this script
const scriptsDir = dirname(fileURLToPath(import.meta.url))

// Configure git aliases according to aliases in the aliases.json file
console.log(chalk.blue('Configuring git aliases according to aliases.json...'))

// Read the aliases.json file
const aliases = JSON.parse(
    fs.readFileSync(resolve(scriptsDir, 'alias.json'), 'utf8')
)

// Add aliases
Object.keys(aliases).forEach((alias) => {
    console.log(chalk.yellow(`Adding alias for ${alias}  ...`))
    git.addConfig(`alias.${alias}`, `!sh -c "${aliases[alias]}" - `)
})

// Configure git aliases for scripts in folder
console.log(chalk.blue('Configuring git aliases for scripts in folder...'))

// Add aliases for all scripts in the folder
fs.readdirSync(scriptsDir)
    .filter((file) => file.startsWith('_') && file.endsWith('.sh'))
    .forEach((file) => {
        const alias = path.basename(file, '.sh').substring(1)
        const script = path.join(scriptsDir, file)
        console.log(chalk.yellow(`Adding alias for ${alias} to ${script} ...`))
        git.addConfig(
            `alias.${alias}`,
            `!sh -c "$(readlink -f '${script}') $* " - `
        )
    })
