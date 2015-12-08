library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/starzengruber1979"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- file.path(path, "Starzengruber1979Tab1.txt")
x <- read.verbatim(file, colnames = "Laufende Nummer", layers = "@")
a <- attributes(x)	# attributes for later use

X <- species(x)

#	sites data also including coordinates
file <- file.path(path, "Starzengruber1979Tab1Locations.txt")
Y <- read.delim(file, colClasses = "character")
names(Y)[1] <- "plot"

#	merge from attributes
Y$altitude <- a$"Meereshöhe"
Y$expo <- a$"Exposition"
Y$slope <- a$"Hangneigung"
Y$htl1 <- a$"Höhe max BS in m"
Y$hsl <- a$"Höhe max SS in m"
Y$hhl1 <- a$"Höhe max KS in cm"
Y$tcov1 <- a$"Deckung BS"
Y$scov <- a$"Deckung SS"
Y$hcov <- a$"Deckung KS"
Y$mcov <- a$"Deckung MS"
Y$pls <- a$"Aufnahmefl. (m²x100)" * 100
Y <- stackSites(Y)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	order layer
layers(obj)	 <- c("tl", "sl", "hl", "ml")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%03d", as.numeric(rownames(obj))), sep = ":")

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
