Random Numbers and Random Sampling in R
================
Agoston Reguly

## Random Numbers

In dealing with data, the use of random numbers is essential. In any
case, you will not use them directly (unless you are carrying out a
Monte-Carlo simulation), but many advanced models use them indeed
directly or as random sampling. Some examples:

-   get a random (sub)-sample (e.g. cross-validation techniques)
-   bootstrapping (to calculate standard errors)
-   estimating models (e.g. machine learning methods or (quasi)
    maximum-likelihood methods)
-   ‘stochastic’ optimization methods (e.g. genetic algorithms)

Here we cover only the main properties and how to use them if we would
like to have reproducible results.

### Different distributions

Data that we observe have an empirical distribution. In theory, we use
some theoretical distributions, which can be characterized as a function
and they are useful as many real-life variables tend to be similar (or
at the limit the same) as the theoretical distribution. In base-R, there
are many pre-programmed distributions, which can be checked by
`?distribution`. Let us first discuss the *uniform* distribution, which
has a lower and upper bound and all values within have the same
probability. It can be called via `*unif`, where `*` stands for one of
the followings:

-   r: random number generation
-   d: density or probability mass function
-   p: cumulative distribution
-   q: quantiles

Here we will focus on `runif` to generate random numbers, but it is good
to know that they exist and you can compute specific values of the
chosen distribution.

If we would like to have 5 randomly drawn numbers from a uniform
distribution between 0 and 1, we can run the following code:

``` r
runif( 5 , min = 0 , max = 1)
```

    ## [1] 0.06767098 0.98660840 0.39275628 0.66632423 0.24219306

Note that if you re-run this piece of code it will result in different
values. Naturally, the question emerges, how to write a code, which will
produce the same random numbers and thus the same results? It turns out
you can *set the seed* for the random number generation:

``` r
set.seed(1234)
runif( 5 , min = 0 , max = 1)
```

    ## [1] 0.1137034 0.6222994 0.6092747 0.6233794 0.8609154

which will ensure that you will get the same random numbers. Note that
they are only the same if you run both lines of commands together, after
each other.

*Good-to-know:* Generating truly random numbers is not an easy task in
computer science and it has its own jargon. At our level, it works
completely fine, but if you are interested, you can check a short
overview on this topic
e.g. [here](https://thecodeboss.dev/2017/05/why-random-numbers-are-impossible-in-software/).

### Normal distribution

A commonly used distribution due to its mathematical properties and its
occurrence in the real data is the normal distribution. You can generate
a normally distributed random variable with `rnorm` function where you
can set the mean and the standard deviation.

``` r
n <- 10000
y <- rnorm( n , mean = 1 , sd = 2 )
df <- tibble( rnd_norm = y )
ggplot( df , aes( x = rnd_norm ) ) +
  geom_histogram( aes( y = ..density.. ) , fill = 'navyblue', bins = 30 ) +
  stat_function( fun = dnorm , args = list( mean = 1 , sd = 2 ) ,
                 color = 'red' , size = 1.5 )+
  labs(x='X',y='Density')
```

![](random_numbers_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

You may play around with the number of observations generated and check
how the generated variable converges to the true (theoretical)
distribution! You should have something similar!

![](random_numbers_files/figure-gfm/unnamed-chunk-4-1.gif)<!-- -->

There are other useful distributions that you can check out. E.g.:

-   `rbinom` (binomial distribution)
-   `rexp` (exponential distribution)
-   `rlnorm` (log-normal distribution)

## Random sampling

Random sampling is one of the most powerful tools used nowadays in
statistics. It selects a random part of your original data and you will
do the manipulations with only those parts. Later we will use this
extensively in many cases hidden in our models, therefore it is useful
to have an idea of how to get a random sample.

The most commonly used function is
`sample_n( df , size , replace = FALSE )`, where `df` is the original
tibble and `size` is a non-negative integer giving the number of
observations (rows) to choose and `replace` decides if one observation
(or row) can be used multiple times or not. Usually, this last input is
neglected as we want to get a random sample **without** replacement. A
good exception is *bootstrapping*, where we resample with replacement to
always has the same number of observations as the original data.

To show how this method works, let us use the **`sp500`** data and get a
randomly selected sub-sample with 100 observations, without replacement.

``` r
sp500 <- read_csv('https://osf.io/h64z2/download')
head(sp500)
```

    ## # A tibble: 6 × 2
    ##   DATE       VALUE  
    ##   <date>     <chr>  
    ## 1 2006-08-25 1295.09
    ## 2 2006-08-28 1301.78
    ## 3 2006-08-29 1304.28
    ## 4 2006-08-30 1304.27
    ## 5 2006-08-31 1303.82
    ## 6 2006-09-01 1311.01

``` r
set.seed(123)
sp500_ss <- sample_n( sp500 , 100 )
head(sp500_ss)
```

    ## # A tibble: 6 × 2
    ##   DATE       VALUE  
    ##   <date>     <chr>  
    ## 1 2016-02-02 1903.03
    ## 2 2016-04-08 2047.60
    ## 3 2015-03-09 2079.43
    ## 4 2008-08-29 1282.83
    ## 5 2007-05-24 1507.51
    ## 6 2013-09-16 1697.60

Note that we have used here `set.seed` purposefully, to be able to
replicate the results.

**Good-to-know:** As usual with R there are many other options to get a
random sample. In our experience, `sample_n` is the most commonly used
with tibbles. However, there is a newer release for tidyverse (dplyr to
be specific), which has the function of `slice_sample( df , n = size )`,
which does the same, but it is newer and will be maintained. Also in
many cases people use the base-R function, which is called
`sample(x,size,replace=F)`, but here you can not support tibbles in `x`,
but vectors. Also good to know about `sample.int(n,size=n,replace=F)`,
which is similarly a base-R function and it provides you random *index
values*, therefore if you want to select observations through indexing
(e.g. use the same indexes for multiple vectors/tibbles), then you may
want to use that.
