context('summary() wrapper Tests')

test_that('commented vectors summarize correctly', {
  df <- c(1,2,3,4,5,6)
  df <- enotes(df)
  expect_equal(capture_output_lines(summary(df))[1],"#    Comments                                                       Time Stamp       ")
})

test_that('commented lists summarize correctly', {
  df <- list(1,2,3,4,'a','b')
  df <- enotes(df)
  expect_equal(capture_output_lines(summary(df))[1],"#    Comments                                                       Time Stamp       ")
})

test_that('commented data frames summarize correctly', {
  df <- (cars)
  df <- enotes(df[1,])
  expect_equal(capture_output_lines(summary(df))[1],"#    Comments                                                       Time Stamp       ")
})


test_that('uncommented objects summarize correctly', {
  df <- cars[1,]
  expect_equal(capture_output(summary(df)),"")
})

