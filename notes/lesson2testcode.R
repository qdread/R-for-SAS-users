# Testing with edwards Oats
library(tidyverse)

edwards_oats <- read_csv('data/Edwards_oats.csv')

table(edwards_oats$gen)
with(edwards_oats, table(gen,loc))

# Use 6 of the genotypes with complete data
gen_use <- c('Belle', 'Chaps', 'Brawn', 'Jud', 'Riser', 'Troy')

head(edwards_oats, 10)
summary(edwards_oats, 10)
glimpse(edwards_oats)

oats_reduced <- filter(edwards_oats, gen %in% gen_use)

ggplot(oats_reduced, aes(x = loc, y = yield)) + geom_boxplot() + theme_bw()
ggplot(oats_reduced, aes(x = gen, y = yield)) + geom_boxplot() + theme_bw()

ggplot(oats_reduced, aes(x = loc, y = testwt)) + geom_boxplot() + theme_bw()
ggplot(oats_reduced, aes(x = gen, y = testwt)) + geom_boxplot() + theme_bw()

# G by E interaction plot
ggplot(oats_reduced, aes(x = loc, y = yield)) + geom_violin() + theme_bw() +
  facet_wrap(~ gen)
ggplot(oats_reduced, aes(x = loc, y = testwt)) + geom_violin() + theme_bw() +
  facet_wrap(~ gen)

ggplot(oats_reduced, aes(x = testwt, y = yield, color = loc)) + geom_point() + geom_smooth(method = lm, se = FALSE) + theme_bw()
