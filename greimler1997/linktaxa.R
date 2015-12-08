library(vegit)
library(linktaxa)
library(vegsoup)

path <- "~/Documents/vegsoup-data/greimler1997"

#	reference list
z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")
	
#	match taxa for tables 15, 16, and 27
files <- paste0("Greimler1997Tab", c(15,16,27), ".txt")
x <- sapply(files, function (x) readLines(file.path(path, x)))

#	teh taxa block of all tables is indented indentically
x <- sapply(1:3, function (i) extractTaxon(x[[i]], 33, 12, blank = ""))
x0 <- unlist(x)

files <- paste0("Greimler1997Tab", c(16,27), "FooterSpecies.txt")
x <- sapply(files, function (x) castFooter(file.path(path, x), first = FALSE, layers = "@")[, 3])
x1 <- as.character(unlist(x))

xx <- sort(unique(c(x0, x1)))
xx <- xx[xx != ""]

#	seek matches ...
yy <- linktaxa(xx, z$taxon, order = FALSE,
	file = file.path(path, "translate.csv"),
	overwrite = FALSE)
