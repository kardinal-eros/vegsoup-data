require(vegsoup)
require(naturalsort)
require(bibtex)
require(stringr)

path <- "~/Documents/vegsoup-data/wittmann2007"

#	taxon translation
file <- file.path(path, "translate1.csv")
A <- read.csv2(file, stringsAsFactors = FALSE)

#	species
file <- file.path(path, "Wittmann2007Tab1Appendix.csv")
X <- read.csv2(file, stringsAsFactors = FALSE)
names(X) <- gsub("X", "", names(X))

#	join taxa translation with abbreviations
stopifnot(identical(X$taxon, A$taxon))
X <- cbind(A, X[, -1])

#	build object of class "Species"
X <- stackSpecies(x = X, schema = c("abbr", "layer", "taxon"))[, 1:4]

#	sites
file <- file.path(path, "Wittmann2007Tab1AppendixLocations.csv")

#	build object of class "Sites"
Y <- stackSites(file = file, sep = ";")

#	build object of class "SpeciesTaxonomy", tests matching to reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

#	build vegsoup object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", rownames(obj), sep = ":")

tab1 <- obj