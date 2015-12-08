require(vegsoup)
require(linktaxa)

path <- "~/Documents/vegsoup-data/franz2000"

#	main table
file <- file.path(path, "Franz2000Tab1.txt")
X <- read.verbatim(file, colnames = "Laufende Nr.")

#	species names
x <- rownames(X)

#	taxonomic reference
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
yy <- read.csv2(file, colClasses = "character")
y <- yy$taxon

#	NOT RUN:
if (FALSE) {
	x <- str_trim(x)
	x[x == ""] <- NA

	xy <- linktaxa(x, y, order = FALSE)
#	must manually edit results
	write.csv2(xy, file.path(path, "translate.csv"), row.names = FALSE, quote = FALSE)
#	backup

#	read and join abbr
	x <- read.csv2(file.path(path, "translate.csv"),
		colClasses = "character")
	x$abbr <- yy$abbr[match(x$matched.taxon, y)]
	nas <- is.na(x$abbr)
	if (any(nas)) {
		x[nas, ]
		stop()	
	}
#	overwrite file
	write.csv2(x, file.path(path, "translate.csv"),	row.names = FALSE, quote = FALSE)
}

#	additional species
file <- file.path(path, "Franz2000Tab1FooterSpecies.txt")
x <- castFooter(file, first = FALSE)
x <- x[, grep("taxon", colnames(x))]

#	NOT RUN:
if (FALSE) {
	x <- str_trim(x)
	x[x == ""] <- NA

	xy <- linktaxa(x, y, order = FALSE)
#	must manually edit results
	write.csv2(xy, file.path(path, "translate footer species.csv"), row.names = FALSE, quote = FALSE)
#	backup

#	read and join abbr
	x <- read.csv2(file.path(path, "translate footer species.csv"),
		colClasses = "character")
	x$abbr <- yy$abbr[match(x$matched.taxon, y)]
	nas <- is.na(x$abbr)
	if (any(nas)) {
		x[nas, ]
		stop()	
	}
#	overwrite file
	write.csv2(x, file.path(path, "translate footer species.csv"),	row.names = FALSE, quote = FALSE)
}
