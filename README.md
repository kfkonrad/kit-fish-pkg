<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### kit
> A plugin for [Oh My Fish][omf-link].

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.2.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>


## Install

```fish
$ omf install kit
```


## Usage

```fish
$ kit clone git@github.com:fish-shell/fish-shell.git
$ kit clone https://github.com/fish-shell/fish-shell.git
```

`kit clone` supports the same parameters as `git clone` except that you must not give the optional directory-parameter - `kit clone` will generate that for you.

`kit clone <URL>` will clone the repo to `~/workspace/<domain>/<uri-path>` (e.g. `~/workspace/github/fish-shell/fish-shell`) so that the domain (without TLD) and path in the URL are translated to a path under `~/workspace`. Non-existing intermediary directories will be auto-generated as well. Both https and ssh/git are supported.

```fish
$ kit help
$ kit -h
$ kit --help
```

Shows a rudimentary help.

```fish
$ kit version
$ kit -v
$ kit --version
```

# License

[MIT][mit] © [Kevin Konrad][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/{{USER}}
[contributors]:   https://github.com/{{USER}}/plugin-kit/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
