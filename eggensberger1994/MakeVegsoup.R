require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/eggensberger1994"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	table 10
#	read prepared digitized table
file <- file.path(path, "Eggensberger1994Tab10taxon2standard.txt")
x <- read.verbatim(file, colnames = "Spalte", verbose = T, layers = "@", vertical = FALSE)
X <- species(x)

#   sites data including coordinates
file <- file.path(path, "Eggensberger1994Tab10Locations.csv")
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
obj$pls <- NA
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Inklination...."
obj$elevation <- a$"Höhe..x.10.m."
obj$hcov <- a$"Deckung.....KG"

#	unique rownames
rownames(obj) <- paste(key, "Tab10", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

tab10 <- obj

#	table 11
#	read prepared digitized table
file <- file.path(path, "Eggensberger1994Tab11taxon2standard.txt")
x <- read.verbatim(file, colnames = "Spalte", verbose = T, layers = "@", vertical = FALSE)
#	see line 60 in stack.species
#	X <- species(x)

r <- data.frame(abbr = rownames(x),
		layer = NA,
		taxon = NA, x,
		check.names = FALSE, stringsAsFactors = FALSE)
						
a <- strsplit(as.character(r$abbr), "@")
r$abbr <- sapply(a, "[[", 1)
r$layer <- sapply(a, "[[", 2)

X <- stackSpecies(r, absences = ".")[, 1:4]

#   sites data including coordinates
file <- file.path(path, "Eggensberger1994Tab11Locations.csv")
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
obj$pls <- NA
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Inklination...."
obj$elevation <- a$"Höhe..x.10.m."
obj$hcov <- a$"Deckung.....KG"

#	unique rownames
rownames(obj) <- paste(key, "Tab11", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

tab11 <- obj

#	combine tables
obj <- bind(tab10, tab11)

#	order layer
layers(obj)	 <- c("hl", "ml")

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