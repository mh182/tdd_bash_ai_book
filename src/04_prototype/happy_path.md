# The Happy Path

Jane already knew that the test case testing a successful download was fake
since the current implementation of `data_download` didn't call anything.
All the test cxase did was checking the script output.

Since Jane wanted to practice [test driven
development](https://en.wikipedia.org/wiki/Test-driven_development) she had to
adapt the test case.

Jane creates a new test case which would test the happy path. She needed an URL
from which she could download a real file.

http://ipv4.download.thinkbroadband.com/5MB.zip


```bash
@test "Script downloads data when valid URL and directory are provided" {
    run data_download -u "http://example.com/data" -d "tmp"
    assert_success
    assert_output --partial "Downloading data from http://example.com/data to tmp"
}
```

