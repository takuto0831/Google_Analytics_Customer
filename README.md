<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Google_Analytics_Customer_Kaggle](#google_analytics_customer_kaggle)
- [Overview](#overview)
  - [Description](#description)
  - [Evaluation](#evaluation)
  - [Data](#data)
- [File](#file)
  - [Rmd](#rmd)
  - [data](#data)
  - [input](#input)
- [Layered Directory](#layered-directory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Google_Analytics_Customer_Kaggle

- Purpose: predict how much Gstore custormers will spend. (Gsotre is Google Merchandise Store)
- Url: [kaggle site](https://www.kaggle.com/c/google-analytics-customer-revenue-prediction)
- Deadline: November 15, 2018

# Overview

## Description

- The 80/20 rule has proven true for many businesses-only a small percentage of customers produce most of revenue. It is known to "Pareto principle".
- The predict revenue per customer.
- Hopefully, the outcome will be more actionable operational changes and a better use of marketing budgets for those companies who choose to use data analysis on top of GA data.

## Evaluation

- Submissions are scored on the root mean squared error. RMSE is defined as, 

<div align="center">
<img src="https://latex.codecogs.com/gif.latex?\mbox{RMSE}&space;=&space;\sqrt{\frac{1}{n}&space;\sum^n_{i=1}&space;(y_i&space;-&space;\hat{y}_i)^2&space;}," />
</div>

y hat is the predicted revenue for a customer and y is the **natural log** of the acutual revenue value. More importantly, RMSE of ln(1 + `totalRevenue`), since if `totalRevenue`=0 the ln will be infinity.

- For each `fullVisitor ID` in the test set, we must predict the **natural log** of their total revenue in `PredictLogRevenue`.
- Using Log(1 + `totalRevenue`) for aggregate by user id, `totalReveneu` is sum of `transactionRevenue` by user id.

## Data 

- you should check at `data/TableDescription.numbers`
- target value is `transactionRevenue`

# File

## Rmd

Show process simply

- 0_EDA.Rmd (update: 2018/09/18)
    - Apply glimpse, skimr and dfsummary to the all data
    - Search target values
    - Check three id values -> **2_EDA.Rmd**
    - Check time and date
    - Confirm relationship with target variables -> **2_EDA.Rmd** 
- 1_Preprocess.Rmd (update: 2018/09/18)
    - Remove columns for which information can not be obtained
    - change character type and logical type to numeric type
    - Replace NA with zero on target values
    - Convert Unix time stamp to Date on `visitStartTime`
    - Determine the local time on `visitStartTime`
- 2_EDA.Rmd (now begin ...)

## data

- TableDescription.numbers

## input

- raw: raw data
- imp: imputed data

# Layered Directory

```
├── Google_Analytics_Kaggle.Rproj
├── README.md
├── Rmd
│   ├── 0_EDA.Rmd
│   ├── 1_Preprocess.Rmd
│   └── 2_EDA.Rmd
├── data
│   ├── TableDescription.numbers
├── input
│   ├── imp
│   │   ├── test_imp1.scv
│   │   └── train_imp1.scv
│   └── raw
│       ├── sample_submission.csv
│       ├── test.csv
│       └── train.csv
└── script
    ├── function.R
    └── makedummies.R

```
