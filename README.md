# lxml

<img src="resources/images/professor-xavier-emile.png" />

*An LFE XML-parsing wrapper for erlsom, with utility functions*

Note that for genereating XML in LFE (using S-expressions), we recommend
[exemplar](https://github.com/lfex/exemplar). The intended use for lxml is
the *parsing* of XML documents.

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
* [API Reference](http://lfex.github.io/lxml/current/api)
