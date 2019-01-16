library(vegit)
library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/beiser2014")

#	match taxa
file <- "Beiser2014Tab4 species wide.csv"
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

	###	footer species
	#	transform to matrix and ...
	xx <- castFooter("Beiser2014Tab4FooterSpecies.txt", abundance.first = FALSE)
	#	 ... save for later use
	#	write.csv(species(xx), "Beiser2014Tab4Footer species.csv")
	
	#	seek matches ...
	xy <- linktaxa(xx$abbr, z$taxon, order = FALSE,
		file = "Beiser2014Tab4taxon2standardFooterSpecies.csv", overwrite = TRUE)	
	
	#	... and read edits
	x <- read.csv("Beiser2014Tab4taxon2standardFooterSpecies.csv", colClasses = "character")
			
	#	... replace
	a <- z$abbr[match(x$matched.taxon, z$taxon)]
	
	#	... and save temporary file
	#	conetents to be copied to write.csv(species(xx), paste0(file,"FooterSpecies.csv"))
	write.csv2(a, "tmp.csv")
}
