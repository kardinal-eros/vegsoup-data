library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/neusiedlersee dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- file.path(path, paste0(key, ".xml"))

#	build object from turboveg XML file
obj <- read.XML(file)

#	set coverscale
coverscale(obj) <- "braun.blanquet"

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # estimated
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	recode layer
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	collapse layer
#	the data set defines a middle tree layer, we change it to upper tree layer,
#	although, stand descriptions indicate a low tree layer.
#	Maybe it's coppice or brushwood (cp. obj$remarks)

obj <- layers(obj, collapse = c("hl", "hl", "sl", "tl1"))

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
