#' Add previous comment to highlighted data.frame
#' @export
convertToCommentAddin <- function() {
  document <- rstudioapi::getActiveDocumentContext()
  contents <- document$contents
  selection <- rstudioapi::primary_selection(document)
  comment <- ''
  # find last comment by searching from current position back up document
  lineNum <- as.numeric(selection$range$start[1])
  while(lineNum >= 1) {
    print(paste('line num', lineNum))
    if (grepl('#',contents[lineNum])) {
      comment <- substring(contents[lineNum],2)
      break
    }
    lineNum <- lineNum -1
  }
  # rstudioapi::setCursorPosition(Inf)
  df_name <- selection$text
  df <- getFromSysframes(df_name)
  # check that df is already enabled for comments
  if (grepl('commented',class(df))[1]) {
    rstudioapi::insertText(paste(df_name,' <- anote(',df_name, ',"',trimws(comment),'")', sep = ''))
    } else {
      rstudioapi::insertText(paste(df_name,' <- enotes(',df_name, ',"',trimws(comment),'")', sep = ''))
      }
}

getFromSysframes <- function(x) {
  if (!(is.character(x) && length(x) == 1 && nchar(x) > 0)) {
    warning("Expecting a non-empty character of length 1. Returning NULL.")
    return(invisible(NULL))
  }
  validframes <- c(sys.frames()[-sys.nframe()], .GlobalEnv)
  res <- NULL
  for (i in validframes) {
    inherits <- identical(i, .GlobalEnv)
    res <- get0(x, i, inherits = inherits)
    if (!is.null(res)) {
      return(res)
    }
  }
  return(invisible(res))
}
