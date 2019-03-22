context('print() wrapper Tests')

test_that('commented vectors print correctly', {
  df <- c(1,2,3,4,5,6)
  df <- enotes(df)
  expect_equal(capture_output(print(df, shownotes = T, showtimestamps = F)),"#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n\n[1] 1 2 3 4 5 6")
})

test_that('commented lists print correctly', {
  df <- list(1,2,3,4,'a','b')
  df <- enotes(df)
  expect_equal(capture_output(print(df, shownotes = T, showtimestamps = F)),'#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n\n[[1]]\n[1] \"1\" \"2\" \"3\" \"4\" \"a\" \"b\"\n')
})

test_that('commented data frames print correctly', {
  df <- (cars)
  df <- enotes(df[1,])
  expect_equal(capture_output(print(df, shownotes = T, showtimestamps = F)),'#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n\n  speed dist\n1     4    2')
})

test_that('commented data frames print correctly', {
  df <- (cars)
  df <- enotes(df[1,])
  expect_equal(capture_output(print(df, shownotes = T, showtimestamps = F)),'#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n\n  speed dist\n1     4    2')
})

test_that('uncommented objects print correctly', {
  df <- cars[1,]
  expect_equal(capture_output(print(df)),'  speed dist\n1     4    2')
})

test_that('shownotes and showtimestamps parameters work correctly', {
  df <- enotes(c(1,2,3,4,5,6))
  expect_equal(capture_output_lines(print(df, shownotes = T, showtimestamps = T))[1],'#    Comments                                                       Time Stamp')
  expect_equal(capture_output(print(df, shownotes = T, showtimestamps = F)),'#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n\n[1] 1 2 3 4 5 6')
  expect_equal(capture_output(print(df, shownotes = F)),'[1] 1 2 3 4 5 6')
})
