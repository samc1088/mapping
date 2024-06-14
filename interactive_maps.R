##########################################################
# This file provides a                 
# reproducible example demonstrating how to implement 
# some very basic interactive maps in R, using the 
# plotly and leaflet packages. 
# These can be very useful if you decide to publish your work 
# on a website using something like shiny!
# #########################################################





library(plotly)
library(sf)
library(ggplot)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)





#making dummy data 

nome <- data.frame(lat = c(64.50008874202608), long = c(-165.40944499824437), label = c("Nome"))



salinity = data.frame(lat = c(64.36954054558281 , 64.22089445898632, 63.814970590435124,  64.68072754844472, 64.36404941220977), long =  c( -163.89099119576764 , -165.46493350085828 , -161.75855323403195 , -161.30160224223144  , -167.4704406315383), salinity = runif(5, min = 30, max = 35), 
                      site = c("site 1", "site 2", "site 3", "site 4", "site 5"))


#this is very similar code to the rnaturalearth example! We are assigning it to 
# a variable so we can pass it to the ggplotly() function later!
p <- ne_countries(country = c("united states of america","canada"), returnclass = 'sf', scale = 10) %>%
  ggplot() + 
  geom_sf(fill = "gray34") +  
  coord_sf(xlim = c( -168.516727, -158.592211), ylim =c(66.424801, 63.370551)) + 
  geom_point(data = salinity, aes(x = long, y = lat, color = salinity), size = 3) + 
  geom_label(data = nome, aes(x = long, y = lat, label = label),  nudge_y = -.3) + 
  labs(x = "Longitude", y = "Latitude") + 
  scale_color_viridis_c()


?ggplotly


#by passing out plot to ggplotly() we can make it interactive! now you can 
#zoom and hover over points to see their values! 
ggplotly(p)

#one thing you may notice is you cannot add labels or certain aesthetics to 
# the plot if you want it to work with ggplotly! for example geom_label doesn't work! 




######## Leaflet implementation 

#here, I will be making the same map but instead it will be implemented using the leaflet package,
# which is an interactive mapping tool! 
library(leaflet)


?leaflet()

?setView

?addTiles



#to make a palette for the legend you need to use colorNumeric (since our salintiy values are continous!)

palette <- colorNumeric("RdYlBu", domain = salinity$salinity)

leaflet(data = salinity) %>% #creating leaflet object
  addTiles() %>% #adding basemap tiles 
  setView(lat = 64.50008874202608,lng = -165.40944499824437, zoom = 6) %>% #centering on nome, and setting the zoom so all my points fit 
  addCircleMarkers(~long, ~lat, label = ~salinity, popup = ~salinity, color = ~palette(salinity)) %>% #this lets you add your points to the map! it is also setup so when you hover over the point it reads the salinity ! 
  addLegend(position = "bottomright", title = "Salinity", values = ~salinity, pal = palette) # this adds a legend to the map and places it in the bottom right! 



