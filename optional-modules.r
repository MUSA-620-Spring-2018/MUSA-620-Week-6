
# *** Possibilities for Optional Modules

# Option 1: 3D visualizations with OpenGL

install.packages("rgl")
library(rgl)

data(iris)
head(iris)

x <- sep.l <- iris$Sepal.Length
y <- pet.l <- iris$Petal.Length
z <- sep.w <- iris$Sepal.Width

rgl.open()# Open a new RGL device
rgl.bg(color = "white") # Setup the background color
rgl.spheres(x, y, z, r = 0.2, color = "yellow")
rgl.bbox(color = "#333377") # Add bounding box decoration


# Option 2: D3 basics in JavaScript
# https://github.com/MUSA-620-Spring-2017/d3

utils::browseURL("https://bl.ocks.org/galkamax/c19642317ac807fe13a99bbcf2eaaa75")
utils::browseURL("https://bl.ocks.org/galkamax/f3ecfeb0b4ebbbec104e87a08dc4806e")
