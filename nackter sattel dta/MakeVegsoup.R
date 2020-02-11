library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/nackter sattel dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, paste0(key, ".xml"))

#	build object from turboveg XML file
obj <- read.XML(file)

#	set coverscale
coverscale(obj) <- "braun.blanquet"

#	assign coordiantes
#	values are stored in the remarks field!
xy <- as.character(obj$remarks)
xy <- strsplit(sapply(strsplit(xy, ";"), "[[", 1), ",")
x <- sapply(xy, "[[", 1)
y <- sapply(xy, "[[", 2)
x <- gsub(" Ost", "", x)
y <- gsub(" Nord", "", y)

obj$longitude <- char2dd(x)
obj$latitude <- char2dd(y)
obj$accuracy <- 50 # estimated
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	recode layer
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	collapse middle and lower tree layer
obj <- layers(obj, collapse = c("hl", "sl", "tl1", "tl2", "tl2"))

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
