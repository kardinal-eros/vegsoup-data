library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/Petrik2005"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read digitized table 
file <- file.path(path, "Petrik2005Tab1taxon2standard.txt")
x <- read.verbatim(file, "Releveé number", verbose = T)

#	assign moss layers
l <- rep("hl", nrow(x))
l[c(3,40, 42,43,70,71,74,97:174)] <- "ml"


# promote to class "Species"
x.df <- data.frame(abbr = rownames(x),
			layer = "hl",
			taxon = NA, x,
			check.names = FALSE)
X <- stackSpecies(x.df)[, 1:4]

# groome abundance scale codes to fit the standard
# of the extended Braun-Blanquet scale used in the original publication
X$cov <- gsub("m", "2m", X$cov)
X$cov <- gsub("a", "2a", X$cov)
X$cov <- gsub("b", "2b", X$cov)

#   sites data including coordinates
file <- file.path(path, "Petrik2005Tab1TLocations.csv")
Y <- read.csv2(file, colClasses = "character")
names(Y)[1] <- "plot"
# promote to class "Sites"
Y <- stackSites(Y)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")
#	grome names
names(obj)[1:9] <- c("pls", "expo", "slope", "elevation",
	"hcov", "mcov", "cov", "bedrock", "date")
obj$alliance <- "Oxytropido carpaticae-Elynetum"		

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
