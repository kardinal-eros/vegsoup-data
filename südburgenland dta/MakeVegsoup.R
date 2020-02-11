library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/südburgenland dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	build objects from turboveg XML files

#	project 1 (Staudinger001)
file <- file.path(path, paste0(key[[1]], ".xml"))
obj1 <- read.XML(file)

#	harmonize coverscales
coverscale(obj1[[1]]) <- "braun.blanquet"
coverscale(obj1[[2]]) <- "braun.blanquet"

obj1 <- do.call("bind", obj1)

coverscale(obj1) <- "braun.blanquet2" # to match obj2

obj1 <- turbovegLayers(obj1, "hl") # no layer is herb layer 

#	project 2 (Staudinger014-017)
file <- file.path(path, paste0(key[[2]], ".xml"))
obj2 <- read.XML(file)

#	harmonize coverscales
coverscale(obj2[[1]]) <- "braun.blanquet2"
#	turboveg defines cover code "x"	but this is not used
#	we tweek the objects coverscale
obj2[[2]]@coverscale <- Coverscale("braun.blanquet2")

obj2 <- do.call("bind", obj2)

obj2 <- turbovegLayers(obj2, "hl") # no layer is herb layer

#	concatenate objects
obj <- bind(obj1, obj2)

#	collapse juveniles layers
obj <- layers(obj, c("hl", "sl2", "tl2", "tl3", "hl", "tl1", "sl1", "ml"))

#	order layers
layers(obj) <- c("ml", "hl", "sl1", "sl2", "tl3", "tl2", "tl1")

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # maximum value, accurcay is usally better!
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	assign result object
key1 <- unique(sapply(key, gsub, pattern = "[0-9-]", replacement = ""))
key2 <- paste(sapply(key, gsub, pattern = "[[:alpha:]]", replacement = ""), collapse = "-")
key2 <- gsub("-", "and", key2)

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
