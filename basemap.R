library(sf)
install.packages("basemaps")
library(basemaps)
library(terra)
library(tidyverse)
library(tidyterra)


#Lake Iliamna example! 


#this is a KML file from google earth - you can draw polygons and then save them as a KML file, which you can read in R
#here, I'm using it to essentiallyy create a "box" around the area I want the map to be in! 
iliamna <- st_read("iliamna.kml")

?basemap

#here are the maptypes you can set, ESRI is the ArcGIS ones! 
get_maptypes()



#this gives you your map as a raster 
map <- basemap_terra(ext = iliamna, map_service = "esri", map_type = "world_imagery")

plot(map)


#here I'm changing the CRS projection so it's easier to plot points and polygons on here! 
#there is nothing wrong with the original projection but this makes it easier to use lat longs
#like if you wanted to put points or polygons (that aren't rasters!) on this basemap! 
map <- project(map,"+proj=longlat +datum=WGS84")

#an example point 
examp <- data.frame(x = -154.1914, y = 59.55361, label = 'Hey!')

#geom_spatraster_rgb is from the tiny terra package and is useful for plotting multicolor rasters! 
ggplot() + geom_spatraster_rgb(data = map) + geom_point(data = examp, aes(x = x, y = y), color = "red", size =6)




#or you can pull it as a ggplot layer! 
ggplot() +
  basemap_gglayer(ext = iliamna, map_service = "esri", map_type = "world_imagery") +
  geom_sf() +
  scale_fill_identity() + coord_fixed()




# Auke Lake Example 

#creating an empty raster object! 
auke <- rast()

#setting the extent of my raster - basically drawing a "map" around my 
ext(auke) <- c(-134.651674, -134.620304,58.377379,58.395540)

#getting an auke lake basemap! 
auke_map <- basemap_terra(ext = auke, map_service = "esri", map_type = "world_light_gray_base", map_res = 1)

#crude plot of basemap
plot(auke_map)



#making fake data to plot! 
temps <- data.frame(lat = c(58.390059,58.385555,58.382885,58.390726), long = c(-134.635945,-134.636036,-134.629398,-134.627215), temp = c(1.123, 3.32, 4.55, 4.221))

#changing projection to lat/long to make manipulation easier! 
auke_map <- project(auke_map,"+proj=longlat +datum=WGS84")



#plotting the auke lake map! 
ggplot() + geom_spatraster_rgb(data = auke_map) + theme(panel.border = element_blank(), panel.grid.major = element_blank(),panel.grid.minor = element_blank()) + geom_point(data = temps, aes(x = long, y = lat, color = temp), size = 5) + scale_color_viridis_c()



