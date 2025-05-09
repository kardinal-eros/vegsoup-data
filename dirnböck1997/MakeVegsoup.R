library(vegsoup)
require(bibtex)


path <- "~/Documents/vegsoup-data/dirnböck1997"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key
key <- key[[1]]

file <- "~/Documents/vegsoup-data/dirnböck1997/Dirnböck1997Tab3.txt"
x <- read.verbatim(file, "Aufnahmenummer")
x <- data.frame(abbr = rownames(x),
	layer = "hl", x, check.names = FALSE)
# promote to class "Species"
X <- stackSpecies(x)[, 1:4]

file <- "~/Documents/vegsoup-data/dirnböck1997/Dirnböck1997Tab3Locations.csv"
Y <- stackSites(file = file, sep = ";", schema = "Aufahmenummer")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")
obj$Längengrad <- as.numeric(gsub("E", "", obj$Längengrad))
obj$Breitengrad <- as.numeric(gsub("N", "", obj$Breitengrad))
coordinates(obj) <- ~ Längengrad + Breitengrad
proj4string(obj) <- CRS("+init=epsg:4326")

names(obj) <- c("date", "tcov", "hcov", "scov", "expo", "pls", "elevation", "location", "slope", "observer", "remarks", "accuracy")

#	unique rownames
rownames(obj) <- paste(key, "Tab3", sprintf("%04d", as.numeric(rownames(obj))), sep = ":")

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
