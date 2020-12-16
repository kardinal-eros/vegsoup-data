library(vegsoup)
require(bibtex)

#	note, there is a minor leading zero issue with this data set

path <- "~/Documents/vegsoup-data/roithinger1996"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	read prepared digitized table 
file <- file.path(path, "Roithinger1996TabAtaxon2standard.txt")
x <- xx <- read.verbatim(file, "Aufnahmenummer", layers = "@")
# promote to class "Species"
X1 <- species(x)

#	and footer taxa
file <- file.path(path, "Roithinger1996TabAFooterSpecies.csv")
X2 <- species(file, sep = ";")[, 1:4]
X2$plot <- sprintf("%03d", as.numeric(X2$plot))
X <- vegsoup::bind(X1, X2)

#   sites data including coordinates
file <- file.path(path, "Roithinger1996TabALocations.csv")
# promote to class "Sites"
Y <- stackSites(file = file, sep = ",")
Y$plot <- sprintf("%03d", as.numeric(Y$plot))

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

layers(obj) <- c("sl", "hl")
# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
a <- as.data.frame(attributes(xx)[- c(1:3, length(attributes(x)))])
rownames(a) <- colnames(x)
# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ] 

# give names and assign variables
obj$elevation <- a$"Meereshöhe.in.m"
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Inklination.in.Grad"
obj$pls <- a$"Größe.der.Aufnahmefläche.in.m2"
obj$cov <- obj$cov <- a$"Gesamtdeckung.in.."
obj$hcov <- obj$hhl <- a$"Höhe.der.Vegetationsdecke.in.cm"
names(obj)[9] <- "scov"
names(obj)[3] <- "hsl"
names(obj)[10] <- "zcov"
names(obj)[4] <- "hzl"
names(obj)[6] <- "mcov"

#	syntaxa assigment missing
obj$alliance <- ""

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")
		
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
