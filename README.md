<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Google_Analytics_Customer_Kaggle](#google_analytics_customer_kaggle)
- [Overview](#overview)
  - [Description](#description)
  - [Evaluation](#evaluation)
  - [Data](#data)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Google_Analytics_Customer_Kaggle

- Purpose: predict how much Gstore custormers will spend. (Gsotre is Google Merchandise Store)
- Url: [kaggle site](https://www.kaggle.com/c/google-analytics-customer-revenue-prediction)
- Deadline: November 15, 2018

# Overview

## Description

- パレートの法則は多くのビジネスにおいて証明されている. パレート法則とは少数の顧客が利益の大部分を占めているという法則である. (具体的な数字を用いると2割の客が収益の8割を占めるという構造)
- 顧客ごとの収益を予測する.
- 結論が実行可能な機能的変更であればよく, 参加企業にとって有益なマーケティング予算の適用となる.

## Evaluation

- Submissions are scored on the root mean squared error. RMSE is defined as, 

<div align="center">
<img src="https://latex.codecogs.com/gif.latex?\mbox{RMSE}&space;=&space;\sqrt{\frac{1}{n}&space;\sum^n_{i=1}&space;(y_i&space;-&space;\hat{y}_i)^2&space;}," />
</div>

y hat is the predicted revenue for a customer and y is the **natural log** of the acutual revenue value.

- For each `fullVisitor ID` in the test set, we must predict the **natural log** of their total revenue in `PredictLogRevenue`.

## Data 
