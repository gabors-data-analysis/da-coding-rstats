Getting started with R
================
Agoston Reguly

## Creating the first script

Using the console is really handy, but will not keep track of what we
have done. R-scripts are for this purpose: collect your commands, you
can save this as a file and rerun these commands whenever you want. This
is the first pillar of good coding: reproducible codes.

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
Furthermore, note that nothing will happen even if you hit enter, but a
new line will show up in the script.

In order to run this code, you need to run it via the console, which can
be done in several ways. The most obvious way to do it is to copy and
paste it to the console, however, it is not really efficient. The
quickest is to bring your courser to the line which you want to run and
hit `cmd+return` or `ctrl+enter`. This will execute the command.
Alternatively, you can find the icon on the top-right corner of the
script window, which says `Run` with a possible rolling window.

*Tip:* you may select multiple lines and use the same method to run
multiple codes at once.

You can also use characters, but in this case, you will need to use `'`
or `"` signs before and after:

``` r
"Hello world!"
```

    ## [1] "Hello world!"

### Good-to-know: script or project?

R-script is one file with bunch of commands in it. During this course we
mainly use R-scripts saved in a well-organized folder structure, that we
initially create (see tidy approach from [DA Book, Chapter
02](https://gabors-data-analysis.com/chapters/#chapter-02-preparing-data-for-analysis)).

On the other hand R-project creates the folder structure when
initialized and set the working directory automatically (we will discuss
this issue more in detail in
[lecture02](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp_n_exp).).
This can help to organize your project (with possibly many files) and to
simplify: you do not need bother with where is your project. Although,
it seems more convenient, we will prefer simple scripts and learn later
how to deal with folder structure and set the path correctly.

## Variables

Running simple codes is great, but in many cases, we want to write
elaborate multistage commands. In this case, we can create `variables`,
which will store information in the memory and can be called later.

E.g. we can save the command ‘Hello world!’ into a variable, that we
call `message_world` in the following way:

``` r
message_world <- 'Hello world!'
```

If you run this piece of command, seemingly nothing happens - or at
least in the console window does not print out anything only runs the
command. However, a new variable shows up in the `Environment` window
under the `Values` section, which says: ‘message\_world’ and ‘Hello
world!’. It shows that there is a `variable` stored in the memory with
the name of `message_world`.

*Fun fact:* the assignment operator `<-` is somewhat a unique feature of
R. Many programming languages use instead `=` to define variables. In
many cases `=` works as well in R, but in some other cases it does not,
s we stick with the assignment operator of `<-`. We will see when
covering functions when `=` does not work, but if you can not wait until
then, you may check out [this StackOverflow
thread](https://stackoverflow.com/questions/1741820/what-are-the-differences-between-and-assignment-operators-in-r).

*Tip:* You can use the following hot key for `<-`: `option+-` for mac
and `alt+-` for windows.

You can call this variable via typing in and running:

``` r
message_world
```

    ## [1] "Hello world!"

## Coding 101

Always keep in mind you write your code not only for the computer or for
some specific goal, but for the future of yourself or for your colleges.
Therefore it is highly advised to develop good coding habits that result
in an easy-to-read code. Here are some tips to achieve that:

### Name your variable properly

Naming convention in programming broadly speaking has two big branches.
One is utilizing capital letters, the other one the underscore. Both of
them are good but try not to mix them. You are completely free to use
any variable name, but always keep in mind the three requirements:

1.  human-readable:

-   good: `message_world` refers to a variable that includes a probably
    string message.
-   bad: `messageWorld` is not preferred (called camelCase). It is
    rather an old school convention which is now rarely used. `m3st96k`
    does not reveal much about the possible content

2.  computer-readable:

-   good: `messageWorld`
-   bad: `message-to-world!` as it uses invalid characters. E.g. never
    start with a number and avoid special characters such as
    -,.!\~=&^%$, etc.

3.  (+1) try to avoid already defined *function names* or already
    *existing variables*. We will see what are they and it is always
    advised not to re-define variables. It is just a source of confusion
    and will make debugging much harder.

### Commenting your script

Commenting is always helpful, especially in the beginning. In R you can
use the `#` mark to tell R it is not a command, but comment and do not
run that part.

Commenting has two purposes:

1.  Tell future yourself or to college what the command in the next line
    does (or intended to do…)
2.  You have a command that is useful for some purpose (e.g. you develop
    a code and are not sure which command to use as there are different
    options), but you do not want to run it. Then you can uncomment that
    line.

Commenting and uncommenting a line or selection of lines has the hotkey
of `cmd+shift+c` (mac) or `ctrl+shift+c` (windows). Unfortunately in
Rstudio, there is no quick way to comment out multiple lines with only
two lines such as `\*` in the beginning and in the end.

**Tip:** as you advance in programming you will use less commenting for
the codes as you will start to be able to read the commands as it would
be plain English, which is pretty cool. However, if you are working with
others, always keep in mind that their level might be different. This
course material will use extensive commenting to make sure that the
material is learned even if in some cases it would be unnecessary.
Finally, always make sure that the code does what it is said to be doing
as it is really frustrating and leads to potential misunderstanding.

### Spacing and formatting your code

Finally, how you structure your code indeed matters a lot. Here is some
guidance on how to format your code:

1.  Use spacing as you learn R. It will make your code much more
    readable. E.g. as we will see functions use parenthesis `()`,
    indexing brackets `[]`, conditionals and loops curly brackets `{}`.
    It is a good practice to use a space after an input of a function,
    index or element of a list that we will discuss later this lecture.
2.  In R you can break your code into multiple lines. Use these line
    breaks to make your code more easily readable.
3.  In the future we will see many embedded commands, meaning you use a
    command within a command. If it is rather complex use spacing and
    line break together to make it easier to follow.
4.  If you are using functions, conditionals, or loops it is advised to
    increase the indent accordingly.

**Note:** too much formatting will increase the chance of making a
coding error and your commands will not run or even worse, it will run,
but not as you wish. Try to keep a good balance!

**Good-to-know:** there are some general advice specific to `tidyverse`
approach on how to format and which style to use, that can be found
[here](https://style.tidyverse.org/) if one is interested in more-depth
on this topic. Also there is a general or base-R coding style called
[‘linter for R’](https://github.com/r-lib/lintr), which may be useful
when doing more hard-core programming in R.

## R-objects

We have already created an R-object, `message_world` a single-valued
variable, which included a *character R-object*. We call *R-object* the
type of value stored in a variable. It is the smallest element in R. To
collect all types, let us create a detailed list here:

**R-objects**:

-   *character* - also known as a string. Any variable which contains
    letters, special characters, or numbers between `''` or `""` marks.
    When creating a character, decide if you use `'` or `"` and use them
    consistently. Here we use `'`. Note: when want to display a ’ or "
    character, you can do it by using the other to define as a
    character.
-   *numeric* - any numeric value, broadly speaking is called *double*.
-   *integer* - a special numeric value, which is not a fraction. An
    extra ‘L’ is put next to the value in the Environment to show that
    it is an integer and not a numeric.
-   *logical* - have only two values: `TRUE` or `FALSE` possibly after a
    statement is run and evaluated as true or false
-   *factor* - special R-object that we will discuss in later lectures.

There is one more, *complex*, which is a complex value defined in R. It
is interesting, but not that important from our perspective. (You can
create a complex value with a numeric and adding ‘i’, such as `1+2i`)

### Operations with numeric values

One can define numeric variables similarly to character values. Let us
create `a` and `b` with values of 2 and 3 respectively:

``` r
a <- 2
b <- 3
```

Now, instead of using the numbers 2 and 3, we can use `a` and `b`
instead when doing mathematical operations:

``` r
a+b-(a*b)^a
```

    ## [1] -31

We can create new variables, defined by already existing variables:

``` r
c <- a + b
d <- a*c/b*c
```

**Notes:**

-   R is case-sensitive, which means `A` is not the same as `a` and if
    you use `A` instead, it will result in an error!
-   We used numeric (double) values here, if you want specifically an
    integer object, you have to define it as `int_var<-2L`. Integers are
    more memory efficient, thus computes faster, but at our level, it
    does not have any impact. We will see later how to distinguish
    between integer and non-integer numeric values later.

## Operations with logical values

In many cases, you want to check if two values or variables are the same
or not. For this purpose, you can use the so-called logical operators,
which will always result in a logical R-object.

E.g. check if values are the same with `==` command,

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
(a + 1) == b
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

Note: later we will discuss the difference between `&, |` and `&&, ||`
operators.

### Operations with R-objects

In general, different R-objects have different basic operations. The
most important basic operations are the previously mentioned numeric and
logical operations. With characters, there is not much to do (or at
least at the base level) and we will discuss factors later.

## Simple functions

R is a great software and gains its popularity by the tremendous amount
of functions it has. Functions as in math will take an input and map it
to something else. E.g. `2+3` was a function, which added these two
values together and resulted in `5`. Of course, functions can be much
more elaborate and we will see that they are. In principle a function is
constructed as follows:

`name(input)`

where `name` is the name of the function which tells R what to execute.
Functions *always* use `(` and `)` parenthesis and within the
parenthesis you need to define the `input`, which depends on the
function itself. We will see multiple examples during the course to see
many possibilities for these inputs.

Let us start with the simplest functions. It is always a good practice
to keep your Environment (stored variables) tidy. If you have used a
variable, but will not need it anymore you can delete it from the
memory:

``` r
rm(d)
```

will remove variable `d` from your environment and you can not refer to
it anymore unless you re-define it.

**Tip:** If you are unsure what a function does: what inputs it expects
and what it is going to give, you can check the help by using `?name`
expression in the console and on the left window ‘Help’ section will
provide you an answer with examples. E.g.:

``` r
?rm
```

    ## starting httpd help server ... done

**Good to know:** If you would like to remove all variables in the
environment you can run `rm(list=ls())` command. This specifies an input
called `list` for the `rm()` function and it tells R to clear
everything. Here, you should **not run** this code as later we will use
already defined variables.

Another example is the square root function:

``` r
sqrt(4)
```

    ## [1] 2

which computes the square root of 4.

## Type of R-objects

One may be interested in the type of the R-object saved in a variable.
As it turns out it is easy to get this information with the function of
`typeof`:

``` r
typeof(message_world)
```

    ## [1] "character"

``` r
typeof(a)
```

    ## [1] "double"

When working with numeric values and one wants to make sure the numeric
has certain type, it can force R to save accordingly:

``` r
num_val  <- as.numeric(1.2)
doub_val <- as.double(1.2)
int_val  <- as.integer(1.2)
typeof(num_val)
```

    ## [1] "double"

``` r
typeof(doub_val)
```

    ## [1] "double"

``` r
typeof(int_val)
```

    ## [1] "integer"

``` r
int_val
```

    ## [1] 1

As you can see, there is no difference between numeric and double, both
are saved as ‘double’. However, the integer does differ and it is going
to save the value `1.2 -> 1` thus taking out of the integer part,
whatever digits it has. In general base R using `as.*type*()` to turn a
value (or variable) into a certain type, thus character or factor would
also work.

In some cases you would like to decide if a variable has certain type.
Base R functions can be characterized as `is.*type*()` to provide a
logical answare to this question:

``` r
is.character(message_world)
```

    ## [1] TRUE

``` r
is.logical(2==3)
```

    ## [1] TRUE

``` r
is.double(doub_val)
```

    ## [1] TRUE

``` r
is.integer(int_val)
```

    ## [1] TRUE

``` r
is.numeric(doub_val)
```

    ## [1] TRUE

``` r
is.numeric(int_val)
```

    ## [1] TRUE

``` r
is.integer(doub_val)
```

    ## [1] FALSE

``` r
is.double(int_val)
```

    ## [1] FALSE

Note that all numbers are numeric values, but integers and doubles are
different from each other.

### Variables: combine multiple R-objects in one variable

By using a simple but powerful basic function we can combine multiple
numeric values into a vector. This means your variable will not have
only one value anymore, but multiple values. Let us create a vector `v`
and `z` with the function `c()`:

``` r
v <- c(2,5,10)
z <- c(3,4,7)
```

Now, we have two vectors, that we can use to do different *vector
operations*, such as addition, multiplication, etc.

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
operation to decide if `z` and `v` have the same number of elements,
thus the operation was valid.

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

unfortunately, R tries to be ‘fool-proof’ and does not give an error.
Instead, it fixes the problem by filling the missing elements by
restarting from the first element:

``` r
v+c(2,3,2)
```

    ## [1]  4  8 12

*Side-note:* you can also connect vectors as well, not only values, such
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

### Quick de-tour: Indexing

Indexing is one of the most important tools to use with vectors (or
variables in general). It will select certain items from a vector, such
as the first element or the second and third, etc. It is done, by using
`[]` after your variable name:

E.g. selecting the first element from vector `v`:

``` r
v[1]
```

    ## [1] 2

or the second to third:

``` r
v[2:3]
```

    ## [1]  5 10

where `2:3` will create consecutive numbers of 2 and 3. But you are not
prone to consecutive numbers, you can select the first and third
elements, by using another *indexing vector*:

``` r
ind_vec <- c(1,3)
v[ind_vec]
```

    ## [1]  2 10

**To do:** Fix the addition of `v+q` by selecting the first two elements
from the vector `v`.

## Special variables/values

### Empty variable

There exists a null vector or any empty variable, which does not include
anything. Later we will see it is useful for programming
e.g. for-cycles:

``` r
null_vector <- c()
```

### NA or NaN value

If a value is missing or unknown, usually it is marked as `NA` or `NaN`.
`NA` is standing for unknown value as `NaN` stands for ‘Not-a-Number’,
specifically designed standing for missing numeric value. However, in
practice at our level, they are essentially the same and we are going to
use rather `NA`.

Work with `NA` values are pretty much the same: they do not respond to
operations and remains NAs:

``` r
na_vec <- c(NA,1,2,3,4)
na_vec + 3
```

    ## [1] NA  4  5  6  7

**To do:** check if `NA` or `NaN` are numeric values with the
`is.numeric()` function. Also find the functions which decide if a value
is `NA` or `NaN`

### Inf value

In R `Inf` stands for ‘Infinite’ value, which is different from `NA` as
it stands for a very large number. It is usually encountered when a
mathematical operation does not have a value, but in the limit, it
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

### Good to know: rounding precision in R

As all software R works with certain digits and not in a so-called
*symbolic* way. It means that if you use an irrational expression
(number) it is going to be rounded. A great example is the following:

``` r
sqrt(2)^2 == 2
```

    ## [1] FALSE

which should be the same, however, due to rounding `sqrt(2)`, it will
not be the same. **To do:** ‘fix’ this problem, by using the function
`round()`. Check its description and use it so the logical operator will
give `TRUE` as an output.

## Variable types

It is time to collect the different variable types, which includes
different R-object(s):

-   vectors: containing only the same R-objects (values) in a
    single-dimension vector
-   lists: can mix different R-objects as elements
-   matrices: containing the same R-objects (values) in a 2-dimensional
    matrix
-   arrays: allows for multidimensional matrices
-   factors: a special vector, which contains *categorical* or *ordinal*
    values. We will see these in later classes
-   data frames: containing data, basically a flexible matrix, which can
    contain different vectors with different R-object and organized as
    it has variables and observations. We will discuss this in the next
    lecture more in detail.

### Vectors

We have already created numeric vectors. Just for the sake of
completeness we can create character and logical vectors as well:

``` r
char_vec <- c('a','b','banana','I love R')
log_vec <- c(TRUE,FALSE,T,NA,F)
```

**To do:** try to mix different R-object types in one vector! What
happens? Play around with different types and check with the function of
`typeof`!

### Lists

Lists are great to combine different types of R-objects. These are
created via `list()` function:

``` r
my_list <- list('a',2,0==1)
my_list
```

    ## [[1]]
    ## [1] "a"
    ## 
    ## [[2]]
    ## [1] 2
    ## 
    ## [[3]]
    ## [1] FALSE

where `my_list` will combine these different types. If one pays
attention it is easy to see, that the output is different from a simple
vector. Actually, it is structured such that it has 3 elements and
within each element, there is an R-object or possibly a vector:

``` r
my_list2 <- list(c('a','b'),c(1,2,3),sqrt(2)^2==2)
my_list2
```

    ## [[1]]
    ## [1] "a" "b"
    ## 
    ## [[2]]
    ## [1] 1 2 3
    ## 
    ## [[3]]
    ## [1] FALSE

`my_list2` shows that lists essentially store different vectors in their
elements, and these vectors need to have the same R-object values in
them, but the length can differ.

As lists are created in this fashion, the indexing differs a bit. You
can select the different elements similarly as with the vectors:

``` r
my_list2[1]
```

    ## [[1]]
    ## [1] "a" "b"

and the selected element will be still a list variable type. If you want
to have the vector out of that certain element, you will need to use
double brackets:

``` r
my_list2[[1]]
```

    ## [1] "a" "b"

and finally, you can get certain elements out of the vector you have
selected in the following way:

``` r
my_list2[[1]][2]
```

    ## [1] "b"

This type of indexing will be handy when working with lists and also
helps to better understand working with data frame types of variables.
