library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/niklfeld1979"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ";")
X <- X[, 1:4]

file <- file.path(path, "sites.csv")
#	promote to class "Sites"
Y <- sites(file, sep = ",")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
#	we don't change what we have in the files

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
