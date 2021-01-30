library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/gruber2006"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	 ... and read authored translate list
z <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")

file <- file.path(path, "Gruber2006.csv")
X <- stackSpecies(file = file, schema = c("taxon", "layer"), sep = ",")
species(X) <- join(z, Z)

#	transform cover scale
X$cov[X$cov == "1"] <- "+"

file <- file.path(path, "Gruber2006Locations.csv")
Y <- stackSites(file = file, sep = ",")

XZ <- SpeciesTaxonomy(X, Z)

obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet2")

#	classification into syntaxon
obj$allicance <- "Caricion bicoloris atrofuscae"
		
#	order layer
layers(obj)	<- c("hl", "ml")

#	unique rownames
rownames(obj) <- paste0(key, ":Tab", obj$tab, ":", rownames(obj))

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
