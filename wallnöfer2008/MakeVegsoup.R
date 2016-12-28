library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/wallnöfer2008"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")
key <- bib$key

file <- file.path(path, "species wide.csv")
X <- stackSpecies(file = file, schema = c("taxon", "layer"), sep = ",", verbose = T)[, 1:4]

file <- file.path(path, "sites wide.csv")
Y <- stackSites(file = file, sep = ",")

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")
	
#	 ... and read authored translate list
zz <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")
	
zz <- join(unique(zz), Z)
species(X) <- zz

obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet")

#	split by reference system and reproject
obj1 <- obj[obj$epsg == "EPSG:31257", ]
obj2 <- obj[obj$epsg == "EPSG:31258", ]
coordinates(obj1) <- ~x+y
proj4string(obj1) <- CRS("+init=epsg:31257")
coordinates(obj2) <-  ~x+y
proj4string(obj2) <- CRS("+init=epsg:31258")

obj1 <- spTransform(obj1, CRS("+init=epsg:4326"))
obj2 <- spTransform(obj2, CRS("+init=epsg:4326"))

obj <- bind(obj1, obj2)

#	order layer
layers(obj)	 <- c("tl", "sl", "hl")

#	unique rownames
rownames(obj) <- paste(key, rownames(obj), sep = ":")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])


