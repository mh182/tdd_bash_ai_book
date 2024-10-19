#!/usr/bin/env bats

# BATS test for data_download

setup() {
    # Set up test environment if needed
    # e.g., touch files, create directories, etc.
    mkdir -p tmp
}

teardown() {
    # Clean up after the tests
    rm -rf tmp
}

@test "Script prints usage when no arguments are provided" {
    run ./src/data_download
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "Script downloads data when valid URL and directory are provided" {
    run ./src/data_download -u "http://example.com/data" -d "tmp"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Downloading data from http://example.com/data to tmp"* ]]
}

