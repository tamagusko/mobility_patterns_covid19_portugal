# Calculates and plots the changepoint for Google Mobility Reports.
# Author:  Tiago Tamagusko <tamagusko@gmail.com>
# Version: 0.6 (2020-11-04)
# License: CC-BY-NC-ND-4.0

library(tidyverse)  # v1.3.0
library(ggplot2)  # v3.3.0
library(cowplot)  # v1.0.0 - formating graphs for pub
library(ggpubr)  # v0.3.0 - plot figures into a grid
library(changepoint)  # 2.2.2 Changepoint detection

# clean memory
rm(list=ls())

# set system to english
# Sys.setlocale("LC_TIME", "en_US.UTF-8")  # to use in linux

COUNTRY <- 'Portugal'

GOOGLE_DATASET <- 'https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv'

# read data
GlobalMobilityReport <- read.csv(file = GOOGLE_DATASET) %>%
  group_by(date)
GlobalMobilityReport$date <- as.Date(GlobalMobilityReport$date) 

# filter data by COUNTRY and REGION
googleData <- GlobalMobilityReport %>%
  filter(country_region == COUNTRY, sub_region_1 == '') %>%
  select(date, retail_and_recreation_percent_change_from_baseline, grocery_and_pharmacy_percent_change_from_baseline, parks_percent_change_from_baseline, transit_stations_percent_change_from_baseline, workplaces_percent_change_from_baseline, residential_percent_change_from_baseline) %>%
  group_by(date)

# rename columns
colnames(googleData) <- c('date','Retail_and_recreation', 'Grocery_and_pharmacy', 'Parks', 'Transit_stations', 'Workplaces', 'Residential')

resultMobi <- cbind(
  'Date' = format(googleData$date, '%Y-%m-%d'),
  'Retail and recreation' = googleData$Retail_and_recreation,
  'Grocery and pharmacy' = googleData$Grocery_and_pharmacy,
  'Parks' = googleData$Parks,
  'Transit stations' = googleData$Transit_stations,
  'Workplaces' = googleData$Workplaces,
  'Residential' = googleData$Residential
)

# save results
write.csv(resultMobi, file = 'mobilityPatternsPT.csv')

# changepoit
cp_retail = cpt.mean(googleData$Retail_and_recreation, method="BinSeg", Q=2)
x_cp_retail_1 <- as.numeric(strsplit(as.character(cp_retail@cpts), " ")[[1]])
x_cp_retail_2 <- as.numeric(strsplit(as.character(cp_retail@cpts), " ")[[2]])

cp_grocery = cpt.mean(googleData$Grocery_and_pharmacy, method="BinSeg", Q=2)
x_cp_grocery_1 <- as.numeric(strsplit(as.character(cp_grocery@cpts), " ")[[1]])
x_cp_grocery_2 <- as.numeric(strsplit(as.character(cp_grocery@cpts), " ")[[2]])

cp_parks = cpt.mean(googleData$Parks, method="BinSeg", Q=2)
x_cp_parks_1 <- as.numeric(strsplit(as.character(cp_parks@cpts), " ")[[1]])
x_cp_parks_2 <- as.numeric(strsplit(as.character(cp_parks@cpts), " ")[[2]])

cp_transit = cpt.mean(googleData$Transit_stations, method="BinSeg", Q=2)
x_cp_transit_1 <- as.numeric(strsplit(as.character(cp_transit@cpts), " ")[[1]])
x_cp_transit_2 <- as.numeric(strsplit(as.character(cp_transit@cpts), " ")[[2]])

cp_workplaces = cpt.mean(googleData$Workplaces, method="BinSeg", Q=2)
x_cp_workplaces_1 <- as.numeric(strsplit(as.character(cp_workplaces@cpts), " ")[[1]])
x_cp_workplaces_2 <- as.numeric(strsplit(as.character(cp_workplaces@cpts), " ")[[2]])

cp_residential = cpt.mean(googleData$Residential, method="BinSeg", Q=2)
x_cp_residential_1 <- as.numeric(strsplit(as.character(cp_residential@cpts), " ")[[1]])
x_cp_residential_2 <- as.numeric(strsplit(as.character(cp_residential@cpts), " ")[[2]])

# split data into categories (to facilitate handling)
retail <- googleData %>%
  select(date, Retail_and_recreation)

grocery <- googleData %>%
  select(date, Grocery_and_pharmacy)

parks <- googleData %>%
  select(date, Parks)

transit <- googleData %>%
  select(date, Transit_stations)

workplaces <- googleData %>%
  select(date, Workplaces)

residential <- googleData %>%
  select(date, Residential)

# graph
plotRetail <- ggplot(retail, aes(x = date, y = Retail_and_recreation)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_retail_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_retail_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(
    yintercept = 0,
    linetype = 'dotted',
    alpha = .5
    ) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Retail and recreation'
       ) +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  annotate("text",
           x = (googleData$date[x_cp_retail_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_retail_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
           ) +
  annotate("text",
           x = (googleData$date[x_cp_retail_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_retail_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  ) 
  

plotGrocery <- ggplot(grocery, aes(x = date, y = Grocery_and_pharmacy)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_grocery_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_grocery_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(
    yintercept = 0,
    linetype = 'dotted',
    alpha = .5) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(
    y = 'Distance to baseline',
    x = 'Date',
    title = 'Grocery and pharmacy'
    ) +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  annotate("text",
           x = (googleData$date[x_cp_grocery_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_grocery_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  ) +
  annotate("text",
           x = (googleData$date[x_cp_grocery_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_grocery_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  )

plotParks <- ggplot(parks, aes(x = date, y = Parks)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_parks_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_parks_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Parks') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  annotate("text",
           x = (googleData$date[x_cp_parks_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_parks_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  ) +
  annotate("text",
           x = (googleData$date[x_cp_parks_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_parks_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  )

plotTransit <- ggplot(transit, aes(x = date, y = Transit_stations)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_transit_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_transit_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Transit stations') +
  scale_x_date(date_labels = '%b/%d', breaks = '14 days') +
  annotate("text",
           x = (googleData$date[x_cp_transit_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_transit_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  ) +
  annotate("text",
           x = (googleData$date[x_cp_transit_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_transit_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  )

plotWorkplaces <- ggplot(workplaces, aes(x = date, y = Workplaces)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_workplaces_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_workplaces_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Workplaces') +
  scale_x_date(date_labels = '%b/%d', 
               breaks = '14 days'
               ) +
  annotate("text",
           x = (googleData$date[x_cp_workplaces_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_workplaces_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  ) +
  annotate("text",
           x = (googleData$date[x_cp_workplaces_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_workplaces_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  )
  
plotResidential <-
  ggplot(residential, aes(x = date, y = Residential)) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_residential_1]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_vline(
    xintercept = as.numeric(googleData$date[x_cp_residential_2]),
    linetype = 'solid',
    colour = 'red'
  ) +
  geom_hline(yintercept = 0,
             linetype = 'dotted',
             alpha = .5) +
  geom_line(linetype = 'solid') +
  geom_point(size = .75) +
  theme_cowplot(12) +
  labs(y = 'Distance to baseline',
       x = 'Date',
       title = 'Residential') +
  scale_x_date(date_labels = '%b/%d', 
               breaks = '14 days'
               ) +
  annotate("text",
           x = (googleData$date[x_cp_residential_1] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_residential_1], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
           ) +
  annotate("text",
           x = (googleData$date[x_cp_residential_2] + 2), 
           y = Inf, 
           label = googleData$date[x_cp_residential_2], 
           colour = 'red', 
           hjust = "left", 
           vjust = "top"
  )


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
