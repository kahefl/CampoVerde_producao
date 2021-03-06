library(readxl)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(scales)
library(patchwork)

setwd("C:\\Users\\kahel\\OneDrive\\Documents\\Coisas do R\\scripts\\Campo_Verde\\producao")

producao <- read_excel('culturas.xlsx')

prod <- producao %>% 
  filter(anos > "1989-12-31") %>% 
  select(anos, Total, `Soja (em gr�o)`,
         `Algod�o herb�ceo (em caro�o)`,
         `Milho (em gr�o)`) %>% 
  mutate(anos=as.Date(anos)) %>%
  mutate(restante = Total - c(`Milho (em gr�o)`+`Soja (em gr�o)`+ `Algod�o herb�ceo (em caro�o)`))

p1 <- prod %>%
  select(anos,Total) %>% 
  mutate(cult = rep("Todos os cultivos",29)) %>% 
  rename(valor = Total)

p2 <- prod %>%
  select(anos, `Milho (em gr�o)`) %>% 
  rename(valor =`Milho (em gr�o)`)%>% 
  mutate(cult = rep("Milho (em gr�o)",29))

p3 <- prod %>%
  select(anos, `Soja (em gr�o)`) %>% 
  rename(valor =`Soja (em gr�o)`)%>% 
  mutate(cult = rep("Soja (em gr�o)",29))

p4 <- prod %>%
  select(anos, `Algod�o herb�ceo (em caro�o)`) %>% 
  rename(valor = `Algod�o herb�ceo (em caro�o)`)%>% 
  mutate(cult = rep("Algod�o herb�ceo (em caro�o)",29))

p5 <- p1 %>% 
  mutate(valor = as.numeric(p1$valor - c(p2$valor+p3$valor+p4$valor))) %>% 
  mutate(cult = rep("Demais cultivos",29))

p6 <- p1 %>% 
  mutate(valor = as.numeric(c(p2$valor+p3$valor+p4$valor))) %>% 
  mutate(cult = rep("Algod�o, Milho e Soja", 29))

p7 <- rbind(p1,p6)

p8 <- rbind(p2,p3,p4)


graf_1 <- ggplot(p7, aes(x=anos, y=valor, fill=cult)) + 
  geom_col(position = "dodge")+
  scale_y_continuous(limits = c(0, 500000),labels = label_number(suffix = " ton"))+
  scale_x_date(limits = as.Date(c("1989-12-31","2020-12-31")),
               date_labels = "%Y",date_breaks = "5 years")+
  theme_excel_new()+
  labs(title="Produ��o agr�cola",
       x=" ", y=" ")+
  theme(axis.text = element_text(colour = "black", size = 10),
        legend.text = element_text(size = 9.5, colour = "black"),
        plot.title = element_text(hjust = 0.5, colour = "black"))+
  scale_fill_manual(values = c("#FF4500", "#008000"))

graf_2 <- ggplot(p8, aes(x=anos, y=valor,color=cult))+
  geom_line(size=1.2)+
  scale_y_continuous(limits = c(0, 300000),labels = label_number(suffix = " ton"))+
  scale_x_date(limits = as.Date(c("1990-12-31","2019-12-31")),
               date_labels = "%Y", date_breaks = "5 years")+
  labs(title="Principais cultivos", x=" ", y=" ")+
  theme_excel_new()+
  theme(axis.text = element_text(colour = "black", size = 10),
        legend.text = element_text(size = 9.5, colour = "black"),
        plot.title = element_text(hjust = 0.5, colour = "black"))+
  scale_colour_manual(values = c("#CD853F","#FDE910","#FF8C00"))

graf_1 + graf_2 + plot_layout(ncol = 1,heights = c(1, 3))

ggsave("CV_cultivos.jpg", width = 8, height = 7.5)
