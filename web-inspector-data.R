
library(rgdal)
library(sf)
library(maptools)
library(tidyverse)
library(viridis)

myTheme <- function() {
  theme_void() + 
    theme(
      text = element_text(size = 9),
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



# ****** WEB INSPECTOR: ELEMENTS TAB ******

# Download a hidden video file
# https://i.imgur.com/9M4Rsf0.gifv

download.file("https://i.imgur.com/9M4Rsf0.mp4","nyc-in-love.mp4")



# ****** WEB INSPECTOR: ELEMENTS TAB ******


# *** FiveThirtyEight: Congressional Districts ***
#
# https://projects.fivethirtyeight.com/redistricting-maps/

# This file is in topojson format, a compressed variant of geojson
topojson <- readOGR("https://null:null@projects.fivethirtyeight.com/redistricting-maps/US-current.topo.json")
plot(topojson)

# The coodinate system is screen coordinates -- need to flip the y axis
topojson <- elide(topojson, reflect=c(FALSE, TRUE))

topojson <- st_as_sf(topojson)
ggplot() +
  geom_sf(data = topojson, fill="#bbbbbb", color="black") +
  myTheme()

head(topojson)


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
  geom_sf(data = caDrought20111227, aes(fill = as.factor(dm)), color="black") +
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

# In the network tab, look for these two files and copy out their URLs:
# sunlight.csv
# us.json

# topojson files can have multiple layers
counties <- readOGR("https://www.washingtonpost.com/graphics/business/sunlight/data/us.json")
ogrListLayers("https://www.washingtonpost.com/graphics/business/sunlight/data/us.json")

# you can specify the layer ("counties") when you load the file
counties <- readOGR("https://www.washingtonpost.com/graphics/business/sunlight/data/us.json","counties") %>%
  st_as_sf()

# read in the csv
sunlight <- read.csv("https://www.washingtonpost.com/graphics/business/sunlight/data/sunlight.csv")

# join the csv data to the map
sunlight$code <- as.character(sunlight$code) 
counties$id <- as.character(counties$id)
countysunlight <- left_join(counties,sunlight,by=c("id"="code"))

# Remove HI, AK, PR for display purposes
countysunlight$county <- as.character(countysunlight$county)
countysunlight <- mutate(countysunlight,state = substr(county,nchar(county)-1,nchar(county)))
countysunlight <- filter(countysunlight, state != "HI") %>%
  filter(state != "AK") %>%
  filter(state != "PR")

# set the CRS 
st_crs(countysunlight) = 4326

ggplot() +
  geom_sf(data = countysunlight, aes(fill=avg), color=alpha("black",0.3), size=0.1) +
  scale_fill_viridis(discrete=FALSE , direction = 1, option="magma", name="Daily sunlight  ") +
  coord_sf(crs = st_crs(102003)) +
  labs(
    title = 'Average Daily Sunlight by County',
    subtitle = "Measured as solar radiation per square meter",
    caption = "Source: Washington Post"
  ) +
  myTheme()

