# The Prototype

## Ask for a project template

Prompting ChatGPT:

> Provide a skeleton folder structure with minimal setup to start coding a
> shell script. Use the Google Shell Style guide settings, but instead of 2
> spaces indentation, use 4 spaces. Use editoconfig to configure the settings
> for shfmt and shellcheck.
> Create templates for use bats as testing framework. The shell script we are
> going to write is called data_download,

Answer from ChatGPT:

> Here’s a minimal folder structure and configuration to get you started with a shell script project using `data_download` as the script name. This includes the setup for `shfmt`, `shellcheck`, and BATS for testing.
> 
> ### Folder Structure:
> ```
> data_download_project/
> │
> ├── .editorconfig
> ├── .shellcheckrc
> ├── scripts/
> │   └── data_download.sh
> ├── tests/
> │   └── test_data_download.bats
> ├── README.md
> └── Makefile
> ```
> 
> ### 1. `.editorconfig` (for `shfmt` and consistent indentation):
> This will ensure that your indentation is set to 4 spaces when formatting the shell scripts.
> ```ini
> # EditorConfig helps maintain consistent coding styles between different editors and IDEs.
> root = true
> 
> [*]
> charset = utf-8
> end_of_line = lf
> insert_final_newline = true
> 
> [*.sh]
> indent_style = space
> indent_size = 4
> trim_trailing_whitespace = true
> ```
> 
> ### 2. `.shellcheckrc` (to configure `shellcheck`):
> ```bash
> # Add any custom shellcheck settings here.
> # Example: Ignoring specific rules if needed.
> # For more info on options, visit: https://www.shellcheck.net/
> 
> # Exclude a specific warning, e.g., SC1090 for sourcing files
> # shellcheck disable=SC1090
> ```
> 
> ### 3. `scripts/data_download.sh` (the shell script):
> This is a placeholder for the actual logic of your `data_download` script.
> ```bash
> #!/bin/bash
> 
> # data_download.sh - A script to download data from various sources.
> 
> set -euo pipefail
> 
> # Usage function
> usage() {
>     echo "Usage: $0 [-u url] [-d directory]"
>     exit 1
> }
> 
> # Default values
> URL=""
> DIRECTORY="."
> 
> # Parse options
> while getopts ":u:d:" opt; do
>     case $opt in
>         u) URL="$OPTARG" ;;
>         d) DIRECTORY="$OPTARG" ;;
>         *) usage ;;
>     esac
> done
> 
> # Check if URL is set
> if [[ -z "$URL" ]]; then
>     usage
> fi
> 
> # Download logic
> download_data() {
>     echo "Downloading data from $URL to $DIRECTORY"
>     # Insert download command here (e.g., curl or wget)
> }
> 
> # Execute the download
> download_data
> ```
> 
> ### 4. `tests/test_data_download.bats` (unit testing with BATS):
> BATS tests for validating the behavior of your `data_download.sh` script.
> ```bash
> #!/usr/bin/env bats
> 
> # BATS test for data_download.sh
> 
> setup() {
>     # Set up test environment if needed
>     # e.g., touch files, create directories, etc.
>     mkdir -p tmp
> }
> 
> teardown() {
>     # Clean up after the tests
>     rm -rf tmp
> }
> 
> @test "Script prints usage when no arguments are provided" {
>     run ./scripts/data_download.sh
>     [ "$status" -eq 1 ]
>     [[ "$output" == *"Usage:"* ]]
> }
> 
> @test "Script downloads data when valid URL and directory are provided" {
>     run ./scripts/data_download.sh -u "http://example.com/data" -d "tmp"
>     [ "$status" -eq 0 ]
>     [[ "$output" == *"Downloading data from http://example.com/data to tmp"* ]]
> }
> ```
> 
> ### 5. `Makefile` (for running common tasks):
> To automate tasks such as testing and linting, use a simple Makefile.
> ```makefile
> SHELLCHECK_OPTS := --exclude=SC1090
> 
> .PHONY: test lint format
> 
> test:
>     bats tests/
> 
> lint:
>     shellcheck $(SHELLCHECK_OPTS) scripts/*.sh
> 
> format:
>     shfmt -w -i 4 scripts/*.sh
> ```
> 
> ### 6. `README.md` (documentation):
> ```md
> # data_download
> 
> This project contains a shell script to download data from various sources.
> 
> ## Usage
> 
> ```bash
> ./scripts/data_download.sh -u <url> -d <directory>
> ```
> 
> ## Testing
> 
> To run the tests, use:
> 
> ```bash
> make test
> ```
> 
> ## Linting & Formatting
> 
> To check for linting errors and auto-format the code, use:
> 
> ```bash
> make lint
> make format
> ```
> ```
> 
> ### Instructions:
> 1. Install `shfmt` and `shellcheck` for linting and formatting:
>     ```bash
>     sudo apt-get install shfmt shellcheck
>     ```
> 2. Install BATS for testing:
>     ```bash
>     sudo apt-get install bats
>     ```
> 
> This setup provides the essential structure for building, testing, and maintaining a well-formatted shell script project.

Jane was suprised how well this worked out. She wasn't happy with small details:
- The shell script used the `.sh` extension which goes againts the Shell Style Guide.
- `make` is cumbersome, use [just](https://just.systems/man/en/introduction.html) instead

So she prompted again:

> Change the following: data_downloader should not use the extension `.sh`. Use
> `just` instead of make to run common tasks. Provide only the output for the
> things which changed

Answer from ChatGPT:

> Here are the changes based on your new requirements:
> 
> ### Folder Structure:
> ```
> data_download_project/
> │
> ├── .editorconfig
> ├── .shellcheckrc
> ├── scripts/
> │   └── data_download    # No .sh extension
> ├── tests/
> │   └── test_data_download.bats
> ├── README.md
> └── justfile             # Replaces Makefile
> ```
> 
> ### 1. `scripts/data_download` (without the `.sh` extension):
> ```bash
> #!/bin/bash
> 
> # data_download - A script to download data from various sources.
> ```
> 
> ### 2. `justfile` (replaces `Makefile`):
> ```makefile
> # Define tasks for common operations
> 
> SHELLCHECK_OPTS := --exclude=SC1090
> 
> test:
>     bats tests/
> 
> lint:
>     shellcheck {{SHELLCHECK_OPTS}} scripts/*
> 
> format:
>     shfmt -w -i 4 scripts/*
> ```
> 
> ### 3. `README.md` (updated to use `just` instead of `make`):
> ```md
> ## Testing
> 
> To run the tests, use:
> 
> ```bash
> just test
> ```
> 
> ## Linting & Formatting
> 
> To check for linting errors and auto-format the code, use:
> 
> ```bash
> just lint
> just format
> ```
> ```

Jane doesn't feel confident to run test scripts in her environment. If she
makes a mistake files may be deleted. She would like to run the tests in a
contained environment. That's what containers are for.

Prompting ChatGPT:

> Change the just file so we would run the tests in a container. Make sure we
> either can use podman or docker.

Answer from ChatGPT:

> Here’s the updated `justfile` to run tests in a container, allowing for either `podman` or `docker` to be used.
> 
> ### Updated `justfile`:
> 
> ```makefile
> # Define variables for container engine
> CONTAINER_ENGINE := $(if $(shell command -v podman 2>/dev/null),podman,docker)
> 
> # Define tasks for common operations
> 
> test:
>     # Use the selected container engine to run the BATS tests
>     {{CONTAINER_ENGINE}} run --rm -v $(pwd):/mnt -w /mnt bats/bats:latest bats tests/
> 
> lint:
>     {{CONTAINER_ENGINE}} run --rm -v $(pwd):/mnt -w /mnt koalaman/shellcheck shellcheck scripts/*
> 
> format:
>     {{CONTAINER_ENGINE}} run --rm -v $(pwd):/mnt -w /mnt mvdan/shfmt shfmt -w -i 4 scripts/*
> ```
> 
> ### Key Changes:
> 1. **Container Engine Selection**: It checks if `podman` is available; if not, it defaults to `docker`.
> 2. **Running Tests in a Container**: BATS is run inside a `bats/bats` container.
> 3. **Linting and Formatting**: Both `shellcheck` and `shfmt` are executed within their respective containers.
> 
> This setup allows you to run tests, lint, and format code consistently in isolated containerized environments using either `podman` or `docker`.

## Test the Prototype

Calling `just`

```bash
✦ ❯ just
error: Unknown start of token:
 ——▶ justfile:2:42
  │
2 │ CONTAINER_ENGINE := $(if $(shell command -v podman 2>/dev/null),podman,docker)
```
