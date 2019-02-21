library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/springer1993"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table
file <- file.path(path, "Springer1993Tab14taxon2standard.txt")
x <- xx <- read.verbatim(file, "Laufende Nummer", layers = "@")

X0 <- species(x)[, 1:4]
X0$plot <- gsub(".", "", X0$plot, fixed = TRUE)

#	and footer taxa
file <- file.path(path, "Springer1993Tab14Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

X <- bind(X0, X1)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/springer1993/Springer1993Tab14Locations.csv"
Y <- stackSites(file = file, sep = ";")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")


# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class

df.attr <- header(x)
rownames(df.attr) <- gsub(".", "", colnames(x), fixed = TRUE)
# reorder by plot
df.attr <- df.attr[match(rownames(obj), rownames(df.attr)), ] 

# give names and assign variables
obj$elevation <- df.attr$"Höhe..in.10.m."* 10
obj$expo <- as.character(df.attr$Exposition)
obj$slope <- df.attr$"Inklination...."
obj$cov <- obj$hcov <- df.attr$"Deckungsgrad...."
obj$pls <- df.attr$"Aufnahmeflache..m."

#	unique rownames
rownames(obj) <- paste(key, "Tab14", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

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
