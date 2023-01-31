############################################################################################
#### R FOR SAS USERS                                                                    ####
#### ===============                                                                    ####
#### This worksheet contains an incomplete version of the code presented in the lesson. ####
#### Fill in all ... with code.                                                         ####
############################################################################################
############################################################################################

# Load packages

...(tidyverse)
library(nlme)
library(easystats)

# Import data

nass_soybeans ... ('https://github.com/qdread/R-for-SAS-users/raw/main/data/NASS_soybean.csv')

# Examine data

head(... = , 10)
...(nass_soybeans)
...(nass_soybeans)

# Subsetting data

se_states ... ('Alabama', 'Arkansas', 'Florida', 'Georgia', 'Louisiana', 'Mississippi', 'North Carolina', 'South Carolina', 'Tennessee')

se_soybeans <- ...(nass_soybeans, state %in% ...)

# calculations to create a new column

se_soybeans <- ...(se_soybeans, total_yield = ...)

# Combining operations with pipe

se_soybeans <- nass_soybeans ...
  ...(state %in% se_states) ...
  ...(total_yield = acres * yield)
  
# Sort the data

se_soybeans <- ...(se_soybeans, year, ...)
  
# Combining operations with pipe, part 2

se_soybeans <- nass_soybeans %>%
  filter(state %in% se_states) %>%
  mutate(total_yield = acres * yield) %>%
  arrange(year, state)

# Reshaping long to wide

total_yield_wide <- se_soybeans %>%
  ...(id_cols = ..., names_from = ..., values_from = ...)

# Reshaping wide to long

total_yield_long <- total_yield_wide %>%
  ...(-year, ... = 'state', ... = 'total_yield')

# Make a plot 

fourstates <- filter(se_soybeans, state %in% c('Arkansas', 'Tennessee', 'North Carolina', 'Georgia'))

...(fourstates, aes(x = ..., y = ..., color = ...)) +
  geom_line(linewidth = 1) +
  theme_bw() +
  scale_y_continuous(name = 'yield (bu/ac)') +
  theme(legend.position = c(0.2, 0.8))

# Make a multi panel plot

ggplot(fourstates, aes(x = year, y = yield)) +
  facet_wrap(~ ...) +
  geom_line(linewidth = 1) +
  theme_bw() +
  scale_y_continuous(name = 'yield (bu/ac)')

# Table of summary statistics

se_soybeans %>%
  ...(year %% 10 == 0) %>%
  ...(year) %>%
  ...(
    grand_total_acres = ...(acres),
    grand_total_yield = ...(total_yield),
    mean_yield = weighted.mean(...)
  )

# Linear regression

yield_fit <- ...(... ~ ..., data = se_soybeans)

# Examining model output

summary(yield_fit)
anova(yield_fit)
check_model(yield_fit)

# Linear mixed model with repeated measures error structure

yield_fit_lme <- lme(... = yield ~ year, 
                     ... = ~ 1 + year | ..., 
                     correlation = ...(), 
                     data = se_soybeans)

# Examine model output

check_model(yield_fit_lme)
summary(yield_fit_lme)
anova(yield_fit_lme)
coef(yield_fit_lme)

# Plot of modeled and observed trends

yield_pred_bystate <- expand_grid(year = c(1924, 2011), state = se_states) %>%
  mutate(yield = as.numeric(predict(yield_fit_lme, newdata = .)))

yield_pred_overall <- data.frame(state = 'overall', year = c(1924, 2011)) %>% 
  mutate(yield = as.numeric(predict(yield_fit_lme, newdata = ., level = 0)))

ggplot(mapping = aes(x = year, y = yield, color = state, group = state)) +
  geom_line(data = se_soybeans, alpha = 0.3) +
  geom_line(data = yield_pred_bystate, linewidth = 0.7) +
  geom_line(data = yield_pred_overall, color = 'black', linewidth = 1.2) +
  theme_bw() +
  ggtitle('soybean yields by state, observations and modeled trends, 1924-2011',
          'black line is overall modeled trend')
