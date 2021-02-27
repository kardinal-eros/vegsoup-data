require(vegsoup)
library(bibtex)

path <- "/Users/roli/Documents/vegsoup-data/zimmermann2019"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	read prepared digitized table
file <- file.path(path, "Zimmermann2019Tab1taxon2standard.txt")
x <- read.verbatim(file, colnames = "Laufende Nr.", layers = "@", vertical = FALSE)
X <- species(x)

#	groome cover codes
X$cov[ X$cov == "m" ] <- "2m"
X$cov[ X$cov == "a" ] <- "2a"
X$cov[ X$cov == "b" ] <- "2b"

sort(unique(X$cov))

#   sites data including coordinates
file <- file.path(path, "Zimmermann2019Tab1 sites wide.csv")
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
a <- header(x)

# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ]
# assign variables
obj$elevation <- a$Seehöhe

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

#	assign alliance
obj$alliance.code <- "FES-01A"
obj$alliance <- "Bromion erecti Koch 1926"

#	order layer
layers(obj)	 <- c("sl", "hl", "ml")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE, select = "richness")

#	tidy up
rm(list = ls()[-grep(key, ls())])
