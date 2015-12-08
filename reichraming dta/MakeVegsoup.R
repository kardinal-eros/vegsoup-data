library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/reichraming dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- file.path(path, paste0(key, ".xml"))

#	build object from turboveg XML file
obj <- read.XML(file)

#	harmonize coverscales
#	turboveg defines cover code "x"	but this is not used
#	we tweek the objects coverscale
obj[[1]]@coverscale <- Coverscale("braun.blanquet2")
coverscale(obj[[2]]) <- "braun.blanquet2" # to make it compatible

obj <- do.call("bind", obj)

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # estimated
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	recode layer
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), select = "richness",
	sep = "", add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
