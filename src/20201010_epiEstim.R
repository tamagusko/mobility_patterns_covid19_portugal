# Calculates and plots Epidemiology estimation for Portugal.
# Author:  Tiago Tamagusko <tamagusko@gmail.com>
# Version: 0.5 (2020-10-10)
# License: CC-BY-NC-ND-4.0

library(EpiEstim)
library(xts)
library(ggplot2)

COUNTRY <- 'Portugal'

download.file('https://covid.ourworldindata.org/data/ecdc/full_data.csv',
              'full_data.csv')
data <- read.csv(file = 'full_data.csv')
dados_pt <- data[data$location == paste(COUNTRY), ]
times <- as.Date(dados_pt[, 'date'])
cases <- pmax(dados_pt[, 'new_cases'], 0)
incidence <- data.frame(dates = times, I = cases)

# R estimation

mean_si <- 4.7
std_si <- 2.9
delta_si <- 30
discrete_si_distr <- discr_si(seq(0, delta_si), mean_si, std_si)

res <- estimate_R(incid = incidence,
                  method = 'non_parametric_si',
                  config = make_config(list(si_distr = discrete_si_distr)))

times2 = tail(times, -7)
serieR <- xts(res$R[, c('Median(R)')], order.by = times2)
serieRl <- xts(res$R[, c('Quantile.0.025(R)')], order.by = times2)
serieRu <- xts(res$R[, c('Quantile.0.975(R)')], order.by = times2)

plot(res, legend = FALSE)

write.csv(
  cbind(
    'Date' = time(times2),
    'Rt' = serieR,
    'Quantile_2.5_Low' = serieRl,
    'Quantile_97.5_Upper' = serieRu
  ),
  file = 'resultRtPT.csv'
)

plot_estimR <-
  plot(
    serieR,
    ylim = c(0, 5),
    main = 'R(t)',
    xlab = 'R',
    ylab = 'Tempo'
  )
lines(serieRl)
lines(serieRu)
ref <- xts(rep(1.0, length(serieR)), order.by = time(serieR))
lines(ref, col = 'red')