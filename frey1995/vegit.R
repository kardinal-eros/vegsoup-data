library(vegit)
library(linktaxa)
library(vegsoup)

path <- "~/Documents/vegsoup-data/frey1995"

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	match taxa in main table
x <- file.path(path, "Frey1995Tab4.txt")
xx <- extractTaxon(x, row = 21, col = 9)
	
#	NOT RUN:
linktaxa(tolower(xx), z$abbr, order = FALSE,
		file = file.path(path, "translate.csv"), overwrite = FALSE)	

#	match taxa in table footer
xx <- read.csv(file.path(path, "Frey1995Tab4FooterSpecies.csv"))$abbr

#	NOT RUN:
linktaxa(tolower(xx), z$abbr, order = FALSE,
		file = file.path(path, "translate2.csv"), overwrite = FALSE)