
#Carregando os Pacotes
library(tidyverse)
library(geobr)
library(sf)
library(ggthemes)
library(plotly)
library(ggtext)
library(glue)

#Carregando base de dados
VOTOS_BR=read.csv("votacao_partido_munzona_2022_BR.csv",sep = ";",encoding = "UTF-8")
VOTOS_BR_2018=read.csv("votacao_partido_munzona_2018_BR.csv",sep = ";",encoding = "UTF-8")
VOTOS_BRASIL <- read_delim("votacao_partido_munzona_2022_BRASIL.csv", 
                           delim = ";", escape_double = FALSE, trim_ws = TRUE)
## Análise primeiro turno da eleição presidencial do Brasil

#Votos_candidatos

VOTOS_BR %>% group_by(SG_PARTIDO) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS)) %>% filter(QT_votos>1000000) %>% mutate(SG_PARTIDO = forcats::fct_reorder(SG_PARTIDO, QT_votos,.desc = T))%>%ggplot() + aes(x=SG_PARTIDO,y=QT_votos,fill=SG_PARTIDO) + geom_col() + geom_text(aes(label=paste0(round(QT_votos/1000000,1), "M")), vjust=-0.5, size=4.5,color="black")+scale_y_continuous(limits = c(0, 60000000),
                                                                                                                                                                                                                                                                                                                                                                                                 labels = function(x){paste0(x/1000000, "M")}) + scale_x_discrete(labels=c("Lula","Bolsonaro","Tebet","Ciro")) + labs(x="",y="",title = "Quantidade de votos por candidato \n(em milhoes) ") + theme_minimal(base_size=12)+theme(
                                                                                                                                                                                                                                                                                                                                                                                                   plot.title.position = "plot",
                                                                                                                                                                                                                                                                                                                                                                                                   panel.grid.minor = element_blank(),
                                                                                                                                                                                                                                                                                                                                                                                                   panel.grid.major = element_blank(),
                                                                                                                                                                                                                                                                                                                                                                                                   legend.position="none",
                                                                                                                                                                                                                                                                                                                                                                                                  text = element_text(
                                                                                                                                                                                                                                                                                                                                                                                                     color = "#80868b", family = "Verdana"
                                                                                                                                                                                                                                                                                                                                                                                                   ),
                                                                                                                                                                                                                                                                                                                                                                                                   plot.title = element_text(size = 14)
                                                                                                                                                                                                                                                                                                                                                                                                 ) + scale_fill_manual(values = c("red","yellow","blue","gray"))


#Lula por UF 

states <- read_state(
  year=2019, 
  showProgress = FALSE
)

VOTOS_UF=VOTOS_BR %>% group_by(SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PT_UF  =VOTOS_BR %>% filter(SG_PARTIDO=="PT") %>% group_by(SG_UF) %>% summarise(PT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PT_mapa=cbind(VOTOS_UF,PT_UF)[,-3]
PT_mapa = PT_mapa  %>% mutate(Porcentagem_votos=round(100*PT_votos/QT_votos,2))

states=left_join(states,PT_mapa, by=c("abbrev_state"="SG_UF"))

UF_PT=PT_mapa %>% filter(SG_UF!="ZZ") %>%   ggplot() +
  geom_point(
    aes(x = Porcentagem_votos, y =forcats::fct_reorder(SG_UF, Porcentagem_votos,.desc = F), color = Porcentagem_votos),
    size = 5,
    show.legend = FALSE
  )+ theme_solarized() +scale_color_distiller(palette="Reds",direction = 1,limits=c(0,100)) +scale_x_continuous(limits = c(0,100)) + labs(x="",y="",title = "Votos no Lula por UF \n (em porcentagem)")+ theme(axis.text.y = element_text(size = 8),axis.text.x = element_text(size = 8),axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15) )
UF_PT


mapa_PT=states %>% ggplot() +
  geom_sf(aes(fill=Porcentagem_votos)) +
  labs(title="Votos para o Lula por UF \n (em porcentagem)", size=8) +
  scale_fill_distiller(palette = "Reds",direction = 1, name="",limits=c(0,100)) +
  theme_minimal() + labs(x="",y="") +theme(
    plot.title.position = "plot",
    text = element_text(
      family = "Verdana"
    ),axis.text=element_blank())

plotly::ggplotly(mapa_PT)


#Bolsonaro por UF 

PL_UF  =VOTOS_BR %>% filter(SG_PARTIDO=="PL") %>% group_by(SG_UF) %>% summarise(PL_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PL_mapa=cbind(VOTOS_UF,PL_UF)[,-3]
PL_mapa = PL_mapa  %>% mutate(Porcentagem_votos=round(100*PL_votos/QT_votos,2))

states <- read_state(
  year=2019, 
  showProgress = FALSE
)

states=left_join(states,PL_mapa, by=c("abbrev_state"="SG_UF"))

PL_mapa %>% filter(SG_UF!="ZZ") %>%  ggplot() +
  geom_point(
    aes(x = Porcentagem_votos, y =forcats::fct_reorder(SG_UF, Porcentagem_votos,.desc = F), color = Porcentagem_votos),
    size = 5,
    show.legend = FALSE
  )+ theme_solarized() +scale_color_distiller(palette="GnBu",direction = 1,limits=c(0,100)) +scale_x_continuous(limits = c(0,100)) + labs(x="",y="",title = "Votos no Bolsonaro por UF \n (em porcentagem)")+ theme(axis.text.y = element_text(size = 8),axis.text.x = element_text(size = 8),axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15) )

MAPA_BOLSONARO=states %>% ggplot() +
  geom_sf(aes(fill=Porcentagem_votos)) +
  labs(title="Votos para o Bolsonaro por UF \n (em porcentagem)", size=8) +
  scale_fill_distiller(palette = "GnBu",direction = 1, name="",limits=c(0,100)) +
  theme_minimal() + labs(x="",y="") +theme(
    plot.title.position = "plot",
    text = element_text(
      family = "Verdana"
    ),axis.text=element_blank())

plotly::ggplotly(MAPA_BOLSONARO)



#Quem ganhou em cada estado?

VOTOS = VOTOS_BR  %>% group_by(SG_PARTIDO,SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS)) %>% arrange(desc(QT_votos)) %>% group_by(SG_UF) %>% slice(1) %>% group_by(SG_PARTIDO) %>% mutate(Candidato = if_else(SG_PARTIDO=="PT", "Lula","Bolsonaro"))

states <- read_state(
  year=2019, 
  showProgress = FALSE
)

states=left_join(states,VOTOS, by=c("abbrev_state"="SG_UF"))

states %>% ggplot() +
  geom_sf(aes(fill=Candidato)) + labs(title="Qual candidato ganhou por Estado?", size=8) +
  scale_fill_manual(values = c("yellow", "red")) +
  theme_minimal() +theme(
    plot.title.position = "plot",
    text = element_text(
      family = "Verdana"
    ),axis.text=element_blank())


#Quem ganhou em cada estado?(Sem Bolsonaro e sem Lula)

VOTOS = VOTOS_BR %>% filter(SG_PARTIDO!="PT",SG_PARTIDO!="PL") %>% group_by(SG_PARTIDO,SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS)) %>% arrange(desc(QT_votos)) %>% group_by(SG_UF) %>% slice(1) %>% group_by(SG_PARTIDO) %>% mutate(Candidato = if_else(SG_PARTIDO=="MDB", "Tebet","Ciro"))

states <- read_state(
  year=2019, 
  showProgress = FALSE
)

states=left_join(states,VOTOS, by=c("abbrev_state"="SG_UF"))

states %>% ggplot() +
  geom_sf(aes(fill=Candidato)) + labs(title="Qual candidato ganhou por Estado? \n(Tirando Lula e Bolsonaro)", size=8) +
  scale_fill_manual(values = c("gray", "blue")) +
  theme_minimal() +theme(
    plot.title.position = "plot",
    text = element_text(
      family = "Verdana"
    ),axis.text=element_blank())


# Comparação com outros anos

#EVOLUÇÃO VOTAÇÃO DO PT
PT_VOTOS = data.frame(QT_VOTOS=c(11622673,17112255,21475218,39455233,46662365,47651434,43267668,31342005,57259504),
                      Ano = c(1989,1994,1998,2002,2006,2010,2014,2018,2022))	

graf_basico = PT_VOTOS %>% ggplot() +
  aes( x = Ano,y = round(QT_VOTOS)) +
  geom_line(size = 1.5) 

min_votos_max = PT_VOTOS %>% filter(Ano %in% c(max(Ano),min(Ano))) %>%mutate(legenda= paste0(round(QT_VOTOS/1000000,0),"M"))


graf_basico +
  theme_minimal(base_size = 12) + scale_x_continuous(limits=c(1988,2022),breaks = c(1989,1994,1998,2002,2006,2010,2014,2018,2022)) + labs(x="",y="",title = "Quantidade de votos no PT no primeiro turno por ano de eleição\n (em milhões)") + scale_y_continuous(limits=c(0,65000000),labels = function(x){paste0(x/1000000, "M")}) + geom_point(data =min_votos_max,aes(x=Ano,y=QT_VOTOS),size=5,col="red" ) + ggrepel::geom_text_repel(
    data = min_votos_max,
    aes(x = Ano, y = QT_VOTOS , label = legenda),
    size = 5,
    color = "red",
    family = "Verdana",nudge_y = 1000
  )+ 
  theme(
    plot.title.position = "plot",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    text = element_text(
      color = "#80868b", family = "Verdana"
    ),
    plot.title = element_text(size = 12,hjust = 0.5)
  )


#Correlação da eleição de 2018 com 2022 do PT

VOTOS_UF=VOTOS_BR %>% group_by(SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PT_UF =VOTOS_BR %>% filter(SG_PARTIDO=="PT") %>% group_by(SG_UF) %>% summarise(PT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))              
PT_2022=cbind(VOTOS_UF,PT_UF)[,-3]
PT_2022 = PT_2022  %>% mutate(Porcentagem_votos_2022=round(100*PT_votos/QT_votos,2)) %>% select(SG_UF,Porcentagem_votos_2022)   
VOTOS_UF_2018=VOTOS_BR_2018 %>% filter(NR_TURNO==1) %>% group_by(SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PT_UF_2018 =VOTOS_BR_2018%>% filter(NR_TURNO==1) %>% filter(SG_PARTIDO=="PT") %>% group_by(SG_UF) %>% summarise(PT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))           
PT_2018=cbind(VOTOS_UF_2018,PT_UF_2018)[,-3]
PT_2018 = PT_2018  %>% mutate(Porcentagem_votos_2018=round(100*PT_votos/QT_votos,2))%>% select(SG_UF,Porcentagem_votos_2018)   

PT_COMPARACAO=merge(PT_2022,PT_2018)
PT_COMPARACAO$Regiao = c("Norte","Nordeste","Nordeste","Norte","Nordeste","Nordeste","Centro-Oeste","Sudeste","Centro-Oeste","Nordeste","Sudeste","Centro-Oeste","Norte","Nordeste","Nordeste","Nordeste","Nordeste","Sul","Sudeste","Nordeste","Norte","Norte","Sul","Sul","Nordeste","Sudeste","Norte","A")
PT_COMPARACAO %>% filter(SG_UF!="ZZ") %>% ggplot(aes(x=Porcentagem_votos_2022,y=Porcentagem_votos_2018)) + geom_point(aes(fill=Regiao,col=Regiao)) + labs(x="Eleição 2022",y="Eleição 2018",title = "Porcentagem de votos petista") +
  annotate("text", x =30, y = 65, label = "italic(corr) == 0.87",
           parse = TRUE)  + scale_x_continuous(limits=c(0,100),breaks = c(0,25,50,75,100),labels = function(x){paste0(x, "%")})+ scale_y_continuous(limits=c(0,100),breaks = c(0,25,50,75,100),labels = function(x){paste0(x, "%")})  +ggthemes::theme_economist() + theme(text = element_text(
             color = "#80868b", family = "Verdana"
           ),legend.text = element_text(size=12)) +
  gghighlight::gghighlight(
    Porcentagem_votos_2022 > 50,Porcentagem_votos_2018 > 50, label_key = SG_UF
  )


#Diferença de votos Bolsonaro
PSL_UF_2018 =VOTOS_BR_2018%>% filter(NR_TURNO==1) %>% filter(SG_PARTIDO=="PSL") %>% group_by(SG_UF) %>% summarise(PSL_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
PL_UF =VOTOS_BR %>% filter(SG_PARTIDO=="PL") %>% group_by(SG_UF) %>% summarise(PL_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
BOLSONARO_COMPARACAO=merge(PL_UF,PSL_UF_2018)

BOLSONARO_COMPARACAO %>% filter(SG_UF!="ZZ") %>% mutate(diff=PL_votos-PSL_votos,Ganhouvoto=(if_else(diff>0,"Ganhou","Perdeu"))) %>% ggplot(aes(x=SG_UF,y=diff,fill=Ganhouvoto)) + geom_col(width = 0.7) + labs(x="",y="", title = "Diferença de votos no Bolsonaro nas duas últimas eleições por UF", fill="Bolsonaro ganhou ou perdeu voto na UF?") + scale_fill_manual(values =c("Ganhou"="blue","Perdeu"="Red") ) + theme_minimal() +
  theme(legend.position = "top",plot.title=element_text(size = 12),axis.text.y = element_text(size = 8),axis.text.x = element_text(size = 8),axis.title.y = element_text(size = 12),axis.title.x = element_text(size=12),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        text = element_text(
          color = "#80868b", family = "Verdana")) + scale_y_continuous(labels=function(x){paste0(x/1000, " mil")}) 

##Análise segundo turno
#2 TURNO POR REGIAO
TURNO_2=VOTOS_BRASIL %>% filter(NR_TURNO==2,DS_CARGO=="Presidente")%>%group_by(SG_PARTIDO,SG_UF) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS))
TURNO_2$Regiao= c("Norte","Nordeste","Nordeste","Norte","Nordeste","Nordeste","Centro-Oeste","Sudeste","Centro-Oeste","Nordeste","Sudeste","Centro-Oeste","Norte","Nordeste","Nordeste","Nordeste","Nordeste","Sul","Sudeste","Nordeste","Norte","Norte","Sul","Sul","Nordeste","Sudeste","Norte","A","Norte","Nordeste","Nordeste","Norte","Nordeste","Nordeste","Centro-Oeste","Sudeste","Centro-Oeste","Nordeste","Sudeste","Centro-Oeste","Norte","Nordeste","Nordeste","Nordeste","Nordeste","Sul","Sudeste","Nordeste","Norte","Norte","Sul","Sul","Nordeste","Sudeste","Norte","A")
TURNO_2=TURNO_2 %>% filter(Regiao!="A")%>% group_by(Regiao,SG_PARTIDO) %>% summarise(QT=sum(QT_votos)) %>%
  spread(key = SG_PARTIDO, value = QT) %>% mutate(TOTAL=PT+PL,PT=round(100*PT/(TOTAL),1),PL=round(100*PL/(TOTAL),1)) %>% gather(-c(Regiao,TOTAL),key = "PARTIDO",value = "PORCENTAGEM") %>% select(-TOTAL) %>% mutate(legenda=str_replace(as.character(PORCENTAGEM),"[.]",","))
img = c("bolsonaro.jpg","lula.jpg")

TURNO_2 %>% ggplot(aes(x=PARTIDO,y=PORCENTAGEM,fill=PARTIDO)) + geom_col(width = 0.75)+theme_minimal() + coord_flip() + labs(x="",y="")+facet_wrap(~Regiao) + scale_fill_manual(values = c("PT"="red","PL"="blue")) + geom_text(aes(label=paste0(legenda, "%")), vjust=1,hjust=1, size=4.5,color="white") +scale_x_discrete(name = NULL, labels = glue::glue("<img src='{img}'  width='50' >"))+ theme(axis.text.y = element_markdown(color = "black", size = 11),axis.text.x = element_blank(), panel.grid.minor = element_blank(),
                                                                                                                                                                                                                                                                                                                                                                                                       panel.grid.major = element_blank(),
                                                                                                                                                                                                                                                                                                                                                                                                       legend.position="none",
                                                                                                                                                                                                                                                                                                                                                                                                       text = element_text(
                                                                                                                                                                                                                                                                                                                                                                                                         color = "#80868b", family = "Verdana"
                                                                                                                                                                                                                                                                                                                                                                                                       ))  
#2 TURNO

BR_2TURNO=VOTOS_BRASIL %>% filter(NR_TURNO==2,DS_CARGO=="Presidente")%>%group_by(SG_PARTIDO) %>% summarise(QT_votos=sum(QT_VOTOS_NOMINAIS_VALIDOS)) %>% spread(key = SG_PARTIDO, value = QT_votos) %>% mutate(TOTAL=PT+PL,PT=round(100*PT/(TOTAL),1),PL=round(100*PL/(TOTAL),1)) %>% gather(-c(TOTAL),key = "PARTIDO",value = "PORCENTAGEM") %>% select(-TOTAL) %>% mutate(legenda=str_replace(as.character(PORCENTAGEM),"[.]",","))

BR_2TURNO |>
  ggplot(aes(y = PARTIDO, x = PORCENTAGEM, fill = PARTIDO)) +
  geom_col( show.legend = FALSE,width = .5) +
  scale_fill_brewer(palette = "Set1",direction = -1) + scale_x_continuous(
    labels = function(x){paste0(x, "%")} )+
  ggthemes::theme_economist() +
  labs(x = "") +
  scale_y_discrete(
    name = NULL,
    labels = glue::glue("<img src='{img}'  width='100' >")
  ) + theme(axis.text.y = element_markdown(color = "black", size = 11))  + geom_text(aes(label=paste0(legenda, "%")), vjust=1,hjust=1, size=5.5,color="white")
