library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/Petrik2005"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	read digitized table 
file <- file.path(path, "Petrik2005Tab1taxon2standard.txt")
x <- read.verbatim(file, "Relevee number")

#	assign moss layers
l <- rep("hl", nrow(x))
l [c(3,40, 42,43,70,71,74,97:174) ] <- "ml"

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
Y <- read.csv(file, colClasses = "character")
names(Y)[1] <- "plot"
# promote to class "Sites"
Y <- stackSites(file = file, sep = ",", schema = "Releve nr.")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")
#	grome names
names(obj) <-  c("accuracy", "elevation", "pls", "expo", "mcov", "hcov", "cov", "date", "geology", "location", "observer", "slope")

obj$alliance <- "Oxytropido carpaticae-Elynetum"		

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE, select = "richness")

#	tidy up
rm(list = ls()[-grep(key, ls())])
