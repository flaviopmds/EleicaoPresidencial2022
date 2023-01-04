
# Visualização de dados

<!-- badges: start -->
Trabalho final do curso de visualização de dados do curso-r.

```{r setup, include=FALSE,echo=FALSE}
setwd("C:/Users/flavio.silva/Desktop/curso-r/Visualização de dados/trabalho final/trabalho_final")
library(tidyverse)
library(geobr)
library(sf)
library(ggthemes)
library(plotly)
library(ggtext)
library(glue)


VOTOS_BR=read.csv("votacao_partido_munzona_2022_BR.csv",sep = ";",encoding = "UTF-8")
VOTOS_BR_2018=read.csv("votacao_partido_munzona_2018_BR.csv",sep = ";",encoding = "UTF-8")
VOTOS_BRASIL=read.csv("votacao_partido_munzona_2022_BRASIL.csv",sep = ";",encoding = "UTF-8")
```

<!-- badges: end -->

The goal of Visualizacaodedados is to ...

