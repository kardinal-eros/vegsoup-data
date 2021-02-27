library(vegit)
library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/zimmermann2019")

#	match taxa
file <- "Zimmermann2019Tab1"
x <- paste0(file, ".csv")
csv2txt(x,  header.rows = 3, vertical = FALSE, width = 5, overwrite = FALSE)
x <- readLines(paste0(file, ".txt"))

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
if (FALSE) {
	xx <- extractTaxon(x, row = 5, col = 43)
	
	#	seek matches ... edit ...
	yy <- linktaxa(xx, z$taxon, order = FALSE,
		file = paste0(file, "taxon2standard.csv"),
		overwrite = FALSE)
		
	#	 ... and read edits
	y <- read.csv(paste0(file, "taxon2standard.csv"),
		colClasses = "character")
	
	#	replace and save to file with suffix
	r <- replaceTaxon(x, y, z, row = 5, col = 43,
		overwrite = TRUE, keywords = TRUE,
		file = paste0(file, "taxon2standard.txt"))
	
	###	footer species, not needed
	#	transform to matrix and ...
	#	xx <- castFooter(paste0(file,"FooterSpecies.txt"), abundance.first = NA)
	#	 ... save for later use
	#	write.csv(species(xx), paste0(file,"Footer species.csv"))
	
	#	seek matches ...
	#	xy <- linktaxa(xx$abbr, z$taxon, order = FALSE,
		#	file = paste0(file,"taxon2standardFooterSpecies.csv"), overwrite = TRUE)	
	
	#	... and read edits
	#	x <- read.csv(paste0(file,"taxon2standardFooterSpecies.csv"), colClasses = "character")
			
	#	... replace
	#	a <- z$abbr[match(x$matched.taxon, z$taxon)]
	
	#	... and save temporary file
	#	contents to be copied to write.csv(species(xx), paste0(file,"FooterSpecies.csv"))
	#	write.csv2(a, "tmp.csv")	
}

#	defaults write com.macromates.TextMate fontLeadingDelta -integer 8
#	zoom 193