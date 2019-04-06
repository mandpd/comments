#' enotes Function
#'
#' This function enables comments to be added to the supplied R object.
#' @param x R object to which comments should be added
#' @param comment optional comment to be added to R object
#' @param category optional category tag for comment
#' @return Original R object wrapped for use with comment functions
#' @keywords comments
#' @export
#' @examples
#' \dontrun{
#' df <- enotes(cars)
#' df <- enotes(cars, 'based on cars dataset from http://mysite.com')
#' }
enotes <- function(x, comment = '', category = 'none') {
  if(!is.character(comment)) {
    cat('Comment should be a string or character vector. See ?notes for for correct usage\n')
    invisible(x)
  } else if(length(comment) > 66) {
    cat('Your comment should be less than 66 characters.')
    invisible(x)
  } else if (!is.character(category) || length(category) != 1 || nchar(category) > 10) {
    cat('category must be string of less than 10 characters. See ?notes for correct usage\n')
    invisible(x)
  } else if (inherits(x, 'commented')) {
    cat('This object is already enabled for comments\n')
    invisible(x)
  } else {

  # check it hasn't already been applied

  class(x) <- c('commented', class(x))
  cmtMatrix <- matrix(list(1 ,paste(ifelse(comment == '', 'Comments enabled' ,comment)), Sys.time(), category), nrow = 1)
  colnames(cmtMatrix) <- c('comment_id','comment_text','comment_timestamp','comment_category')
  attr(x,'comments') <- cmtMatrix
  invisible(x)
  }
}

#' notes Function
#'
#' This function prints the comments associated with the supplied R object. If a single comment is specified by
#' @param x R object to print the comments from
#' @param ids vector of comment id's to return
#' @param commentonly default = FALSE, set to TRUE to only return the comment text
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @param showcategories boolean to indicate if comment categories for each comment should be shown or hidden
#' @return print out of comments in tabular form
#' @keywords get comments
#' @export
#' @examples
#' \dontrun{
#' df <- notes(df)
#' }
notes <- function(x, ids = NULL, commentonly = FALSE, showtimestamps = FALSE, showcategories = FALSE) UseMethod("notes", x)

#' rnotes Function
#'
#' This function returns the raw comments matrix associated with the supplied R object.
#' @param x R object to print the comments from
#' @return comments matrix
#' @keywords get comments matrix
#' @export
#' @examples
#' \dontrun{
#' df <- rnotes(df)
#' }
rnotes <- function(x) UseMethod("rnotes", x)

#' todos Function
#'
#' This function prints the comments associated with the supplied R object with a category of 'todo'.
#' @param x R object to print the todo comments from
#' @param showtimestamps boolean to indicate if timestamps for each todo comment should be shown or hidden
#' @return print out of todo comments in tabular form
#' @keywords get todo comments
#' @export
#' @examples
#' \dontrun{
#' df2 <- todo(df2)
#' }
todos <- function(x, showtimestamps = FALSE) UseMethod("todos", x)


#' anote Function
#'
#' This function allows a comment to be added to the supplied R object.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#' @param category optional category tag for comment
#' @return Original R object with added comment
#' @keywords add comment
#' @export
#' @examples
#'  \dontrun{
#' df2 <- anote(df2, 'My new note')
#' }
anote <- function(x, comment, category = 'none') UseMethod("anote", x)

#' dnote Function
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
#' df2 <- dnote(df2,2,T)
#' }
dnote <- function(x, index, confirm) UseMethod("dnote", x)

#' atodo Function
#'
#' This function allows a todo comment to be added to the supplied R object.
#' @param x R object to add a comment to
#' @param comment the text of the todo comment to add
#' @return Original R object with added comment
#' @keywords add comment
#' @export
#' @examples
#'  \dontrun{
#' df2 <- atodo(df2, 'My new todo note')
#' }
atodo <- function(x, comment) UseMethod("atodo", x)

#' dtodo Function
#'
#' This function allows a todo comment to be removed from the list of todo comments associated with the supplied R object.
#' @param x R object to remove the todo comment from
#' @param index optional index of the todo comment to remove
#' @param confirm optional TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return Original R object with selected comment removed from comments attribute
#' @keywords delete comment
#' @export
#' @examples
#'  \dontrun{
#' df2 <- dtodo(df2,2,T)
#' }
dtodo <- function(x, index, confirm) UseMethod("dtodo", x)

#' notes commented Function
#'
#' This function prints the comments associated with the supplied R object.
#' @param x R object to print the comments from
#' @param ids vector of comment id's to return
#' @param commentonly default = FALSE, set to TRUE to only return the comment text
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @param showcategories boolean to indicate if the category of each comment should be shown or hidden
#' @return print out of comments in tabular form
#' @keywords get comments
#' @export
notes.commented <- function(x, ids = NULL, commentonly = NULL, showtimestamps = FALSE, showcategories = FALSE) {
  cmtMatrix <- attr(x,'comments')
  # check ids is an integer vector
  if(!is.null(ids)) {
    for(id in ids) {
      # check all entries are integers
      if(id%%1!=0) {
        return(print("ids must be a vector of class id's"))
      }
      # check all class id's exist
      if(is.null(cmtMatrix[,1] == id)) {
        return(print(paste('comment id ', id, 'does not exist')))
      }

    }
    cmtMatrix <- cmtMatrix[apply(cmtMatrix,1, function(row) {row[1] %in% ids}),, drop=F]
  }
  if(is.null(commentonly)) {
    commentonly <- if(length(ids) == 1) TRUE else FALSE
  }
  if(!commentonly) {
    cat(format('#    Comments', width = 66), ifelse(showtimestamps, ' Time Stamp      ', ''), ifelse(showcategories, ' Category\n', '\n'))
    cat(rep('-', ifelse(showtimestamps, ifelse(showcategories, 96, 92), ifelse(showcategories, 79, 70))),'\n', sep = '')
  }

  for ( i in 1:nrow(cmtMatrix)) {
    if(commentonly) {
      cat(as.character(cmtMatrix[i,2]), '\n')
    } else {
    cat(as.character(format(cmtMatrix[i,1]), width = 3),': ', format(as.character(cmtMatrix[i,2]), width = 60), ' ', ifelse(showtimestamps, format(as.POSIXct(cmtMatrix[i,3][[1]]), '%m/%d/%Y %H:%M '), ''), ifelse(showcategories, format(as.character(cmtMatrix[i,4][[1]]), width = 9), ''), '\n')
  }
  #cat('\n')
  }
}

#' rnotes commented Function
#'
#' This function returns the raw comments matrix associated with the supplied R object.
#' @param x R object to print the comments from
#' @return comments matrix
#' @keywords get comments matrix
#' @export
rnotes.commented <- function(x) {
  cmtMatrix <- attr(x,'comments')
  return(cmtMatrix)
}

#' todos commented Function
#'
#' This function prints the comments associated with the supplied R object with a category of 'todo'.
#' @param x R object to print the comments from
#' @param showtimestamps boolean to indicate if timestamps for each todo comment should be shown or hidden
#' @return print out of todo comments in tabular form
#' @keywords get comments
#' @export
todos.commented <- function(x, showtimestamps = FALSE) {
  cmtMatrix <- attr(x,'comments')
  todoMatrix <- cmtMatrix[cmtMatrix[, 'comment_category'] == "todo",]
  if (length(todoMatrix) == 0) {
    return('None')
  }
  cat(format('#    To Do', width = 66), ifelse(showtimestamps, ' Time Stamp', ''), '\n')
  cat(rep('-', ifelse(showtimestamps, 92, 70)),'\n', sep = '')
  if (!is.matrix(todoMatrix)) {
    cat(as.character(format(todoMatrix$comment_id[[1]]), width = 3),': ', format(as.character(todoMatrix$comment_text[[1]]), width = 60), ' ', ifelse(showtimestamps, format(as.POSIXct(todoMatrix$comment_timestamp[[1]]), '%m/%d/%Y %H:%M '), ''), '\n')
  } else {
  for ( i in 1:nrow(todoMatrix)) {
    cat(as.character(format(todoMatrix[i,1]), width = 3),': ', format(as.character(todoMatrix[i,2]), width = 60), ' ', ifelse(showtimestamps, format(as.POSIXct(todoMatrix[i,3][[1]]), '%m/%d/%Y %H:%M '), ''), '\n')
  }
  cat('\n')
  }
}



#' anote commented Function
#'
#' This function allows a comment to be added to the supplied R object.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#' @param category optional category tag for comment
#' @return Original R object with added comment
#' @keywords add comment
#' @export
anote.commented <- function(x, comment, category = 'none') {
  if (missing(comment)) {
    cat('See ?anote for correct usage\n')
  } else if (!is.character(category) || length(category) != 1 || nchar(category) > 10) {
    cat('category must be string of less than 10 characters. See ?anote for correct usage\n')
    invisible(x)
  } else {
  cmtMatrix <- attr(x, 'comments')
  idx <- as.numeric(cmtMatrix[nrow(cmtMatrix),'comment_id'])
  attr(x, 'comments') <- rbind(cmtMatrix, list(idx+1, comment, Sys.time(), category))
  invisible(x)
  }
}

#' dnote commented Function
#'
#' This function allows a comment to be removed from the list of comments associated with the supplied R object.
#' @param x R object to remove the comment from
#' @param index the index of the comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return Original R object with selected comment removed from comments attribute
#' @keywords delete comment
#' @export
dnote.commented <- function(x, index, confirm) {
    if(missing(confirm)) {
    confirm <- TRUE
  }
  if (confirm) {
    notes(x, TRUE)
  }
  if(missing(index)) {
    index <- readline("Enter # of the comment you wish to delete: ")
  }
  ok <- "N"
  if (confirm) {
    message <- paste("Are you sure you want to delete to do #", index, "? (Y or N):")
    ok <- readline(message)
  } else {
    ok <- "Y"
  }
  if (ok == "Y") {
    cmtMatrix <- attr(x, 'comments')
    cmtMatrix <- cmtMatrix[-as.numeric(index),]
    if(is.matrix(cmtMatrix)) {
      # re-index notes
      cmtMatrix[,'comment_id'] <- c(1:nrow(cmtMatrix))
      attr(x,'comments') <- cmtMatrix
    } else {
      cmtMatrix$commed_id <- 1
      attr(x,'comments') <- matrix(cmtMatrix, nrow= 1)
    }

  }
  invisible(x)
}


#' atodo commented Function
#'
#' This function allows a todo comment to be added to the supplied R object.
#' @param x R object to add a todo comment to
#' @param comment the text of the todo comment to add
#' @return Original R object with added todo comment
#' @keywords add comment todo
#' @export
atodo.commented <- function(x, comment) {
  if (missing(comment)) {
    cat('See ?anote for correct usage\n')
  } else {
    cmtMatrix <- attr(x, 'comments')
    idx <- as.numeric(cmtMatrix[nrow(cmtMatrix),'comment_id'])
    attr(x, 'comments') <- rbind(cmtMatrix, list(idx+1, comment, Sys.time(), 'todo'))
    invisible(x)
  }
}

#' dtodo commented Function
#'
#' This function allows a todo comment to be removed from the list of todo comments associated with the supplied R object.
#' @param x R object to remove the todo comment from
#' @param index optional index of the todo comment to remove
#' @param confirm optional TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return Original R object with selected todo comment removed from list of comments
#' @keywords delete comment todo
#' @export
dtodo.commented <- function(x, index, confirm) {
  if(missing(confirm)) {
    confirm <- TRUE
  }
  if (confirm) {
    todos(x, TRUE)
  }
  if(missing(index)) {
    index <- readline("Enter # of the todo comment you wish to delete: ")
  }
  ok <- "N"
  if (confirm) {
    message <- paste("Are you sure you want to delete todo comment #", index, "? (Y or N):")
    ok <- readline(message)
  } else {
    ok <- "Y"
  }
  if (ok == "Y") {
    x <- dnote(x, index = index, confirm = F)
    #cmtMatrix <- attr(x, 'comments')
    #cmtMatrix <- cmtMatrix[-as.numeric(index),]
    #attr(x,'comments') <- cmtMatrix
  }
  invisible(x)
}

#' notes Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to print the comments from
#' @param ids vector of comment id's to return
#' @param commentonly default = FALSE, set to TRUE to only return the comment text
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @param showcategories boolean to indicate if the category of each comment should be shown or hidden
#' @return message on correct use of function
#' @keywords get comments
#' @export
notes.default <- function(x, ids, commentonly, showtimestamps, showcategories) {
  cat('See ?notes for correct usage\n')
  invisible(x)
}

#' rnotes Default Function
#'
#' This function returns the raw comments matrix associated with the supplied R object.
#' @param x R object to print the comments from
#' @return comments matrix
#' @keywords get comments matrix
#' @export
rnotes.default <- function(x) {
  cat('See ?notes for correct usage\n')
  invisible(x)
}

#' todos Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to print the comments from
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @return message on correct use of function
#' @keywords get comments
#' @export
todos.default <- function(x, showtimestamps) {
  cat('See ?todo for correct usage\n')
  invisible(x)
}

#' anote Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to add a comment to
#' @param comment the text of the comment to add
#'
#' @param category optional category tag for comment
#' @return message on correct use of function
#' @keywords add comment
#' @export
anote.default <- function(x,comment, category) {
  cat('See ?anote for correct usage\n')
  invisible(x)
}

#' dnote Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to remove the comment from
#' @param index the index of the comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return message on correct use of function
#' @keywords delete comment
#' @export
dnote.default <- function(x, index, confirm) {
  cat('See ?dnote for correct usage\n')
  invisible(x
  )
}

#' atodo Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to add a todo comment to
#' @param comment the text of the todo comment to add
#' @return message on correct use of function
#' @keywords add comment todo
#' @export
atodo.default <- function(x,comment) {
  cat('See ?anote for correct usage\n')
  invisible(x)
}

#' dtodo Default Function
#'
#' This function provides a help message when applied to an R object that has not been enabled for comments.
#' @param x R object to remove the todo comment from
#' @param index the index of the todo comment to remove
#' @param confirm TRUE = require confirmation before deleting, FALSE = delete without confirmation
#' @return message on correct use of function
#' @keywords delete comment todo
#' @export
dtodo.default <- function(x, index, confirm) {
  cat('See ?dnote for correct usage\n')
  invisible(x
  )
}

