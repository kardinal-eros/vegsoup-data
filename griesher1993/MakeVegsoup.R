require(vegsoup)
require(bibtex)
require(naturalsort)

path <- "~/Documents/vegsoup-data/griesher1993"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	main table
file <- file.path(path, "Griehser1993Tab1.txt")
x <- xx <- read.verbatim(file, colnames = "Aufnahmenummer")

a <- read.csv2(file.path(path, "translate.csv"),
		colClasses = "character")
a <- a$abbr[match(rownames(x), a$taxon)]

x <- data.frame(abbr = a, layer = "hl", x, check.names = FALSE, stringsAsFactors = FALSE)

x$layer[c(38,39,40,41,49)] <- "ml"
X <- stackSpecies(x)[, 1:4]

#	read prepared digitized table
file <- "~/Documents/vegsoup-data/griesher1993/Griehser1993Tab1FooterSpecies.csv"
x <- read.csv2(file, colClasses = "character")
x <- x[, -grep("taxon", names(x))]
XX <- species(x)
X <- bind(X, XX)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/griesher1993/Griehser1993Tab1Locations.csv"
Y <- read.csv2(file, colClasses = "character")
names(Y)[1] <- "plot"
# promote to class "Sites"
Y <- stackSites(Y)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
a <- as.data.frame(attributes(xx)[- c(1:3, 9)])
rownames(a) <- colnames(xx)
# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ] 

# give names and assign variables
obj$elevation <- a$"Höhe.über.dem.Meer.in.Meter"
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Neigung.in.Grad"
obj$pls <- a$"Groesse.in.Quadratmeter"
obj$cov <- obj$hcov <- a$"Deckung.in.."
obj$hcov <- obj$hcov <- a$"Deckung.in.."

obj$alliance <- ""
obj$association <- ""
obj$association[1:7] <- "Caricetum firmae"
obj$alliance[1:7] <- "Caricion firmae"
obj$association[8:17] <- "Elynetum seslerietosum variae"
obj$alliance[8:17] <- "Oxytropido-Elynion"

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")
		
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
