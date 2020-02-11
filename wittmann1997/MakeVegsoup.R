library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/wittmann1997"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	 ... and read authored translate list
zz <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")
zz <- join(zz, Z)

#	read prepared digitized table
file <- file.path(path, "Wittmann1997Tab1.txt")
x <- read.verbatim(file, colnames = "Aufnahmenummer", layers = "@")
#	promote to class "Species"
X <- species(x)
species(X) <- zz

#   sites data including coordinates
file <- file.path(path, "Wittmann1997Tab1Locations.csv")
#	promote to class "Sites"
Y <- stackSites(file = file, zeros = FALSE)

#	taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	syntaxa assigment missing
obj$alliance <- "Nanocyperion"

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")
		
#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])