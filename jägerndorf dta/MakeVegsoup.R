library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/jägerndorf dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key
key <- bib$key
key <- key[[1]]

file <- "~/Documents/vegsoup-data/jägerndorf dta/species wide.csv"
X <- stackSpecies(file = file, sep = ",")[, 1:4]

file <- "~/Documents/vegsoup-data/jägerndorf dta/sites wide.csv"
Y <- stackSites(file = file, sep = ",", dec = ".")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "pfadenhauer")

#	order layer
#	layers(obj)	 <- c("hl", "ml")

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


