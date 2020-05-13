library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/furka dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species wide.csv")
#	promote to class "Species"
X <- stackSpecies(file = file, sep = ";")[, 1:4]

file <- file.path(path, "sites wide.csv")
#	promote to class "Sites"
Y <- stackSites(file = file, sep = ";", dec = ",")

file <- "~/Documents/vegsoup-data/furka dta/taxonomy.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = Coverscale("swiss", code = c("r", "-", "+", "1", "2", "3", "4", "5"),
lims = c(0.1,0.50,3,7.50,17.50,37.50,62.50,87.50)))

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
