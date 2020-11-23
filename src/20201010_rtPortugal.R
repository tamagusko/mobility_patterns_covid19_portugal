# Plot Rt value for Portugal.
# Author:  Tiago Tamagusko <tamagusko@gmail.com>
# Version: 0.5 (2020-10-10)
# License: CC-BY-NC-ND-4.0

# import libraries
library(tidyverse)
library(ggplot2)
library(cowplot)

COUNTRY <- 'Portugal'

# import data
data <- read.csv(file = 'resultRtPT.csv') %>%
  group_by(Date)
data$Date <- as.Date(data$Date)


ggplot(data, aes(x = Date, y = Rt)) +
  geom_ribbon(
    aes(x = Date, ymax = Quantile_97.5_Upper, ymin = Quantile_2.5_Low),
    fill = 'gray',
    alpha = .5
  ) +
  geom_vline(
    xintercept = as.numeric(data$Date[c(13, 55)]),
    linetype = 'dashed',
    colour = "red"
  ) +
  geom_hline(yintercept = 1,
             linetype = 'dotted',
             alpha = .5) +
  geom_line() +
  geom_point() +
  theme_cowplot(12) +
  labs(
    y = 'R(t)',
    x = 'Date',
    title = paste("Estimated Rt for", COUNTRY),
    subtitle = "Lockdown: mar/22 to mai/03 (dashed red lines)",
    caption = "Method: Non parametric serial interval distribution\n Cori et al. (2013)"
  ) +
  scale_x_date(date_labels = "%b/%d", breaks = '14 days')

summary(data)



