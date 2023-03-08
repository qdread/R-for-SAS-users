# Test code for RSAS exercises

library(tidyverse)

oats <- read_csv('https://github.com/qdread/R-for-SAS-users/raw/main/data/Edwards_oats.csv')

oats_subset <- oats %>%
  filter(
    year == 2001, 
    gen %in% c('Belle', 'Blaze', 'Brawn', 'Chaps')
  )

oats_subset %>%
  group_by(gen) %>%
  summarize(
    mean_yield = mean(yield),
    stdev_yield = sd(yield)
    )

ggplot(oats_subset, aes(x = loc, y = yield)) +
  geom_boxplot()

oats_fit <- lm(yield ~ gen, data = oats_subset)
check_model(oats_fit) # Regression diagnostics
summary(oats_fit) # Displays model coefficients
anova(oats_fit) # ANOVA table

oats_fit_GxE <- lm(yield ~ gen + loc + gen:loc, data = oats_subset)
check_model(oats_fit_GxE) # Regression diagnostics
summary(oats_fit_GxE) # Displays model coefficients
anova(oats_fit_GxE) # ANOVA table
