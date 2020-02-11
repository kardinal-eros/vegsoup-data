library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/ybbs dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species wide fer.csv")
X1 <- stackSpecies(file = file)[, c(1:4)]

#sprintf("%03d", as.numeric(Y$plot))

file <- file.path(path, "species wide leu.csv")
X2 <- stackSpecies(file = file)[, c(1:4)]

file <- file.path(path, "species wide mat.csv")
X3 <- stackSpecies(file = file)[, c(1:4)]

X <- bind(X1, X2, X3)

file <- file.path(path, "sites wide.csv")
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	order layer
layers(obj)	 <- c("tl1", "tl2", "sl", "hl")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	groome observer name
obj$observer <- c("Y. Schneemann")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE, select = "richness")

#	tidy up
rm(list = ls()[-grep(key, ls())])