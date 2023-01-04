
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

```{r warning=F,echo=FALSE}
VOTOS_BR %>% group_by(SG_PARTIDO) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS)) %>% filter(QT_votos>1000000) %>% mutate(SG_PARTIDO = forcats::fct_reorder(SG_PARTIDO, QT_votos,.desc = T))%>%ggplot() + aes(x=SG_PARTIDO,y=QT_votos,fill=SG_PARTIDO) + geom_col() + geom_text(aes(label=paste0(round(QT_votos/1000000,1), "M")), vjust=-0.5, size=4.5,color="black")+scale_y_continuous(limits = c(0, 60000000),
                                                                            labels = function(x){paste0(x/1000000, "M")}) + scale_x_discrete(labels=c("Lula","Bolsonaro","Tebet","Ciro")) + labs(x="",y="",title = "Quantidade de votos por candidato \n(em milhões) ") + theme_minimal(base_size=12)+theme(
    plot.title.position = "plot",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    legend.position="none",
    text = element_text(
      color = "#80868b", family = "Verdana"
    ),
    plot.title = element_text(size = 14)
  ) + scale_fill_manual(values = c("red","yellow","blue","gray"))

<!-- badges: end -->

The goal of Visualizacaodedados is to ...

