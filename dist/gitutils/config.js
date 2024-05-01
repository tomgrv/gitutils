/** @format */

import fs from 'fs'
import chalk from 'chalk'
import path from 'path'
import { simpleGit } from 'simple-git'
import { flatten } from 'flat'

const loadGitConfig = (jsonFile, scriptsDir) => {
    console.log(chalk.blue(`Configuring git according to ${jsonFile}...`))

    // Initialize git
    const git = simpleGit(process.cwd())

    // Read the aliases.json file
    const config = flatten(
        JSON.parse(fs.readFileSync(path.resolve(scriptsDir, jsonFile), 'utf8'))
    )

    // Flatten the JSON object into lines
    Object.keys(config).forEach((key) => {
        console.log(chalk.yellow(`Adding config ${key}=${config[key]}  ...`))
        git.addConfig(key, config[key])
    })
}

export default loadGitConfig
