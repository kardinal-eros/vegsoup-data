library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/lippert1966"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	read digitized table 
file <- file.path(path, "Lippert1966Tab3taxon2standard.txt")
x <- xx <- read.verbatim(file, "Nr. d. Aufnahme", layers = "@", vertical = FALSE)

X0 <- species(x)[, 1:4]

#	and footer taxa
file <- file.path(path, "Lippert1966Tab3Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

X <- bind(X0, X1)


#   sites data including coordinates
file <- "~/Documents/vegsoup-data/lippert1966/Lippert1966Tab3Locations.csv"
Y <- stackSites(file = file, sep =",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")


# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
df.attr <- as.data.frame(attributes(x)[- c(1:3, 10)])
rownames(df.attr) <- colnames(x)
# reorder by plot
df.attr <- df.attr[match(rownames(obj), rownames(df.attr)), ] 

# give names and assign variables
obj$elevation <- df.attr$"Höhe.in.10.m" * 10
obj$expo <- as.character(df.attr$Exposition)
obj$slope <- df.attr$"Neigung.in.Grad"
obj$cov <- obj$hcov <- df.attr$"Bodenbedeckung.in.."
obj$hcov <- obj$hcov <- df.attr$"Bodenbedeckung.in.."
obj$pls <- "Aufnahmefläche.in.qm"

#	unique rownames
rownames(obj) <- paste(key, "Tab3", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

#	assign alliance
obj$alliance.code <- "THL-05C"
obj$alliance <- "Stipion calamagrostis Jenny-Lips ex Br.-Bl. 1950"

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
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
