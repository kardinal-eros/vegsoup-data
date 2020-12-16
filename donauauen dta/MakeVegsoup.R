library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/donauauen dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	build objects from turboveg XML files

#	project 1 (Staudinger010)
file <- file.path(path, paste0(key[[1]], ".xml"))
obj1 <- read.XML(file)
coverscale(obj1) <- "braun.blanquet"
obj1 <- turbovegLayers(obj1, "hl") # no layer is herb layer 

#	project 2 (Staudinger102)
file <- file.path(path, paste0(key[[2]], ".xml"))
obj2 <- read.XML(file)
coverscale(obj2) <- "braun.blanquet"
obj2 <- turbovegLayers(obj2)       # all herb layer 

#	concatenate objects
obj <- vegsoup::bind(obj1, obj2)

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # maximum value, accurcay is usally better!
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	assign result object
key1 <- unique(sapply(key, gsub, pattern = "[0-9-]", replacement = ""))
key2 <- paste(sapply(key, gsub, pattern = "[[:alpha:]]", replacement = ""), collapse = "and")

key <- paste0(key1, key2)

assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), select = "richness",
	sep = "", add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
