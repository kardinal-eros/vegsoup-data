library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/springer1990"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read digitized table 
file <- file.path(path, "Springer1990Tab5taxon2standard.txt")
x <- xx <- read.verbatim(file, "Releveé number", layers = "@")

X <- species(x)[, 1:4]

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/springer1990/Springer1990Tab5Locations.csv"
Y <- stackSites(file = file)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")


# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
df.attr <- as.data.frame(attributes(x)[- c(1:3, 8)])
rownames(df.attr) <- colnames(x)
# reorder by plot
df.attr <- df.attr[match(rownames(obj), rownames(df.attr)), ] 

# give names and assign variables
obj$elevation <- df.attr$"Höhe"
obj$expo <- as.character(df.attr$Exposition)
obj$slope <- df.attr$"Inklination"
obj$cov <- obj$hcov <- df.attr$"Deckungsgrad.."
obj$hcov <- obj$hcov <- df.attr$"Deckungsgrad.."

obj$association <- "Juncus trifidus-Primula minima-Gesellschaft"
obj$alliance <- "Oxytropido-Elynion"

#	order layer
layers(obj)	 <- c("hl", "ml")

#	unique rownames
rownames(obj) <- paste(key, "Tab5", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

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
