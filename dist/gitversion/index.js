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
        git.addConfig(
            'alias.gitversion',
            '!gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!gitversion -config .gitversion -showvariable SemVer'
        )
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig(
            'alias.gitversion',
            '!dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!dotnet-gitversion -config .gitversion -showvariable SemVer'
        )
    }
}

// Configure repo for Linux
if (machine === 'Linux') {
    console.log(chalk.blue('Configuring gitversion for Linux...'))
    try {
        execSync('brew install gitversion', { stdio: 'inherit' })
        git.addConfig(
            'alias.gitversion',
            '!gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!gitversion -config .gitversion -showvariable SemVer'
        )
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig(
            'alias.gitversion',
            '!dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!dotnet-gitversion -config .gitversion -showvariable SemVer'
        )
    }
}

// Configure repo for MinGw/Windows
if (machine === 'MinGw') {
    console.log(chalk.blue('Configuring gitversion for MinGw...'))
    try {
        execSync('winget install gitversion', { stdio: 'inherit' })
        git.addConfig(
            'alias.gitversion',
            '!gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!gitversion -config .gitversion -showvariable SemVer'
        )
    } catch {
        execSync('dotnet tool install -g GitVersion.Tool', { stdio: 'inherit' })
        git.addConfig(
            'alias.gitversion',
            '!dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch'
        )
        git.addConfig(
            'alias.semver',
            '!dotnet-gitversion -config .gitversion -showvariable SemVer'
        )
    }
}

// Configure repo for gitflow
console.log(chalk.blue('Configuring gitflow for gitversion...'))
git.addConfig(
    'alias.release',
    '!sh -c "git flow release start $(git gitversion)" -'
)
git.addConfig(
    'alias.publish',
    '!sh -c "git flow release finish -m "Release As: $(git gitversion)"  $(git gitversion)" -'
)
