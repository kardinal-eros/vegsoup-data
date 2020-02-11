#	this is a build script for all available data sets
#	referencing to https://github.com/kardinal-eros/vegsoup-standards/tree/master/austrian%20standard%20list%202008

library(vegsoup)
library(RefManageR)
library(knitr)
library(rgdal)
library(naturalsort)
library(bibtex)
library(stringr)

rm(list = ls())

path <- "~/Documents/vegsoup-data"
x <- list.files(path)

ii <- c(
#	other files
	"CHANGES.md",
	"README.md",
	"README.png",	
	"mirror",
	"givd",	
#	unfished data sets
	"dirnböck1999",
	"brunner2011",
	"dunzendorfer1980",
	"greimler1996",
	"greimler1997",
	"grims1982",
	"hohewand fence dta",
	"hohewand transect dta",
	"jakubowsky1996",
	"monte negro dta",
	"nußbaumer2000",
	"pflugbeil2012",
	"prebersee dta",
	"ruttner1994",
	"sobotik1998",
	"schwarz1989",
	"stadler1991",
	"stadler1992",
	"surina2004",
	"urban1992",
	"urban2008",
	"urhamerberg dta",
#	occurrence plots only
	"alt ems dta",
	"adnet dta",
	"bräumauer dta",
	"glasenbachklamm dta",
	"graswang dta",
	"illschlucht dta",
	"jansenmäuer dta",
	"kreuzmauer dta",
	"lichtl dta",
	"luegstein dta",
	"montikel dta",
	"priental dta",
	"reitnerkogel dta",
	"schartenmauer dta",
	"schieferstein dta",
	"schrattenboden dta",
	"wirlingwand dta",
	"ybbs and türnitz prealps dta",
	"zwurms meschach dta",	
#	independent taxonomy
	"crete dta",
	"javakheti dta",
	"cape hallet lichen dta",
	"salzkammergut lichen dta",
	"kalkalpen lichen dta",
#	turboveg taxonomy (keep in sync with mirror dev.R)
	"aspro dta",
	"donauauen dta",
	"enzersfeld dta",
	"fischamend dta",	
	"hainburg dta",
	"kirchdorf and steyr-land dta",
	"mountain hay meadows dta",
	"nackter sattel dta",
	"neusiedlersee dta",
	"pilgersdorf dta",
	"ravine forest dta",	
	"reichraming dta",
	"sankt margarethen dta",
	"seekirchen dta",	
	"südburgenland dta",
	"traun and steyr and ennstal dta",
	"vorarlberg dta",
	"wien dta",
	"wienerwald dta",
	"witzelsdorf dta"
)

x <- x[ -match(ii, x) ]

#	run update
#	WARNING, running Make-files will delete *all* objects in the enviroment when leaving.

build = FALSE

if (build) {
	sapply(file.path(path, x, "MakeVegsoup.R"), function (x) {
		cat(x, "\n")
		source(x)
		} )
}

#	biblographic entities	
x <- sapply(file.path(path, x), function (x) {
	read.bib(file.path(x, "references.bib"))	
}, simplify = FALSE)

#	write bibliography
b <- do.call("c", x)

f <- names(x)
k <- sapply(x, function (x) x[[1]]$key)
n <- sapply(x, function (x) x[[1]]$title)
a <- sapply(x, function (x) x[[1]]$author)
a <- sapply(a, function (x) {
	l <- length(x)
	if (l > 1)
		paste(paste(x[1:l - 1], collapse = ", "), x[l], sep = " & ")
	else
		as.character(x)})

#	load objects
for (i in seq_along(f)) {
	load(file.path(f[ i ], paste0(k[ i ], ".rda")))
	ii <- get(k[ i ])
	ii$key = k[ i ]
	ii$author = a[ i ]
	ii$title = n[ i ]
	assign(k[ i ], ii)
}

#	applied coverscales
sapply(sapply(mget(k), coverscale), slot, "name")

#	compress and bind all objects
l <- sapply(mget(k), function (x) compress(x, retain = c("author", "title", "accuracy", "observer")))
X <- do.call("bind", l)

#	summary for README.md
src <- as.data.frame(table(X$author))
names(src) <- c("author", "plots")

rk <- grep("R Kaiser", src$author)
te <- grep("T Eberl", src$author)

rkte <- src[ unique(c(rk, te)), ]
sum(rkte$plots)
lit <- src[ -unique(c(rk, te)), ]
sum(lit$plots)

#	save to disk
save(X, file = file.path(path, "mirror", "mirror.rda"))

#	write ESRI Shapefile
x <- data.frame(coordinates(X), sites(X))
coordinates(x) <- ~x + y
proj4string(x) <- CRS("+init=epsg:4326")
dsn <- file.path(path.expand(path), "mirror")

#	flag literature data
x$published <- "no"
x$published[grep(":", rownames(X), fixed = TRUE)] <- "yes"
table(x$published)

#	write ESRI Shaepfile
writeOGR(x, dsn, "mirror", driver = "ESRI Shapefile", overwrite_layer = TRUE)
