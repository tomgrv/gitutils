/** @format */

import { execSync } from 'child_process'
import chalk from 'chalk'
import os from 'os'
import { simpleGit } from 'simple-git'

// Initialize git
const git = simpleGit(process.cwd())

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

// Install & configure gitversion
if (machine === 'Mac') {
    console.log(chalk.blue('Configuring gitversion for Mac...'))
    try {
        execSync('brew install gitversion', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!gitversion')
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!dotnet-gitversion')
    }
}

// Configure repo for Linux
if (machine === 'Linux') {
    console.log(chalk.blue('Configuring gitversion for Linux...'))
    try {
        execSync('brew install gitversion', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!gitversion')
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!dotnet-gitversion')
    }
}

// Configure repo for MinGw/Windows
if (machine === 'MinGw') {
    console.log(chalk.blue('Configuring gitversion for Mac...'))
    try {
        execSync('winget install gitversion', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!gitversion')
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig('alias.gversion', '!dotnet-gitversion')
    }
}
