<!-- @format -->

# DevUtils

[![NPM](https://img.shields.io/npm/v/@tomgrv/devutils?logo=npm)](https://www.npmjs.com/package/@tomgrv/devutils)

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![Semantic Release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

[![License](https://img.shields.io/github/license/tomgrv/devutils.svg)](https://github.com/tomgrv/devutils/blob/master/LICENSE)
[![Buy me a coffee](https://badgen.net/badge/buymeacoffe/tomgrv/yellow?icon=buymeacoffee)](https://buymeacoffee.com/tomgrv)

Configure developpement environnement in one step with:

-   @commitlint/cli
-   @commitlint/config-conventional
-   @commitlint/core
-   @commitlint/cz-commitlint
-   commitizen
-   conventional-changelog-cli
-   devmoji
-   git-precommit-checks
-   husky
-   lint-staged
-   prettier
-   standard-version
-   git-flow

## Installation

```shell
npm install @tomgrv/devutils --save-dev
```

-   All specified development packages are installed
-   Default configuration is pushed in `package.json` file
-   husky is configured
-   .gitignore & .gitattributes are deployed
-   current git repo is configured
    -   aliases are declared
    -   mergers are configured

| Alias                    | Description                                                                                         |
| ------------------------ | --------------------------------------------------------------------------------------------------- |
| `amend`                  | Amend the last commit                                                                               |
| `crush`                  | Amend and push the last commit                                                                      |
| `undo`                   | Undo the last commit                                                                                |
| `clean`                  | Restore the last commit                                                                             |
| `ignore <file>`          | Ignore specified file                                                                               |
| `renameTag <tag>`        | Rename the specified tag                                                                            |
| `initFrom <repo> <path>` | Initialize a new repository from the specified repository in specified directory                    |
| `histo`                  | Show git history                                                                                    |
| `conflicts`              | Show git conflicts                                                                                  |
| `hibernate`              | Remove all ignored files (but keep untracked ones)                                                  |
| `fixup [commit]`         | Edit the specified commit message. List relevant commits and ask for one if no commit is specified. |
| `align`                  | Align working directory _files_ with the last _pushed_ commit                                       |
| `sync`                   | Align working directory _state_ with the last _pushed_ commit                                       |
| `integrate`              | Align working directory _state_ with the last _local_ commit                                        |

## Usage

Manage your commits with the usual `git commit` as hooks are configured to handle your commit message with commitlint and commitizen + devmoji

Call git aliases with `git <alias> [args]`

## License (MIT)

Copyright (c) 2024 [tomgrv](http://www.github.com/tomgrv)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
