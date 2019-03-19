context('notes() Tests')

test_that('object with existing commented class is trapped', {
  df <- notes(cars)
  expect_output(notes(df), regexp = 'This object is already enabled for comments')
  expect_equal(class(df)[1], 'commented')
  expect_false(isTRUE(all.equal(class(df)[2], 'commented')))
})

test_that('non-character comments are rejected with correct error message', {
  expect_equal(capture_output(notes(cars, comment = c(1,2,3,4,5,6))),'Comment should be a string or character vector. See ?notes for for correct usage')
})


test_that('> 66 character comments are rejected with correct error message', {
  expect_equal(capture_output(notes(cars, comment = rep('a',67))),'Your comment should be less than 66 characters.')
})

test_that('object is enabled for comments', {
  # data.frame
  df <- notes(cars)
  expect_equal(capture_output(getNotes(df)), '#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n')
  # vector
  df <- notes(c(1,2,3,4,5,6))
  expect_equal(capture_output(getNotes(df)), '#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n')
  # list
  df <- notes(list(1,2,3,4,'a','b'))
  expect_equal(capture_output(getNotes(df)), '#    Comments                                                      \n--------------------------------------------------------------\n1 :  Comments enabled                                                 \n')
  })

test_that('comments parameter works correctly', {
  df <- notes(cars, comment = 'first comment')
  expect_equal(capture_output(getNotes(df)), '#    Comments                                                      \n--------------------------------------------------------------\n1 :  first comment                                                    \n')
})
