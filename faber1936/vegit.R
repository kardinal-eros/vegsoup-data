library(vegit)
library(linktaxa)
library(vegsoup)

setwd("~/Documents/vegsoup-data/faber1936")

#	match taxa
file <- "Faber1936Tab2"
x <- paste0(file, ".csv")
csv2txt(x, header.rows = 0, vertical = FALSE, width = 6, overwrite = FALSE)
x <- readLines(paste0(file, ".txt"))

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
if (FALSE) {
	xx <- extractTaxon(x, row = 4, col = 32)
	
	#	seek matches ...
	yy <- linktaxa(xx, z$taxon, order = FALSE,
		file = paste0(file, "taxon2standard.csv"),
		overwrite = FALSE)
		
	#	 ... and read edits
	y <- read.csv(paste0(file, "taxon2standard.csv"),
		colClasses = "character")
	
	#	replace and save to file with suffix
	r <- replaceTaxon(x, y, z, row = 4, col = 32,
		overwrite = TRUE, keywords = TRUE,
		file = paste0(file, "taxon2standard.txt"))
}

#	defaults write com.macromates.TextMate fontLeadingDelta -float 0