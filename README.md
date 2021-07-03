# lxml

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe badge]][lfe]
[![Erlang Versions][erlang badge]][versions]
[![Tags][github tags badge]][github tags]

*An LFE XML parser / wrapper for erlsom*

[![Project logo][logo]][logo]

##### Table of Contents

* [Introduction](#introduction-)
  * [About lxml](#about-lxml-)
* [Installation](#installation-)
* [Usage](#usage-)


## Introduction [&#x219F;](#table-of-contents)

lxml, or as it is better known, Professor El Xavier Emile (A.K.A "El X. Emile"),
is a wrapper for the Erlang community's
[erlsom](https://github.com/willemdj/erlsom) library, providing the following
additional features:

1. Lispy naming conventions via [LFE](https://github.com/rvirding/lfe) and
   [kla](https://github.com/billosys/kla), and
2. Utility functions for easily accessing parsed XML data
   (e.g., ``map``, ``get-in``, ``get-linked``, &c.).

Both of these are discussed more in the lxml docs (see below for the link).


## Installation [&#x219F;](#table-of-contents)

Just add it to your ``rebar.config`` deps:

```erlang
  {deps, [
    ...
    {lxml, ".*", {git, "git@github.com:lfex/lxml.git", {tag, "x.y.z"}}},
    ...]}.
```

Or, if you use ``lfe.config``:

```lisp
#(project (#(deps (#("oubiwann/lxml" "master")))))
```

And then do the usual:

```bash
    $ rebar3 compile
```


## Usage [&#x219F;](#table-of-contents)

Usage information is provided in the documentation:

* [User Guide](http://lfex.github.io/lxml/current/user-guide)


[//]: ---Named-Links---

[org]: https://github.com/lfex
[github]: https://github.com/lfex/lxml
[gitlab]: https://gitlab.com/lfex/lxml
[gh-actions-badge]: https://github.com/lfex/lxml/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfex/lxml/actions
[logo]: priv/images/professor-xavier-emile.png
[lfe]: https://github.com/lfe/lfe
[lfe badge]: https://img.shields.io/badge/lfe-2.0-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-19%20to%2024-blue.svg
[versions]: https://github.com/lfex/lxml/blob/master/.github/workflows/cicd.yml
[github tags]: https://github.com/lfex/lxml/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/lxml.svg
[github downloads]: https://img.shields.io/github/downloads/lfex/lxml/total.svg
[hex badge]: https://img.shields.io/hexpm/v/lxml.svg?maxAge=2592000
[hex package]: https://hex.pm/packages/lxml
[hex downloads]: https://img.shields.io/hexpm/dt/lxml.svg
