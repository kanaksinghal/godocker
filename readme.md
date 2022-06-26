# Go - Docker FIXUID

This is a POC project to try out [FIXUID](https://github.com/boxboat/fixuid) for fixing docker permission issue while generating files on host file system.
This project uses golang base image, runs go unit tests inside the container and exports a coverage file on host file system.

## Prerequisite

Docker and Docker compose must be preinstalled

## Run go test

Run `make test`

## Validate

Validate the tests should run successfully and should create a coverage.txt file. And the user and group of this coverage.txt file should match the 