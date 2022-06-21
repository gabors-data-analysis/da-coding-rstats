Loops: Programming with R
================
Agoston Reguly

Dataset used: [sp500](https://gabors-data-analysis.com/datasets/#sp500)

## Imperative programming

Reducing code duplication has three main benefits:

1.  It’s easier to see the intent of your code because your eyes are
    drawn to what’s different, not what stays the same.
2.  It’s easier to respond to changes in requirements. As your needs
    change, you only need to make changes in one place, rather than
    remembering to change every place that you copied and pasted the
    code.
3.  You’re likely to have fewer bugs because each line of code is used
    in more places.

A great tool for reducing duplication is iteration, which helps you when
you need to do the same thing to multiple inputs: repeating the same
operation on different columns, or on different datasets. *(Hadley
Wickham and Garrett Grolemund R for Data Science Ch. 21.1)*

There are two important iteration paradigms: *imperative programming*
and *functional programming*. On the imperative side, you have tools
like for loops and while loops, which are a great place to start because
they make iteration very explicit, so it’s obvious what’s happening.
However, loops are quite verbose and require quite a bit of bookkeeping
code that is duplicated for every for loop. Functional programming (FP)
offers tools to extract this duplicated code, so each common for loop
pattern gets its own function.

In this lecture, we focus on **imperative programming** to introduce
students to this topic. In the end, we discuss briefly *functional
programming*, but it will not be covered.

## The `for` loop

The `for` loop repeats the same command multiple times.

Pseudo-code:

``` r
for ( i in vector ) {
  do_something_i_times
}
```

The iteration process is defined inside parentheses after `for` command,
while the command is between the curly brackets. The `index` will be in
this case be `i` and its values defined in `vector`.

Lets take a simple example:

``` r
for( i in c(1,3,5) ){
  print( i )
}
```

    ## [1] 1
    ## [1] 3
    ## [1] 5

Which, prints out the vector’s values. The vector, which is provided for
the for-loop, can be many different things. The most frequently used is
a simple ordered sequence, e.g. the following code will add `i` to `k`
`100` times, where `i` takes the values from 1 to 100.

``` r
k <- 0
for ( i in 1 : 100 ) {
  k <- k + i
}
k
```

    ## [1] 5050

But many other definitions for the `vector` are possible. The most
commonly used are `seq` or `seq_along` functions, but lists or basically
anything can be used.

**Task:** Build a cumulative sum function and calculate the cumulative
sum for `v<-c( 10 , 6 , 5 , 32 , 45 , 23 )!` At the end check with a
conditional statement if the last value in the vector is the same as if
you have been used `cumsum()` function! Hints: define `cs_v` variable
before and then use a for-loop with indexing.

## Computational issues

With for-cycles students need to know what they are doing. In many
cases, it is easy to create a for-cycle that will run almost forever.
Therefore there is a big emphasis when dealing with for-cycles, on how
to properly program. We will not discuss many details here, as the
purpose of this lecture is to show the existence of for-loops and not to
provide a deep analysis of how to write for-cycles.

For this purpose, let us show a simple demonstration of the speed of
pre-allocating memory. To measure CPU-time, we will use the package
`tictoc` (but there are some other alternatives as well).

``` r
if (!require(tictoc)){
  install.packages('tictoc')
  library(tictoc)
}
```

    ## Loading required package: tictoc

``` r
iter_num <- 10000

# Sloppy way to do loops:
tic('Sloppy way')
q <- c()
for ( i in 1 : iter_num ){
  q <- c( q , i )
}
toc()
```

    ## Sloppy way: 0.295 sec elapsed

``` r
# Proper way
tic('Good way')
r <- double( length = iter_num )
for ( i in 1 : iter_num ){
  r[ i ] <- i
}
toc()
```

    ## Good way: 0.01 sec elapsed

You may play along with `iter_num` to find how strong your computer is
and when the ‘good way’ is outperformed by the ‘sloppy way’ in CPU time.
Argue and discuss what is happening!

## While loop

An alternative for the `for-loop` is the `while-loop`. The `while-loop`
iterates until a conditional statement is violated. It is convenient, as
the programmer should not count (or think) about how many times it wants
to evaluate, but only state a conditional statement.

A simple example is to print out `x` until it is smaller than 10.

``` r
x <- 0
while ( x < 10 ) {
  x <- x + 1
  print( x )
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

``` r
x
```

    ## [1] 10

This method has some benefits, but a huge con, namely, that if the
condition is never violated it will run forever. Therefore `while-loops`
are generally not preferred.

**Good-to-know:** If you run an infinite loop, which will never stop,
you can stop R evaluating by hitting a red ‘stop’ icon at the top right
corner of your console window.

### Fixing while loop

It is advised to use a `for-loop` instead of a `while-loop` with a
fairly long iteration number. It has the advantage that it will
eventually stop, while it can be `break` during the iterations if a
condition is satisfied.

The next chunk of code defines `max_iter`, as the maximum number of
iterations for the for-loop and a `flag` variable, which will show us if
the condition is satisfied or not. There are two important parts: the
first is the embedded conditional statement. The second is that if the
conditional is not satisfied (`else` part), then with the command
`break` the iteration will be stopped. Everything which is defined later
within that loop is not going to be executed. For simplicity, we will
use the same code as for the while-loop. We have also added a
notification to say if the iteration was successful or not.

``` r
# Define maximum iteration number and a flag variable for the condition
max_iter <- 10000
flag <- FALSE
x <- 0
for ( i in 1 : max_iter ){
  if ( x < 10 ){
    x <- x + 1 
  } else{
    flag <- TRUE
    break
  }
}
x
```

    ## [1] 10

``` r
if ( flag ) {
  print('Successful iteration!')
}else{
  print('Did not satisfied stopping criterion!')
}
```

    ## [1] "Successful iteration!"

## Good-to-know: functional programming

Here, we are not going to discuss functional programming, only mention
what is it and why it is useful.

The idea of passing a function to another function is an extremely
powerful idea, and it’s one of the behaviors that make R a functional
programming language. The apply family of functions in base R
(`apply()`, `lapply()`, `tapply()`, `sapply()` etc.) are examples of
this. These functions will apply a defined function (e.g. mean) and
execute it multiple times on the supplied objects (e.g. tibble).
`tidyverse` has its own iteration functions in the sub-package `purr`,
such as the `map()` function or its R-object specific functions such as
`map_dbl()`, `map_lgl()` or `map_chr()`.

## Exercise: `sp-500` data

To exercise for-loops, we use the `sp-500` data to calculate yearly
returns.

``` r
library(tidyverse)
# Load data
sp500 <- read_csv('https://osf.io/h64z2/download' , na = c('', '#N/A') )
# Filter out missing and create a year variable
sp500 <- sp500 %>% filter( !is.na( VALUE ) ) %>% 
                  mutate( year = format( DATE , '%Y' ) ) 
# Note: later we will learn to convert date format to year more elegantly
```

To do so, we create a new `tibble` called `return_yearly` and save
`uniqe` values from `sp500$year`. The yearly returns are:

![return_t = \\frac{price_t - price\_{t-1}}{price\_{t-1}}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;return_t%20%3D%20%5Cfrac%7Bprice_t%20-%20price_%7Bt-1%7D%7D%7Bprice_%7Bt-1%7D%7D "return_t = \frac{price_t - price_{t-1}}{price_{t-1}}")

where
![t](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;t "t")
stands for the last day’s price at year
![t](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;t "t").

``` r
years <- unique( sp500$year )
return_yearly <- tibble( years = years , return = NA )

aux <- sp500$VALUE[ sp500$year == years[ 1 ] ]
lyp <- aux[ length( aux ) ]
rm( aux )
for ( i in 2 : length( years ) ){
  # get the values for specific year
  value_year_i <- sp500$VALUE[ sp500$year == years[ i ] ]
  # last day's price
  ldp <- value_year_i[ length(value_year_i) ]
  # calculate the return
  return_yearly$return[ i ] <- ( ldp - lyp ) / lyp * 100
  # save this years last value as last year value
  lyp <- ldp
}

kableExtra::kable(return_yearly,booktabs=T)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
years
</th>
<th style="text-align:right;">
return
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
2006
</td>
<td style="text-align:right;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
2007
</td>
<td style="text-align:right;">
3.5295777
</td>
</tr>
<tr>
<td style="text-align:left;">
2008
</td>
<td style="text-align:right;">
-38.4857937
</td>
</tr>
<tr>
<td style="text-align:left;">
2009
</td>
<td style="text-align:right;">
23.4541932
</td>
</tr>
<tr>
<td style="text-align:left;">
2010
</td>
<td style="text-align:right;">
12.7827101
</td>
</tr>
<tr>
<td style="text-align:left;">
2011
</td>
<td style="text-align:right;">
-0.0031806
</td>
</tr>
<tr>
<td style="text-align:left;">
2012
</td>
<td style="text-align:right;">
13.4056934
</td>
</tr>
<tr>
<td style="text-align:left;">
2013
</td>
<td style="text-align:right;">
29.6012453
</td>
</tr>
<tr>
<td style="text-align:left;">
2014
</td>
<td style="text-align:right;">
11.3906382
</td>
</tr>
<tr>
<td style="text-align:left;">
2015
</td>
<td style="text-align:right;">
-0.7266016
</td>
</tr>
<tr>
<td style="text-align:left;">
2016
</td>
<td style="text-align:right;">
6.1205319
</td>
</tr>
</tbody>
</table>

**Task:** Calculate the monthly returns.

*Note:* Later we will cover more efficient ways of calculating returns,
but it is a good exercise for for-loops.
