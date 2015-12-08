library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/stadler2011"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")
key <- bib$key

file <- file.path(path, "species wide.csv")
X <- stackSpecies(file = file, schema = c("taxon", "layer"))[, 1:4]

file <- file.path(path, "sites wide.csv")
Y <- stackSites(file = file, sep = ";")

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")
	
#	 ... and read authored translate list
zz <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")
	
zz <- join(unique(zz), Z)
species(X) <- zz

obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet")

#	order layer
layers(obj)	 <- c("tl", "sl", "hl")

#	unique rownames
rownames(obj) <- paste(key, sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

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


