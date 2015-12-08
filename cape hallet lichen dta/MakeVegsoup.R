library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/cape hallet lichen dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- file.path(path, "species wide.csv")
#	promote to class "Species"
X <- stackSpecies(file = file, sep = ";")[, 1:4]

file <- file.path(path, "sites wide.csv")
#	promote to class "Sites"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-data/cape hallet lichen dta/taxonomy.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "percentage")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))

coverscale(obj) <- "domin"
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
