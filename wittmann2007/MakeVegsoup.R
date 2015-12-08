require(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/wittmann2007"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

source(file.path(path, "MakeVegsoup1.R"))
source(file.path(path, "MakeVegsoup2.R"))

#	bind data sets
obj <- bind(tab1, tab2)

#	assign result object
assign(key, obj)

do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))

#	save to disk
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

rm(list = ls()[-grep(key, ls())])