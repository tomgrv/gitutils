#!/bin/sh

### Install GitVersion
dotnet tool install --global GitVersion.Tool --version 5.*
alias gitversion="~/.dotnet/tools/dotnet-gitversion"

### Install GitFlow
sudo apt-get update
sudo apt-get install git-flow
