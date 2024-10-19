# Test Prototype

Calling `just` led to an error:

```bash
✦ ➜ just test
error: Unknown start of token:
 ——▶ justfile:2:42
  │
2 │ CONTAINER_ENGINE := $(if $(shell command -v podman 2>/dev/null),podman,docker)
  │                                          ^
```

Jane noticed that the given shell expression wasn't a valid one. So she changed
the `if` expression and called `just` again, which led to the following error:

```bash
✦ ➜ just
error: Unknown start of token:
 ——▶ justfile:2:34
  │
2 │ CONTAINER_ENGINE := $(if command -v podman 2>/dev/null; then echo podman; else echo docker; fi)
  │                                  ^
```

After some prompting in ChatGPT Jane realized she had to use backticks instead
of `$()` for command evaluation in `just`. After fixing the backticks the call
to `docker` worked leading to a new error.

```bash
✦ ➜ just
# Use the selected container engine to run the BATS tests
docker run --rm -v $(pwd):/mnt -w /mnt bats/bats:latest bats tests/
ERROR: Test file "/mnt/bats" does not exist.
error: Recipe `test` failed on line 8 with exit code 1
```

`bats` documentation provides a chapter [how to use bats with
docker](https://bats-core.readthedocs.io/en/stable/docker-usage.html) for it.
The call of `docker run` was erronous: the container image already uses `bats`
as entrypoint and thus we don't need to provide the `bats` command. After Jane
fixed the call, a new error popped up.


```bash
✦ ➜ just
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

Good new for Jane: the test code is called. The not so good ones - both tests failed.
It seemed more people run into this problems since the `bats`
[FAQ](https://bats-core.readthedocs.io/en/stable/warnings/BW01.html) had an
detailed description about this error. It seems `src/data_download` couldn't be
found in the tests.

Calling `data_download` in the project directory, without container, worked and
returned the exit code expected in the test case. Changing the relative path in
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

The tests executed without failure. So why would the tests fail when executed
in the container?

Jane was not someone to give up lightly. She created a container image `mybats`
based from the `Dockerfile` provided by the [bats-core
](https://github.com/bats-core/bats-core) project and adapted the entry point
to call a shell instead of the `bats` test framework. She used the newly
created container image to start the container interactively and run `bats`
from within, reproducing the error.

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
changed `shfmt` not to run in the container since she had `shfmt` installed on
her local developer machine.

Creating a [devcontainer](https://containers.dev/) for bash development is
going to get on her TODO list.

The `justfile` had now the following content:

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
    # Format files as configured in .editorconfig
    shfmt -w src/*
```

