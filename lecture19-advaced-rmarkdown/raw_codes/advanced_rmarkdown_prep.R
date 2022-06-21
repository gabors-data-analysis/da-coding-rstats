###############################################
#                                             #
#               Lecture 19                    #
#                                             #
#    Advanced RMarkdown - preparation         #
#     - Analysis of wage gap in US            #
#     - Special attention to plots            #
#     - Customizing etable output             #
#     - Comparing competing models            #
#                                             #
#   In Rmd file:                              #
#     - Naming chunks                         #
#     - Suppressing messages                  #
#     - customizing figure:                   #
#         - size, alignment, caption,         #
#           resolution knitting format,       #
#           referencing                       #
#     - Customizing tables                    #
#         - Properly formatted descriptives   #
#         - title, caption, alignment,        #
#           referencing                       #
#         - Formatted model comparison tables #
#     - In line equations and greek letters   #
#     - Referencing tables, figures in text   #
#                                             #
#                                             #
# Case Study:                                 # 
#   Wage differences                          #
#                                             #
###############################################


# clear memory
rm(list=ls())

# Import libraries 
library(tidyverse)
library(modelsummary)
library(fixest)
library(ggpubr)
library(devtools)

# Import Gabors book theme for pretty plots
source_url('https://raw.githubusercontent.com/gabors-data-analysis/da_case_studies/master/ch00-tech-prep/theme_bg.R')



#####
# Import Data and Clean

# Import data (there is a column without a name, hence name_repair input and rename)
cps <- read_csv('https://osf.io/4ay9x/download', 
                name_repair = 'minimal' )
cps <- cps %>% rename( 'id' = '' )

# Select observations
cps <- cps %>% filter(uhours>=20 & earnwke>0 & age>=24 & age<=64 & grade92>=44)
glimpse(cps)

# Check the number of observations for each state
datasummary( state ~ N + Percent(), data = cps)

# Check occupations
datasummary( factor( occ2012 ) ~ N + Percent(), data = cps)

# Create new variables
cps <- cps %>% mutate(female     = as.numeric( sex == 2  ),
                      female_fac = factor( ifelse( female == 1 , 'female' , 'male' ) ),
                      w = earnwke / uhours,
                      lnw = log( w ) )


# Distribution of earnings
datasummary( earnwke + uhours + w ~ Mean + Median + P25 + P75 + Max + Min + N , data = cps )

# Distribution of earnings by gender 
datasummary( female_fac * ( earnwke + uhours + w + lnw ) ~ Mean + Median + P25 + P75 + Max + Min + N , data = cps )


# Show wage and log-wage conditional distributions (pretty on purpose -> only copy to Rmd)
gw <- ggplot( data = cps, aes( x = w , color= female_fac ) ) +
        geom_density( bw = 10 ) +
        labs( x = 'Wage', y = 'Density', color = '') +
        scale_color_manual( name='', 
                            values=c(color[2],color[1]),
                            labels=c('Female','Male') ) +
        scale_x_continuous(expand = c(0.01, 0.01), limits = c(0, 100)  , breaks = seq(0,  100, by = 25)) +
        scale_y_continuous(expand = c(0.0, 0.0)  , limits = c(0, 0.03), breaks = seq(0, 0.03, by = 0.01)) +
        annotate( 'text' , x = 55, y = 0.020, label = 'Male'  , color = color[1] , size = 4 ) +
        annotate( 'text' , x = 25, y = 0.025, label = 'Female', color = color[2], size = 4 ) +
        theme_bg( ) +
        theme(legend.position = 'none')
gw

glnw <- ggplot( data = cps, aes( x = lnw, color= female_fac ) ) +
          geom_density( bw = .25 ) +
          labs( x = 'Log-Wage', y = 'Density', color = '') +
          scale_color_manual( name='', 
                              values=c(color[2],color[1]),
                              labels=c('Female','Male') ) +
          scale_x_continuous(expand = c(0.01, 0.01), limits = c(-1, 6) , breaks = seq(-1,  6, by = 1)) +
          scale_y_continuous(expand = c(0.0, 0.0)  , limits = c(0, 0.8), breaks = seq(0, 0.8, by = 0.2)) +
          annotate( 'text' , x = 5, y = 0.6, label = 'Male', color = color[1] , size = 4 ) +
          annotate( 'text', x = 2, y = 0.6, label = 'Female', color = color[2], size = 4 ) +
          theme_bg( ) +
          theme(legend.position = 'none')
glnw

# Plot together
ggarrange( gw , glnw , nrow = 1 , ncol = 2 )

################################################################
# Models to understand earnings:
#
# A) Age as a confounder
#     reg1 := lnw ~ female
#     reg2 := lnw ~ female + age
#     reg3 := age ~ female (to show bias)

reg1 <- feols( lnw ~ female        , data=cps, vcov = 'hetero')
reg2 <- feols( lnw ~ female + age  , data=cps, vcov = 'hetero')
reg3 <- feols( age ~ female        , data=cps, vcov = 'hetero')

# Compare the results
etable( reg1 , reg2 , reg3 , headers = c('Omitted','Complete','Auxillary') )

# Kernel density to show age distribution -> one source of the bias
ggplot(data = cps, aes(x=age, y = stat(density), color = female_fac)) +
  geom_density(adjust=1.5, show.legend=F, na.rm =TRUE, size=0.7) +
  labs(x='Age (years)', y='Density', color = '') +
  scale_color_manual(name='', 
                     values=c(color[1],color[2]),
                     labels=c('Male','Female')) +
  scale_x_continuous(expand = c(0.01, 0.01), limits = c(24, 64), breaks = seq(25, 65, by = 5)) +
  scale_y_continuous(expand = c(0.0, 0.0), limits = c(0, 0.04), breaks = seq(0, 0.04, by = 0.01)) +
  annotate('text',x = 55, y = 0.020, label = 'Male', color = color[1], size = 4 ) +
  annotate('text',x = 55, y = 0.03, label = 'Female', color = color[2], size = 4 ) +
  theme_bg()



####
# Fixing the age problem:
#   Adding age and its higher order polinomials

cps <- cps %>% mutate(agesq = age^2,
                      agecu = age^3,
                      agequ = age^4 )

# Adjusted models
reg4 <- feols(lnw ~ female                              , data=cps, vcov = 'HC1')
reg5 <- feols(lnw ~ female + age                        , data=cps, vcov = 'HC1')
reg6 <- feols(lnw ~ female + age + agesq                , data=cps, vcov = 'HC1')
reg7 <- feols(lnw ~ female + age + agesq + agecu + agequ, data=cps, vcov = 'HC1')

# show results
etable( reg4, reg5, reg6, reg7)


####
# Adding another potential confounder:
#    education

# create education dummies
cps <- cps %>% mutate( ed_MA      = as.numeric(grade92==44),
                       ed_Profess = as.numeric(grade92==45),
                       ed_PhD     = as.numeric(grade92==46) )

reg8  <- feols( lnw ~ female                       , data=cps, vcov = 'HC1')
reg9  <- feols( lnw ~ female + ed_Profess + ed_PhD , data=cps, vcov = 'HC1')
reg10 <- feols( lnw ~ female + ed_MA + ed_PhD      , data=cps, vcov = 'HC1')

etable(reg8, reg9, reg6, reg10 )




###
# Checking interactions: age and gender:
# interacted model is capturing the difference

reg11 <- feols(lnw ~ age                      , data=cps %>% filter(female==1), vcov = 'HC1')
reg12 <- feols(lnw ~ age                      , data=cps %>% filter(female==0), vcov = 'HC1')
reg13 <- feols(lnw ~ female + age + age*female, data=cps,                       vcov = 'HC1')

etable(reg11, reg12, reg13 )

###
# As it it significant we can check for higher orders of age as well!
#     (but try not to over complicate, use theory!)

reg14 <- feols(lnw ~ age + agesq + agecu + agequ  , data=cps %>% filter(female==1), vcov = 'HC1')
reg15 <- feols(lnw ~ age + agesq + agecu + agequ  , data=cps %>% filter(female==0), vcov = 'HC1')
reg16 <- feols(lnw ~ age + agesq + agecu + agequ 
               + female + female*age + female*agesq 
               + female*agecu + female*agequ      , data=cps, vcov = 'HC1')

etable(reg14, reg15, reg16 )
# Note: R2 is somewhat better, but we are after the coefficient!

###
# Sidenote:
#  if we believe the effect is non-linear, we can show the difference between
#   using a simple linear model vs using polynomials!

##
# Prediction with linear models:
# Males
data_m <- cps %>% filter(female==0)
pred_m <- predict( reg13, newdata = data_m, se.fit=T, interval = 'confidence' , level = 0.95 )
data_m <- data_m %>% mutate( lin_fit      = pred_m$fit,
                             lin_fit_CIup = pred_m$ci_high,
                             lin_fit_CIlo = pred_m$ci_low )

# Females
data_f <- cps %>% filter(female==1)
pred_f <- predict( reg13, newdata = data_f, se.fit=T, interval = 'confidence' , level = 0.95 )
data_f <- data_f %>% mutate( lin_fit      = pred_f$fit,
                             lin_fit_CIup = pred_f$ci_high,
                             lin_fit_CIlo = pred_f$ci_low )

pred_lin <- ggplot( )+
  geom_line(data=data_m,aes(x=age,y=lin_fit),colour=color[1],linetype=1, lwd=0.8)+
  geom_line(data=data_m,aes(x=age,y=lin_fit_CIup), colour=color[1], linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_m,aes(x=age,y=lin_fit_CIlo), colour=color[1], linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_f,aes(x=age,y=lin_fit),colour=color[2],lwd=0.8)+
  geom_line(data=data_f,aes(x=age,y=lin_fit_CIup), colour=color[2],  linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_f,aes(x=age,y=lin_fit_CIlo), colour=color[2],  linetype= 'dashed', lwd=0.3)+
  labs(x = 'Age (years)',y = 'ln(earnings per hour, US dollars)')+
  scale_x_continuous(expand = c(0.01,0.01), limits = c(24, 65), breaks = seq(25, 65, by = 5)) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(2.8, 3.8), breaks = seq(2.8, 3.8, by = 0.1)) +
  annotate('text',x = 50, y = 3.25, label = 'Female', color = color[2], size=4) +
  annotate('text',x = 35, y = 3.65, label = 'Male', color = color[1], size=4) +
  theme_bw() 
pred_lin

###
# Prediction with polynomials:

# Males
pred_m <- predict( reg16, newdata = data_m, se.fit=T, interval = 'confidence' , level = 0.95 )
data_m <- data_m %>% mutate( poly_fit      = pred_m$fit,
                             poly_fit_CIup = pred_m$ci_high,
                             poly_fit_CIlo = pred_m$ci_low )

# Females
pred_f <- predict( reg16, newdata = data_f, se.fit=T, interval = 'confidence' , level = 0.95 )
data_f <- data_f %>% mutate( poly_fit      = pred_f$fit,
                             poly_fit_CIup = pred_f$ci_high,
                             poly_fit_CIlo = pred_f$ci_low )

pred_poly <- ggplot( )+
  geom_line(data=data_m,aes(x=age,y=poly_fit),colour=color[1],linetype=1, lwd=0.8)+
  geom_line(data=data_m,aes(x=age,y=poly_fit_CIup), colour=color[1], linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_m,aes(x=age,y=poly_fit_CIlo), colour=color[1], linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_f,aes(x=age,y=poly_fit),colour=color[2],lwd=0.8)+
  geom_line(data=data_f,aes(x=age,y=poly_fit_CIup), colour=color[2],  linetype= 'dashed', lwd=0.3)+
  geom_line(data=data_f,aes(x=age,y=poly_fit_CIlo), colour=color[2],  linetype= 'dashed', lwd=0.3)+
  labs(x = 'Age (years)',y = 'ln(earnings per hour, US dollars)')+
  scale_x_continuous(expand = c(0.01,0.01), limits = c(24, 65), breaks = seq(25, 65, by = 5)) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(2.8, 3.8), breaks = seq(2.8, 3.8, by = 0.1)) +
  annotate('text',x = 50, y = 3.25, label = 'Female', color = color[2], size=4) +
  annotate('text',x = 35, y = 3.65, label = 'Male', color = color[1], size=4) +
  theme_bw() 
pred_poly

# Show them vertically aligned
ggarrange( pred_lin , pred_poly , ncol = 1 , nrow = 2 )



########################################################################
# Adding more confounders to tackle causality questions
# 

# Sample selection between age 40-60 -> there is a stable pattern across those age cohorts!
cps <- cps %>% filter(age>=40 & age<=60)


# Pre-determined demographics: create features
cps <- cps %>% mutate(white = as.numeric( race == 1 ),
                      afram = as.numeric( race == 2 ),
                      asian = as.numeric( race == 4 ),
                      hisp  = !is.na(ethnic),
                      othernonw = as.numeric(white==0 & afram==0 & asian==0 & hisp==0),
                      nonUSborn = as.numeric( prcitshp=='Foreign Born, US Cit By Naturalization' 
                                              | prcitshp=='Foreign Born, Not a US Citizen') )


# Potentially important (confounder) family background variables
cps <- cps %>% mutate(married  = as.numeric(marital==1 | marital==2),
                      divorced = as.numeric(marital==3 | marital==5 | marital==6),
                      widowed  = as.numeric(marital==4),
                      nevermar = as.numeric(marital==7),
                      child0   = as.numeric(chldpres==0),
                      child1   = as.numeric(chldpres==1),
                      child2   = as.numeric(chldpres==2),
                      child3   = as.numeric(chldpres==3),
                      child4pl = as.numeric(chldpres>=4))

# Work-related confounder variables
cps <- cps %>% mutate(fedgov  = as.numeric(class=='Government - Federal'),
                      stagov  = as.numeric(class=='Government - State'),
                      locgov  = as.numeric(class=='Government - Local'),
                      nonprof = as.numeric(class=='Private, Nonprofit'),
                      ind2dig = as.integer(as.numeric(as.factor(ind02))/100),
                      occ2dig = as.integer(occ2012/100),
                      union   = as.numeric(unionmme=='Yes' | unioncov=='Yes'))


# Control for hours in polynomial
cps <- cps %>% mutate(uhourssq = uhours^2,
                      uhourscu = uhours^3,
                      uhoursqu = uhours^4)

######
# Extended regressions for comparison (remember the filter!)

# Simple benchmark
reg1_e <- feols(lnw ~ female                            , data=cps, vcov = 'HC1')
# Age and Education
reg2_e <- feols(lnw ~ female + age + ed_Profess + ed_PhD, data=cps,vcov = 'HC1')
# Age, Education, demographics, socio-economic and work related
reg3_e <- feols(lnw ~ female + age + afram + hisp + 
                      asian + othernonw + nonUSborn + 
                      ed_Profess + ed_PhD + married + 
                      divorced+ widowed + child1 + child2 + 
                      child3 +child4pl + as.factor(stfips) + 
                      uhours + fedgov + stagov + locgov + nonprof + 
                      union + as.factor(ind2dig) + as.factor(occ2dig) , data=cps,vcov = 'HC1')
# Age, Education, demographics, socio-economic and work related with polynomials
reg4_e <- feols(lnw ~ female + age + afram + hisp + 
                      asian + othernonw + nonUSborn + 
                      ed_Profess + ed_PhD + married + 
                      divorced+ widowed + child1 + child2 + 
                      child3 +child4pl + as.factor(stfips) + 
                      uhours + fedgov + stagov + locgov + nonprof + 
                      union + as.factor(ind2dig) + as.factor(occ2dig) + 
                      agesq + agecu + agequ + uhoursqu + uhourscu + uhourssq , data=cps,vcov = 'HC1')

# Simple comparison table
etable( reg1_e, reg2_e, reg3_e, reg4_e , drop = 'factor' )

# As we are interested in one parameter (female coeff) -> lets make a pretty regression output!
#   we can specify multiple 'control' groups and show YES/NO in etable
#   also we need to 'drop' variables when reporting

groupConf <- list('Age and Education' = c('age','ed_'),
                  'Family background' = c('married','divorced','widowed','child',
                                          'afram','hisp','asian','othernonw'),
                  'Hours worked' = c('uhours'),
                  'Government or private' = c('fedgov','stagov','locgov','nonprof'),
                  'Union member' = c('union'),
                  'Not born in USA' = c('nonUSborn'),
                  'Age in polynomial' = c('agesq','agecu','agequ'),
                  'Hours in polynomial' = c('uhourssq','uhourscu','uhoursqu') )

# Note: if you use factors then 'keepFactors = F' will do this automatically for each factor variable

varname_report <- c('female' = 'Female' )

# Note: etable uses string manipulations, thus you do not need to write everything out 
#   (but should deal with care e.g. in case of age in polynomials!)

etable( reg1_e , reg2_e , reg3_e , reg4_e ,
        title = 'Gender wage gap',            # Add a title
        headers = c('(1)','(2)','(3)','(4)'), # Name of the models
        depvar = F,                           # Hide the dependent variable from the header
        keep = 'Female',                      # Keep variable -> show coeff and stats
        dict = varname_report,                # Rename variable for pretty presentation
        #drop = vars_omit ,                   # Hide variables from presentation (not used: keep or drop)
        group = groupConf ,                   # Grouping variables into 'control types'
        digits = 3,                           # Reported digits for coeffs and SE
        digits.stats = 3,                     # Reported digits for the summary statistics
        se.below = T,                         # Show standard errors below the coefficients
        se.row = F,                           # Hide Type of SE used from summary stat part
        fitstat = c('r2','n')                 # Reported statistics (R2 and Num obs.)
        )

# Note: if you use 'keep', then you have to use the same name as you specified in 'dict'.
#   also if you use 'drop' you have to take care!

