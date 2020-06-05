library(tidyverse)
library(readxl)
library(lubridate)
library(geosphere)

import_flightlist_jan <- read_csv("data/flightlist_20200101_20200131.csv")
import_flightlist_feb <- read_csv("data/flightlist_20200201_20200229.csv")
import_flightlist_mar <- read_csv("data/flightlist_20200301_20200331.csv")
import_flightlist_apr <- read_csv("data/flightlist_20200401_20200430.csv")

import_airports <- read_csv("data/airports.csv")
set_airports <- import_airports %>% 
  select(IATA, ICAO, Lat, Long, Elevation)

# Pas op read_csv denkt dat sommige dingen logical fields zijn
import_CAPA_fleet <- read_csv("data/CAPA-fleet.csv", skip = 10)

import_EEA_fuel_burn <- read_xlsx("data/fuelburn.xlsx", sheet = 2)

set_CAPA_fleet <- import_CAPA_fleet %>% 
  select(`Tail/Registration Number`, starts_with("Engine"), starts_with("Aircraft")) %>% 
  rename(Registration = `Tail/Registration Number`)
      
import_fuel_burn <- read_xlsx("data/aircraft-fuel-burn.xlsx")

airport_distance_nm <- function(long_1, lat_1, long_2, lat_2) {
  distHaversine(c(long_1, lat_1), c(long_2, lat_2), r = 6378137) * 0.000539956803
}

set_flightlist_jan_apr <- import_flightlist_jan %>%
  bind_rows(import_flightlist_feb) %>% 
  bind_rows(import_flightlist_mar) %>% 
  bind_rows(import_flightlist_apr) %>% 
  filter(origin != destination) %>% 
  left_join(set_airports, by = c("origin" = "ICAO")) %>% 
  rename(Departure = origin, Arrival = destination) %>% 
  rename(Departure_Lat = Lat, Departure_Long = Long) %>% 
  left_join(set_airports, by = c("Arrival" = "ICAO")) %>% 
  rename(Arrival_Lat = Lat, Arrival_Long = Long) %>% 
  mutate(Date = ymd(day)) %>% 
  rename(Registration = registration, Callsign = callsign, Typecode = typecode) %>% 
  rename(Departure_Elevation = Elevation.x, Arrival_Elevation = Elevation.y) %>% 
  select(Date, Registration, Typecode, Callsign, Departure, Departure_Lat,
         Departure_Long, Departure_Elevation, Arrival, Arrival_Lat, Arrival_Long,
         Arrival_Elevation) %>% 
  drop_na()

tb_map <- tibble(long_1 = set_flightlist_jan_apr$Departure_Long,
                 lat_1 = set_flightlist_jan_apr$Departure_Lat,
                 long_2 = set_flightlist_jan_apr$Arrival_Long,
                 lat_2 = set_flightlist_jan_apr$Arrival_Lat)

# Purr
set_distance <- pmap_dbl(tb_map, airport_distance_nm)

set_flightlist_jan_apr <- set_flightlist_jan_apr %>% 
  mutate(Distance = set_distance)

CAPA_reg_aircraft_ICAO <- set_CAPA_fleet %>% 
  select(Registration, `Aircraft Variant ICAO Code`) %>% 
  drop_na()

set_flightlist_jan_apr <- set_flightlist_jan_apr %>% 
  inner_join(CAPA_reg_aircraft_ICAO, by = "Registration")

set_EEA_fuelburn <- import_EEA_fuel_burn %>% 
  pivot_longer(-Type, names_to = "Distance[NM]", values_to = "Fuelburn[KG]") %>% 
  mutate(`Distance[NM]` = as.numeric(`Distance[NM]`))

calc_ready_stuff <- set_flightlist_jan_apr %>% 
  filter(`Aircraft Variant ICAO Code` %in% c("B738")) %>% 
  mutate(`Fuelburn[KG]` = ifelse(`Aircraft Variant ICAO Code` == "A320",
                                 (176.16 * (`Distance` ** 2)) + (131.5 * `Distance`) + 1684.4,
                                 ((-7.7899 * (`Distance` ** 3)) + (288.83 * (`Distance` ** 2)) - (274.7 * `Distance`) + 2139)) %>% 
  mutate(`CO2[KG]` = (`Fuelburn[KG]`) * 3.16)


(176.16 * (10 ** 2) + 131.5 * 10 + 1684.4) * 3.16
