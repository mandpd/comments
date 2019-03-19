
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

library(devtools)

install\_github(“mandpd/comments”)

## Example

The comments package allows you to add comments to your data sets as you
manipulate them, e.g. during your exploratory data analysis phase. To
enable a data set to contain comments, first apply the notes() function
to it. You can optionally add an intial comment, e.g. a summary of the
contents of the dataset, or the source of the dataset. Additional notes
can be added using addNote()

### notes()

``` r
library(comments)
df <- notes(cars, 'dataset of speed and stopping distances of cars')
df <- addNote(df, 'from base package') 
```

This enables the use of addNote(), deleteNote(), and getNotes() with the
cars data.frame

### getNotes()

``` r
getNotes(df)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  dataset of speed and stopping distances of cars                  
#> 2 :  from base package
```

### addNote()

Let’s rescale the values in the speed and distance columns to be between
0 and 1, add notes explaining this, and then print out the notes. An
individual comment can contain a maximum of 66 characters. If your
comment needs to be longer, use the addNote function multiple times.

``` r
rescale_param <- function(x) { (x-min(x)) / (max(x)- min(x))}
df[] <- lapply(df, rescale_param)
df <- addNote(df, 'rescaled speed to between 0 and 1')
df <- addNote(df, 'rescaled distance to between 0 and 1')
getNotes(df)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  dataset of speed and stopping distances of cars                  
#> 2 :  from base package                                                
#> 3 :  rescaled speed to between 0 and 1                                
#> 4 :  rescaled distance to between 0 and 1
```

### Use with dplyr package

These comments will follow any operations performed on the object, and
can be used in conjunction with dplyr pipes (%\>%) which provides a fast
way to add notes as you proceed

``` r
library(dplyr)
df2 <- notes(cars, 'dataset of speed and stopping distances of cars')
df3 <- df2 %>% 
  addNote('added a time variable based on dist / speed') %>%
  mutate(time = dist / speed) %>%
  addNote('filtered out dist variable') %>%
  select(-dist)
getNotes(df3)
#> #    Comments                                                      
#> --------------------------------------------------------------
#> 1 :  dataset of speed and stopping distances of cars                  
#> 2 :  added a time variable based on dist / speed                      
#> 3 :  filtered out dist variable
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
#> 2 :  added a time variable based on dist / speed                      
#> 3 :  filtered out dist variable
```

### summary function

Data frames with the commented class will include any comments when
summary is run

``` r
summary(df3)
#> #    Comments                                                       Time Stamp
#> --------------------------------------------------------------------------------------------
#> 2 :  added a time variable based on dist / speed                    Tue Mar 19 12:30:46 2019 
#> 3 :  filtered out dist variable                                     Tue Mar 19 12:30:46 2019
#>      speed           time      
#>  Min.   : 4.0   Min.   :0.500  
#>  1st Qu.:12.0   1st Qu.:1.921  
#>  Median :15.0   Median :2.523  
#>  Mean   :15.4   Mean   :2.632  
#>  3rd Qu.:19.0   3rd Qu.:3.186  
#>  Max.   :25.0   Max.   :5.714
```

### print function

R objects with the commented class will include any comments when print
is run with the ‘shownotes’ parameter set to TRUE

``` r
print(df3[1:5,], shownotes = T)
#> #    Comments                                                       Time Stamp
#> --------------------------------------------------------------------------------------------
#> 2 :  added a time variable based on dist / speed                    Tue Mar 19 12:30:46 2019 
#> 3 :  filtered out dist variable                                     Tue Mar 19 12:30:46 2019 
#> 
#>   speed      time
#> 1     4 0.5000000
#> 2     4 2.5000000
#> 3     7 0.5714286
#> 4     7 3.1428571
#> 5     8 2.0000000
```

### timestamps

All notes are entered with a timestamp. You can use the ‘showtimestamps’
parameter to see these

``` r
getNotes(df3, showtimestamps = T)
#> #    Comments                                                       Time Stamp
#> --------------------------------------------------------------------------------------------
#> 2 :  added a time variable based on dist / speed                    Tue Mar 19 12:30:46 2019 
#> 3 :  filtered out dist variable                                     Tue Mar 19 12:30:46 2019
```
