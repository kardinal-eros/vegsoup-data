library(linktaxa)
library(stringr)

#	read data
path <- "/Users/roli/Documents/vegsoup-data/chytry1997"
file <- file.path(path, "Chytry1997.csv")

x <- read.csv2(file, stringsAsFactors = FALSE)
j <- ncol(x)
x <- x[, -c((j - 1), j)]
i <- max(which(x[, 1] == ""))
x <- x[(i + 1):nrow(x), 1]

#	taxonomic reference
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
yy <- read.csv2(file, colClasses = "character")
y <- yy$taxon

#	NOT RUN:
if (FALSE) {
	x <- str_trim(x)
	x[x == ""] <- NA

	xy <- linktaxa(x, y, order = FALSE)
#	must manually edit results
	write.csv2(xy, file.path(path, "translate.csv"), row.names = FALSE)
#	backup
	sh <- paste0("tar -zcvf",
		paste0(" \"", file.path(path, "translate.tar.gz"), "\""),
		paste0(" --directory=\"", path, "\"", " translate.csv"))
	system(sh)
#	read and join abbr
	x <- read.csv2(file.path(path, "translate.csv"),
		colClasses = "character")
	x$abbr <- yy$abbr[match(x$matched.taxon, y)]
	nas <- is.na(x$abbr)
	if (any(nas)) {
		x[nas, ]
		stop()	
	}
#	overwrite file
	write.csv2(x, file.path(path, "translate.csv"),	row.names = FALSE, quote = FALSE)
}

#	tidy up
rm(list = ls())

