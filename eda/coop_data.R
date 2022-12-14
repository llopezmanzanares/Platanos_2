
# ESTE LO PUEDO BORRAR

# modificaciones al conjunto de datos para trabajar mejor con él

library(tidyverse)
library(here)

load(here("data/processed", "datos_finca.RData"))

# para poder agrupar por meses me llevo las fechas al último día de cada mes
datos_mes <- datos_sem %>% 
  mutate(
    mes = lubridate::rollforward(fecha),
    .after = 1
  ) %>% 
  group_by(mes) %>% 
  summarise(
    across(racimos:segunda_eur, ~sum(.x, na.rm = T))
  ) %>% 
  select(!ends_with(c("_pc", "_eurkg", "prec_med")))

# guardo los datos

save(datos_mes, datos_sem, file = here("data/processed", "ds_cooperativa.RData"))

write_csv2(datos_mes, file = here("data/processed", "ds_coop_mes.csv"))