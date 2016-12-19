#install these pacakges
install.packages("ggmap")
install.packages("leaflet")

library(ggmap)
library(leaflet)


# Geocoding is the art of mapping data. It is an art because, like graphing, 
# while the simply making a map is relatively simply, making a good map takes 
# time and finesse.
#
# In this lesson you will learn how to take data, find the coordinates for
# each data point, and map it. 

# The first part in mapping is getting the coordinates you want to map.
# Some datasets will give you the coordinates but if they don't, you can
# use ggmap() to get them yourself. ggmap() is a package that lets you 
# geocode (find the coordinates) addresses through Google. It has a limit
# of 2500 geocodes per day. There are other ways to geocode huge amounts
# of addresses in R but that is beyond the scope of this class.


# The syntax for geocoding is simple. Put the address you want in quotes,
# then say 'source = "google"' to specify that you want it geocode 
# through Google. You can have other sources but Google is the best one.
geocode("3814 Walmut St, Philadelphia, PA 19104", source = "google")
geocode("3814 Walnut St, Philadelphia, PA 19104", source = "google")

# One of the reasons that Google is the best is that it can fix minor
# problems in your addresses. The first geocode line spells Walnut
# wrong, but Google gave us the same coordinates.

# It is best to be as precise as possible with the addresses.
geocode("3814 Walnut St", source = "google") 
# This gives us different coordinates than before because the city, state,
# and zipcode are removed.

# Lets begin with a real example
# Read in the police shootings dataset which has real information about people shot
# and killed by police officers in 2015.

police <- read.csv("police_shootings.csv")

# Lets subset this to only the first 100 rows to make geocoding quicker.
police <- police[1:100,]


# The data tells us the city and state that the shooting occured in, but not
# the coordinates. We will have to find that ourselves. Remember, we need to
# be as specific as possible to geocode. 
# First, we'll create a new column that combines the city and state columns
# To do this we will use the paste() command.


# paste() is a function that lets you combine multiple columns (or any text)
# into one. The syntax is paste(item1, item2). So we want the column for city
# as item1 and the column for state as item2.
paste(police$city, police$state)

# To keep with how addresses are usually written, lets put a comma between the 
# city and state. To write text into paste you put what you want to write in 
# quotations. 
paste(police$city, ",", police$state)
# Lets save this in a new column
police$ADDRESS <- paste(GCLeaf$CITY, ",", GCLeaf$STATE)

# Now we are ready to geocode. Since our address column has all the
# addresses we want, we can use geocode to simply take addresses
# from it and return the coordinates
geocode(police$address[1], source = "google")

# We want to store the coordinates for later use so lets store it in a new
# column in our police dataset. ggmap is smart enough to create two columns -
# one for longitude and one for latitude. 
police$coordinates <- geocode(police$address, source = "google")

# This new column is different than previous ones you've encountered.
# It is essentially a dataframe inside a dataframe. That basically means
# you need to do something different to use it.
police$coordinates.lat # This won't work. You need to treat the coordinates
# column as its own dataframe with lon and lat as its
# columns.
police$coordinates$lat

# Another method is to geocode into a temporary variable that you can use
# to make new columns in the dataset with the coordinates
storage <- geocode(police$address, source = "google")
storage
storage$lon 
storage$lat

police$lon <- storage$lon 
police$lat <- storage$lat


# Now that we have our coordinates, we can begin mapping.
# The two major mapping packages in R are leaflet and ggmap


# Lets start with ggmap which is the more basic package. ggmap is basically
# a graph that paints the dots onto a map background instead of a 
# plain background. 
# To start we need to get our background. We do this using get_map
# To use get_map, put an address inside the quotes. It will automatically zoom
# if you don't set it. Since our data is national, we want the zoom to be
# very far out so I set it to 4. 
america <- get_map("United States", zoom = 4)
# Put the result into a object, in this case called america.
# Then use ggmap on the object to see the map
ggmap(america)
# At this point the syntax is nearly the same as in ggplot.
ggmap(america) + geom_point(aes(x = lon, y = lat), data = police)
# This puts a dot at every coordinate in our data.
# We can change the color of the data in the same way as in ggplot
ggmap(america) + geom_point(aes(x = lon, y = lat), color = "red", data = police)

# We can also change the transparency of the dots to make them more
# translucent. That doesn't really matter in this example, but for maps
# with data more closely mapped, it can improve the readability of your map
# Change the transparency by using "alpha =" with a number between 0 and 1 after the =
ggmap(america) + geom_point(aes(x = lon, y = lat), color = "red", data = police, alpha = 0.5)

# You can also add titles in the same way you would for ggplot
ggmap(america) + geom_point(aes(x = lon, y = lat), color = "red", data = police, alpha = 0.5) +
  ggtitle("Sample of Police Shootings in 2015")

# ggmap has lots of options for displaying its data, such as heatmaps.


####################################################################################
#Leaflet

# leaflet is an interactive mapping package that essentially allows you to map
# on Google Maps. You can zoom in, scroll around, and make your dots interactive
# to display data about each point. It is better used than ggmap for presentations
# and websites.

# The syntax for leaflet is more complicated than ggmap so we'll break it down
# into smaller pieces. The start is the same, you need to get your coordinates.



# The first part is the tile which is just what map you use as your background. 
# The one I have provided is a good basic one because it has city and state names
# while zoomed out and street names and landmarks while zoomed in.
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') 
# The attribution isn't necessary but you should always provide it to cite your 
# map tile source.
# One different piece of syntax between leaflet and ggmap is the leaflet uses
# %>% instead of +

# Next lets add our dots to the graph. Do this by using the addCircleMarkers()
# part of leaflet. 
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police)
# Within addCircleMarkers(), the first ~ is where you put the longitude column,
# and the second ~ is where you put the latitude column.

# We can add color the same way we do with ggmap
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red")

# The circles from addCircleMarkers will scale themselves to the zoom. That means when you
# zoom out they get bigger to be easier to see, and when you zoom in they will get smaller 
# to fit the screen. We can affect how big they will appear by using "radius = ". I like to
# use a radius of 4 but you can fiddle with it to find a size you like
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4)

# Using "weight = " will also affect how each dot is displated. Higher numbers will
# make it appear larger, smaller number will make it appear smaller
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 5)

leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1)


# fillOpacity is like alpha in ggmap. It affects how transparent your dots will be. 
# The "O" in fillOpacity is capitalized
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 1)

leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0)

# You'll need to play with this option to find a level you like.
leaflet() %>% addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
                       attribution='&copy; <a href="http://openstreetmap.org">
                       OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6)


# leaflet will automatically zoom out to fill all the points in its screen.
# You can automatically set the view and zoom if you'd like. For this you'll
# need coordinates you want to focus on and a zoom level. Like ggmap, lower
# zoom levels are more zoomed out and higher levels are closer.
# The command is setView(lng = <longitude>, lat = <latitude>, zoom = <some number>)

leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6)
# The view is set to focus on the continental United States and zoomed out to include
# all of it. One hint when setting view is that if you go to Google Maps and click
# on a point it will tell you the coordinates. That's an easy way to quickly find
# coordinates you want to set your view to.

# The major difference between leaflet and ggmap is that leaflet is interactive.
# You can make it display the data for each point when you click on it. 
# To do this you use "popup = " with what you want to say after the =. We will again
# use paste() to set what we want to say.

leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste("Police Shooting"))

# We can also have it display values from one of our columns, such as the location.
leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste(police$address))

# Let's specify that what we are displaying is the location of the shooting.
# Remember, when you are having it print something exactly, that thing must be in
# quotes; when it comes from something that already exists and is different each time, 
# like values in a column, you don't use quotes.
leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste("Location of Shooting:", police$address))

# We can have more than one column displayed in our popup. Let's add the name
# of the deceased.
leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste("Location of Shooting:", police$address,
                                 "Name of Deceased:", police$name))

# That looks messy because it is all written on one line. We can use "<br>" to
# make a line break so everything we print is one its own line.
# "<br>" is the code to make a line break - it must be in quotes
leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste("Location of Shooting:", police$address, "<br>",
                                 "Name of Deceased:", police$name))


# We can add as many lines of text as we want to the popup
leaflet() %>%  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
  addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
           attribution='&copy; <a href="http://openstreetmap.org">
           OpenStreetMap</a> contributors') %>%
  addCircleMarkers(~lon, ~lat, data = police, color = "red", radius = 4, weight = 1, 
                   fillOpacity = 0.6, 
                   popup = paste("Location of Shooting:", police$address, "<br>",
                                 "Name of Deceased:", police$name, "<br>",
                                 "Manner of Death:", police$manner_of_death, "<br>",
                                 "Signs of Mental Illness:", police$signs_of_mental_illness, "<br>",
                                 "Deceased Armed With:", police$armed, "<br>",
                                 "Race:", police$race, "<br>",
                                 "Gender:", police$gender, "<br>",
                                 "Age:", police$age, "<br>",
                                 "Date of Shooting:", police$date))
