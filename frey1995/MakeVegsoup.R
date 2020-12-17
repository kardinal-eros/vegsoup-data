library(vegit)
library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/frey1995"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key
key <- bib$key

#	authored translate lists
#	note, we have to translate abbreviations to other abbreviations first!
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
z <- read.csv2(file)
z1 <- read.csv(file.path(path, "translate.csv"), colClasses = "character")
z2 <- read.csv(file.path(path, "translate2.csv"), colClasses = "character")
zz <- rbind(z1, z2)
zz <- zz[ !is.na(zz$matched.abbr), ]
zz[,1] <- gsub(" ", ".", zz[,1])
zz[,2] <- gsub(" ", ".", zz[,2])
names(zz) <- c("taxon", "abbr")

#	main table
x <- file.path(path, "Frey1995Tab4.txt")
X <- read.verbatim(x, layers = "@", colnames = "RELEVE NO.")
X1 <- species(X)
X1$plot <- gsub(".", "", X1$plot, fixed = TRUE)

Y <- stackSites(header(X), schema = "rownames")
Y$plot <- gsub(".", "", Y$plot, fixed = TRUE)

#	footer species
x <- file.path(path, "Frey1995Tab4FooterSpecies.csv")
X2 <- species(x, sep = ",")
X2$plot <- gsub(" ", "", X2$plot, fixed = TRUE)

X <- vegsoup::bind(X1, X2)
X$abbr <- tolower(X$abbr)

#	translate taxon names
species(X) <- zz

#	groome abundance scale codes
X$cov[ X$cov == "R" ] <- "r"

#	build Vegsoup object
obj <- Vegsoup(X, Y, z, "braun.blanquet2")

#	groome rownames
rownames(obj) <- gsub(".", "", rownames(obj), fixed = TRUE)

#	join available coordiantes in EPSG:21781
x <- file.path(path, "Frey1995Appendix1.csv")
y <- read.csv(x)

#	assign coordinates of village Flums as center of study area (cp. page 12)
obj$x <- 744400 
obj$y <- 217600
obj$location <- "Switzerland"

#	assign available coordinates and additional variables	
i <- match(rownames(obj), y$plot)
y <- y[ i[ !is.na(i) ], ]
i <- match(y$plot, rownames(obj))
obj$x[ i ] <- y$x
obj$y[ i ] <- y$y
obj$accuracy <- 10000
obj$accuracy[ i ] <- 50 # rough guess
obj$date[ i ] <- y$date
obj$observer[ i ] <- y$observer
obj$remarks[ i ] <- y$remarks

coordinates(obj) <- ~x+y
proj4string(obj) <- CRS("+init=epsg:21781")
obj <- spTransform(obj, CRS("+init=epsg:4326"))
coordinates(obj)



#	order layer
layers(obj)	 <- c("tl", "sl", "hl", "ml")

#	unique rownames
rownames(obj) <- paste(key, rownames(obj), sep = ":")

#	groome names
names(obj)[ 1:5 ] <- c("expo", "slope", "elevation", "group", "number")

#	expand association labels
obj$association <- factor(obj$group,
	labels = c(
		"Ulmo-Aceretum typicum",
		"Ulmo-Aceretum mercurialietosum",
		"Ulmo-Aceretum calamagrostietosum",
		"Ulmo-Aceretum calamagrostietosum asperuletostum taurinae",
		"Sorbo-Aceretum",
		"Phyllitido-Aceretum typicum",
		"Phyllitido-Aceretum allietosum",
		"Corydalido-Aceretum",
		"Arunco Aceretum adoxetosum",
		"Asplerulo taurinae Tilietum aegopodietosum",
		"Asplerulo taurinae Tilietum typicum",
		"Asplerulo taurinae Tilietum tametosum",
		"Teucrio-Quercetum tilietosum",
		"Teucrio-Quercetum typicum",
		"Luzulo niveae-Quercetum"))

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
