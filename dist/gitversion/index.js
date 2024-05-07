/** @format */

import { execSync } from 'child_process'
import chalk from 'chalk'
import os from 'os'
import { simpleGit } from 'simple-git'

// Initialize git
const git = simpleGit(process.cwd())

// Install & configure gitversion
function configureGitVersion(installCommand, runCommand) {
    var status = true

    try {
        execSync(installCommand, { stdio: 'inherit' })
        git.addConfig(
            'alias.bump-version',
            `!${runCommand} -config .gitversion -showvariable MajorMinorPatch`
        )
        git.addConfig(
            'alias.semver',
            `!${runCommand} -config .gitversion -showvariable SemVer`
        )
    } catch {
        status = false
    }

    return status
}

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
    if (!configureGitVersion('brew install gitversion', 'gitversion')) {
        configureGitVersion(
            'dotnet-gitversion -version || dotnet tool install -g GitVersion.Tool',
            'dotnet-gitversion'
        )
    }
}

// Configure repo for Linux
if (machine === 'Linux') {
    console.log(chalk.blue('Configuring gitversion for Linux...'))
    if (!configureGitVersion('brew install gitversion', 'gitversion')) {
        configureGitVersion(
            'dotnet-gitversion -version || dotnet tool install -g GitVersion.Tool',
            'dotnet-gitversion'
        )
    }
}

// Configure repo for MinGw/Windows
if (machine === 'MinGw') {
    console.log(chalk.blue('Configuring gitversion for MinGw...'))
    if (!configureGitVersion('winget install gitversion', 'gitversion')) {
        configureGitVersion(
            'dotnet-gitversion -version >/dev/null || dotnet tool install -g GitVersion.Tool',
            'dotnet-gitversion'
        )
    }
}
