# Testing framework for Bash

## Picking a Bash testing framework

Prompt to ChatGPT

```
I'm a software developer and want to write a bash script to retrieve a CVS from
a HTTPs server. The script should be unit tested. Please provide me a list of
open source testing frameworks which are actively maintained.
```

Answer from ChatGPT

> Here’s a list of actively maintained open-source testing frameworks for Bash that are suitable for unit testing:
>
> 1. **Bats (Bash Automated Testing System)**
>    - Popular framework for testing bash scripts.
>    - Simple, TAP-compliant (Test Anything Protocol).
>    - Actively maintained with a rich ecosystem of plugins.
>    - GitHub: Bats-core
> 2. **shUnit2**
>    - xUnit style unit testing framework for Bourne-based shell scripts.
>    - Fairly lightweight and easy to use.
>    - GitHub: shUnit2
> 3. **bash_unit**
>    - A unit testing framework for bash scripts.
>    - Simple and self-contained.
>    - GitHub: bash_unit
> 4. **Assert.sh**
>    - A very simple and lightweight assertion library for Bash.
>    - Primarily focused on testing shell script functions.
>    - GitHub: Assert.sh
> 5. **shellspec**
>    - A full-featured BDD (Behavior Driven Development) framework for shell scripts.
>    - Focuses on readable, expressive specifications.
>    - GitHub: shellspec
>
> Each of these tools has good community support and should fit into your testing workflow for bash scripts.

Prompt to ChatGPT

```
Please provide me references and links to a comparison of those testing
frameworks written by humans. The article should not be older than 2 years.
```

Answer from ChatGPT

> If you're looking for comparisons between bash testing frameworks, recent
> articles and resources can help you evaluate the best fit for your project.
> Here are some useful overviews:
>
> 1. **Bats (Bash Automated Testing System)** is highly regarded for its simple
>    syntax and TAP (Test Anything Protocol) compliance, making it easy to
>    integrate with other TAP-compliant tools. It's actively maintained and
>    widely used in CI/CD pipelines
>    [LibHunt](https://www.libhunt.com/compare-shunit2-vs-bats-core) > [Github](https://github.com/topics/shellspec).
> 2. **shUnit2** is an older, but reliable option for unit testing bash
>    scripts. It has a simple interface, though it may lack some of the modern
>    features seen in newer frameworks like Bats and ShellSpec
>    [LibHunt](https://www.libhunt.com/compare-shunit2-vs-bats-core).
> 3. **ShellSpec** offers a full-featured behavior-driven development (BDD)
>    approach to testing, similar to popular frameworks in other languages.
>    It's designed to be compatible with multiple shells (bash, zsh, dash,
>    etc.) and is actively maintained
>    [GitHub](https://github.com/topics/shellspec).
> 4. **Assert.sh** is a lightweight, minimalistic framework that simplifies
>    shell testing with basic assertions. It's a great option if you're
>    looking for something that requires little setup but still offers core
>    functionality [GitHub](https://github.com/lehmannro/assert.sh).
>
> For a deeper comparison and more details, you can explore articles like those
> on GitHub or software discussion platforms like
> [LibHunt](https://www.libhunt.com/compare-shunit2-vs-bats-core).

The answers above were provided a good overview which testing frameworks
existed but it didn't provide a comparison which Jane would trust.

Searching on Google with the terms `comparison unit testing frameworks bash`
provided the answer she was searching for: [In search of the best test
framework](https://github.com/dodie/testing-in-bash) compares the testing
frameworks listed above and some more.

Looking at the comparison tables Jane's first choice would have been
[bashunit](https://github.com/TypedDevs/bashunit) because it fulfills most
criteria for a good testing framework:

- Open source with a permissive license
- Requirements to the test framework:
  - Good documentation
  - Active community
  - Easy to install, no dependencies
  - Isolation between tests
  - Support for mocking with
  - Reporting in Junit XML format
  - Tests are written in bash and don't have their own DSL
  - Compatible with the [unofficial bash strict mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

At the end Jane decided to use
[bats-core](https://bats-core.readthedocs.io/en/stable/) since it is more
mature (13 years) and its community is bigger (over 4k stars, more than 100
contributors)

## Installing bats

```bash

```

## Test Skeleton

Create the first tests in `tests/call_without_arguments`

```

```

TODO: setup project skeleton
