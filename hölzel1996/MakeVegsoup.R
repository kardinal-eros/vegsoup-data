require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/hölzel1996"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table
file <- file.path(path, "Hölzel1996Tab7taxon2standard.txt")
x <- read.verbatim(file, colnames = "Aufnahmenummer", verbose = T, layers = "@", vertical = TRUE)
X0 <- species(x)

#	and footer taxa
file <- file.path(path, "Hölzel1996Tab7Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

X <- bind(X0, X1)

#   sites data including coordinates
file <- file.path(path, "Hölzel1996Tab7Locations.csv")
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
a <- a[ match(rownames(obj), rownames(a)), ] 

# give names and assign variables
obj$pls <- 16 # page 13 in publication states areas between 10 and 25 m^2 for grassland and scree

obj$expo <- compass(a$"Exposition")
obj$slope <- a$"Hangneigung..Grad."
obj$elevation <- a$"Meereshöhe..10m."

obj$hcov <- a$"Deckung.der.Krautschicht...."
obj$scov <- a$"Deckung.der.Strauchschicht...."
obj$mcov <- a$"Deckung.der.Moosschicht...."

#	unique rownames
rownames(obj) <- paste(key, "Tab3", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	order layer
layers(obj)	 <- c("hl", "sl")

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

