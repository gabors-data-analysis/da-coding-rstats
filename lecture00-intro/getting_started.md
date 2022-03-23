Getting started with R
================
Agoston Reguly
March 22, 2022

## Getting familiar with the interface

Show the following features of RStudio: - 4 different windows: - The
Console/Terminal/Jobs window: what are they and how to use them -
Scripts and Files window: the main programming will happen here -
Environment/History/Connection/Tutorial window -
Files/Plots/Packages/Help/Viewer widnow

## Using the console

R can be used as a calculator through the console! E.g. you can type in:

``` r
2+2
```

    ## [1] 4

and R will calculate and show the result in the console window. Note
that every command that you do will show in the console window. It can
be useful if you are getting familiar and using some of the ‘clicking’
options in R as we will see with data import.

## Creating the first script

Using the console is really handy, but will not keep track what we have
done. R-scripts are for this purpose: collect your commands, you can
save this as a file and rerun these commands whenever you want. This is
the first pillar of good coding: reproducible codes.

To create your new script you need to click on
`File -> New file -> R Script` or simply push `shift+cmd+N` on mac or
`shift+crtl+N` on windows.

### Run codes via scripts

Now you can write whatever R will understand. Continuing our example you
can just type in:

``` r
2+2
```

    ## [1] 4

You can see that there is a line number left to your command.
Furthermore, note that nothing will happen eve if you hit enter, but a
new line will show up in the script.

In order to run this code, you need to run it via the console, which can
be done in several ways. The most obvious way to do it is to copy and
paste it to the console, however, it is not really efficient. The
quickest is to bring your courser to the line which you want to run and
hit `cmd+return` or `ctrl+enter`. This will execute the command.
Alternatively you can find the icon on the top-right corner of the
script window, which says `Run` with a possible rolling window.

*Tip:* you may select multiple lines and use the same method to run
multiple codes at once.

``` r
"Hello world!"
```

    ## [1] "Hello world!"

``` r
myString <- "Hello world!"
print(myString)
```

    ## [1] "Hello world!"

``` r
# We can define numbers
a <- 2
b <- 3

a+b-(a*b)^a
```

    ## [1] -31

``` r
c <- a + b
d <- a*c/b*c

# Use of logical operators
a == b
```

    ## [1] FALSE

``` r
2 == 3
```

    ## [1] FALSE

``` r
( a + 1 ) == b
```

    ## [1] TRUE

``` r
a <- 2

a != b
```

    ## [1] TRUE

``` r
# other logical operators
2 == 2 & 3 == 2
```

    ## [1] FALSE

``` r
2 == 2 | 3 == 2
```

    ## [1] TRUE

``` r
# Remove variables from work space
rm(d)

##
# Create vectors
v <- c(2,5,10)
# Operations with vectors
z <- c(3,4,7)

v+z
```

    ## [1]  5  9 17

``` r
v*z
```

    ## [1]  6 20 70

``` r
a+v
```

    ## [1]  4  7 12

``` r
# Number of elements
num_v <- length(v)
num_v
```

    ## [1] 3

``` r
# Create vector from vectors
w <- c(v,z)
w
```

    ## [1]  2  5 10  3  4  7

``` r
length(w)
```

    ## [1] 6

``` r
# Gives an error
# length(W)

# Note: be careful w operation
q <- c(2,3)
v+q
```

    ## Warning in v + q: longer object length is not a multiple of shorter object
    ## length

    ## [1]  4  8 12

``` r
v+c(2,3,2)
```

    ## [1]  4  8 12

``` r
## Extra:
null_vector <- c()
# NaN value
nan_vec <- c(NaN,1,2,3,4)
nan_vec + 3
```

    ## [1] NaN   4   5   6   7

``` r
# Inf values
inf_val <- Inf
5/0
```

    ## [1] Inf

``` r
sqrt(2)^2 == 2
```

    ## [1] FALSE

``` r
# Convention to name your variables
my_fav_var <- "bla"
myFavVar <- "bla"
# Rarely use long names such as
my_favourite_variable <- "bla"

# Difference between doubles and integers
int_val <- as.integer(1.6)
doub_val <- as.double(1)

#
typeof(int_val)
```

    ## [1] "integer"

``` r
typeof(myString)
```

    ## [1] "character"

``` r
is.character(myString)
```

    ## [1] TRUE

``` r
##
# INDEXING - goes with '[]'
v[1]
```

    ## [1] 2

``` r
v[2:3]
```

    ## [1]  5 10

``` r
v[c(1,3)]
```

    ## [1]  2 10

``` r
# Fix the addition of v+q
v[1:2] + q 
```

    ## [1] 4 8

``` r
####
# Lists
my_list <- list("a",2,0==1)
my_list2 <- list(c("a","b"),c(1,2,3),sqrt(2)^2==2)

# indexing with lists:
# you get the list's value - still a list (typeof(my_list2[1]))
my_list2[1]
```

    ## [[1]]
    ## [1] "a" "b"

``` r
# you get the vector's value - it is a character (typeof(my_list2[[1]]))
my_list2[[1]]
```

    ## [1] "a" "b"

``` r
# you get the second element from the vector
my_list2[[1]][2]
```

    ## [1] "b"
