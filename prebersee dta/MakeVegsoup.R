require(vegsoup)
require(raster)

#	data from course in year 2012 (Paul Heiselmayer and Verena Meroth)

file <- "~/Documents/vegsoup-data/prebersee dta/2012/species wide.csv"
X <- stackSpecies(file = file)[, c(1:4)]

file <- "~/Documents/vegsoup-data/prebersee dta/2012/sites wide.csv"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

us2012 <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

save(us2012, file = "~/Documents/vegsoup-data/prebersee dta/ps2012.rda")
rm(list = ls()[-grep("us2012", ls(), fixed = TRUE)])


#	data from course in year 2013 (Roland Kaiser and Verena Meroth)

file <- "~/Documents/vegsoup-data/prebersee dta/2013/species.csv"
X <- species(file, sep = ";")#[, c(1:4)]

file <- "~/Documents/vegsoup-data/prebersee dta/2013/sites wide.csv"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

us2013 <- Vegsoup(XZ, Y, coverscale = "as.is")

#	complement missing values from interpolated data
i <- is.na(us2013$ph)

#	prediction grid have Global Mercator projection
#us2013 <- spTransform(us2013, CRS("+init=epsg:3857"))

#	measurement taken from wells
r <- brick("~/Documents/vegsoup-data/prebersee dta/2013/variables.tif")
names(r) <- c("ph", "conductivity", "watertable")
r <- as.data.frame(extract(r, us2013))
us2013$ph[i] <- round(r$ph[i], 1)
us2013$conductivity[i] <- round(r$conductivity[i], 0)
us2013$watertable[i] <- round(r$watertable[i], 0) * -1
#	we need to subtract the well's height for measurements
us2013$watertable[!i] <- us2013$watertable[!i] - us2013$wellheight[!i]


#	interpolated slope and aspect map from high precision GNSS measurements
#	taken at each plot
r <- raster("~/Documents/vegsoup-data/prebersee dta/2013/slope.tif")
us2013$slope <- extract(r, us2013)

r <- raster("~/Documents/vegsoup-data/prebersee dta/2013/aspect.tif")
us2013$aspect <- compass(extract(r, us2013))

#us2013 <- spTransform(us2013, CRS("+init=epsg:4326"))

save(us2013, file = "~/Documents/vegsoup-data/prebersee dta/ps2013.rda")

#	tidy up

rm(list = ls()[-c(grep("us2012", ls(), fixed = TRUE), grep("us2013", ls(), fixed = TRUE))])