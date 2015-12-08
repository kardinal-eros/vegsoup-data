library(vegit)
library(linktaxa)
library(vegsoup)

path <- "~/Documents/vegsoup-data/dullnig1989"

#	reference list
z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")
	
#	match taxa for tables 1 : 4
files <- paste0("Dullnig1989Tab", 1:4, ".txt")
x <- sapply(files, function (x) readLines(file.path(path, x)))
	
ij <- matrix(data = c(
		38, 12,
		38, 12,
		30, 12,
		38, 12), ncol = 2, nrow = 4, byrow = TRUE)
x <- sapply(1:4, function (i) extractTaxon(x[[i]], ij[i, 1], ij[i, 2]))
x0 <- unlist(x)

files <- paste0("Dullnig1989Tab", 1:4, "FooterSpecies.txt")
x <- sapply(files, function (x) castFooter(file.path(path, x), first = FALSE)[, 3])
x1 <- unlist(x)

xx <- sort(unique(c(x0, x1)))

#	seek matches ...
yy <- linktaxa(xx, z$taxon, order = FALSE,
	file = file.path(path, "translate.csv"),
	overwrite = FALSE)
