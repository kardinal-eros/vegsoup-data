library(vegsoup)
require(bibtex)

#	note, minor issue with plot names from read.verabtim
path <- "~/Documents/vegsoup-data/strauch1992"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	main table
file <- file.path(path, "Strauch1992Tab2.txt")
x <- xx <- read.verbatim(file = file, colnames = "Aufnahme Nr.", layers = "a")

#	additional species
file <- file.path(path, "Strauch1992Tab2FooterSpecies.txt")
x <- read.verbatim.append(x, file, "plots")

X <- species(x)[, 1:4]
X$plot <- gsub(".", "", X$plot, fixed = TRUE)

#	sites
Y <- read.delim("~/Documents/vegsoup-data/strauch1992/Strauch1992Tab2Locations.txt",
	header = FALSE, colClasses = "character")
names(Y) <- c("plot", "location", "tms", "date", "remarks", "observer")

Y <- data.frame(Y, t(sapply(Y[,3], str2latlng, USE.NAMES = FALSE)))
names(Y)[grep("precision", names(Y))] <- "accuracy"
Y <- stackSites(Y[, -grep("tms", names(Y))])

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, class and plot id

ii <- c("Ausbildungen", "Aufnahme Nr.", "Deck. BS", "Deck. SS", "Deck. KS")
a <- as.data.frame(attributes(xx)[ii])
rownames(a) <- a$Aufnahme.Nr
# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ]
#	identical(rownames(strauch1992), rownames(df.attr))
# give names and assign
obj$block <- as.character(a$"Ausbildungen")
obj$tcov <- a$"Deck..BS"
obj$scov <- a$"Deck..SS"
obj$hcov <- a$"Deck..KS"
obj$alliance <- "Carpinion betuli"
obj$association <- "Stellario-Carpinetum Oberd. 1957"

#	order layres
layers(obj) <- c("tl", "sl", "hl")

#	unique rownames
rownames(obj) <- paste(key, "Tab2", rownames(obj), sep = ":")

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


