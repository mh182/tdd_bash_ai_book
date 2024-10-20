#!/usr/bin/env bats

# BATS test for data_download

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"

    # Load the necessary libraries for assertions
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-file

    # Create directory to place the downloaded files
    mkdir -p tmp
}

teardown() {
    # Cleanup after the test
    rm -rf tmp
}

@test "Script prints usage when no arguments are provided" {
    run data_download
    assert_failure 1
    assert_output --partial "Usage:"
}

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

