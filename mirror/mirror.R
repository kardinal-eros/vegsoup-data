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

#	files to ignore
ii <- c(
#	other files
	"CHANGES.md",
	"README.md",
	"README.png",	
	"mirror",
	"givd",	# to be deleted
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
	"stadler1991", # to be deleted
	"stadler1992", # to be deleted
	"surina2004",
#	occurrence plots only
	"alt ems dta",
	"adnet dta",
	"bräumauer dta",
	"glasenbachklamm dta",
	"graswang dta",
	"illschlucht dta",
	"jansenmäuer dta",
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
	"ybbs and türnitz prealps dta",
	"zwurms meschach dta",	
#	independent taxonomy
	"crete dta",
	"javakheti dta",
	"cape hallet lichen dta",
	"salzkammergut lichen dta",
	"kalkalpen lichen dta",
#	custom coverscale and taxonomy
	"furka dta",		
#	turboveg taxonomy (keep in sync with *mirror turboveg.R*)
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
	"südburgenland dta",
	"traun and steyr and ennstal dta",
	"vorarlberg dta",
	"wien dta",
	"wienerwald dta",
	"witzelsdorf dta"
)

#	test project exclusion list
stopifnot(all(ii %in% x))

x <- x[ -match(ii, x) ]

#	run build update?
build = FALSE

#	WARNING, running a Make-file will
#	delete *all* objects in the enviroment when leaving.
if (build) {	
	sapply(file.path(path, x, "MakeVegsoup.R"), function (x) {
		cat(x, "\n")
		source(x)
		} )
}

#	pre load and process biblographic entities	
x <- sapply(file.path(path, x), function (x) {
	read.bib(file.path(x, "references.bib"))	
}, simplify = FALSE)
b <- do.call("c", x)

f <- names(x)
k <- sapply(x, function (x) x[[ 1 ]]$key)
p <- sapply(x, function (x) x[[ 1 ]]$bibtype)
n <- sapply(x, function (x) x[[ 1 ]]$title)
m <- sapply(x, function (x) x[[ 1 ]]$note)
n[ p == "Unpublished" ] <- paste(n[ p == "Unpublished"], m[ p == "Unpublished"], sep = ". ")
a <- sapply(x, function (x) x[[ 1 ]]$author)
a <- sapply(a, function (x) {
	l <- length(x)
	if (l > 1) {
		paste(paste(x[ 1:l - 1 ], collapse = ", "), x[ l ], sep = " & ")
	} else {
		as.character(x)
	}	
	} )



#	load objects and add bibliographic references
for (i in seq_along(f)) {
	load(file.path(f[ i ], paste0(k[ i ], ".rda")))
	ii <- get(k[ i ])
	ii$key = k[ i ]
	ii$author = a[ i ]
	ii$title = n[ i ]
	ii$bibtype <- p[ i ]
	assign(k[ i ], ii)
}

#	applied coverscales
sapply(sapply(mget(k), coverscale), slot, "name")

#	compress and bind all objects
l <- sapply(mget(k), function (x) compress(x,
	retain = c("date", "observer", "location",
		"accuracy", "remarks", "author", "title", "bibtype")))

sapply(l, names, simplify = FALSE)
which(sapply(sapply(l, names, simplify = FALSE), length) != 7)


X <- do.call("bind", l)

#	key
X$id <- row.names(X)

sites(X) <- sites(X)[ , names(X) != "compress" ]

#	richness
X$richness <- richness(X, "sample")

#	format date
X$date <- as.Date(X$date)

test <- any(is.na(X$date))

if (test) {
	message("some dates are missing")
}

#	extract year
X$year <- as.integer(sapply(str_split(X$date, "-"), head, 1))

#	groome remarks to caintain.only date related comment
X$remarks <- as.character(X$remarks)
X$remarks[ -grep("date", X$remarks) ] <- NA

#	flag literature data
X$published <- TRUE
X$published[ X$bibtype == "Unpublished"] <- FALSE
X$published[ X$bibtype == "TechReport"] <- FALSE
table(X$published)

#	save R image file
save(X, file = file.path(path, "mirror", "mirror.rda"))

#	save ESRI Shapefile
x <- data.frame(coordinates(X), sites(X))
coordinates(x) <- ~x + y
proj4string(x) <- CRS("+init=epsg:4326")
dsn <- file.path(path.expand(path), "mirror")
writeOGR(x, dsn, "mirror", driver = "ESRI Shapefile",
	layer_options = "ENCODING=UTF-8", overwrite_layer = TRUE)

#	summary to be included in README.md
src <- as.data.frame(table(X$author))
names(src) <- c("author", "plots")

rk <- grep("R Kaiser", src$author)
te <- grep("T Eberl", src$author)

rkte <- src[ unique(c(rk, te)), ]
sum(rkte$plots)

sum(rkte$plots)
lit <- src[ -unique(c(rk, te)), ]
sum(lit$plots)

plot(X)

y <- X$year[ !X$published ]
hist(y, main = "", xlab = "Year",
	breaks = seq(min(y), max(y), by = 1))
