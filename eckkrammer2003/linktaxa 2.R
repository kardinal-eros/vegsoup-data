library(linktaxa)
#	not run

if (FALSE) {
xx <- read.csv2("~/Documents/vegsoup-data/eckkrammer2003/species wide 2.csv",
	colClasses = "character")
x <- xx$taxon	
yy <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv", colClasses = "character")
y <- yy$taxon


main table
xy <- linktaxa(x, y, order = FALSE)
edited results stored as taxon2standard.csv
write.csv2(xy, "~/Documents/vegsoup-data/eckkrammer2003/taxon2standard 2.csv")

x <- read.csv2("~/Documents/vegsoup-data/eckkrammer2003/taxon2standard 2.csv",
	colClasses = "character")
a <- yy$abbr[match(x$matched.taxon, y)]
saved and pasted into table
write.csv2(a, "~/Documents/vegsoup-data/eckkrammer2003/tmp.csv")

footer species
zz <- read.csv2("~/Documents/vegsoup-data/eckkrammer2003/footer species 2.csv",
	colClasses = "character")
x <- zz$taxon
xy <- linktaxa(x, y, order = FALSE)
edited results stored as taxon2standard footer species 1.csv
write.csv2(xy, "~/Documents/vegsoup-data/eckkrammer2003/taxon2standard footer species 2.csv")

x <- read.csv2("~/Documents/vegsoup-data/eckkrammer2003/taxon2standard footer species 2.csv",
	colClasses = "character")
a <- yy$abbr[match(x$matched.taxon, y)]
saved and pasted into table
write.csv2(a, "~/Documents/vegsoup-data/eckkrammer2003/tmp.csv")
}