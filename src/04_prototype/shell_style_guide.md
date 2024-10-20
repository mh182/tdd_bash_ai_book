# Complying to Shell Style Guide

`data_download` doesn't comply to the used [Shell Style Guide]. Jane

- [function location](https://google.github.io/styleguide/shellguide.html#s7.6-function-location):
  put all functions together below constants. A function called `main` as the
  bottom-most function, the last non-comment line in the file should be a call
  to `main`.
- [Constants, Environment Variables, and readonly
  Variables](https://google.github.io/styleguide/shellguide.html#s7.3-constants-and-environment-variable-names):
  the constants we set at runtime are not made readonly.
- [STDOUT vs STDERR](https://google.github.io/styleguide/shellguide.html#s3.1-stdout-vs-stderr):
  error messages are not going to `STDERR`.

[Shell Style Guide]: https://google.github.io/styleguide/shellguide.html

Prompt ChatGPT:

> The code of data_download shown below doesn't comply to the Google Shell
> Style guide. Change the code to comply to the standard: global variables
> should be on top (after the `set` command), refactor the code which sets the
> global variable from the command line argument into its own function. Make
> the global variable read-only after their value is set. Create a main
> function as last function which calls the other function. The main function
> is called as the last command in the file.
>
> ```bash
> #!/usr/bin/env bash
>
> # data_download - A script to download data from various sources.
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
>     wget -P "${DIRECTORY}" "${URL}"
> }
>
> # Execute the download
> download_data
> ```

Answer from ChatGPT:

> Here’s the refactored version of the `data_download` script according to the Google Shell Style Guide:
>
> ```bash
> #!/usr/bin/env bash
>
> # data_download - A script to download data from various sources.
>
> set -euo pipefail
>
> # Global variables (initially empty)
> URL=""
> DIRECTORY="."
>
> # Usage function to show how to use the script
> usage() {
>     echo "Usage: $0 [-u url] [-d directory]"
>     exit 1
> }
>
> # Function to parse command line arguments and set global variables
> parse_args() {
>     while getopts ":u:d:" opt; do
>         case $opt in
>             u) URL="$OPTARG" ;;
>             d) DIRECTORY="$OPTARG" ;;
>             *) usage ;;
>         esac
>     done
>
>     if [[ -z "$URL" ]]; then
>         usage
>     fi
>
>     # Set global variables as read-only
>     readonly URL
>     readonly DIRECTORY
> }
>
> # Function to download the data
> download_data() {
>     echo "Downloading data from $URL to $DIRECTORY"
>     wget -P "${DIRECTORY}" "${URL}"
> }
>
> # Main function
> main() {
>     parse_args "$@"
>     download_data
> }
>
> # Call the main function
> main "$@"
> ```
>
> ### Changes made:
>
> - Moved global variables (`URL`, `DIRECTORY`) to the top, after the `set` command.
> - Created `parse_args` function to handle argument parsing.
> - Marked global variables `URL` and `DIRECTORY` as read-only after their values are set.
> - Created `main` function that calls `parse_args` and `download_data`.
> - The script execution starts by calling the `main` function at the end.

Jane replaced the current implementation with the generated code and runs
the test suite - all executed tests passed. Without those tests she would not
have been confident to replace the code.

All she had to address now is the separation of `STDOUT` and `STDERR`. Chapter
4 - Mind the streams - of [12 Factor CLI Apps] and [Command Line Interface Guideline]
are a good source how the output of a CLI should look like and how to deal with
errors.

[12 Factor CLI Apps]: https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46
[Command Line Interface Guideline]: https://clig.dev/#output

Prompt ChatGPT:

> The test case calling data_download with no arguments should be changed to
> write a short error message of missing arguments followed by the usage and a
> hint to call the script with the --help option. The output should be done on
> STDERR, not STDOUT. Here is the current test case, which should be changed to
> the specifcation above:
>
> ```bash
> @test "Script prints usage when no arguments are provided" {
>     run data_download
>     assert_failure 1
>     assert_output --partial "Usage:"
> }
> ```

Answer from ChatGPT:

> Here's the updated test case to reflect the new behavior, which writes a short error message followed by usage and a hint, all to STDERR:
>
> ```bash
> @test "Script prints error and usage when no arguments are provided" {
>     run data_download
>     assert_failure 1
>     assert_error --partial "Error: Missing arguments."
>     assert_error --partial "Usage:"
>     assert_error --partial "Hint: Call the script with --help for more information."
> }
> ```
>
> - **`assert_error`** is used to check the output on `STDERR` rather than `STDOUT`.
> - The test checks for a short error message, usage, and the hint about the `--help` option.

Prompt ChatGPT:

> The test case for calling the data_download without arguments is changed:
>
> ```bash
> @test "Script prints usage when no arguments are provided" {
>     run data_download
>     assert_failure 1
>     assert_error --partial "data_download: missing argument"
>     assert_error --partial "Usage: data_download URL [-d DIRECTORY]"
>     assert_error --partial "Try 'data_download --help' fore more information."
> }
> ```
>
> This means the URL is not optional, the directory flag is optional. If the directory is not provided, the working directory from which the script is called is used as target directory.
> Note that the name of the script is printed in the usage, without directory name. Please change data_download so this test would pass.
