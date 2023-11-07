/** @format */

import fs from 'fs'
import { execSync } from 'child_process'
import chalk from 'chalk'

console.log(chalk.blue('Configuring husky for this repo...'))

fs.readdirSync('.husky').forEach((file) => {
    fs.chmodSync(`.husky/${file}`, '755')
})

execSync('npx husky install', { stdio: 'inherit' })
