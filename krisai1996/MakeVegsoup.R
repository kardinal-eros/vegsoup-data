library(vegsoup)
library(bibtex)

path <- "~/Documents/vegsoup-data/krisai1996"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

source(file.path(path, "MakeVegsoup 7.R"))
source(file.path(path, "MakeVegsoup 8.R"))

obj <- vegsoup::bind(tab7, tab8)

#	order layer
layers(obj)	 <- c("tl", "sl", "hl", "ml")

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

