require(vegsoup)
require(bibtex)
require(naturalsort)

path <- "~/Documents/vegsoup-data/hörandl1991"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	main table
file <- file.path(path, "Hörandl1991Tab1.txt")
x <- read.verbatim(file, colnames = "Aufnahmenummer")

a <- read.csv2(file.path(path, "translate.csv"),
		colClasses = "character")
a <- a$abbr[match(rownames(x), a$taxon)]

x <- data.frame(abbr = a, layer = "hl", x, check.names = FALSE, stringsAsFactors = FALSE)
x$layer[c(33:48,59)] <- "ml"
X <- stackSpecies(x)[, 1:4]

#	sites
file <- file.path(path, "Hörandl1991Tab1Locations.csv")
Y <- stackSites(file = file, schema = "plot")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	order layer
layers(obj)	 <- c("hl", "ml")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", rownames(obj), sep = ":")

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
