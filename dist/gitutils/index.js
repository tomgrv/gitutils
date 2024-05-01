/** @format */

import os from 'os'
import { dirname, resolve } from 'path'
import { fileURLToPath } from 'url'
import chalk from 'chalk'
import { execSync } from 'child_process'
import { simpleGit } from 'simple-git'
import fs from 'fs'

import loadGitAliases from './alias.js'
import loadGitConfig from './config.js'

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
    // Install gitflow
    console.log(chalk.blue('Installing gitflow...'))
    execSync('npm list -g gitflow || npm i -g gitflow', { stdio: 'inherit' })
}

// Configure repo for Linux
if (machine === 'Linux') {
    console.log(chalk.blue('Configuring git for Linux...'))

    // Add your Linux-specific configuration here
    // Install gitflow
    console.log(chalk.blue('Installing gitflow...'))
    execSync('npm list -g gitflow || npm i -g gitflow', { stdio: 'inherit' })
}

// Configure repo for MinGw/Windows
if (machine === 'MinGw') {
    console.log(chalk.blue('Configuring git for MinGw...'))
    git.addConfig('core.filemode', 'false')
    git.addConfig('credential.helper', 'wincred')

    // Install gitflow
    console.log(chalk.blue('Installing gitflow...'))
    execSync(
        'curl -sSL https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh | bash -s install stable'
    )
}

// Get the directory of this script
const scriptsDir = dirname(fileURLToPath(import.meta.url))

// Configure git globally for all platforms
console.log(chalk.blue('Configuring git globally for all platforms...'))
loadGitConfig('config.json', scriptsDir)

console.log(chalk.blue('Configuring git aliases...'))
loadGitAliases('alias.json', scriptsDir)
