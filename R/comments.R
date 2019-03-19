#' Notes Function
#'
#' This function enables comments to be added to the supplied R object.
#' @param x R object to which comments should be added
#' @param comment optional comment to be added to R object
#' @return Original R object wrapped for use with comment functions
#' @keywords comments
#' @export
#' @examples
#' \dontrun{
#' df <- notes(cars)
#' df <- notes(cars, 'based on cars dataset from http://mysite.com')
#' }
notes <- function(x, comment = '') {
  if (missing(x)) {
    stop('See ?notes for correct usage\n')
  }
  if(!is.character(comment)) {
    cat('Comment should be a string or character vector. See ?notes for for correct usage\n')
    invisible(x)
  }
  if(length(comment) > 66) {
    cat('Your comment should be less than 66 characters.')
    invisible(x)
  }
  if (inherits(x, 'commented')) {
    cat('This object is already enabled for comments\n')
    invisible(x)
  }
  # check it hasn't already been applied

  class(x) <- c('commented', class(x))
  cmtMatrix <- matrix(list(1 ,paste(ifelse(comment == '', 'Comments enabled' ,comment)), Sys.time()), nrow = 1)
  colnames(cmtMatrix) <- c('comment_id','comment_text','comment_timestamp')
  attr(x,'comments') <- cmtMatrix
  invisible(x)
}

#' getNotes Function
#'
#' This function prints the comments associated with to the supplied R object.
#' @param x R object to print the comments from
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @return print out of comments in tabular form
#' @keywords get comments
#' @export
#' @examples
#' \dontrun{
#' df2 <- getNotes(df2)
#' }
getNotes <- function(x, showtimestamps = FALSE) UseMethod("getNotes", x)

#' addNote Function
#'
#' This function allows a comment to be added to the supplied R object.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#' @return Original R object with added comment
#' @keywords add comment
#' @export
#' @examples
#'  \dontrun{
#' df2 <- addNotes(df2, 'My new note')
#' }
addNote <- function(x, comment) UseMethod("addNote", x)

#' deleteNote Function
#'
#' This function allows a comment to be removed from the list of comments associated with the supplied R object.
#' @param x R object to remove the comment from
#' @param index the index of the comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return Original R object with selected comment removed from comments attribute
#' @keywords delete comment
#' @export
#' @examples
#'  \dontrun{
#' df2 <- deleteNote(df2,2,T)
#' }
deleteNote <- function(x, index, confirm) UseMethod("deleteNote",x)

#' getNotes commented Function
#'
#' This function prints the comments associated with the supplied R object.
#' @param x R object to print the comments from
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @return print out of comments in tabular form
#' @keywords get comments
#' @export
getNotes.commented <- function(x, showtimestamps = FALSE) {
  if (missing(x)) {
    stop('See ?getNotes for correct usage\n')
  }
  cmtMatrix <- attr(x,'comments')
  cat(format('#    Comments', width = 66), ifelse(showtimestamps, ' Time Stamp\n', '\n'))
  cat(rep('-', ifelse(showtimestamps, 92, 62)),'\n', sep = '')
  for ( i in 1:nrow(cmtMatrix)) {
    cat(as.character(format(cmtMatrix[i,1]), width = 3),': ', format(as.character(cmtMatrix[i,2]), width = 60), ' ', ifelse(showtimestamps, format(as.POSIXct(cmtMatrix[i,3][[1]]), '%c'), ' '), '\n')
  }
  cat('\n')
}

#' addNote commented Function
#'
#' This function allows a comment to be added to the supplied R object.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#' @return Original R object with added comment
#' @keywords add comment
#' @export
addNote.commented <- function(x,comment) {
  if (missing(x) || missing(comment)) {
    stop('See ?addNote for correct usage\n')
  }
  cmtMatrix <- attr(x, 'comments')
  idx <- as.numeric(cmtMatrix[nrow(cmtMatrix),'comment_id'])
  attr(x, 'comments') <- rbind(cmtMatrix, list(idx+1, comment, Sys.time()))
  NextMethod()
  invisible(x)
}

#' deleteNote commented Function
#'
#' This function allows a comment to be removed from the list of comments associated with the supplied R object.
#' @param x R object to remove the comment from
#' @param index the index of the comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return Original R object with selected comment removed from comments attribute
#' @keywords delete comment
#' @export
deleteNote.commented <- function(x,index, confirm) {
  if (missing(x)) {
    stop('See ?deleteNote for correct usage\n')
  }
  if(missing(confirm)) {
    confirm <- TRUE
  }
  if (confirm) {
    getNotes(x, TRUE)
  }
  if(missing(index)) {
    index <- readline("Enter # of the comment you wish to delete: ")
  }
  ok <- "N"
  if (confirm) {
    message <- paste("Are you sure you want to delete comment #", index, "? (Y or N):")
    ok <- readline(message)
  } else {
    ok <- "Y"
  }
  if (ok == "Y") {
    cmtMatrix <- attr(x, 'comments')
    cmtMatrix <- cmtMatrix[-as.numeric(index),]
    attr(x,'comments') <- cmtMatrix
  }
  invisible(x)
}

#' getNotes Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to print the comments from
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @return message on correct use of function
#' @keywords get comments
#' @export
getNotes.default <- function(x, showtimestamps) {
  cat('See ?getNotes for correct usage\n')
}

#' addNote Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#' @return message on correct use of function
#' @keywords add comment
#' @export
addNote.default <- function(x,comment) {
  ('See ?addNote for correct usage\n')
}

#' deleteNote Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to remove the comment from
#' @param index the index of the comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return message on correct use of function
#' @keywords delete comment
#' @export
deleteNote.default <- function(x, index, confirm) {
  cat('See ?deleteNote for correct usage\n')
}

