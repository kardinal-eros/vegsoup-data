library(linktaxa)

xx <- read.csv2("~/Documents/vegsoup-data/sonnberger2009/species wide.csv",
	colClasses = "character")
x <- xx$taxon	
yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	not run:
#	xy <- linktaxa(x, y, order = FALSE)
#	edited results stored as taxon2standard.csv

#	x <- read.csv2("~/Documents/vegsoup-data/sonnberger2009/taxon2standard.csv",
#		colClasses = "character")
#	r <- yy$abbr[match(x$matched.taxon, y)]
#	r saved and pasted into table

