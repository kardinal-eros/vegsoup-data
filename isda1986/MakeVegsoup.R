#	outdated make script!

library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/isda1986"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- "~/Documents/vegsoup-data/isda1986/Isda1986Tab1.txt"
x <- read.verbatim(file, "Aufnahmenummer")

file <- "~/Documents/vegsoup-data/isda1986/Isda1986Tab1TableFooter.txt"
x <- read.verbatim.append(x, file, "plots", abundance = TRUE)
x.df <- data.frame(abbr = rownames(x), layer = "hl", taxon = NA, x,
	check.names = FALSE)
X <- stackSpecies(x.df)[, 1:4]

Y <- read.delim("~/Documents/vegsoup-data/isda1986/Isda1986Tab1Locations.txt",
	header = FALSE, colClasses = "character")
names(Y) <- c("plot", "location.short", "location", "tms", "observer", "date", "remarks")
#	Y$plot <- type.convert(Y$plot)

Y <- data.frame(Y, t(sapply(Y[,4], str2latlng, USE.NAMES = FALSE)))
names(Y)[grep("precision", names(Y))] <- "accuracy"
Y <- stackSites(Y, zeros = FALSE)
Y
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, class and plot id

a <- as.data.frame(attributes(x)[-c(1:3)])
rownames(a) <- colnames(x)
# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ]
# give names and assign
obj$block <- a$"block"
obj$ph <- as.character(a$"pH..10..1.")
obj$ph[obj$ph == ".."] <- 0
obj$ph <- as.numeric(obj$ph) /10
obj$expo <- toupper(gsub("[[:punct:]]", "", as.character(a$Exposition)))
obj$slope <- a$Hangneigung
obj$elevation <- a$"Seehöhe...100." * 100
obj$block <- a$Block
obj$altitude <- a$Seehöhe

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%03d", as.numeric(rownames(obj))), sep = ":")

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
