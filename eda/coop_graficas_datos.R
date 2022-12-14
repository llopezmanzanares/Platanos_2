# Estructuras de datos usados en el script coop_graficas.R
# los saco aquí para simplificar el script de las gráficas

# objeto datos_sem
load(file = here("data/processed", "datos_finca.RData"))

# Datos mensuales ---------------------------------------------------------

# Es más útil trabajar con los datos mensuales
# solo tengo un dato de 2020, así que lo elimino
coop_ds$mes <- 
  filter(coop_ds$sem, year(fecha) > 2020) %>% 
  select(
    !c(semana,             # el dato de la semana no aporta información
       total_fac,          # el total facturado es muy similar al importe, lo quito
       ends_with(c("_med", # tampoco las medias y porcentajes
                   "_pc",
                   "_eurkg")
       )
    )
  ) %>% 
  mutate(
    fecha = rollforward(fecha)
  ) %>% 
  group_by(fecha) %>% 
  summarise(
    across(everything(), sum),
    .groups = "drop"
  ) %>% 
  mutate(
    kg_rac = total_kg / racimos
  )

# Kg por meses ------------------------------------------------------------

coop_ds$mes_kg <- coop_ds$mes %>% 
  mutate(
    aa = year(fecha),
    mm = month(fecha, label = TRUE),
    .after = 1
  ) %>% 
  select(fecha:mm, ends_with("kg")) %>% 
  group_by(aa) %>% 
  mutate(
    across(ends_with("_kg"), cumsum, .names = "{.col}_acum")
  ) %>% 
  ungroup()

# Guardo los datos --------------------------------------------------------

save(coop_ds, file = here("data/processed", "datos_finca.RData"))
