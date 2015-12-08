library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/medicus2010"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

source("~/Documents/vegsoup-data/medicus2010/MakeVegsoup 1.R")
source("~/Documents/vegsoup-data/medicus2010/MakeVegsoup 2.R")

obj <- bind(tab1, tab2)

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


