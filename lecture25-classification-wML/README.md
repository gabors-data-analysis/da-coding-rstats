# Lecture 25: Prediction and classification of binary outcome with ML tools

## Motivation

Predicting whether people will repay their loans or default on them is important to a bank that sells such loans. Should the bank predict the default probability for applicants? Or, rather, should it classify applicants into prospective defaulters and prospective repayers? And how are the two kinds of predictions related? In particular, can the bank use probability predictions to classify applicants into defaulters and repayers, in a way that takes into account the bank’s costs when a default happens and its costs when it forgoes a good applicant?

Many companies have relationships with other companies, as suppliers or clients. Whether those other companies stay in business in the future is an important question for them. You have rich data on many companies across the years that allows you to see which companies stayed in business and which companies exited, and relate that to various features of the companies. How should you use that data to predict the probability of exit for each company? How should you predict which companies will exit and which will stay in business in the future?

In the previous seminars we covered the logic of predictive analytics and its most important steps, and we introduced specific methods to predict a quantitative y variable. But sometimes our y variable is not quantitative. The most important case is when y is binary: y = 1 or y = 0. How can we predict such a variable?

## This lecture

This lecture introduces the framework and methods of probability prediction and classification analysis for binary y variables. Probability prediction means predicting the probability that y = 1, with the help of the predictor variables. Classification means predicting the binary y variable itself, with the help of the predictor variables: putting each observation in one of the y categories, also called classes. We build on what we know about probability models and the basics of probability prediction from [lecture16-binary-models](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture16-binary-models). In this seminar, we put that into the framework of predictive analytics to arrive at the best probability model for prediction purposes and to evaluate its performance. We then discuss how we can turn probability predictions into classification with the help of a classification threshold and how we should use a loss function to find the optimal threshold. We discuss how to evaluate a classification by making use of a confusion table and expected loss. We introduce the ROC curve, which illustrates the trade-off of selecting different classification threshold values. We discuss how we can use random forests based on classification trees. 

Case study:
  - [Chapter 17, A: Predicting firm exit: probability and classification](https://gabors-data-analysis.com/casestudies/#ch17a-predicting-firm-exit-probability-and-classification)

## Learning outcomes

Lecturer/students should be aware that there is a separate file at the official case studies repository: [`ch17-firm-exit-data-prep.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit/ch17-firm-exit-data-prep.R) for this seminar, overviewing only the data cleaning and feature engineering process for binary outcomes. This is extremely important and powerful to understand how to prepare the data for these methods, as without it data analysts do garbage-in garbage-out analysis... Usually, due to time constraints, this part is not covered in the seminar but asked students to cover it before the seminar.

After successfully completing [`seminar_5_binary_w_ML.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/part-III-case-studies/seminar05-binary-wML-predicting-firm-exit/codes/seminar_5_binary_w_ML.R), students should be able:

  - What is winsorizing and how it helps
  - Basic linear models for predicting probabilities
    - simple linear probability model (review)
    - simple logistic model (logit, review)
    - Cross-validation with logit model (via `caret`)
    - LASSO with logit model (via `glmnet` and `caret`)
  - Evaluation of model prediction
    - Calibration curve (review)
    - Confusion matrix
    - ROC curve and AUC (Area Under Curve) 
  - Model comparison based on RMSE and AUC
  - User-defined loss funtion
    - find the optimal trheshold based on self-defined loss function
    - Show ROC curve and optimal point
    - Show loss-function values for different points on ROC  
  - CART and Random Forest
    - modelling porbabilities
    - Random Forest with majority voting as a misunderstand method, especially with user-defined loss function     

## Dataset used

  -[bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms)

## Lecture Time

Ideal overall time: **100 mins**.


## Further material

  - This lecture is a modified version of [`ch17-predicting-firm-exit.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit/ch17-predicting-firm-exit.R) from [Gabor's case study repository](https://github.com/gabors-data-analysis/da_case_studies).

