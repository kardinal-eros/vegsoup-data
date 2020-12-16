library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/fischer1998"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	 join authored translate list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
z <- read.csv2(file)
zz <- read.csv(file.path(path, "translate.csv"), colClasses = "character")
zz <- join(zz, z)

#	read OCR table
tab1 <- file.path(path, "Fischer1998Tab1.txt")
tab2 <- file.path(path, "Fischer1998Tab2.txt")

tab1 <- read.verbatim(tab1, colnames = "Aufnahmenummer", vertical = FALSE, layers = "@")
tab2 <- read.verbatim(tab2, colnames = "Aufnahmenummer", vertical = FALSE, layers = "@")

#	read location information including coordinates 
loc1 <- file.path(path, "Fischer1998Tab1Locations.csv")
loc2 <- file.path(path, "Fischer1998Tab2Locations.csv")

loc1 <- stackSites(file = loc1, sep = ",", dec = ".")
loc2 <- stackSites(file = loc2, sep = ",", dec = ".")

x1 <- species(tab1)
x2 <- species(tab2)
y1 <- vegsoup::bind(sites(tab1), loc1)
y2 <- vegsoup::bind(sites(tab2), loc2)

#	translate taxon names
species(x1) <- zz
species(x2) <- zz

#	build Vegsoup objects
X1 <- Vegsoup(x1, y1, z, "braun.blanquet2")
X2 <- Vegsoup(x2, y2, z, "braun.blanquet2")

#	add syntaxa
X1$association <- "Arunco-Aceretum"
X2$association <- "Phyllitido-Aceretum"

#	unique rownames
rownames(X1) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(X1))), sep = ":")
rownames(X2) <- paste(key, "Tab2", sprintf("%02d", as.numeric(rownames(X2))), sep = ":")

#	bind objects
obj <- vegsoup::bind(X1, X2)

#	groome names
names(obj) <- c("accuracy", "association", "pls", "plot", "date", "tcov", "hcov", "scov", "expo", "slope",
	"location", "observer", "remarks", "elevation", "mcov")
sites(obj) <- sites(obj)[ ,-grep("plot", names(obj)) ]

#	order layer
obj <- layers(obj, collapse = c("tl", "hl", "ml", "sl"))
layers(obj)	 <- c("tl", "hl", "ml", "sl")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE, select = "richness")

#	tidy up
rm(list = ls()[-grep(key, ls())])

