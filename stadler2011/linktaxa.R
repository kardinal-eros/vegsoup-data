library(linktaxa)
library(stringr)

path <- "~/Documents/vegsoup-data/stadler2011"

#	read species
file <- file.path(path, "species wide.csv")
x <- read.csv2(file, stringsAsFactors = FALSE)[, 1]

#	taxonomic reference
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
y <- read.csv2(file, colClasses = "character")$taxon

xy <- linktaxa(x, y, order = FALSE)

#	must manually edit results
write.csv2(xy, file.path(path, "translate.csv"), row.names = FALSE, quote = FALSE)
