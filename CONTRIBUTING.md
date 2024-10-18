# Contributing

Welcome stranger!

If you have come here to learn how to contribute to this tutorial, we have some tips for you!

First of all, don't hesitate to ask questions! Use the issue tracker, no question is too simple.

## Building the Tutorial

The tutorial is made using [`mdbook`][mdbook]. In case you haven't installed
`mdbook` follow the [installation
instructions](https://rust-lang.github.io/mdBook/guide/installation.html).

Now just run this command from this directory:

```bash
$ mdbook build
```

This will build the tutorial and output files into a directory called `book`. From
there you can navigate to the `index.html` file to view it in your browser. You
could also run the following command to automatically generate changes if you
want to look at changes you might be making to it:

```bash
$ mdbook serve
```

This will automatically generate the files as you make changes and serves them
locally so you can view them easily without having to call `build` every time.

The files are all written in Markdown so if you don't want to generate the tutorial
to read them then you can read them from the `src` directory.

[mdbook]: https://github.com/rust-lang-nursery/mdBook
