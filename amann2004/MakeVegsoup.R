require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/amann2004"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read digitized table
file <- file.path(path, "Amann2004Tab2 species wide.csv")
X <- stackSpecies(file = file, sep = ",")

#   sites data including coordinates
file <- file.path(path, "Amann2004Tab2 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab2", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	order layer
layers(obj)	 <- c("hl")

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

