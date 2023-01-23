# Use data from agridat to create a dataset for R/SAS lesson

data(nass.soybean, package = 'agridat')
d <- nass.soybean

SEA <- c('Georgia','Florida','South Carolina','North Carolina','Tennessee','Alabama','Mississippi','Louisiana','Arkansas')

d2 <- subset(d, state %in% SEA)

ggplot(d2, aes(x=year,y=yield,color=state)) + geom_line()

lmer(yield ~ year + (year|state))
lmer(yield ~ year + (1|state), data = d2)

write.csv(d, 'data/NASS_soybean.csv', row.names = FALSE)

data(edwards.oats, package = 'agridat')
d_oat <- edwards.oats

write.csv(d_oat, 'data/Edwards_oats.csv', row.names = FALSE)
