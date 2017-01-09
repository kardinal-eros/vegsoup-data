library(vegit)
library(linktaxa)
library(vegsoup)

path <- "~/Documents/vegsoup-data/frey1995"
#	match taxa
x <- file.path(path, "Frey1995Tab41.txt")

z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	NOT RUN:
xx <- extractTaxon(x, row = 21, col = 9)

#	overwrite = FALSE
linktaxa(tolower(xx), z$abbr, order = FALSE,
		file = file.path(path, "translate.csv"), overwrite = FALSE)	
