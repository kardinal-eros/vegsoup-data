library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/amann2019")

#	match taxa
#file <- "Amann2019Tab1 species wide.csv"
#file <- "Amann2019Tab2 species wide.csv"
file <- "Amann2019Tab3 species wide.csv"
x <- read.csv(file)

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
if (FALSE) {
	xx <- as.character(x$taxon)
	#	seek matches ...
	yy <- linktaxa(xx, z$taxon, order = FALSE,
		file = "taxon2standard.csv",
		overwrite = FALSE)
		
	#	 ... and read edits
	x <- read.csv("taxon2standard.csv",
		colClasses = "character")
					
	#	... replace
	a <- z$abbr[match(x$matched.taxon, z$taxon)]
	
	#	... and save temporary file
	#	with contents to be copied to "Amann2004Tab2 species wide.csv"
	write.csv2(a, "tmp.csv")	
}
