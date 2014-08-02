# plotsvn

## Description

Makes some plots with GNUPlot from SVN logs.

## Usage

Right now, only a single graph is possible: commits by date.

It shows the number of commits per day, per author.

```
$ plotsvn log-file.xml commits-by-date
```

You can filter to a single author by adding its name as last argument.

```
$ plotsvn log-file.xml commits-by-date author-name
```

## Requirements

- GNUPlot

## Requirements to build

- [sbcl][0]
- [buildapp][1]
- eventually, specify your asdf-tree in the Makefile if it's not `~/quicklisp`

## License

MIT License


  [0]: http://sbcl.org
  [1]: http://www.xach.com/lisp/buildapp/
