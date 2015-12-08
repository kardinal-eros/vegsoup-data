library(vegsoup)
library(bibtex)

path <- "~/Documents/vegsoup-data/krisai1996"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

source(file.path(path, "MakeVegsoup 7.R"))
source(file.path(path, "MakeVegsoup 8.R"))

obj <- bind(tab7, tab8)

#	order layer
layers(obj)	 <- c("tl", "sl", "hl", "ml")

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

