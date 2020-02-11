library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/seekirchen dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, paste0(key, ".xml"))

#	build object from turboveg XML file
obj <- read.XML(file)

#	harmonize coverscales
#	turboveg defines cover code "x"	but this is not used
#	we tweek the objects coverscale
coverscale(obj[[1]]) <- "braun.blanquet"
coverscale(obj[[2]]) <- "braun.blanquet"

obj <- do.call("bind", obj)

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # estimated
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	recode layer
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	collapse juveniles layers
obj <- layers(obj, c("hl", "sl2", "hl", "sl1", "tl2", "tl1", "tl3", "ml"))

#	order layers
layers(obj) <- c("ml", "hl", "sl1", "sl2", "tl3", "tl2", "tl1")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), select = "richness",
	sep = "", add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
