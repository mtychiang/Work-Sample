# Work-Sample - Smart Meter Electricity Consumption and Weather Analysis (London, 2013)



This repository demonstrates a reproducible R workflow for cleaning, integrating, and transforming multiple public datasets into a single analysis-ready dataset. This repository also includes an interactive Power BI dashboard.



The project highlights practical data wrangling, integration of structured and semi-structured data, and preparation of an analytical dataset suitable for exploratory analysis or business intelligence tools.



## Project Overview

This project aims to produce a clean, analysis-ready dataset that can be used to explore policy questions around **energy poverty**. For example, whether households from different socio-economic backgrounds respond differently to cold weather in their electricity usage.



## Data Sources (All Public)

The datasets are focused on London, United Kingdom. The source datasets selected for this project are as follows:

| Dataset | Description | Source |
|----------|--------------|--------|
| A | Half-hourly smart-meter data for 112 London households (2013) *(data has been reduced for this exercise)* | [Kaggle – Smart Meters in London](https://www.kaggle.com/jeanmidev/smart-meters-in-london) |
| B | Household information linked to smart-meter ID | Same source |
| C | UK Bank Holidays | Same source |
| D | Hourly London weather data | Same source |
| E | Daily areal rainfall in London | [data.london.gov.uk](https://data.london.gov.uk/dataset/daily-areal-rainfall) |



## Workflow Overview


1. **Load Data**  

- Read in all datasets, verify structure, and check encoding consistency.


2. **Data Cleaning**  

- Convert wide smart-meter readings to long format  

- Aggregate half-hourly readings to hourly totals  

- Standardise date formats across datasets  

- Simplify categorical weather variables 



3. **Merge and Export Datasets**  

- Join: Meter readings, Household information, Weather, Rainfall,  Bank holiday Flag
  
- Export a tidy, analysis-ready CSV for statistical modelling or Power BI visualisation.


## Running the Code

**Run the code run\_all.R**


This will run the following:

- source("code/00\_setup.R")

- source("code/01\_loadData.R")

- source("code/02\_cleanTransform.R")

- source("code/03\_mergeDatasets.R")



## PowerBI Dashboard

File: **Work Sample PBI.pbix**

The Power BI dashboard  demonstrates the integration of the cleaned dataset into an interactive dashboard built in Power BI. 

The visualisations are intentionally simple and designed to showcase a clear, reproducible link between data wrangling in R and accessible insights in BI, rather than advanced predictive modelling.  

Users can interactively explore differences in electricity consumption across socio-economic groups (ACORN classifications), weather conditions, rainfall, and holidays. This dashboard represents an initial analytical exploration phase that could be extended with more detailed statistical or policy-focused analysis as needed.



Prepared by Michelle Chiang.



