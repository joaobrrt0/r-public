# r-public

# Crescimento Populacional dos Municípios de Roraima

Este projeto em R tem como objetivo analisar o **crescimento populacional** dos municípios do estado de **Roraima** entre os anos de **2000, 2010 e 2022**. Utiliza dados reais de população e visualiza os resultados por meio de gráficos e mapas geográficos.

## Objetivos

- Obter dados geográficos dos municípios de Roraima com o pacote `geobr`.
- Integrar dados reais de população (2000, 2010, 2022).
- Calcular o crescimento populacional em três períodos:
  - 2000–2010
  - 2010–2022
  - 2000–2022
- Gerar:
  - Um gráfico de barras comparando o crescimento por município.
  - Um mapa temático da população em 2022.

## Pacotes necessários

```r
install.packages(c("geobr", "ggplot2", "dplyr", "sf", "tidyr"))
