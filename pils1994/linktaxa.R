library(linktaxa)
library(vegsoup)
library(stringr)

#	match taxa
file <- "~/Documents/vegsoup-data/pils1994/Pils1994Tab8.txt"
con <- file(file)
x <- readLines(con)
close(con)

yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	NOT RUN:
if (FALSE) {
#	build taxon join table 
    #	maximum width of species names
	column <- 31
	#	row where species block starts 
	row <- 24
	x <- sapply(x, function (x) substring(x, 1, column), USE.NAMES = FALSE)
	x <- x[row:(length(x))]
	x <- str_trim(x)
	x[x == ""] <- "BLANK"

	xy <- linktaxa(x, y, order = FALSE)
#	edit table ...
	write.csv2(xy, "~/Documents/vegsoup-data/pils1994/taxon2standard.csv")
#	and read in back to join abbr
	x <- read.csv2("~/Documents/vegsoup-data/pils1994/taxon2standard.csv",
		colClasses = "character")
	a <- yy$abbr[match(x$matched.taxon, y)]
	x$abbr <- a
#	save (overwrite!) file
	write.csv2(x, "~/Documents/vegsoup-data/pils1994/taxon2standard.csv",
	row.names = FALSE)
	
#	footer species
#	transform to matrix and save for later use			
	zz <- castFooter("~/Documents/vegsoup-data/pils1994/Pils1994Tab8FooterSpecies.txt",
		schema = c(":", ",", " "))
	write.csv2(zz, "~/Documents/vegsoup-data/pils1994/Pils1994Tab8FooterSpecies.csv")
#	get taxon names			
	x <- zz[,3]
	xy <- linktaxa(x, y, order = FALSE)
#	save matches and edit file
	write.csv2(xy, "~/Documents/vegsoup-data/pils1994/taxon2standard footer species.csv")
#	read edits ...
	x <- read.csv2("~/Documents/vegsoup-data/pils1994/taxon2standard footer species.csv",
		colClasses = "character")
#	... and get abbreviations		
	a <- yy$abbr[match(x$matched.taxon, y)]
#	saved as temporary file paste column abbr to Pils1994Tab8FooterSpecies.csv
	write.csv2(a, "~/Documents/vegsoup-data/pils1994/tmp.csv")	
}

#	NOT RUN:
if (FALSE) {
	#	assign taxon abbreviations
	file <- "~/Documents/vegsoup-data/pils1994/Pils1994Tab8.txt"
	con <- file(file)
	x <- readLines(con)
	close(con)
	
	xx <- read.csv2("~/Documents/vegsoup-data/pils1994/taxon2standard.csv",
		stringsAsFactors = FALSE)	
	xx <- xx[!is.na(xx[,1]),]
	
	#	width: maximum number of letters of in taxon names 
	width = 32
	
	for (i in 1:nrow(xx)) {
		x <- gsub(xx[i, 1], format(xx[i, 3],
			width = width - (width - nchar(xx[i, 1])), justiy = "left"), x)	
	}
	
	#	save to disk
	file <- "~/Documents/vegsoup-data/pils1994/Pils1994Tab8Taxon2standard.txt"
	con <- file(file)
	x <- writeLines(x, con)
	close(con)
	#	and add KEYWORDS
}