library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/greimler1997"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	reference list
Z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	 ... and read authored translate list
zz <- read.csv(file.path(path, "translate.csv"),
	colClasses = "character")
zz <- join(zz, Z)

#	make function for tables 1:4
make <- function (tab = 16) {
	file <- file.path(path, paste0("Greimler1997Tab", tab, ".txt"))
	x <- read.verbatim(file, colnames = "Aufn.Nr.", layers = "@", vertical = FALSE)
	x1 <- species(x)
	
	file <- file.path(path, paste0("Greimler1997Tab", tab, "FooterSpecies.txt"))
	x2 <- castFooter(file, first = FALSE, layers = "@")
	x2 <- species(x2)
	
	X <- bind(x1, x2)
	species(X) <- zz
	
	y1 <- header(x)
	names(y1) <- c("elevation", "slope", "expo", "pls", "hcov", "mcov")
	y1$elevation <- y1$elevation * 10
	y1 <- cbind(plot = as.character(rownames(y1)), y1)	
	y1 <- stackSites(x = y1, zeros = TRUE)
	
	file <- file.path(path, paste0("Greimler1997Tab", tab, "Locations.csv"))
	y2 <- stackSites(file = file, sep = ",", zeros = TRUE)
	Y <- bind(y1, y2)
	
	obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet2")
		
	obj$tab <- tab
	return(obj)
}

obj <- sapply(c(15,16,27), make)
obj <- do.call("bind", obj)

#p <- readOGR("/Users/roli/Documents/vegsoup-data/greimler1997Tab", "Greimler1997Tab",
#	stringsAsFactors = FALSE)
#p <- p[match(p$PLOT, rownames(obj)), ]
#obj$longitude <- coordinates(p)[, 1]
#obj$latitude <- coordinates(p)[, 2]
#obj$accuracy <- p$ACCURACY

#coordinates(obj) <- ~longitude+latitude
#proj4string(obj) <- CRS("+init=epsg:4326")

#	order layer
layers(obj)	<- c("hl", "ml")

#	unique rownames
rownames(obj) <- paste0(key, ":Tab", obj$tab, ":", rownames(obj))

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
