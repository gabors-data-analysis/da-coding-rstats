#######################
# Multiple regression #
#                     #
# Test scores and     #
#   student-teacher   #
#     ratio           #
#                     #
#######################


rm(list=ls())

# Libraries
#install.packages("AER")
library(AER)
library(tidyverse)
library(lspline)
library(fixest)
library(modelsummary)
# Extra for correlation heatmap
library(reshape2)


##########
# 1) Research question:
#     - IDEA: Want to understand the pattern (possible connection) between,
#               student's performance and learning environment!
#     - Question: What is the pattern between student-to-teacher ratio and test scores?
#     - Intention: Close to causality: interpretable coefficient.

# Get the data
data("MASchools")
df <- MASchools
rm( MASchools )

# Data description: https://www.rdocumentation.org/packages/AER/versions/1.2-9/topics/MASchools
# The Massachusetts data are district-wide averages for public elementary school
#   districts in 1998. The test score is taken from the Massachusetts Comprehensive 
#   Assessment System (MCAS) test, administered to all fourth graders in Massachusetts 
#   public schools in the spring of 1998. The test is sponsored by the Massachusetts 
#   Department of Education and is mandatory for all public (!) schools. The data analyzed 
#   here are the overall total score, which is the sum of the scores on the English, Math, 
#   and Science portions of the test. Data on the student-teacher ratio, the percent of 
#   students receiving a subsidized lunch and on the percent of students still learning 
#   english are averages for each elementary school district for the 1997--1998 school year 
#   and were obtained from the Massachusetts department of education. Data on average district 
#   income are from the 1990 US Census.


# Re-iterated research question:
#   Does better student-teacher ratio yield better score results in MCAS in 1998 in Massachusetts?
#
#####
# Model setup
# Outcome variable:      score4  - 4th grade score (math + English + science).
# Parameter of interest: stratio - Student-teacher ratio
#
# Thinking about potential confounders:
#   - background of students (socio-economic status: mother language, income level,
#                             ethnicity, parent's education level, ect. )
#   - type of school (public/private school, specialization, wealth of school)
#
#
####
# What we have:
#
# Qualitative variables by geography:
#   - district     - character. District code -> qualitative var
#   - municipality - character. Municipality name -> qualitative var
#
# Schools' wealth/measure
#   - income  - Per capita income (using 1990 census)
#   - scratio - Students per computer
#
# Shcools' expenditure variables - use only "exptot", the others are only for robustness check
#   - expreg  - Expenditures per pupil, regular
#   - expspecial - Expenditures per pupil, special needs.
#   - expbil  - Expenditures per pupil, bilingual.
#   - expocc  - Expenditures per pupil, occupational.
#   - exptot  - Expenditures per pupil, total.
#
# Schools' special students measures
#   - special - Special education students (per cent)
#   - lunch   - Percent qualifying for reduced-price lunch.
#   - english - Percent of English learners
#
# Proxys for teacher
#   - salary  - Average teacher salary
#
# Alternative outcome - great for external validity
#   - score8 - 8th grade score (math + English + science).
#
#

####
# 2) What are the possible problems with the data - data quality
#   - Representative sample?
#       - Half of the Massachusetts schools - representative only for this state
#   - Measurement errors in the variables?
#       - In general, we do not have variable on the size of the school:
#           - matter for salary, income/capita and for score(s)
#   - What they truly capture and what you want to use them for?
#       - Expenditures also capture the size of the school...
#
#
####
# 3) Descriptives
#
# Quick check on all HISTOGRAMS - dont include such graph to the term project...
df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  theme_bw()+
  facet_wrap(~key, scales = "free") +
  geom_histogram()

datasummary_skim( df )

####
# Sample restriction: drop missing values from:
# Our main variables will be:
#   score4 , score8, stratio, english, 
#   income, scratio, exptot, special,
#   lunch, salary

df <- df %>% select( score4 , score8, stratio, english, 
                     income, scratio, exptot, special,
                     lunch, salary ) %>% drop_na()

# As this is an already cleaned dataset there is no much to do w.r.t. cleaning...

# Check the main parameter of interests and potential confounders:

# score 4
ggplot( df , aes(x = score4)) +
  geom_histogram( binwidth = 5, fill='navyblue', color = 'white' ) +
  labs(y = 'Count',x = "Averaged values of test scores for schools") +
  theme_bw()

# stratio
ggplot( df , aes(x = stratio)) +
  geom_histogram(binwidth = 1,fill='navyblue', color = 'white' ) +
  labs(y = 'Count',x = "Student to teacher ratio") +
  theme_bw()

# english
ggplot( df , aes(x = english)) +
  geom_histogram(binwidth = 0.5,fill='navyblue', color = 'white' ) +
  labs(y = 'Count',x = "Ratio of english speakers (mother tounge)") +
  theme_bw()

# Create a dummy variable from english learner:
# 1 if ratio of english speakers is larger than 1%
# 0 otherwise
df <- df %>% mutate( english_d = 1*(english>1))


# Scaling: already these are in percent or not so large values, thus scaling is not necessary

####
# 4) Check the correlations
#
# 
numeric_df <- keep( df , is.numeric )
cT <- round( cor( numeric_df , use = "complete.obs") , 2 )
# create a lower triangular matrix
cT[ upper.tri( cT ) ] <- NA
# Put it into a tibble format
melted_cormat <- melt( cT , na.rm = TRUE)
# Now we can create a heat-map
ggplot( data = melted_cormat, aes( Var2 , Var1 , fill = value ) )+
  geom_tile( color = "white" ) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Correlation") +
  theme_bw()+ 
  theme( axis.text.x = element_text(angle = 45, vjust = 1, 
                                    size = 10, hjust = 1))+
  labs(y="",x="")+
  coord_fixed()

rm( cT , numeric_df , melted_cormat )

####
# 5) Checking scatter-plots to decide the functional form
# Create a general function to check the pattern
chck_sp <- function( x_var , x_lab ){
  ggplot( df , aes(x = x_var, y = score4)) +
    geom_point(color='red',size=2,alpha=0.6) +
    geom_smooth(method="loess" , formula = y ~ x )+
    labs(x = x_lab, y = "Averaged values of test scores") +
    theme_bw()
}

# Our main interest: student-to-teacher ratio:
chck_sp(df$stratio,'Student-to-teacher ratio')

# The pattern changes around 17-18 students/teacher...
#   test it with P.L.S
#   Would be a quadratic transformation be useful?

# English learners
chck_sp(df$english,'Number of english learner in class')
chck_sp(df$english_d,'Number of english learner in class')
# It seems there is a different average (and sd) for 0 and 1

# Income per capita
chck_sp(df$income,'Income per capita')
chck_sp( log( df$income ) , 'Log of income per capita')
# Result: log-transformation

# Student to computer ratio
chck_sp( df$scratio , 'Student to computer ratio' )
# Pretty much seems like uncorrelated...

# Expenditure total (neglect the others for now)
chck_sp(df$exptot, 'Expenditure total')
# Not much informative... need to check whether it matters in the regression

# Special education students (per cent)
chck_sp(df$special,'Special education students (per cent)')
# Pretty much linear and seems important...

# Percent qualifying for reduced-price lunch.
chck_sp(df$lunch,'Percent qualifying for reduced-price lunch')
# Seems like there is a break around 15% -> try P.L.S

# Average teacher salary
chck_sp(df$salary,'Average teacher salary')
# Seems like there is a break around 35 and maybe around 40 -> try P.L.S

# Think about interactions:
#   For now it is not needed:
#     1) The parameter of interest does not include interaction.
#     2) No strong reason for controlling for such interaction.
#

# Think about weightening: there is no natural candidate for this...

#####
# 6) Modelling
#
# Start from simple to complicated
# Remember: few hundreds obs, 5-10 variable could work
#
# Main regression: score4 = b0 + b1*stratio
#   reg1: NO controls, simple linear
#   reg2: NO controls, use linear spline(L.S) with a knot at 18
# Use reg2 and control for:
#   reg3: english learner dummy
#   reg4: reg3 + Schools' special students measures (lunch with P.L.S, knot: 15; and special)
#   reg5: reg4 + salary with P.L.S, knots at 35 and 40, exptot, log of income and scratio


# reg1: NO control, simple linear regression
reg1 <- feols( score4 ~ stratio , data = df , vcov = 'hetero')
reg1

# reg2: NO controls, use piecewise linear spline(P.L.S) with a knot at 18
reg2 <- feols( score4 ~ lspline( stratio , 18 ) , data = df , vcov = 'hetero')
reg2

# Compare the two results:
etable( reg1 , reg2 )

###
# Side note: if want to find knots automatically (sometimes slow, and does not converge...)
install.packages("segmented")
library(segmented)
reg1_lm <- lm( score4 ~ stratio , data = df )
fit_seg <- segmented( reg1_lm , seg.Z = ~stratio, psi = list( stratio=17 ) )
summary(fit_seg)


###
# Models with controls:
#
# reg3: control for english learners dummy (english_d) only. 
#   Is your parameter different? Is it a confounder?

reg3 <- feols( score4 ~ lspline( stratio , 18 ) + english_d , data = df , vcov = 'hetero' )
reg3

# Extra for reg3
# You may wonder: what if the student-to-teacher ratio is different for those school, 
#   where the % of english learners are more than 1% (english_d)
# We can test this hypothesis! use interactions!
reg31 <- feols( score4 ~ lspline( stratio , 18 ) + english_d +
                      lspline( stratio , 18 ) * english_d, data = df , vcov = 'hetero' )
reg31

etable( reg3, reg31 )

##
# reg4: reg3 + Schools' special students measures (lunch with P.L.S, knot: 15; and special)
reg4 <- feols( score4 ~ lspline( stratio , 18 ) + english_d +
                 lspline( lunch , 15 ) + special , data = df , vcov = 'hetero' )
reg4

##
# Control for: wealth measures as well:
#   reg5: reg4 + salary with P.L.S, knots at 35 and 40, exptot, log of income and scratio
#
# Reminder: this is already 12 variables...
reg5 <-feols( score4 ~ lspline( stratio , 18 ) + english_d +
                lspline( lunch , 15 ) + special +
                lspline( salary , c( 35 , 40 ) ) + exptot +
                log( income ) + scratio , data = df , vcov = 'hetero' )
summary( reg5 )

###
# Summarize our findings:
varname_report <- c("(Intercept)" = "Intercept",
                   "stratio" = "student/teacher",
                   "lspline(stratio,18)1" = "student/teacher (<18)",
                   "lspline(stratio,18)2" = "student/teacher (>=18)",
                   "english_d" = "english_dummy")
groupConf <- list("English" = c("english"),
                  "Lunch" = c("lunch"),
              "Other_Special" = c("special"),
              "Wealth_Measures" = c("exptot","income","scratio"))
vars_omit <- c("english|lunch|special|salary|exptot|income|scratio")

# Note: coefstat = 'confint' is just an example, usually you need to report se.
etable( reg1 , reg2 , reg3 , reg4 , reg5 ,
        title = 'Average test scores for 4th graders',
        headers = c("(1)","(2)","(3)","(4)","(5)"),
        dict = varname_report,
        drop = vars_omit ,
        group = groupConf ,
        se.below = T,
        coefstat = 'confint',
        fitstat = c('r2','bic'))


###
# IF HAVE TIME:
# What if `special' is a `bad control` -> it soaks up the effect on teacher's importance!
#   Let check the result without 'special' value
# And compare reg4, reg5 and reg51


###
# IF HAVE TIME:
# What if `special' is a `bad control` -> it soaks up the effect on teacher's importance!
#   Let check the result without 'special' value

reg51 <- feols( score4 ~ lspline( stratio , 18 ) + english_d
                + lspline(lunch,15)
                + lspline(salary,c(35,40)) + exptot 
                + log( income ) + scratio , data = df , vcov = 'hetero' )

etable(  reg4 , reg5 , reg51,
         title = 'Average test scores for 4th graders',
         headers = c("(4)","(5)","(5.1)"),
         dict = varname_report,
         drop = vars_omit ,
         group = groupConf ,
         se.below = T,
         coefstat = 'confint')


##
# EXTERNAL VALIDITY:
#
# Task: instead of score4 use score8 as an outcome variable.
#   1) Create a function for plotting but now for score8
#   2) Carefully decide, how to include which regressors!
#   3) Run similalry 5 regressions (use the same regressors, but maybe with other transformation)
#   4) Report the results

chck_sp8 <- function(x_var){
  ggplot( df , aes(x = x_var, y = score8)) +
    geom_point() +
    geom_smooth(method="loess" , formula = y ~ x )+
    labs(y = "Averaged values of test scores for 8th grade") 
}

chck_sp8(df$stratio)
# stratio is same, but even smaller value: I would choose 16
chck_sp8(df$english_d)
chck_sp8(df$lunch)
# Lunch is the same
chck_sp8(df$special)
# Special seems to be quadratic...
chck_sp8(df$salary)
# Salary needs only one knot at 35
chck_sp8(df$exptot)
# Use only linear
chck_sp8(df$income)
chck_sp8(log(df$income))
# Perfect for log-transformation with quadratic
chck_sp8(df$scratio)
# Linear

reg1_e <- feols( score8 ~ stratio, data = df , vcov = 'hetero' )
reg2_e <- feols( score8 ~ lspline( stratio , 16 ), data = df , vcov = 'hetero')
reg3_e <- feols( score8 ~ lspline( stratio , 16 ) + english_d, data = df , vcov = 'hetero')
reg4_e <- feols( score8 ~ lspline( stratio , 16 ) + english_d
                 + lspline(lunch,15) + special + special^2 , data = df , vcov = 'hetero')
reg5_e <- feols( score8 ~ lspline( stratio , 16 ) + english_d
                 + lspline(lunch,15) + special + special^2
                 + lspline(salary,35) + exptot 
                 + log( income ) + log( income )^2 + scratio , data = df , vcov = 'hetero')


etable(  reg1_e , reg2_e , reg3_e, reg4_e, reg5_e ,
         title = 'Average test scores for 8th graders',
         headers = c("(1e)","(2e)","(3e)","(4e)","(5e)"),
         dict = varname_report,
         drop = vars_omit ,
         group = groupConf ,
         se.below = T,
         coefstat = 'confint',
         fitstat = c('r2','ll'))

#####
# Extra practice: apply the same methods for California schools
# data("CASchools")
# For details see: https://www.rdocumentation.org/packages/AER/versions/1.2-9/topics/CASchools








