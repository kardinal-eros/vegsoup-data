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
#	turboveg taxonomy (keep in sync with mirror.R)
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

x <- x[ match(ii, x) ]

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


f <- names(x)

ff <- sapply(f, list.files, pattern = "rda", USE.NAMES = FALSE)

#	we miss a citation for projects having more than one refernce (length(key) > 1)
k <- gsub(".rda", "", ff)

for (i in seq_along(f)) {
	load(file.path(f[ i ], ff[ i ]))
	ii <- get(k[ i ])
	ii$key = k[ i ]
	assign(k[ i ], ii)
}

#	applied coverscales
sapply(sapply(mget(k), coverscale), slot, "name")


#	find a common set of sites variables
j <- unique(unlist(sapply(mget(k), names)))

#	compress and bind all objects
l <- sapply(mget(k), function (x) compress(x, retain = c("author"))) # retain = c("author", "title", "accuracy", "observer")
X <- do.call("bind", l)

#	save to disk
save(X, file = file.path(path, "mirror", "mirror turboveg.rda"))

#	write ESRI Shapefile
x <- data.frame(coordinates(X), sites(X))
coordinates(x) <- ~longitude + latitude
proj4string(x) <- CRS("+init=epsg:4326")
dsn <- file.path(path.expand(path), "mirror")
writeOGR(x, dsn, "mirror turboveg", driver = "ESRI Shapefile", overwrite_layer = TRUE)
