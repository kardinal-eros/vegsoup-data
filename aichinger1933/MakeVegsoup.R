library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/aichinger1933"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	read prepared digitized table
file <- file.path(path, "Aichinger1933Tab4taxon2standard.txt")
x <- read.verbatim(file, "Nr. der Aufnahme", layers = "@", vertical = FALSE)

X0 <- species(x)[, 1:4]

#	and footer taxa
file <- file.path(path, "Aichinger1933Tab4Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

X <- vegsoup::bind(X0, X1)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/aichinger1933/Aichinger1933Tab4Locations.csv"
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	assign header data
obj$pls <- header(x)$"Größe.der.Aufnahmefläche.in.qm."
obj$elevation <- header(x)$"Seehöhe..Meter.ü..Meer"
obj$expo <- header(x)$Himmelslage
obj$slope <- header(x)$"Neigung.in.Graden"
obj$cov <- header(x)$"Deckungsgrad.in.."

#	unique rownames
rownames(obj) <- paste(key, "Tab4", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

#	assign allianceTHL-04A

obj$alliance.code <- "THL-04A"
obj$alliance <- "Petasition paradoxi Zollitsch ex Lippert 1966"

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
