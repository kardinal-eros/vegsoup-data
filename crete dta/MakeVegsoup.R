library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/crete dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ";")
X <- X[, 1:4]

file <- file.path(path, "sites.csv")
#	promote to class "Sites"
Y <- sites(file, sep = ";")

file <- "~/Documents/vegsoup-data/crete dta/taxonomy.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE)

if (FALSE) {
	decostand(obj) <- "pa"
	vegdist(obj) <- "bray"
	write.verbatim(seriation(obj), file.path(path, "seriation.txt"),
	sep = "", add.lines = TRUE)
	KML(obj)
}
#	tidy up
rm(list = ls()[-grep(key, ls())])
