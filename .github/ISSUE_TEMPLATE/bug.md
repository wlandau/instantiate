---
name: Bug
about: Please do not submit a bug report unless your issue is a genuine bug in instantiate and not a known limitation, usage error, or issue from another package that instantiate depends on.
title: ""
labels: "type: bug"
assignees: wlandau
---

## Prework

* [ ] Read and agree to the [Contributor Code of Conduct](https://github.com/wlandau/instantiate/blob/main/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/ropensci/instantiate/blob/main/CONTRIBUTING.md).
* [ ] Confirm that your issue is a genuine bug in the `instantiate` package itself and not a user error, known limitation, or issue from another package that `instantiate` depends on. For example, if you get errors running `tar_make_clustermq()`, try isolating the problem in a reproducible example that runs `clustermq` and not `instantiate`. And for miscellaneous troubleshooting, please post to [discussions](https://github.com/ropensci/instantiate/discussions) instead of [issues](https://github.com/ropensci/instantiate/issues).
* [ ] If there is [already a relevant issue](https://github.com/ropensci/instantiate/issues), whether open or closed, comment on the existing thread instead of posting a new issue.
* [ ] Post a [minimal reproducible example](https://www.tidyverse.org/help/) so the maintainer can troubleshoot the problems you identify. A reproducible example is:
    * [ ] **Runnable**: post enough R code and data so any onlooker can create the error on their own computer.
    * [ ] **Minimal**: reduce runtime wherever possible and remove complicated details that are irrelevant to the issue at hand.
    * [ ] **Readable**: format your code according to the [tidyverse style guide](https://style.tidyverse.org/).

## Description

Please describe the bug.

## Reproducible example

* [ ] Post a [minimal reproducible example](https://www.tidyverse.org/help/) so the maintainer can troubleshoot the problems you identify. A reproducible example is:
    * [ ] **Runnable**: post enough R code and data so any onlooker can create the error on their own computer.
    * [ ] **Minimal**: reduce runtime wherever possible and remove complicated details that are irrelevant to the issue at hand.
    * [ ] **Readable**: format your code according to the [tidyverse style guide](https://style.tidyverse.org/).

## Expected result

What should have happened? Please be as specific as possible.

## Diagnostic information

* A [reproducible example](https://github.com/tidyverse/reprex).
* Session info, available through `sessionInfo()` or [`reprex(si = TRUE)`](https://github.com/tidyverse/reprex).
* A stack trace from `traceback()` or `rlang::trace_back()`.
* The [SHA-1 hash](https://git-scm.com/book/en/v1/Getting-Started-Git-Basics#Git-Has-Integrity) of the GitHub commit of `instantiate` currently installed. `packageDescription("instantiate")$GithubSHA1` shows you this.
