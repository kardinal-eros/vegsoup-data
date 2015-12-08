library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/weitwörth dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- file.path(path, "species.csv")
# promote to class "Species"
X <- species(file, sep = ";")[, 1:4]

file <- file.path(path, "sites wide.csv")
# promote to class "Sites"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])

