library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/faber1936"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table
file <- file.path(path, "Faber1936Tab2taxon2standard.txt")
X <- read.verbatim(file, colnames = "Aufnahmenummer", layers = "@")
X <- species(X)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/faber1936/Faber1936Tab2Locations.csv"
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab2", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

#	order layer
layers(obj)	 <- c("tl", "sl", "hl", "ml")

#	assign alliance
obj$alliance.code <- "THL-05C"
obj$alliance <- "Stipion calamagrostis Jenny-Lips ex Br.-Bl. 1950"

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
