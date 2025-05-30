library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/dullnig1989"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	 ... and read authored translate list
zz <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")
zz <- join(zz, Z)

#	interpreted classification
alliance <- c("Cratoneurion",
	"Cardamino-Montio",
	"Cardamino-Montio",
	"Caricion fuscae")

association <- c("Cratoneuretum falcati Gams 1927",
	"Montio-Bryetum schleicheri Br.-Bl. 1925",
	"Dicranella palustris-Philontis seriata prov. Dullnig 1989",
	"Caricetum goodenowii Braun 1915")

#	make function for tables 1:4
make <- function (tab = 1) {
	file <- file.path(path, paste0("Dullnig1989Tab", tab, ".txt"))
	x <- read.verbatim(file, colnames = "Aufnahmenummer", layers = "@", vertical = FALSE)
	x1 <- species(x)
	
	file <- file.path(path, paste0("Dullnig1989Tab", tab, "FooterSpecies.txt"))
	x2 <- castFooter(file, abundance.first = FALSE, layers = "@")
	#x2 <- species(x2)
	
	X <- vegsoup::bind(x1, x2)
	X$cov[ X$cov == "R" ] <- "r"
	species(X) <- zz
	
	y1 <- header(x)[, -1]
	
	names(y1) <- c("pls", "expo", "slope", "pH", "dH", "hcov", "richness.hl", "mcov", "richness.ml")
	y1 <- cbind(plot = as.character(rownames(y1)), y1)
	y1$pH <- y1$pH / 10
	y1 <- stackSites(x = y1, zeros = FALSE)
	
	file <- file.path(path, paste0("Dullnig1989Tab", tab, "Locations.csv"))
	y2 <- stackSites(file = file, sep = ",", zeros = FALSE)
	Y <- vegsoup::bind(y1, y2)
	
	obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet2")
		
	obj$tab <- tab
	obj$alliance <- alliance[tab]
	obj$association <- association[tab]
	return(obj)
}

obj <- sapply(1:4, make)
obj <- do.call("bind", obj)

p <- vect("~/Documents/vegsoup-data/dullnig1989/Dullnig1989.shp")
p <- p[match(p$PLOT, rownames(obj)), ]
obj$longitude <- geom(p, df = TRUE)$x
obj$latitude <- geom(p, df = TRUE)$y
obj$accuracy <- p$ACCURACY

coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

#	order layer
layers(obj)	<- c("hl", "ml")

#	unique rownames
rownames(obj) <- paste0(key, ":Tab", obj$tab, ":", rownames(obj))

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
