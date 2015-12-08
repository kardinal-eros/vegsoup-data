library(linktaxa)
library(stringr)

#	match taxa
file <- "~/Documents/vegsoup-data/petrik2005/Petrik2005Tab1.txt"
con <- file(file)
x <- readLines(con)
close(con)

yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	NOT RUN:
if (FALSE) {
#	build taxon join table 	
	x <- sapply(x, function (x) substring(x, 1, 30), USE.NAMES = FALSE)
	x <- x[15:(length(x) -1)]
	x <- str_trim(x)
	x[x == ""] <- "BLANK"

	xy <- linktaxa(x, y, order = FALSE)
#	edited results stored as taxon2standard.csv
	write.csv2(xy, "~/Documents/vegsoup-data/petrik2005/taxon2standard.csv")
#	read an join abbr
	x <- read.csv2("~/Documents/vegsoup-data/petrik2005/taxon2standard.csv",
		colClasses = "character")
	a <- yy$abbr[match(x$matched.taxon, y)]
	x$abbr <- a
#	saved to file
	write.csv2(x, "~/Documents/vegsoup-data/petrik2005/taxon2standard.csv",
	row.names = FALSE)
}

#	NOT RUN:
if (FALSE) {
	#	assign taxon abbreviations
	file <- "~/Documents/vegsoup-data/Petrik2005/Petrik2005Tab1.txt"
	con <- file(file)
	x <- readLines(con)
	close(con)
	
	xx <- read.csv2("~/Documents/vegsoup-data/Petrik2005/taxon2standard.csv",
		stringsAsFactors = FALSE)	
	xx <- xx[!is.na(xx[,1]),]
	
	#	width: number of letters of taxon names 
	width = 11
	
	for (i in 1:nrow(xx)) {
		x <- gsub(xx[i, 1], format(xx[i, 3],
			width = width - (width - nchar(xx[i, 1])), justiy = "left"), x)	
	}
	
	#	save to disk
	file <- "~/Documents/vegsoup-data/Petrik2005/Petrik2005Tab1taxon2standard.txt"
	con <- file(file)
	x <- writeLines(x, con)
	close(con)
	#	and add KEYWORDS
}