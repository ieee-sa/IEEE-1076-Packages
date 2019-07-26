# VHDL Packages

## Packages

The following repo contains open source materials intended for
reference by the IEEE 1076 standard when approved and published.

## License

All source code files in this repository are subject to the
following copyright and licensing terms.

Copyright 2019 IEEE P1076 WG Authors

See the LICENSE file distributed with this work for copyright and
licensing information, the AUTHORS file for a list of copyright
holders, and the CONTRIBUTORS file for the list of contributors.

## Disclaimer

This open source repository contains material that may be included-in
or referenced by an unapproved draft of a proposed IEEE Standard. All
material in this repository is subject to change. The material in this
repository is presented "as is" and with all faults. Use of the
material is at the sole risk of the user. IEEE specifically disclaims
all warranties and representations with respect to all material
contained in this repository and shall not be liable, under any
theory, for any use of the material. Unapproved drafts of proposed
IEEE standards must not be utilized for any conformance/compliance
purposes.

## Links:
IEEE P1076 Working Group: http://www.eda-twiki.org/cgi-bin/view.cgi/P1076/WebHome  

## Git in a GUI

**Using Git in a GUI (recommended):**  
* **SourceTree** for Windows and Max OS  
  **=>** https://www.sourcetreeapp.com/  
* **SmartGit** for Linux or Windows  
  **=>** http://www.syntevo.com/smartgit/  

**Using Git in PowerShell:**
* **PoshGit** a PowerShell addon  
  **=>** http://dahlbyk.github.io/posh-git/

Please clone this repository onto your local machine and rename the default remote called `origin` to `gitlab`. This gives nicer messages in automatic Git messages.
```Bash
git remote rename origin gitlab
```

## Git on Console

#### PowerShell

Add the command `git tree` and `git treea` to Git. These commands display the commit tree as colored ASCII art
in the console window.

```PowerShell
git config --global alias.tree 'log --decorate --pretty=oneline --abbrev-commit --date-order --graph'
git config --global alias.treea 'log --decorate --pretty=oneline --abbrev-commit --date-order --graph --all'
```

#### Bash

Add the command `git tree` and `git treea` to Git. These commands display the commit tree as colored ASCII art
in the console window. Some Linux distributions need to enable colors in the pager (e.g. `less`).

```Bash
git config --global alias.tree 'log --decorate --pretty=oneline --abbrev-commit --date-order --graph'
git config --global alias.treea 'log --decorate --pretty=oneline --abbrev-commit --date-order --graph --all'
```
