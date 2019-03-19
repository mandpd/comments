##############################
#
# Wrapper functions
#
##############################

## PRINT
#' print commented Function
#'
#' This function suppresses the class and comments attributes in the default print function.
#' @param x R object to summarize
#' @param ... other pass variables
#' @param shownotes flag to show or hide notes accosiated with the R object
#' @param showtimestamps boolean to indicate if timestamps for each comment should be shown or hidden
#' @return print output
#' @keywords print commented
#' @export
print.commented <- function(x, ..., shownotes = F, showtimestamps = T) {
  notes_x <- x
  if(shownotes) {
    getNotes(x, showtimestamps)
  }
  # if this is a basic vector or list, suppress additional class output 2
  if(is.data.frame(x)) {
    NextMethod(x, ...)
  }  else if (is.list(x)) {
    x <- list(unlist(x))
    NextMethod(x, ...)
  } else if (is.numeric(x)) {
    x <- c(x)
    NextMethod(x, ...)
  } else {
    NextMethod(x, ...)
  }
  invisible(notes_x)
}


## SUMMARY
#' summary commented Function
#'
#' This function appends the comments output to the standard summary function.
#' @param object R object to summarize
#' @param ... other pass variables
#' @return summary output
#' @keywords summary commented
#' @export
summary.commented <- function(object, ...) {
  getNotes(object, showtimestamps = T)
  NextMethod(object, ...)
}

## DPLYR

#' mutate commented Function
#'
#' This function allows the dplyr mutate function to work with commented objects.
#' @param x R object to mutate
#' @param ... other pass variables
#' @return mutated object
#' @keywords mutate commented
#' @export
mutate.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}

#' select commented Function
#'
#' This function allows the dplyr select function to work with commented objects.
#' @param x R object to mutate
#' @param ... other pass variables
#' @return mutated object
#' @keywords mutate commented
#' @export
select.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}

#' filter commented Function
#'
#' This function allows the dplyr filter function to work with commented objects.
#' @param x R object to mutate
#' @param ... other pass variables
#' @return filtered object
#' @keywords mutate commented
#' @export
filter.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}

#' arrange commented Function
#'
#' This function allows the dplyr arrange function to work with commented objects.
#' @param x R object
#' @param ... other pass variables
#' @return arrangedobject
#' @keywords mutate commented
#' @export
arrange.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}



#' group_by commented Function
#'
#' This function allows the dplyr group_by function to work with commented objects.
#' @param x R object
#' @param ... other pass variables
#' @return  grouped object
#' @keywords mutate commented
#' @export
group_by.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}

#' summarise commented Function
#'
#' This function allows the dplyr summarise function to work with commented objects.
#' @param x R object
#' @param ... other pass variables
#' @return  grouped object
#' @keywords mutate commented
#' @export
summarise.commented <- function(x, ...) {
  comments <- attr(x,'comments')
  cl <- class(x)
  y <- NextMethod(x, ...)
  class(y) <- cl
  attr(y, 'comments') <-  comments
  invisible(y)
}
