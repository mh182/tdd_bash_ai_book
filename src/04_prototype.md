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

Calling `just` led to an error:

```bash
just
error: Unknown start of token:
 ——▶ justfile:2:42
  │
2 │ CONTAINER_ENGINE := $(if $(shell command -v podman 2>/dev/null),podman,docker)
  │                                          ^
```

Jane noticed that the given shell expression wasn't a valid one. So she changed
the `if` expression and called `just` again, which led to the following error:

```bash
just
error: Unknown start of token:
 ——▶ justfile:2:42
  │
2 │ CONTAINER_ENGINE := $(if $(shell command -v podman 2>/dev/null),podman,docker)
  │                                          ^
```

With the help of ChatGPT she found out she had to use backticks, `$()` doesn't
work as command evaluation in `just`. After fixing the backticks the call to
`docker` worked leading to a new error.

```bash
✦ ❯ just
# Use the selected container engine to run the BATS tests
docker run --rm -v $(pwd):/mnt -w /mnt bats/bats:latest bats tests/
ERROR: Test file "/mnt/bats" does not exist.
error: Recipe `test` failed on line 8 with exit code 1
```

`bats` documentation provides a chapter [how to use bats with
docker](https://bats-core.readthedocs.io/en/stable/docker-usage.html). The call
to the docker was wrong: we don't need the `bats` command. After Jane fixed the
call, a new error popped up.


```bash
✦ ❯ just
# Use the selected container engine to run the BATS tests
docker run --rm -v $(pwd):/mnt -w /mnt bats/bats:latest tests
1..2
not ok 1 Script prints usage when no arguments are provided
# (in test file tests/test_data_download.bats, line 18)
#   `[ "$status" -eq 1 ]' failed
not ok 2 Script downloads data when valid URL and directory are provided
# (in test file tests/test_data_download.bats, line 24)
#   `[ "$status" -eq 0 ]' failed

The following warnings were encountered during tests:
BW01: `run`'s command `./src/data_download` exited with code 127, indicating 'Command not found'. Use run's return code checks, e.g. `run -127`, to fix this message.
      (from function `run' in file /opt/bats/lib/bats-core/test_functions.bash, line 426,
       in test file tests/test_data_download.bats, line 17)
BW01: `run`'s command `./src/data_download -u http://example.com/data -d tmp` exited with code 127, indicating 'Command not found'. Use run's return code checks, e.g. `run -127`, to fix this message.
      (from function `run' in file /opt/bats/lib/bats-core/test_functions.bash, line 426,
       in test file tests/test_data_download.bats, line 23)
error: Recipe `test` failed on line 8 with exit code 1```
```

The good news: the test code is called. The not so good ones - both tests failed.
`bats` [FAQ](https://bats-core.readthedocs.io/en/stable/warnings/BW01.html) had
even an detailed description about this error. It seems `src/data_download`
couldn't be found in the tests.

Calling the script locally, without container, worked and it returned the same
exit code as the test case expected. Changing the relative path in
`test_data_download` to `../src/download_data` had no effect.

```bash
./src/data_download
Usage: ./src/data_download [-u url] [-d directory]

echo $?
1
```

So Jane installed `bats` on here system and run the tests from the project root
directory:

```bash
✦ ➜ bats tests/
test_data_download.bats
 ✓ Script prints usage when no arguments are provided
 ✓ Script downloads data when valid URL and directory are provided

2 tests, 0 failures
```

The test run with no failures. So why would the tests fail when executed in the
container?

Jane was not someone to give up lightly. After creating here own `bats`
container image she called into the container and run `bats` from within
reproducing the error.

```bash
✦ ➜ docker run --rm -it -v $(pwd):/mnt -w /mnt mybats
bash-5.2# bats tests
test_data_download.bats
 ✗ Script prints usage when no arguments are provided
   (in test file tests/test_data_download.bats, line 18)
     `[ "$status" -eq 1 ]' failed
 ✗ Script downloads data when valid URL and directory are provided
   (in test file tests/test_data_download.bats, line 24)
     `[ "$status" -eq 0 ]' failed

2 tests, 2 failures


The following warnings were encountered during tests:
BW01: `run`'s command `./src/data_download` exited with code 127, indicating 'Command not found'. Use run's return code checks, e.g. `run -127`, to fix this message.
      (from function `run' in file /opt/bats/lib/bats-core/test_functions.bash, line 297,
       in test file tests/test_data_download.bats, line 17)
BW01: `run`'s command `./src/data_download -u http://example.com/data -d tmp` exited with code 127, indicating 'Command not found'. Use run's return code checks, e.g. `run -127`, to fix this message.
      (from function `run' in file /opt/bats/lib/bats-core/test_functions.bash, line 297,
       in test file tests/test_data_download.bats, line 23)
bash-5.2# src/data_download
bash: src/data_download: cannot execute: required file not found
bash-5.2# which bash
/usr/local/bin/bash
bash-5.2# grep bash src/data_download
#!/bin/bash
bash-5.2# ls -al /bin/bash
ls: /bin/bash: No such file or directory
```

The reason for the failed tests was the shebang in `data_download`. In the
Alpine based container `/bin/bash` didn't exist. The fix was easy, change the
shebang to `#!/usr/bin/env bash`. Done that, everything worked fine.

The other `just` commands had minor mistakes which Jane could fix easily. She
changed `shfmt` not to run in the container since she had this tool installed
on her local developer machine.

Creating a [devcontainer](https://containers.dev/) for bash development is
going to get on her TODO list.

```just
# Define variables for container engine
CONTAINER_ENGINE := `if command -v podman 2>/dev/null; then echo podman; else echo docker; fi`

# Define tasks for common operations

test:
    # Use the selected container engine to run the BATS tests
    {{CONTAINER_ENGINE}} run --rm -it -v $(pwd):/mnt -w /mnt bats/bats:latest tests

lint:
    {{CONTAINER_ENGINE}} run --rm -v $(pwd):/mnt -w /mnt koalaman/shellcheck src/* tests/*

format:
    # Format files as configured in .editoconfig
    shfmt -w src/*
```

