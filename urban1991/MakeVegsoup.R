require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/urban1991"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table
file <- file.path(path, "Urban1991Tab3taxon2standard.txt")
x <- read.verbatim(file, colnames = "Spaltennummer", verbose = T, layers = "@", vertical = FALSE)
X0 <- species(x)

#	and footer taxa
file <- file.path(path, "Urban1991Tab3Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

X <- bind(X0, X1)

#   sites data including coordinates
file <- file.path(path, "Urban1991Tab3Locations.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
a <- header(x)

# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ] 

# give names and assign variables
obj$pls <- a$"Fläche..m2."
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Inklination...."
obj$elevation <- a$"Höhe..m...x10."

obj$hhl2 <- a$"KG.Höhe..cm." / 100
obj$hcov <- a$"Deckung.KG...."
obj$mcov <- a$"MP"

#	unique rownames
rownames(obj) <- paste(key, "Tab3", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	assign alliance
obj$alliance.code <- "THL-05C"
obj$alliance <- "Stipion calamagrostis Jenny-Lips ex Br.-Bl. 1950"

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

