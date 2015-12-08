library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/mountain hay meadows dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	build objects from turboveg XML files

#	project 1 (Staudinger027)
file <- file.path(path, paste0(key[[1]], ".xml"))
obj1 <- read.XML(file)
coverscale(obj1) <- "braun.blanquet"
obj1 <- turbovegLayers(obj1) # no undefined
obj1 <- layers(obj1, collapse = c("hl", "hl"))
#	project 2 (Staudinger028)
file <- file.path(path, paste0(key[[2]], ".xml"))
obj2 <- read.XML(file)
coverscale(obj2) <- "braun.blanquet"
obj2 <- turbovegLayers(obj2, "hl") # no layer is herb layer 
obj2 <- layers(obj2, collapse = c("hl", "hl", "tl"))

#	concatenate objects
obj <- bind(obj1, obj2)

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # maximum value, accurcay is usally better!
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	assign result object
key1 <- unique(sapply(key, gsub, pattern = "[0-9-]", replacement = ""))
key2 <- paste(sapply(key, gsub, pattern = "[[:alpha:]]", replacement = ""), collapse = "_")

key <- paste0(key1, key2)
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	error
#	error <- subset(obj, which(taxon(obj) == "Carex flacca"))
#	species(error)[species(error)$layer == "tl", ]
#	plot 14654 has Carex flacca in the tree layer

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), select = "richness",
	sep = "", add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
