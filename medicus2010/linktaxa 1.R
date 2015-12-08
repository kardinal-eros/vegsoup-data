library(linktaxa)
#	Not run

if (FALSE) {
xx <- read.csv2("~/Documents/vegsoup-data/medicus2010/species wide 1.csv",
	colClasses = "character")
x <- xx$taxon	
yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon

#	main table
xy <- linktaxa(x, y, order = FALSE)
#	edited results stored as taxon2standard.csv
write.csv2(xy, "~/Documents/vegsoup-data/medicus2010/taxon2standard 1.csv")

x <- read.csv2("~/Documents/vegsoup-data/medicus2010/taxon2standard 1.csv",
	colClasses = "character")
a <- yy$abbr[match(x$matched.taxon, y)]
#	saved and pasted into table
write.csv2(a, "~/Documents/vegsoup-data/medicus2010/tmp.csv")

}