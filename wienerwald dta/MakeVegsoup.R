library(vegsoup)
library(vegit)
require(bibtex)

path <- "~/Documents/vegsoup-data/wienerwald dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	build objects from turboveg XML files

#	project 1 (Staudinger099)
file <- file.path(path, paste0(key[[1]], ".xml"))
obj1 <- read.XML(file)

#	harmonize coverscales
#	turboveg defines cover code "x"	but this is not used
#	table(species(obj1[[1]])$cov); table(species(obj1[[2]])$cov)
#	we tweek the objects coverscale
coverscale(obj1[[1]]) <- "braun.blanquet"
coverscale(obj1[[1]]) <- "braun.blanquet2" # to match obj*
obj1[[2]]@coverscale <- Coverscale("braun.blanquet2")

obj1 <- do.call("bind", obj1)

#	project 2 (Staudinger205)
file <- file.path(path, paste0(key[[2]], ".xml"))
obj2 <- read.XML(file)

#	set coverscales
coverscale(obj2) <- "braun.blanquet"      # in two steps 
coverscale(obj2) <- "braun.blanquet2"     # to match obj*

#	project 3 (Staudinger206)
file <- file.path(path, paste0(key[[3]], ".xml"))
obj3 <- read.XML(file)

#	set coverscales
coverscale(obj3) <- "braun.blanquet2"     # to match obj*    

#	project 4 (StaudingerWBW)
file <- file.path(path, paste0(key[[4]], ".xml"))
obj4 <- read.XML(file)

#	set coverscales
coverscale(obj4) <- "braun.blanquet2"     # to match obj*

#	concatenate objects
obj <- bind(obj1, obj2, obj3, obj4)

#	recode layer
obj <- turbovegLayers(obj, "hl") # no layer is herb layer

#	collapse juveniles layers
obj <- layers(obj, c("hl", "tl1", "sl1", "tl2", "hl", "sl2", "tl3"))

#	order layers
layers(obj) <- c("hl", "sl1", "sl2", "tl3", "tl2", "tl1")

#	assign coordiantes
obj$longitude <- char2dd(obj$e_coord)
obj$latitude <- char2dd(obj$n_coord)
obj$accuracy <- 50 # maximum value, accurcay is usally better!
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	assign result object
key1 <- sapply(key, gsub, pattern = "[0-9-]", replacement = "")
key1 <- unique(gsub("WBW", "", key1)) # hard to match automatically
key2 <- paste(sapply(key, gsub, pattern = "[[:alpha:]]", replacement = ""), collapse = "_")
key2 <- paste0(key2, "WBW")           # hard to get automatically 

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
