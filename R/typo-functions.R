#' @name typo-functions
#'
#' @title
#' Defining typos
#'
#' @description
#' Function used to create a typo and alert the user
#'
#' @param .correct
#' The correctly spelled function for which the wrapper is being defined
#'
#' @param .package
#' The name of the package containing the correct function
#'
#' @param .typo_function
#' Function to be used as an alert
#'
#' @return
#' Wrapper function to call the correctly spelled function
#'
#' @details
#' The `.typo()` function is used to define a typo within the context
#' of the `typo` package. Without `typo`, mistakenly typed functions
#' will cause an Error and not be evaluated; however with `typo`,
#' the function *is* evaluated and a Warning is thrown.
#'
#' @examples
#' nameS <- .typo(names)
#'
#' @export
#'
.typo <- function(.correct,.package=base,.typo_function=.typo_alert)
{
  .pkg_str <- as_name(enquo(.package))
  .correct_str <- as_name(enquo(.correct))
  .alert_str <- as_name(enquo(.typo_function))

   .pkg_func <- paste0(.pkg_str,"::",.correct_str)
  .f <- paste0("function(...)\n",
    "{\n",
    "\trequireNamespace(\"",.pkg_str,"\",quietly=T)\n",
    "\t.call <- match.call()\n",
    "\t.incorrect_call <- as_name(.call[[1]])\n",
    "\t.call[[1]] <- quote(",.correct_str,")\n",
    "\t",.alert_str,"(\"",.correct_str,"\",.incorrect_call)\n",
    "\teval_tidy(.call,env=rlang::caller_env())\n",
  "}",collapse="")

  res <- eval(parse(text=.f))
  environment(res) <- rlang::caller_env()

  return(res)
}

#' @rdname typo-functions
#'
#' @param .call
#' The incorrectly spelled call made by the user
#'
#' @examples
#' .typo_alert("names","nameS(mtcars)")
#'
#' @export
#'
.typo_alert <- function(.correct,.call)
{
  .warn <- paste0("Typo of \"",.correct,"()\" detected in \"",.call,"()\"")
  warning(.warn,call.=F)
}
