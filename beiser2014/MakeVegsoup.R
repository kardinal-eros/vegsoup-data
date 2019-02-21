require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/beiser2014"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read digitized table
file <- file.path(path, "Beiser2014Tab4 species wide.csv")
X1 <- stackSpecies(file = file, sep = ",")[ , 1:4]

file <- file.path(path, "Beiser2014Tab4Footer species.csv")
X2 <- species(file)
X2$plot <- gsub(" ", "", X2$plot)
X <- bind(X1, X2)

#   sites data including coordinates
file <- file.path(path, "Beiser2014Tab4 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	unique rownames
rownames(obj) <- paste(key, "Tab4", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	order layer
layers(obj)	 <- c("hl")

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

