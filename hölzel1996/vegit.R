library(vegit)
library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/hölzel1996")

#	match taxa
file <- "Hölzel1996Tab7"
#	OCR output unsufficient, csv intermediate deleted
#	x <- paste0(file, ".csv")
#	csv2txt(x, header.rows = 28, vertical = TRUE, width = 1, overwrite = FALSE)
x <- readLines(paste0(file, ".txt"))

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
if (FALSE) {
	xx <- extractTaxon(x, row = 35, col = 31)
	
	#	seek matches ...
	yy <- linktaxa(xx, z$taxon, order = FALSE,
		file = paste0(file, "taxon2standard.csv"),
		overwrite = FALSE)
		
	#	 ... and read edits
	y <- read.csv(paste0(file, "taxon2standard.csv"),
		colClasses = "character")
	
	#	replace and save to file with suffix
	r <- replaceTaxon(x, y, z, row = 31, col = 31,
		overwrite = FALSE, keywords = TRUE,
		file = paste0(file, "taxon2standard.txt"))
	
	###	footer species
	#	transform to matrix and ...
	xx <- castFooter(paste0(file,"FooterSpecies.txt"), species.first = TRUE, abundance.first = FALSE)
	#	 ... save for later use
	#	write.csv(species(xx), paste0(file,"Footer species.csv"))
	
	#	seek matches ...
	xy <- linktaxa(xx$abbr, z$taxon, order = FALSE,
		file = paste0(file,"taxon2standardFooterSpecies.csv"), overwrite = TRUE)	
	
	#	... and read edits
	x <- read.csv(paste0(file,"taxon2standardFooterSpecies.csv"), colClasses = "character")
			
	#	... replace
	a <- z$abbr[match(x$matched.taxon, z$taxon)]
	
	#	... and save temporary file
	#	contents to be copied to write.csv(species(xx), paste0(file,"FooterSpecies.csv"))
	write.csv2(a, "tmp.csv")	
}

#	defaults write com.macromates.TextMate fontLeadingDelta -float -4
#	zoom  180