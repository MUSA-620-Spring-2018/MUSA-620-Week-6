
library(rgdal)
library(sf)
library(maptools)
library(tidyverse)
library(viridis)

myTheme <- function() {
  theme_void() + 
    theme(
      text = element_text(size = 8),
      plot.title = element_text(size = 14, color = "#111111", hjust = 0, vjust = 0, face = "bold"), 
      plot.subtitle = element_text(size = 12, color = "#333333", hjust = 0, vjust = 0),
      axis.ticks = element_blank(),
      panel.grid.major = element_line(colour = "white"),
      legend.direction = "horizontal", 
      legend.position = "bottom",
      plot.margin = margin(0, 0, 0.2, 0, 'cm'),
      legend.key.height = unit(0.4, "cm"), legend.key.width = unit(1, "cm"),
      legend.title = element_text(size = 9, color = "#111111", hjust = 0, vjust = 0),
      legend.text = element_text(size = 8, color = "#333333", hjust = 0, vjust = 0)
    ) 
}


# *** FiveThirtyEight: Congressional Districts ***
#
# https://projects.fivethirtyeight.com/redistricting-maps/

# This file is in topojson format, a compressed variant of geojson
topojson <- readOGR("https://projects.fivethirtyeight.com/redistricting-maps/US-current.topo.json")
plot(topojson)

# The coodinate system is screen coordinates -- need to flip the y axis
topojson <- elide(topojson, reflect=c(FALSE, TRUE))

topojson <- st_as_sf(topojson)
ggplot() +
  geom_sf(data = topojson2, fill="#bbbbbb", color="black") +
  myTheme()



# *** WSJ: California Drought ***
#
# http://graphics.wsj.com/californias-long-challenge-with-drought/

# outline of CA - topojson format
caBorder <- readOGR("http://graphics.wsj.com/californias-long-challenge-with-drought/data/shared/california.topo.json") %>%
  st_as_sf()
ggplot() +
  geom_sf(data=caBorder,color="white") +
  myTheme()

# drought isocrones (includes multiple layers)
caDrought <- readOGR("http://graphics.wsj.com/californias-long-challenge-with-drought/data/drought/drought.ca.topo.json") %>%
  st_as_sf()

# drought isocrones, 2011
caDrought20111227 <- filter(caDrought, filename=="USDM_20111227")
ggplot() +
  geom_sf(data=caBorder,color="white") +
  geom_sf(data = caDrought20160105, aes(fill = as.factor(dm)), color="black") +
  scale_fill_viridis(discrete = TRUE, direction = -1, option="magma", name="Drought Intensity ") +
  myTheme()

# drought isocrones, 2016
caDrought20160105 <- filter(caDrought, filename=="USDM_20160105")
ggplot() +
  geom_sf(data=caBorder,color="white") +
  geom_sf(data = caDrought20160105, aes(fill = as.factor(dm)), color="black") +
  scale_fill_viridis(discrete = TRUE, direction = -1, option="magma", name="Drought Intensity ") +
  myTheme()

# overlay major cities
majorCities <- readOGR("http://graphics.wsj.com/californias-long-challenge-with-drought/data/shared/major_cities.topo.json") %>%
  st_as_sf()
ggplot() +
  geom_sf(data=caBorder,color="white") +
  geom_sf(data = caDrought20160105, aes(fill = as.factor(dm)), color="black") +
  scale_fill_viridis(discrete=TRUE , direction = -1, option="magma", name="Drought Intensity ") +
  geom_sf(data = majorCities, colour = "cyan", size = 4) +
  labs(
    title = 'California Long Challenge With Drought',
    subtitle = "Data as of 19-Jan-2016",
    caption = "Source: http://graphics.wsj.com/californias-long-challenge-with-drought"
  ) +
  myTheme()




# Washington Post: Where America’s sunniest and least-sunny places are
#
# https://www.washingtonpost.com/news/wonk/wp/2015/07/13/map-where-americas-sunniest-and-least-sunny-places-are/
# See if you can find the data and recreate their sunlight map

# Note: topojson files can have multiple layers
#   Use ogrListLayers(URL) to view the layer names
#   Use readOGR(URL,LAYER_NAME) to load a specific layer

