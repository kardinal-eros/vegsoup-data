library(vegsoup)
library(bibtex)

path <- "~/Documents/vegsoup-data/eckkrammer2003"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key
key <- key[[ 1 ]]


source(file.path(path, "MakeVegsoup 1.R"))
source(file.path(path, "MakeVegsoup 2.R"))
source(file.path(path, "MakeVegsoup 3.R"))

obj <- vegsoup::bind(tab1, tab2, tab3)

#	order layer
layers(obj)	 <- c("sl", "hl", "ml")

#	unique rownames created by scripts MakeVegsoup *.R


#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(bib[[ 1 ]]$author, collapse = ", "), bib[[ 1 ]]$author)
obj$citation <- format(bib[[ 1 ]], style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))

write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
