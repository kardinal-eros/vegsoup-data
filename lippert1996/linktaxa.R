library(linktaxa)
library(stringr)

#	match taxa
file <- "~/Documents/vegsoup-data/springer1990/Springer1990Tab5.txt"
con <- file(file)
x <- readLines(con)
close(con)

yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	NOT RUN:
if (FALSE) {
	x <- sapply(x, function (x) substring(x, 1, 30), USE.NAMES = FALSE)
	x <- x[15:(length(x) -1)]
	x <- str_trim(x)
	x[x == ""] <- "NA"

	xy <- linktaxa(x, y, order = FALSE)
#	edited results stored as taxon2standard.csv
	write.csv2(xy, "~/Documents/vegsoup-data/springer1990/taxon2standard.csv")
#	read an join abbr
	x <- read.csv2("~/Documents/vegsoup-data/springer1990/taxon2standard.csv",
		colClasses = "character")
	a <- yy$abbr[match(x$matched.taxon, y)]
	x$abbr <- a
#	saved to file
	write.csv2(x, "~/Documents/vegsoup-data/surina2004/taxon2standard.csv",
	row.names = FALSE)
}