library(vegsoup)
library(RefManageR)
library(knitr)
	
path <- "~/Documents/vegsoup-data"

x <- list.files(path)

ii <- c(
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
	"vorarlberg dta",
	"wien dta",
	"wienerwald dta",
	"witzelsdorf dta")

x <- x[match(ii, x)]

#	update
sapply(file.path(path, x, "MakeVegsoup.R"), function (x) { cat(x, "\n"); source(x) } )

#	biblographic entities	
x <- sapply(file.path(path, x), function (x) {
	ReadBib(file.path(x, "references.bib"))	
}, simplify = FALSE)

f <- names(x)
ff <- sapply(f, list.files, pattern = "rda", USE.NAMES = FALSE)
#	we miss a citation for a projects having more than one refernce (length(key) > 1)
k <- gsub(".rda", "", ff)

for (i in seq_along(f)) {
	load(file.path(f[i], ff[i]))
	ii <- get(k[i])
	ii$key = k[i]
	assign(k[i], ii)
}

#	applied coverscales
sapply(sapply(mget(k), coverscale), slot, "name")

#	find a common set of sites variables
j <- unique(unlist(sapply(mget(k), names)))

#	compress and bind all objects
l <- sapply(mget(k), function (x) compress(x)) # retain = c("author", "title", "accuracy", "observer")
X <- do.call("bind", l)

#	save to disk
save(X, file = file.path(path, "mirror", "mirror dev.rda"))

#	write ESRI Shapefile
x <- data.frame(coordinates(X), sites(X))
coordinates(x) <- ~longitude + latitude
proj4string(x) <- CRS("+init=epsg:4326")
dsn <- file.path(path.expand(path), "mirror")
writeOGR(x, dsn, "mirror dev", driver = "ESRI Shapefile", overwrite_layer = TRUE)
