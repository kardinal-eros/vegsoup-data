require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/amann2019"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	tab 1
#	read digitized table
file <- file.path(path, "Amann2019Tab1 species wide.csv")
X <- stackSpecies(file = file, sep = ",")[, 1:4]

#   sites data including coordinates
file <- file.path(path, "Amann2019Tab1 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", rownames(obj), sep = ":")

#	assign alliance
obj$alliance.code <- "THL-05C"
obj$alliance <- "Stipion calamagrostis Jenny-Lips ex Br.-Bl. 1950"

tab1 <- obj

#	tab 2
#	read digitized table
file <- file.path(path, "Amann2019Tab2 species wide.csv")
X <- stackSpecies(file = file, sep = ",")[, 1:4]

#   sites data including coordinates
file <- file.path(path, "Amann2019Tab2 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab2", rownames(obj), sep = ":")

#	assign alliance
obj$alliance.code <- "THL-04A"
obj$alliance <- "Petasition paradoxi Zollitsch ex Lippert 1966"
tab2 <- obj

#	tab 3
#	read digitized table
file <- file.path(path, "Amann2019Tab3 species wide.csv")
X <- stackSpecies(file = file, sep = ",")[, 1:4]

#   sites data including coordinates
file <- file.path(path, "Amann2019Tab3 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab3", rownames(obj), sep = ":")

#	assign alliance
obj$alliance.code <- "THL-04A"
obj$alliance <- "Petasition paradoxi Zollitsch ex Lippert 1966"

tab3 <- obj

obj <- vegsoup::bind(tab1, tab2, tab3)

#	assign result object
assign(key, obj)

#	order layer
layers(obj)	 <- c("hl", "ml")

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

