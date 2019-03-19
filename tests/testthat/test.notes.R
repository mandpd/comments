context('notes() Tests')

test_that('object with existing commented class is trapped', {
  df <- notes(cars)
  expect_output(notes(df), regexp = 'This object is already enabled for comments')
  expect_equal(class(df)[1], 'commented')
  expect_false(isTRUE(all.equal(class(df)[2], 'commented')))
})

test_that('commented vectors print correctly', {
#  df <- c(1,2,3,4,5,6)
#  df <- notes(df)
#  expect_known_output(print(df),)
})
