# Notes for R for SAS users lesson

## Who is this course for?

Practicing scientists who have a decent working knowledge of SAS, and of basic statistical analysis (descriptive stats and regression models) as it applies to their field

## Learning objectives

- Learn the similarities and differences between SAS and R, emphasizing they are different tools for the job, but ultimately saying why I think R is better
- Get a basic acquaintance with the tidyverse, and get introduced to what R packages are 
- Learn which common SAS statistical procedures correspond to which R packages/functions
- Go through a "data to doc" pipeline in R, showing SAS code side-by-side
  + Import the data from a CSV file
  + Clean and reshape the data
  + Calculate some summary statistics and make some exploratory plots
  + Fit a linear model, a generalized linear model, and a generalized linear mixed-effects model
  + Make post hoc comparisons
  + Make plots and tables of results
- Learn about R and SAS' capabilities for Bayesian model fitting, and generating pretty reports and presentations  


## Specific functions/procedures to cover

- workflow: import data, clean and sort, make summary statistics/tables, fit a couple of different models, estimated marginal means or lsmeans, plots and tables of results, make report of results
- Focus on tidyverse tools
- import: proc import, versus read_csv. Emphasize that CSV is better than XLSX
- clean and sort: proc transpose, proc sort, data step. vs filter, mutate, pivot
- summary statistics/tables: proc means, proc freq. vs group_by, summarize
- model fitting: proc reg, proc mixed, proc glm, proc glimmix. vs lm(), lmer(), glm(), glmer()
- post hoc: lsmeans versus emmeans
- note proc bglimm versus brms
- plots and tables: proc sgplot -- ggplot2 and base R plot
- report: SASMarkdown and RMarkdown?? (might not have time to cover this)