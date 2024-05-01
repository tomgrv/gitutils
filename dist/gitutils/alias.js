/** @format */

import fs from 'fs'
import path from 'path'
import chalk from 'chalk'
import { simpleGit } from 'simple-git'

const loadGitAliases = (jsonFile, scriptsDir) => {
    // Configure git aliases according to aliases in the aliases.json file
    console.log(chalk.blue(`Configuring git according to ${jsonFile}...`))

    // Initialize git
    const git = simpleGit(process.cwd())

    // Read the alias.json file
    const config = JSON.parse(
        fs.readFileSync(path.resolve(scriptsDir, jsonFile), 'utf8')
    )

    // Add aliases
    Object.keys(config).forEach((alias) => {
        // Display the alias
        console.log(chalk.yellow(`Adding alias for ${alias}  ...`))

        // Add the alias
        git.addConfig(`alias.${alias}`, `!sh -c "${config[alias]}" - `)
    })

    // Configure git aliases for scripts in folder
    console.log(chalk.blue('Configuring git aliases for scripts in folder...'))

    // Add aliases for all scripts in the folder
    fs.readdirSync(scriptsDir)
        .filter((file) => file.startsWith('_') && file.endsWith('.sh'))
        .forEach((file) => {
            // Extract the alias and script
            const alias = path.basename(file, '.sh').substring(1)
            const script = path.join(scriptsDir, file)

            // Display the alias and script
            console.log(
                chalk.yellow(`Adding alias for ${alias} to ${script} ...`)
            )

            // Add the alias
            git.addConfig(
                `alias.${alias}`,
                `!sh -c "$(readlink -f '${script}') $* " - `
            )

            // Make the script executable
            fs.chmodSync(script, '755')
        })
}

export default loadGitAliases
