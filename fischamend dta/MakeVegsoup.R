library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/fischamend dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, paste0(key, ".xml"))

#	build object from turboveg XML file
obj <- read.XML(file)

#	set coverscale
#	turboveg defines cover code "x"	but this is not used
#	we tweek the objects coverscale
table(species(obj)$cov)
obj@coverscale <- Coverscale("braun.blanquet2")

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 2000 # estimated
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	recode layer
obj <- turboveglayers(obj)

#	collapse layers
obj <- layers(obj, collapse = c("hl", "sl", "tl1", "hl"))

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
