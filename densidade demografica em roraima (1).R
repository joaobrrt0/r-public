install.packages(c("geobr", "ggplot2", "dplyr", "sf", "tidyr"))  # só se não estiverem instalados

library(geobr)
library(ggplot2)
library(dplyr)
library(sf)
library(tidyr)

roraima_muni <- read_municipality(code_muni = "RR", year = 2020, showProgress = FALSE)

#obter códigos e nomes dos municípios
municipios <- roraima_muni %>%
  st_drop_geometry() %>%
  select(code_muni, name_muni)

#gerar dados de população
set.seed(123)  # para reprodutibilidade

pop_data <- municipios %>%
  mutate(
    pop_2000 = sample(8000:15000, n(), replace = TRUE),
    pop_2010 = pop_2000 + sample(1000:4000, n(), replace = TRUE),
    pop_2022 = pop_2010 + sample(1500:5000, n(), replace = TRUE)
  ) %>%
  mutate(
    cres_00_10 = pop_2010 - pop_2000,
    cres_10_22 = pop_2022 - pop_2010,
    cres_00_22 = pop_2022 - pop_2000
  )

pop_long <- pop_data %>%
  select(code_muni, name_muni, cres_00_10, cres_10_22, cres_00_22) %>%
  pivot_longer(
    cols = starts_with("cres"),
    names_to = "periodo",
    values_to = "crescimento"
  ) %>%
  mutate(periodo = case_when(
    periodo == "cres_00_10" ~ "2000–2010",
    periodo == "cres_10_22" ~ "2010–2022",
    periodo == "cres_00_22" ~ "2000–2022"
  ))

ggplot(pop_long, aes(x = crescimento, y = reorder(name_muni, crescimento), fill = periodo)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Crescimento Populacional dos Municípios de Roraima",
    x = "Crescimento da População",
    y = "Município",
    fill = "Período"
  ) +
  scale_fill_manual(values = c("2000–2010" = "#1f78b4", "2010–2022" = "#33a02c", "2000–2022" = "#a6d854")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

#juntar dados com o shapefile
mapa_roraima <- left_join(roraima_muni, pop_data, by = "code_muni")

#criar categorias de faixa populacional
mapa_roraima <- mapa_roraima %>%
  mutate(faixa = case_when(
    pop_2022 <= 13751 ~ "Até 13.751 pessoas",
    pop_2022 <= 18095 ~ "Até 18.095 pessoas",
    pop_2022 <= 21096 ~ "Até 21.096 pessoas",
    pop_2022 >  21096 ~ "Mais que 21.096 pessoas"
  ))

#definir cores
cores <- c(
  "Até 13.751 pessoas" = "#ffff66",
  "Até 18.095 pessoas" = "#e0e000",
  "Até 21.096 pessoas" = "#a0a000",
  "Mais que 21.096 pessoas" = "#556B2F"
)

#plotar o mapa
ggplot(mapa_roraima) +
  geom_sf(aes(fill = faixa), color = "white") +
  scale_fill_manual(values = cores) +
  labs(title = "Distribuição Populacional em Roraima (2022)", fill = "População") +
  theme_minimal()
