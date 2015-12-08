library(vegit)
library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/nußbaumer2000")
#	match taxa
file <- "Nußbaumer2000Tab1"
x <- readLines(paste0(file, ".txt"))

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
if (FALSE) {
	xx <- extractTaxon(x, row = 25, col = 24) # Tab 7. and Tab 8.
	
	#	seek matches ...
	yy <- linktaxa(xx, z$taxon, order = FALSE,
		file = paste0(file, "taxon2standard.csv"),
		overwrite = FALSE)
		
	#	 ... and read edits
	y <- read.csv2(paste0(file, "taxon2standard.csv"),
		colClasses = "character")
	
	#	replace and save to file with suffix
	r <- replaceTaxon(x, y, z, col = 25, row = 24,
		overwrite = TRUE, keywords = TRUE,
		file = paste0(file, "taxon2standard.txt"))
	
	###	footer species
	#	transform to matrix and ...
	xx <- castFooter(paste0(file,"FooterSpecies.txt"))
	#	 ... save for later use
	#	write.csv2(xx, "Krisai1996Tab7FooterSpecies.csv")
	#	write.csv2(xx, "Krisai1996Tab8FooterSpecies.csv")
	
	#	seek matches ...
	xy <- linktaxa(xx[,3], z$taxon, order = FALSE,
		file = "Krisai1996Tab8taxon2standardFooterSpecies.csv", overwrite = TRUE)	
	
	#	... and read edits
	x <- read.csv2("Krisai1996Tab7taxon2standardFooterSpecies.csv", colClasses = "character")
	x <- read.csv2("Krisai1996Tab8taxon2standardFooterSpecies.csv", colClasses = "character")
		
	#	... replace
	a <- z$abbr[match(x$matched.taxon, z$taxon)]
	
	#	... and save temporary file
	write.csv2(a, "tmp.csv")	
}