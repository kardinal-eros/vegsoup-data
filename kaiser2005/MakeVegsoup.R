library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/kaiser2005"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ",")[, 1:4]

file <- file.path(path, "sites wide.csv")
#	promote to class "Sites"
Y <- stackSites(file = file, sep = ",", dec = ".")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "pfadenhauer")
coordinates(obj) <- ~x+y
proj4string(obj) <- CRS("+init=epsg:31258")
obj <- spTransform(obj, CRS("+init=epsg:4326"))

#	order layer
layers(obj) <- c("sl", "hl", "ml")

#	unique rownames
rownames(obj) <- paste(key, sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

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
