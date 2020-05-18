.clear_exported <- function()
{
  .clear.file <- c("\\name{Exported-typos}",
                   "\\alias{Exported-typos}",
                   "\\title{List of currently exported typos}",
                   "\\description{",
                   "List of currently exported typos",
                   "}",
                   "\\details{",
                   "Exported typos:",
                   "\\itemize{",
                   "}",
                   "}",
                   "")
  writeLines(.clear.file,"man/Exported-typos.Rd")
  writeLines("","R/Exported-typos.R")
}

.typo_doc <- function(.incorrect,.correct,.package=base,back.tick=F)
{
  requireNamespace("rlang",quietly=T)
  .incorrect_str <- rlang::as_name(rlang::enquo(.incorrect))
  .correct_str <- rlang::as_name(rlang::enquo(.correct))
  .package_str <- rlang::as_name(rlang::enquo(.package))
  .package_str_raw <- .package_str
  if(.package_str == "base")
    .package_str <- "" else
      .package_str <- paste0(",",.package_str)

  .alias <- paste0("\\alias{",.incorrect_str,"}",sep="")

  if(back.tick)
  {
    .incorrect_str <- paste0("`",.incorrect_str,"`")
    .correct_str <- paste0("`",.correct_str,"`")
  }

  .typo_code <- paste0(
    .incorrect_str,
    " <- .typo(",
    .correct_str,
    .package_str,
    ")"
  )

  .item <- paste0("\\item \\code{",.typo_code,"}")

  .export_Rd <- readLines("man/Exported-typos.Rd")
  .alias.line <- grep("\\alias{",.export_Rd,fixed=T)

  .export_Rd <- append(.export_Rd,
                       .alias,
                       after=utils::tail(.alias.line,1))
  .export_Rd <- append(.export_Rd,
                       .item,
                       after=length(.export_Rd)-3)
  writeLines(.export_Rd,"man/Exported-typos.Rd")


  .export_R <- readLines("R/Exported-typos.R")
  .export_R <- append(.export_R,
                      c("#' @export",
                        .typo_code,
                        ""))
  writeLines(.export_R,"R/Exported-typos.R")

  if(!.package_str_raw %in% c("rlang","base"))
    usethis::use_package(.package_str_raw,"Suggests")

  return(c(.incorrect_str,.correct_str))
}

