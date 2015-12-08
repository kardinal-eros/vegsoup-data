library(vegit)
library(linktaxa)

path <- "~/Documents/vegsoup-data/hartl1974"

#	reference list
z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")
	
#	match taxa for tables 1 : 4
file <- file.path(path, "Hartl1974.txt")
x <- extractTaxon(readLines(file), 30, 10)

#	seek matches ...
y <- linktaxa(x, z$taxon, order = FALSE,
	file = file.path(path, "translate.csv"),
	overwrite = FALSE)
