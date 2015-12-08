library(vegsoup)
require(bibtex)

#	note, minor issues for plot names in read.verbatim
path <- "~/Documents/vegsoup-data/pils1994"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table 
file <- file.path(path, "Pils1994Tab8taxon2standard.txt")
x <- read.verbatim(file, "Aufnahmenummer", verbose = T, layers = "@")
X0 <- species(x)[, 1:4]
X0$plot <- gsub(".", "", X0$plot, fixed = TRUE)

#	and footer taxa
file <- file.path(path, "Pils1994Tab8FooterSpecies.csv")
X1 <- read.csv2(file, colClasses = "character")
X1 <- X1[, -grep("taxon", names(X1))]
X1 <- species(X1)
X <- bind(X0, X1)

#   sites data including coordinates
file <- file.path(path, "Pils1994Tab8Locations.csv")
Y <- read.csv2(file, colClasses = "character")
names(Y)[1] <- "plot"
# promote to class "Sites"
Y <- stackSites(Y)

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
obj$elevation <- a$"Seehöhe.in.10.m" * 10
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Neigung.in.Grad"
obj$pls <- a$"Aufnahmefläche.in.10.qm" * 10
obj$cov <- obj$cov <- a$"Deckung.in.."

#	unique rownames
rownames(obj) <- paste(key, "Tab8", rownames(obj), sep = ":")

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
