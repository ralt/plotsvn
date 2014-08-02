# plotsvn

## Description

Makes some plots with GNUPlot from SVN logs.

## Usage

Right now, only a single graph is possible:

```
$ plotsvn log-file.xml commits-by-date author-name
```

## Requirements

- GNUPlot

## Requirements to build

- [buildapp][0]
- eventually, specify your asdf-tree in the Makefile if it's not `~/quicklisp`

## License

MIT License


  [0]: http://www.xach.com/lisp/buildapp/
