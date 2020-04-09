
<!-- README.md is generated from README.Rmd. Please edit that file -->

# typos <img src="logo.png" align="right" height=139 />

<!-- badges: start -->

<!-- badges: end -->

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
`names()` as `nameS()` will throw an error. But, with `typos`, the
function is still evaluated, and rather than an Error, a Warning is
produced.

``` r
nameS(iris)
#> Warning: Typo Detected: nameS instead of names
#> [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"
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
#> function (...) 
#> {
#>     warning("Typo Detected: nameS instead of names", call. = F)
#>     names(...)
#> }
#> <bytecode: 0x0000000015a5b5f8>
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
#Rnorm <- .typo(rnorm,stats)
```

Within the wrapper function, this changes two things. The argument
passed to `requireNamespace()` will match this package, as will the
“proper” function call

``` r
#Rnorm
```

## Warning

Caution should be used if the misspelled version of your function
already exists as a function in it’s own right. The `.typo()` will
overwrite the other “correct” function with the new typo function. For
this reason, it is recommended that `typos` be the first package loaded
to ensure functions loaded in other packages can overwrite the Exported
typos provided here.
