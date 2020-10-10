This repository contains the results of paper "Mobility patterns of the Portuguese population during the COVID-19 pandemic" submitted to International Conference on Information Technology & Systems (ICTS) 2021.

The preprint for this paper is available at: https://arxiv.org/abs/2007.06506  

## Basic info
© [Tiago Tamagusko](https://tamagusko.github.io)  
Project Page: https://github.com/tamagusko/icts21  
ArXiv: https://arxiv.org/abs/2007.06506  
License: [CC-BY-NC-ND-4.0](/LICENSE)

## Abstract
SARS-CoV-2 emerged in late 2019. Since then, it has spread to several countries, becoming classified as a pandemic. So far, there is no definitive treatment or vaccine, so the best solution is to prevent transmission between individuals through social distancing. However, it is difficult to measure the effectiveness of these distance measures. Therefore, this study uses data from Google COVID-19 Community Mobility Reports to try to understand the mobility patterns of the Portuguese population during the COVID-19 pandemic. In this study, the *Rt* value was modeled for Portugal. Also, the changepoint was calculated for the population mobility patterns. Thus, the change in the mobility pattern was used to understand the impact of social distance measures on the dissemination of COVID-19. As a result, it can be stated that the initial *Rt* value in Portugal was very close to 3, falling to values close to 1 after 25 days. Social isolation measures were adopted quickly. Furthermore, it was observed that public transport was avoided during the pandemic. Finally, until the emergence of a vaccine or an effective treatment, this is the new normal, and it must be understood that new patterns of mobility, social interaction, and hygiene must be adapted to this reality.

## Conclusions
As the main result of this study, it was observed that the Portuguese population reacted quickly, adopting social distancing, and changing their mobility pattern, even be-fore the government decreed restrictive measures. Still, it took 25 days for a *Rt* value close to 3 to reach values near to 1. Now, it is expected that after the first wave of COVID-19, countries are better prepared for a probable second wave. Notwithstanding, observing the behavior adopted by the Portuguese population during that first lockdown, a second intervention of this type to be effective should last between two to four weeks.
It was also possible to observe that the sharpest drop occurred in public transport stations. Probably for fear of crowded locations, people sought individualized alternatives. A significant part of the population most likely used the car on their travels. With the re-opening of cities and the economy, this alternative may quickly prove unfeasible. Therefore, there is now a small window to co-opt users for active transport. Another observation was the significant increase in mobility in parks after the softening of lockdown measures. This trend of outdoor activities shows the importance of these spaces for cities.
Finally, we must understand that, for now, life cannot be as it was before the pandemic. Hence, until the discovery of a vaccine, the population, and the governments must be prepared for this new normal.

## Data
**Google Mobility Reports:**  
> Raw data:  
> Google LLC. Google COVID-19 Community Mobility Reports. Available online: https://www.google.com/covid19/mobility/ (accessed on Ago 20, 2020)  
> Processed data:  
> <a href="https://raw.githubusercontent.com/tamagusko/icts21/master/data/googleMobiDataPT.csv">/data/googleMobiDataPT.csv</a> (Data formatted for Portugal)

**Covid 19 cases reference:**
> Raw data:  
> Roser, M.; Ritchie, H.; Ortiz-Ospina, E.; Hasell, J. Coronavirus Pandemic (COVID-19) - Statistics and Research. Available online: https://ourworldindata.org/coronavirus (accessed on Ago 20, 2020)  
> Processed data:  
> <a href="https://raw.githubusercontent.com/tamagusko/icts21/master/data/covid19DataPT.csv">/data/covid19DataPT.csv</a> (Data formatted for Portugal)  
> <a href="https://raw.githubusercontent.com/tamagusko/icts21/master/data/resultRtPT.csv">/data/resultRtPT.csv</a> (Rt calculated for Portugal)

## Citation
Tamagusko, T. and Ferreira, A. (2020). Mobility patterns of the Portuguese population during the COVID-19 pandemic. Submitted to  International Conference on Information Technology & Systems (ICTS) 2021. ArXiv ID: https://arxiv.org/abs/2007.06506. Retrieved from https://github.com/tamagusko/icts21 (accessed on MONTH DAY, YEAR).

```bibtex
@article{Tamagusko-Ferreira2020,
  archivePrefix = {arXiv},
  arxivId = {arXiv:2007.06506},
  author = {Tiago Tamagusko and Adelino Ferreira},
  title = "{Mobility patterns of the Portuguese population during the COVID-19 pandemic}",
  keywords = {COVI-19 - Mobility Patterns - Rt - Changepoint - Modeling},
  journal = {ArXiv e-prints},
  eprint = {arXiv:2007.06506},
  year = {2020}
}
```
