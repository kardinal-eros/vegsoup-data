require(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/wittmann2007"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

source(file.path(path, "MakeVegsoup1.R"))
source(file.path(path, "MakeVegsoup2.R"))

#	bind data sets
obj <- bind(tab1, tab2)

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

rm(list = ls()[-grep(key, ls())])