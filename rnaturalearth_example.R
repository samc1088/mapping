##########################################################
# This file provides a                 
# reproducible example demonstrating how to implement 
# a basic map using the rnaturalearth package, which is 
# free and does not require a token
# Personally, I find rnaturalearth provides clean 
# large scale maps. If your study site is fairly small 
#check out the basemaps file!
# #########################################################





library(rnaturalearth)
library(rnaturalearthdata)
library(sf) # a really popular package to manipulate spatial data that has replaced SP 
library(tidyverse)

#if you want the really fine scale 1:10m data you need to install rnaturalearthhires 
#using the following 

# remotes::install_github("ropensci/rnaturalearthhires")
# install.packages("rnaturalearthhires", repos = "https://ropensci.r-universe.dev", 
#type = "source")

# library(rnaturalearthhires)






#creating some dummy data 
points = data.frame(lat = c(61.19786329324865,58.211526,57.924332), long = c(-149.88016401524737, -152.132186,-152.454936), label = c("Anchorage", "Site 1", "Site 2"))






library(ggrepel) # this package is great for adding labels to plots! 
#

#A great thing about rnaturalearth is you can graph it relatively easily! 

#this first line grabs the map data for the countries US and CAD, I ask for it 
#as an SF object at the finest scale (1:10m), the pipe %>% lets me pipe it right to ggplot
ne_countries(country = c("united states of america","canada"), returnclass = 'sf', scale = 10) %>%
ggplot() + #beginning ggplot object
  geom_sf(fill = "gray34") +  #recall earlier I asked for my map as an SF object, so this is needed to plot
  #changing the "fill" changes the color of land masses! 
  coord_sf(xlim = c(-161.450225,-142.847392), ylim =c(53.794365,61.175346)) + #here
  #I'm drawing a "box" or setting bounds on my map - I only want to plot this area! 
  geom_point(data = points, aes(x = long, y = lat)) + #here I'm plotting one of my sites! 
  geom_label_repel(data = points, aes(x = long, y = lat, label = label), nudge_y = -.5) + #and here 
  #I'm adding a site label - geom_label_repel is nice because it will prevent overlapping labels! 
  labs( x = "Longitude", y = "Latitude")




