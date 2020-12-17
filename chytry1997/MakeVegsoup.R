require(vegsoup)
require(naturalsort)
require(bibtex)
require(stringr)

path <- "~/Documents/vegsoup-data/chytry1997"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

#	taxon translation
file <- file.path(path, "translate.csv")
A <- read.csv2(file, stringsAsFactors = FALSE)

#	species
file <- file.path(path, "Chytry1997.csv")
x <- read.csv2(file, stringsAsFactors = FALSE)
j <- ncol(x)
x <- x[, -c((j - 1), j)]

#	begin of taxa block
i <- max(which(x[, 1] == ""))

#	get taxa block
X <- x[(i + 1):nrow(x), ]
names(X)[ 1:2 ] <- c("taxon", "layer")

#	relevee names
p1 <- str_trim(unlist( x[grep("No. table in publ.", x[, 1]), -(1:2)] ))
p2 <- str_trim(unlist( x[grep("No. releve in table", x[, 1]), -(1:2)] ))
if (any(p2 == "")) p2[p2 == ""] <- 1
p <- paste(paste0("Tab", p1), p2, sep = ":")
stopifnot(!any(duplicated(p)))
names(X)[ -(1:2) ] <- p

#	join taxa translation with abbreviations
stopifnot(identical(X$taxon, A$taxon))
X <- cbind(A, X[, -1])

#	build object of class "Species"
X <- stackSpecies(x = X, schema = c("abbr", "layer", "taxon"))[, 1:4]

#	sites
Y <- t(x[1:i, -2])
colnames(Y) <- Y[1, ]
Y <- Y[-1, ]
Y <- as.data.frame(Y, stringsAsFactors = FALSE)
Y$plot <- p

#	build object of class "Sites"
Y <- stackSites(x = Y)

#	build object of class "SpeciesTaxonomy", tests matching to reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

#	build vegsoup object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	assign coordinates
xy <- sites(obj)[c("Longitude", "Latitude")]

#	function convert data (DDMMSS.SS) into decimal degrees
string2dd <- function (x) {
	y <- as.character(x[2]); x <- as.character(x[1])
	lx <- nchar(x); ly <- nchar(y)	
	#	longitude
	d <- substring(x, 1, lx - 4)
	m <- substring(x, lx - 3, lx - 2)
	s <- substring(x, lx - 1, lx)
	x <- as.numeric(char2dms(paste0(d, "d", m, "'", s, "\"")))
	#	latitude
	d <- substring(y, 1, ly - 4)
	m <- substring(y, ly - 3, ly - 2)
	s <- substring(y, ly - 1, ly)
	dms <- paste0(d, "d", m, "'", s, "\"")
	y <- as.numeric(char2dms(dms))	
	r <- c(x,y)
	return(r)	
}

xy <- t(apply(xy, 1, string2dd))

obj$Longitude <- xy[, 1]
obj$Latitude <- xy[, 2]
coordinates(obj) <- ~Longitude+Latitude
proj4string(obj) <- CRS("+init=epsg:4326")

obj$accuracy <- 20 # rough guess

obj$observer <- "M. Chytrý, & J. Sádlo"
obj$date <- as.character(strftime(paste0(obj$Year,"-", obj$Month, "-", obj$Day), format = "%Y-%m-%d"))
names(obj)[ names(obj) == "Locality"] <- "location"

#	assign rownames and groome data structure
rownames(obj) <- paste(key, rownames(obj), sep = ":")

obj <- layers(obj, collapse = c("hl", "t1", "hl", "s1", "ml"))
obj <- layers(obj, collapse = c("hl", "tl", "sl", "ml"))
layers(obj) <- c("tl", "sl", "hl", "ml")

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

rm(list = ls()[-grep(key, ls())])

#	table in Chytrý & Sádlo
if (FALSE) {
	obj <- Chytry1997
	
	#	Chytrý & Vicherek 1996, tab 16: 5-9
	load("~/Documents/vegsoup-data/chytry1996/Chytry1996.rda")
	Chytry1996 <- Chytry1996[grep("Chytry1996:Tab16", rownames(Chytry1996)), ]
	Chytry1996 <- Chytry1996[match(paste("Chytry1996:Tab16", 5:9, sep = ":"), rownames(Chytry1996)), ]
	
	#	Chytrý & Vicherek 1995, tab. 8: 2-4, 6
	load("~/Documents/vegsoup-data/chytry1995/Chytry1995.rda")
	Chytry1995 <- Chytry1995[grep("Chytry1995:Tab8", rownames(Chytry1995)), ]
	Chytry1995 <- Chytry1995[match(paste("Chytry1995:Tab8", c(2:4, 6), sep = ":"), rownames(Chytry1995)), ]
	
	#	bind data sets
	obj <- vegsoup::bind(obj, Chytry1995, Chytry1996)
	layers(obj) <- c("tl", "sl", "hl", "ml")
	
	#	assign syntaxa
	obj$alliance <- "Tilio-Acerion"
	obj$association <- "Seslerio albicantis-Tilietum cordatae"
	obj$subassociation <- ""
	
	#	20.	Klika 1942, tab. 1, rel. 20 is missing
	obj$subassociation[1:19] <- "Seslerio albicantis-Tilietum cordatae -campanuletosa rapunculoides"
	obj$subassociation[20:30] <- "Seslerio albicantis-Tilietum cordatae -euphorbietosum cyparissiae"
}