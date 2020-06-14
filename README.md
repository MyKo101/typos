
<!-- README.md is generated from README.Rmd. Please edit that file -->

# typos <img src="man/figures/logo.png" align="right" height=139 />

The goal of `typos` is to provide a flexible warning when commonly
mis-typed functions are called. Functions with typing errors will still
be evaluated and a warning will be output. It also provides the user
with a convenient function to define their own typos.

## Installation

You can install the development version of `typos` from
[GitHub](https://github.com/) with:

    # install.packages("devtools")
    devtools::install_github("MyKo101/typos")

## Example

For example, without `typos` installed, mistyping the functions
`names()` as `nameS()` will throw an error.

``` r
nameS(mtcars)
#> Warning: Typo of "names()" detected in "nameS()"
#>  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear" "carb"
```

But, with `typos`, the function is still evaluated, and rather than an
Error, a Warning is produced.

``` r
library(typos)
nameS(mtcars)
#> Warning: Typo of "names()" detected in "nameS()"
#>  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear" "carb"
```

## Generating typos

The key to `typo` is the `.typo()` function. To generate a typo, we use
the following syntax:

    <incorrect spelling> <- .typo(<correct spelling>)

For example, the above `nameS` typo is generated with

    nameS <- .typo(names)

## Wrapping

The way `.typo()` works is to generate a wrapper function around the
correctly spelled function. This wrapper function sends a warning to the
user, but still evaluates the “proper” function.

The wrapper function, `nameS` looks like this:

``` r
nameS
#> function(...)
#> {
#>  requireNamespace("base",quietly=T)
#>  .call <- match.call()
#>  .incorrect_call <- as_name(.call[[1]])
#>  .call[[1]] <- quote(names)
#>  .typo_alert("names",.incorrect_call)
#>  eval_tidy(.call,env=rlang::caller_env())
#> }
#> <environment: namespace:typos>
```

Notice that all the arguments passed to `nameS(...)` are forwarded on to
`names(...)`

## Other packages

As well as the correctly spelled function, the `.typo()` function can
take a `.package` argument (this will *always* be the second unnamed
argument, so code can be neater). By default, this will be the `base`
package, but *any* other package will need to be specified (this
includes default packages like `stats`).

``` r
Rnorm <- .typo(rnorm,stats)
```

Within the wrapper function, this changes two things. The argument
passed to `requireNamespace()` will match this package, as will the
“proper” function call

``` r
Rnorm
#> function(...)
#> {
#>  requireNamespace("stats",quietly=T)
#>  .call <- match.call()
#>  .incorrect_call <- as_name(.call[[1]])
#>  .call[[1]] <- quote(rnorm)
#>  .typo_alert("rnorm",.incorrect_call)
#>  eval_tidy(.call,env=rlang::caller_env())
#> }
#> <environment: 0x00000242b5f8fa40>
```

## Warning

Caution should be used if the misspelled version of your function
already exists as a function in it’s own right. The `.typo()` will
overwrite the other “correct” function with the new typo function. For
this reason, it is recommended that `typos` be the first package loaded
to ensure functions loaded in other packages can overwrite the Exported
typos provided here.

## Code of Conduct

Please note that the typos project is released with a [Contributor Code
of Conduct](https://michaelbarrowman.co.uk/typos/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
