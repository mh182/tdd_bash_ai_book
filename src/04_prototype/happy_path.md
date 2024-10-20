# The Happy Path

Jane already knew that the test case for the successful download was fake
since the current implementation of `data_download` doesn't download anything.
The test case checks the output, but not if a file is successfully downloaded.

```bash
@test "Script downloads data when valid URL and directory are provided" {
    run data_download -u "http://example.com/data" -d "tmp"
    assert_success
    assert_output --partial "Downloading data from http://example.com/data to tmp"
}
```

Since Jane wants to practice [test driven
development](https://en.wikipedia.org/wiki/Test-driven_development) she
adds an end-to-end test for the happy path. For the end-to-end test she is
going to download the HTML retrieved <htpp://example.com> since it fits to the
test requirements: the file is small, and the service is unlikely to going to
disapear.

Note: Jane plans to use this endpoint only in one test. So there is no risk her
tests would hammer the webserver.

Prompt ChatGPT:

> Write a test which checks if the downloaded files exists.

Answer from ChatGPT:

> To write a BATS test that checks if the downloaded file exists after running your `data_download` script, you can use the `run` function to execute the script and then use `assert_success` (to verify the script ran without errors) and `assert_file_exist` (to check if the file exists in the specified directory).
>
> Here’s how you can structure the test:
>
> ### Test to Check if Downloaded File Exists:
>
> ```bash
> #!/usr/bin/env bats
>
> # Load bats-support and bats-assert from the container's installed location
> load '/opt/bats/lib/bats-support/load'
> load '/opt/bats/lib/bats-assert/load'
>
> setup() {
>     mkdir -p tmp  # Create a temporary directory for the test
> }
>
> teardown() {
>     rm -rf tmp  # Clean up after the test
> }
>
> @test "Script downloads data and file exists in the target directory" {
>     run /mnt/scripts/data_download -u "http://example.com/data" -d "tmp"
>     assert_success  # Asserts the script executed successfully
>
>     # Check if the expected downloaded file exists in the 'tmp' directory
>     expected_file="tmp/data"
>     assert_file_exist "$expected_file"
> }
> ```
>
> ### Key Components of the Test:
>
> 1. **`run`**: Runs the `data_download` script with the URL and target directory arguments.
> 2. **`assert_success`**: Ensures that the script completed successfully (exit code 0).
> 3. **`assert_file_exist`**: Verifies that the file was downloaded into the `tmp` directory.
>
> ### Explanation:
>
> - **`setup`**: This function creates a `tmp` directory before each test, where the file will be downloaded.
> - **`teardown`**: This function cleans up the `tmp` directory after each test to ensure a fresh state.
> - **`expected_file="tmp/data"`**: This variable holds the expected file path, which is used in the assertion.
>
> In this test, the downloaded file is expected to be named `data` and located in the `tmp` directory. Make sure the `data_download` script downloads the file correctly to this path based on your URL and file-saving logic.

Jane adapts the test to her needs

```bash
@test "End2end test with http://example.com" {
    local url="http://example.com"
    run data_download -u "${url}" -d "tmp"
    assert_success
    assert_file_exist "tmp/index.html"
}
```

But the test run fails

```bash
➜ just test
# Use the selected container engine to run the BATS tests
docker run --rm -it -v $(pwd):/mnt -w /mnt bats/bats:latest tests
test_data_download.bats
 ✓ Script prints usage when no arguments are provided
 ✓ Script downloads data when valid URL and directory are provided
 ✗ End2end test with http://example.com
   (in test file tests/test_data_download.bats, line 43)
     `assert_file_exist "tmp/index.html"' failed with status 127
   /mnt/tests/test_data_download.bats: line 43: assert_file_exist: command not found

3 tests, 1 failure
```

OK, probably `assert_file_exists` is in a library which is not loaded. After a
short round trip to the `bats` documentation she adds the missing library with
`bats_load_library bats-file` and reruns the tests.

```bash
➜ just test
# Use the selected container engine to run the BATS tests
docker run --rm -it -v $(pwd):/mnt -w /mnt bats/bats:latest tests
test_data_download.bats
 ✓ Script prints usage when no arguments are provided
 ✓ Script downloads data when valid URL and directory are provided
 ✗ End2end test with http://example.com
   (from function `assert_file_exist' in file /usr/lib/bats/bats-file/src/file.bash, line 72,
    in test file tests/test_data_download.bats, line 43)
     `assert_file_exist "tmp/index.html"' failed

   -- file does not exist --
   path : tmp/index.html
   --


3 tests, 1 failure
```

Nice, the test does what it should do. Now lets change `data_download` until
the test case run successfully. Now Jane changes the `download_data` function.

```bash
# Download logic
download_data() {
    echo "Downloading data from $URL to $DIRECTORY"
    wget -P "${DIRECTORY}" "${URL}"
}
```

Jane runs the test suite with the minimal implementation. The newly added
end-to-end test passes, but the test downloading from an URL pointing to an non
existing resource fails.

```bash
➜ just test
# Use the selected container engine to run the BATS tests
docker run --rm -it -v $(pwd):/mnt -w /mnt bats/bats:latest tests
test_data_download.bats
 ✓ Script prints usage when no arguments are provided
 ✗ Script downloads data when valid URL and directory are provided
   (from function `assert_success' in file /usr/lib/bats/bats-assert/src/assert_success.bash, line 42,
    in test file tests/test_data_download.bats, line 35)
     `assert_success' failed

   -- command failed --
   status : 1
   output (3 lines):
     Downloading data from http://example.com/data to tmp
     Connecting to example.com (93.184.215.14:80)
     wget: server returned error: HTTP/1.1 404 Not Found
   --

 ✓ End2end test with http://example.com

3 tests, 1 failure
```

For now Jane would like to skip the failing test.

TODO: explain why

Prompt ChatGPT:

> How do I mark a test to be skipped from execution?

Answer from ChatGPT:

> In BATS, you can mark a test to be skipped using the `skip` command. Place it inside the test case to signal that the test should be skipped.
>
> ### Example of Skipping a Test:
>
> ```bash
> @test "This test is skipped" {
>     skip "Skipping this test for now"
>     run /mnt/scripts/data_download
>     assert_success
> }
> ```
>
> The test will be marked as skipped, and the message `"Skipping this test for now"` will be displayed.

Jane renames the tests according to their function and marks the failing test to be skipped.

```bash
@test "Script shows error for HTTP 404 Not Found" {
    skip "wget: server returned error: HTTP/1.1 404 Not Found"
    run data_download -u "http://example.com/data" -d "tmp"
    assert_success
    assert_output --partial "Downloading data from http://example.com/data to tmp"
}

@test "Script downloads data when valid URL and directory are provided" {
    local url="http://example.com"
    run data_download -u "${url}" -d "tmp"
    assert_success
    assert_file_exist "tmp/index.html"
}
```

Jane runs the test suite again.

```bash
➜ just
# Use the selected container engine to run the BATS tests
docker run --rm -it -v $(pwd):/mnt -w /mnt bats/bats:latest tests
test_data_download.bats
 ✓ Script prints usage when no arguments are provided
 - Script shows error for HTTP 404 Not Found (skipped: wget: server returned error: HTTP/1.1 404 Not Found)
 ✓ Script downloads data when valid URL and directory are provided

3 tests, 0 failures, 1 skipped
```

Finally. Now everything is in place so that Jane could start refactoring the
code of `data_download` to be compliant to the shell coding style guide.
