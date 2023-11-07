/** @format */

import { dirname, basename } from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'
import * as mergeJson from 'merge-packages'
import { cwd } from 'process'
import { execSync } from 'child_process'
import chalk from 'chalk'
import git from 'simple-git'
import fse from 'fs-extra'
import { globSync } from 'glob'

// Define module directory and display it
const MODULE = dirname(fileURLToPath(import.meta.url))
console.log(chalk.green(`Module directory: ${MODULE}`))

// Define gitignore function
function gitignore(entry) {
    const gitignoreContent = fs.readFileSync('.gitignore', 'utf-8')
    if (!gitignoreContent.split('\n').includes(entry)) {
        fs.appendFileSync('.gitignore', `${entry.replace('\\', '/')}\n`)
    }
    git().rm(['--cached', entry])
}

// Define mergePackageFiles function
function mergePackageFiles(mainFilepath, mergeFilepath) {

    // if package.json does not exist, just copy and rename the mergeFilepath to mainFilepath
    if (!fs.existsSync(mainFilepath)) {
        fs.copyFileSync(mergeFilepath, mainFilepath)
    }
    else {
        const packageFileJson = fs.readFileSync(mainFilepath, 'utf-8')
        const toMergeFileJson = fs.readFileSync(mergeFilepath, 'utf-8')
        const mergedFileJson = mergeJson.default.default(
            packageFileJson,
            toMergeFileJson
        )
        fs.writeFileSync(mainFilepath, mergedFileJson)
    }
}

// Goto repository root and display it
process.chdir(await git().revparse(['--show-toplevel']))
console.log(chalk.green(`Repository root: ${process.cwd()}`))

// Define safe directory
git().addConfig('safe.directory', cwd())

// Copy stub folder in current directory including hidden files
console.log(chalk.blue('Deploy stubs'))
fse.copySync(`${MODULE}/stub`, cwd(), { overwrite: true, dot: true })

globSync('**/*#', {
    ignore: 'stub/**',
    dot: true
}).forEach((file) => {
    const newFile = file.slice(0, -1)
    console.log(chalk.yellow(`Rename ${file} to ${newFile}`))
    fs.renameSync(file, newFile, { overwrite: true })
    gitignore(newFile)
})

// Merge all package folder json files into top level package.json
console.log(chalk.blue('Merge package.json'))
globSync(`*.json`, {
    cwd: `${MODULE}/package/`,
}).forEach((file) => {
    console.log(chalk.yellow(`Merge ${file}`))
    mergePackageFiles('./package.json', `${MODULE}/package/${file}`)
})

// Call index.js in each dist subfolder
console.log(chalk.blue('Run dist scripts'))
globSync(`dist/*/index.js`, {
    cwd: `${MODULE}`,
}).forEach((file) => {
    // Add folder name to gitignore
    gitignore('/.' + basename(dirname(file)))

    // Run index.js
    console.log(chalk.yellow(`Run ${file}`))
    execSync(`node ${MODULE}/${file}`, { stdio: 'inherit' })
})
