# Calculates and plots Google Mobility Reports.
# Author:  Tiago Tamagusko <tamagusko@gmail.com>
# Version: 0.6 (2020-11-04)
# License: CC-BY-NC-ND-4.0

# import libraries
library(tidyverse)  # v1.3.0
library(ggplot2)  # v3.3.0
library(cowplot)  # v1.0.0 - formating graphs for pub
library(ggpubr)  # v0.3.0 - plot figures into a grid
library(changepoint)  # 2.2.2 Changepoint detection

# clean memory
rm(list=ls())

COUNTRY <- 'Portugal'

# import data (https://www.google.com/covid19/mobility/)
GOOGLE_DATASET <- 'https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv'

# read data
GlobalMobilityReport <- read.csv(file = GOOGLE_DATASET) %>%
  group_by(date)
GlobalMobilityReport$date <- as.Date(GlobalMobilityReport$date) 

# import covid data from Portugal
covDataPT <- read.csv(file = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv') %>%
  filter(location == COUNTRY, total_cases != 0) %>%
  select(date, new_cases)
covDataPT$date <- as.Date(covDataPT$date)

# import mobility data from Portugal
googleDataPT <- GlobalMobilityReport %>%
  filter(country_region == COUNTRY, sub_region_1 == '') %>%
  select(date, retail_and_recreation_percent_change_from_baseline, grocery_and_pharmacy_percent_change_from_baseline, parks_percent_change_from_baseline, transit_stations_percent_change_from_baseline, workplaces_percent_change_from_baseline, residential_percent_change_from_baseline) %>%
  group_by(date)

retail <- googleDataPT %>%
  select(date, retail_and_recreation_percent_change_from_baseline)
colnames(retail) <- c('date','pct_diff')

grocery <- googleDataPT %>%
  select(date , grocery_and_pharmacy_percent_change_from_baseline)
colnames(grocery) <- c('date','pct_diff')

parks <- googleDataPT %>%
  select(date, parks_percent_change_from_baseline)
colnames(parks) <- c('date','pct_diff')

transit <- googleDataPT %>%
  select(date, transit_stations_percent_change_from_baseline)
colnames(transit) <- c('date','pct_diff')

workplaces <- googleDataPT %>%
  select(date, workplaces_percent_change_from_baseline)
colnames(workplaces) <- c('date','pct_diff')

residential <- googleDataPT %>%
  select(date, residential_percent_change_from_baseline)
colnames(residential) <- c('date','pct_diff')

resultMobi <- cbind(
  'Date' = format(retail$date, '%Y-%m-%d'),
  'Retail and recreation' = retail$pct_diff,
  'Grocery and pharmacy' = grocery$pct_diff,
  'Parks' = parks$pct_diff,
  'Transit stations' = transit$pct_diff,
  'Workplaces' = workplaces$pct_diff,
  'Residential' = residential$pct_diff
)
write.csv(resultMobi, file = 'googleMobiDataPT.csv')

# visualization
## new cases covid PT
geom_smooth(
  method = 'auto',
  se = TRUE,
  fullrange = FALSE,
  level = 0.95
)

ggplot(covDataPT, aes(x = date, y = new_cases)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_line(linetype = 'dotted') +
  geom_point() +
  theme_cowplot(12) +
  labs(
    y = 'Daily cases',
    x = 'Date',
    title = paste('COVID-19 cases in', COUNTRY),
    subtitle = 'Lockdown: mar/22 to mai/03 (dashed red lines)',
    caption = 'Data from: Center for Systems Science and Engineering at Johns Hopkins University'
  ) +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

write.csv(covDataPT, file = 'covid19DataPT.csv')

## Google mobillity data
## Coloca tudo num facegrid ou em colunas

plotRetail <- ggplot(retail, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Retail and recreation') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plotGrocery <- ggplot(grocery, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Grocery and pharmacy') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plotParks <- ggplot(parks, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Parks') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plotTransit <- ggplot(transit, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Transit stations') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plotWorkplaces <- ggplot(workplaces, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Workplaces') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plotResidential <-
  ggplot(residential, aes(x = date, y = pct_diff)) +
  geom_vline(
    xintercept = as.numeric(retail$date[c(38, 79)]),
    linetype = 'dashed',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'dotted') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Residential') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  geom_smooth(method = 'loess')

plot_grid(
  plotRetail + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  plotGrocery + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  plotParks + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  ncol = 1,
  nrow = 3
)

plot_grid(
  plotTransit + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  plotWorkplaces + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  plotResidential + rremove('xlab') + theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 0
  )),
  ncol = 1,
  nrow = 3
)