library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/nockberge dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key
key <- key[[1]]

#	there are two data partitions with prefix 1 and 2

#	data partiton 1
file <- file.path(path, "species1.csv")
#	promote to class "Species"
X <- species(file, sep = ",")[, 1:4]

file <- file.path(path, "sites wide1.csv")
#	promote to class "Sites"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj1 <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	to match data partiton 2
obj1 <- BraunBlanquetReduce(obj1)

#	data partiton 2
file <- file.path(path, "species2.csv")
#	promote to class "Species"
X <- species(file, sep = ",")[, 1:4]

file <- file.path(path, "sites wide2.csv")
#	promote to class "Sites"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj2 <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	bind data partitions
obj <- vegsoup::bind(obj1, obj2)

#	order layer
layers(obj)	 <- c("ml", "hl")
 
#	assign result object
assign(key, obj)

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))

write.verbatim(obj,	file.path(path, "transcript.txt"), sep = "")

#	tidy up
rm(list = ls()[-grep(key, ls())])
