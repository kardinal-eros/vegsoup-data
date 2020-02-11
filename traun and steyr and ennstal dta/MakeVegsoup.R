library(vegsoup)
library(vegit)
require(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/traun and steyr and ennstal dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	build objects from turboveg XML files

#	2 independent projects in a single file
file <- file.path(path, "Staudinger041_043.xml")
obj <- read.XML(file)

#	harmonize coverscales
coverscale(obj[[1]]) <- "braun.blanquet"
coverscale(obj[[2]]) <- "braun.blanquet"

obj <- do.call("bind", obj)

#	translate layer codes
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	collapse juveniles layers
obj <- layers(obj, collapse = c("hl", "hl",  "sl1", "tl2", "tl1", "ml"))

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- as.numeric(gsub("[^0-9]", "", obj$accuracy)) # remove all except digits
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	assign result object
key1 <- unique(sapply(key, gsub, pattern = "[0-9-]", replacement = ""))
key2 <- paste(sapply(key, gsub, pattern = "[[:alpha:]]", replacement = ""), collapse = "_")

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
