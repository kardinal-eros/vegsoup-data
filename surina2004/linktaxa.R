library(linktaxa)

#	match taxa
file <- "~/Documents/vegsoup-data/surina2004/Surina2004Tab1.txt"
con <- file(file)
x <- readLines(con)
close(con)

yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	NOT RUN:
#	x <- sapply(x, function (x) substring(x, 1, 33), USE.NAMES = FALSE)
#	x <- x[31:(length(x) -1)]
#	x <- str_trim(x)
#	x[x == ""] <- "blank"

#	xy <- linktaxa(x, y, order = FALSE)
#	edited results stored as taxon2standard.csv
#	write.csv2(xy, "~/Documents/vegsoup-data/surina2004/taxon2standard.csv")
#
#	x <- read.csv2("~/Documents/vegsoup-data/surina2004/taxon2standard.csv",
#		colClasses = "character")
#	a <- yy$abbr[match(x$matched.taxon, y)]
#	x$abbr <- a
#	saved to file
#	write.csv2(x, "~/Documents/vegsoup-data/surina2004/taxon2standard.csv",
#	row.names = FALSE)
