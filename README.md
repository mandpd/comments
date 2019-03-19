
[![Travis build
status](https://travis-ci.com/mandpd/comments.svg?branch=master)](https://travis-ci.org/mandpd/comments)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mandpd/comments?branch=master&svg=true)](https://ci.appveyor.com/project/mandpd/comments)
[![Coverage
status](https://codecov.io/gh/mandpd/comments/branch/master/graph/badge.svg)](https://codecov.io/github/mandpd/comments?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# comments

This package allows you to add an attribute to your R objects that can
be used to store comments. It provides a set of functions to list, add,
and delete comments.

## Installation

You can install the released version of comments from
[github](https://github.com/mandpd/comments) with:

``` r
library(githubinstall)
gh_install_packages("comments")
```

## Example

The comments package allows you to add comments to your data sets as you
manipulate them, e.g. during your exploratory data analysis phase. To
enable a data set to contain comments, first apply the notes() function
to it.

### notes()

``` r
library(comments)
df <- notes(cars)
```

This enables the use of addNote(), deleteNote(), and getNotes() with the
cars data.frame

### getNotes()

``` r
getNotes(df)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  Comments enabled
```

### addNote()

Let’s rescale the values in the speed and distance columns to be between
0 and 1, add notes explaining this, and then print out the notes.

``` r
rescale_param <- function(x) { (x-min(x)) / (max(x)- min(x))}
df[] <- lapply(df, rescale_param)
df <- addNote(df, 'rescale speed to between 0 and 1')
df <- addNote(df, 'rescale distance to between 0 and 1')
getNotes(df)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  Comments enabled                                                 
#> 2 :  rescale speed to between 0 and 1                                 
#> 3 :  rescale distance to between 0 and 1
```

### Use with dplyr package

These comments will follow any operations performed on the object, and
can be used in conjunction with dplyr pipes (%\>%) which provides a fast
way to add notes as you proceed

``` r
library(dplyr)
df2 <- notes(cars)
df3 <- df2 %>% 
  addNote('add a time variable based on dist / speed') %>%
  mutate(time = dist / speed) %>%
  addNote('filter out dist variable') %>%
  select(-dist)
getNotes(df3)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  Comments enabled                                                 
#> 2 :  add a time variable based on dist / speed                        
#> 3 :  filter out dist variable
```

``` r
glimpse(df3)
#> Observations: 50
#> Variables: 2
#> $ speed <dbl> 4, 4, 7, 7, 8, 9, 10, 10, 10, 11, 11, 12, 12, 12, 12, 13, …
#> $ time  <dbl> 0.5000000, 2.5000000, 0.5714286, 3.1428571, 2.0000000, 1.1…
```

### deleteNote()

You can selectively remove comments using the comment id

``` r
df3 <- deleteNote(df3,1,confirm = FALSE)
getNotes(df3)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 2 :  add a time variable based on dist / speed                        
#> 3 :  filter out dist variable
```

### summary function

Data frames with the commented class will include any comments when
summary is run

``` r
summary(df3)
#> #    Comments                                                       Time Stamp
#> --------------------------------------------------------------------------------------------
#> 2 :  add a time variable based on dist / speed                      Mon Mar 18 19:31:49 2019 
#> 3 :  filter out dist variable                                       Mon Mar 18 19:31:49 2019
#>      speed           time      
#>  Min.   : 4.0   Min.   :0.500  
#>  1st Qu.:12.0   1st Qu.:1.921  
#>  Median :15.0   Median :2.523  
#>  Mean   :15.4   Mean   :2.632  
#>  3rd Qu.:19.0   3rd Qu.:3.186  
#>  Max.   :25.0   Max.   :5.714
```

### timestamps

All notes are entered with a timestamp. You can use the
‘show\_timestamps’ parameter to see these

``` r
getNotes(df3, show_timestamps = T)
#> #    Comments                                                       Time Stamp
#> --------------------------------------------------------------------------------------------
#> 2 :  add a time variable based on dist / speed                      Mon Mar 18 19:31:49 2019 
#> 3 :  filter out dist variable                                       Mon Mar 18 19:31:49 2019
```
