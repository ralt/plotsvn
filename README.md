# plotsvn

## Description

Makes some plots with GNUPlot from SVN logs.

## Installation

See the [requirements to build](#requirements-to-build).

```
$ make
$ sudo make install
```

## Usage

You first need to generate the XML log file from SVN. Typically, run this:

```
$ svn log --xml > log-file.xml
```

From this on, list of possible graphs:

- commits by date: shows the number of commits per date, per author
- commits total: shows the total number of commits per author

### commits-by-date

It shows the number of commits per day, per author.

```
$ plotsvn log-file.xml commits-by-date
```

You can filter to a single author by adding its name as last argument.

```
$ plotsvn log-file.xml commits-by-date author-name
```

### commits-total

It shows the total number of commits per author.

```
$ plotsvn log-file.xml commits-total
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
