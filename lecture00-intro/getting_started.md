Getting started with R
================
Agoston Reguly
March 22, 2022

## Getting familiar with the interface

Show the following features of RStudio:

Different windows:

-   The Console/Terminal/Jobs window: what are they and how to use them
-   Scripts and Files window: the main programming will happen here
-   Environment/History/Connection/Tutorial window
-   Files/Plots/Packages/Help/Viewer window

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

You can also use characters, but in this case you will need to use `'`
or `"` signs before and after:

``` r
"Hello world!"
```

    ## [1] "Hello world!"

## Variables

Running simple codes are great, but in many cases we want to write
elaborate multistep commands. In this case we can create `variables`,
which will store information in the memory and can be called later.

E.g. we can save the command “Hello world!” into a variable, that we
call `myString` in the following way:

``` r
myString <- "Hello world!"
```

If you run this piece of command, seemingly nothing happens - or at
least in the console window does not print out anything only runs the
command. However, a new variables shows up in the `Environment` window
under the `Values` section, which says: ‘myString’ and “Hello world!”.
It shows that there is a `variable` stored in the memory with the name
of `myString`.

*Fun fact:* the assignment operator `<-` is somewhat a unique feature of
R. Many programming language use instead `=` to define variables. In
many cases `=` works as well in R, but in some other cases it does not,
s we stick with the assignment operator of `<-`. We will see when
covering functions when `=` does not work, but if you can not wait until
then, you may check out [this stackowerflow
thread](https://stackoverflow.com/questions/1741820/what-are-the-differences-between-and-assignment-operators-in-r).

*Tip:* You can use the following hotkey for `<-`: `option+-` for mac and
`alt+-` for windows.

You can call this variable via typing in and running:

``` r
myString
```

    ## [1] "Hello world!"

***Good to know: *** Naming convention in programming broadly speaking
has two big branch. One is utilizing capital letters, the other one the
underscore. Both of them are good, but try not to mix them. You are
completely free to use any variable name, but always keep in mind the
three requirements:

1.  human-readable:

-   good: `myString` or `my_string` refers to a variable which includes
    a string, but
-   bad: `m3st96k` does not reveal much about the possible content

2.  computer-readable:

-   good: `myString`
-   bad: `1-my-string!` as it uses invalid characters. E.g. never start
    with a number and avoid special characters such as -,.!\~=&^%$ etc.

3.  short names

-   good: `myStr`, `my_string` , `m_string`
-   bad: `my_new_string_i_will_use`, this is just hard to write out
    every time and the probability of making coding mistakes are getting
    larger

4.  (+1) try to avoid already defined *function names* or already
    *existing variables*. We will see what are they and it is always
    advised not to re-define variables. It just sources of confusion and
    will make de-bugging much harder.

### Numeric operations

One can define numeric variables similarly. Let us create `a` and `b`
with values of 2 and 3 respectively:

``` r
a <- 2
b <- 3
```

Now, instead of using the numbers 2 and 3 we can use `a` and `b` instead
when doing mathematical operations:

``` r
a+b-(a*b)^a
```

    ## [1] -31

We can create new variables, defined by already existing variables:

``` r
c <- a + b
d <- a*c/b*c
```

Note: R is case-sensitive, which means `A` is not the same as `a` and if
you use `A` instead, it will result in an error!

## Logical operations

In many cases you want to check if two value or variable are the same or
not. For this purpose, you can use the so-called logical operators.

Check if values are the same with `==` command,

``` r
6 == 12
```

    ## [1] FALSE

Check if two variables are the same,

``` r
a == b
```

    ## [1] FALSE

Check if a modified variable is the same as the other,

``` r
( a + 1 ) == b
```

    ## [1] TRUE

You can also check if the two variables are **not** the same with `!=`
command:

``` r
a != b
```

    ## [1] TRUE

It is also possible to make more elaborate comparisons with multiple
statements. E.g. we can compare if `2==2` **and** `3==2` with the `&`
operator:

``` r
2 == 2 & 3 == 2
```

    ## [1] FALSE

or, if `2==2` **or** `3==2` with the `|` operator

``` r
2 == 2 | 3 == 2
```

    ## [1] TRUE

Note: later we will discuss the difference between `&,|` and `&&,"||`
operators.

## Simple functions

R is a great software and gains its popularity by the tremendous amount
of functions it has. Functions as in math will take an input and map it
to something else. E.g. `2+3` was a function, which added these two
values together and resulted in `5`. Of course functions can be much
more elaborate and we will see that they are. In principle a function is
constructed as follows: `name(input)` where, `name` is the name of the
function which tells R what to execute. Functions *always* uses `(` and
`)` parenthesis and within the parenthesis you need to define the
`input`, which depends on the function itself. We will see multiple
examples during the course to see many possibilities for these inputs.

Let us start with the simplest functions. It is always a good practice
to keep your Environment (stored variables) tidy. If you have used a
variable, but will not need any more you can delete it from the memory:

``` r
rm(d)
```

will remove variable `d` from your environment and you can not refer to
it anymore, unless you re-define it.

Another important and most basic function is to combine values into a
vector. This means your variable will not have one value anymore, but
multiple values. Let us create a vector `v` and `z`.

``` r
v <- c(2,5,10)
z <- c(3,4,7)
```

Not surprisingly we can do *vector operations* with these vectors, such
as addition, multiplication, etc.

``` r
a+v
```

    ## [1]  4  7 12

``` r
v+z
```

    ## [1]  5  9 17

``` r
a*z
```

    ## [1]  6  8 14

``` r
v*z
```

    ## [1]  6 20 70

Vector operations have their own rules e.g. you need to have the same
number of elements in each vector if you want to add them up, s you
should be careful to check, which is easy to do. The simplest way is to
use the function `length()` which counts the number of elements in a
vector. Let us call it `num_v`,

``` r
num_v <- length(v)
num_v
```

    ## [1] 3

**To do:** check the number of elements in `z` and do a logical
operation to decide if `z` and `v` has the same number of elements, thus
the operation was valid.

To show, why this is important, let us violate this fundamental
mathematical requirement. Define `q` as a shorter vector and add it to
`v` to see what happens

``` r
q <- c(2,3)
v+q
```

    ## Warning in v + q: longer object length is not a multiple of shorter object
    ## length

    ## [1]  4  8 12

unfortunately, R tries to be ‘foolproof’ and does not give an error.
Instead it fixes the problem by filling the missing elements by
restarting from the first elemet:

``` r
v+c(2,3,2)
```

    ## [1]  4  8 12

Side-note: you can also connect vectors as well, not only values, such
as

``` r
w <- c(v,z)
w
```

    ## [1]  2  5 10  3  4  7

``` r
length(w)
```

    ## [1] 6

## Special values

### Empty variable

There exists a null vector or any empty variable, which does not include
anything. Later we will see it is useful for programming
e.g. for-cycles:

``` r
null_vector <- c()
```

### NA or NaN value

If value is missing or unknown, usually it is marked as `NA` or `NaN`.
`NA` is standing for unknown value as `NaN` stands for ‘Not-a-Number’,
specifically designed standing for missing numeric value. However in
practice at our level they are essentially the same and we are going to
use rather `NA`.

Work with `NA` values are pretty much the same: they do not respond to
operations and remains NAs:

``` r
nan_vec <- c(NA,1,2,3,4)
nan_vec + 3
```

    ## [1] NA  4  5  6  7

### Inf value

In R `Inf` stands for ‘Infinite’ value, which is different from `NA` as
it stands for a very large number. It is usually encountered when a
mathematical operation does not have a value, but in the limit it
converges to infinity such as:

``` r
5/0
```

    ## [1] Inf

You can also define a variable, which has infinite value, and do
operations with it,

``` r
inf_val <- Inf
inf_val*-1
```

    ## [1] -Inf

``` r
inf_val*3
```

    ## [1] Inf

**To do:** Check what happens if you divide `Inf/Inf` and discuss why is
it!

### Rounding precision in R

As all software R works with certain digits and not in a so-called
*symbolic* way. It means that if you use an irrational expression
(number) it is going to be rounded. A great example is the following:

``` r
sqrt(2)^2 == 2
```

    ## [1] FALSE

which should be the same, however due to rounding `sqrt(2)`, it will not
be the same.

## R-objects and variable types

We have already used different R-objects such as numbers, characters and
logical. We call *R-object* the type of value of a variable. It is the
smallest element in R. To collect all of them, let us create a detailed
list here:

1.  R-objects

-   numeric - any numeric value
-   integer - a special numeric value, which is not a fraction. An extra
    ‘L’ is put next to the value in the Environment to show that it is
    an integer.
-   character - also known as string. Any variable which contains
    letters, special characters or numbers between ’’ or ““.
-   logical - have only two values: `TRUE` or `FALSE` possibly after a
    statement is run and evaluated as true or false
-   factor - special R-object that we will discuss later. It is an
    element in a factor variable type.

2.  Variable types

-   vectors: containing only the same R-objects (values) in a
    single-dimension vector
-   lists: can mix different R-objects as elements
-   matrices: containing same R-objects (values) in a 2-dimensional
    matrix
-   arrays: allows for multidimensional matrices
-   factors: a special vector, which contains *categorical* or *ordinal*
    values. We will see these in later classes
-   data frames: containing data, basically a flexible matrix, which can
    contain different vectors with different R-object and organized as
    it has variables and observations. We will discuss this at next
    lecture more in detail.

``` r
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

# Indexing

-   goes with ‘\[\]’

``` r
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

# Lists

``` r
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
