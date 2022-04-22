Loops: Programming with R
================
Agoston Reguly

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
  install.packages("tictoc")
  library(tictoc)
}
```

    ## Loading required package: tictoc

``` r
iter_num <- 10000

# Sloppy way to do loops:
tic("Sloppy way")
q <- c()
for ( i in 1 : iter_num ){
  q <- c( q , i )
}
toc()
```

    ## Sloppy way: 0.228 sec elapsed

``` r
# Proper way
tic("Good way")
r <- double( length = iter_num )
for ( i in 1 : iter_num ){
  r[ i ] <- i
}
toc()
```

    ## Good way: 0.009 sec elapsed

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
  print("Successful iteration!")
}else{
  print("Did not satisfied stopping criterion!")
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