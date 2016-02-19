library(vegit)
library(linktaxa)

path <- "~/Documents/vegsoup-data/fischer1998"

#	extract csv.zip to run the below set of commands
#	beware don't set overwrite = TRUE, the files have edits

#	format OCR table transcript for table 1
#file <- file.path(path, "Fischer1998Tab1.csv")
#csv2txt(file, 8, width = 4, vertical = FALSE, overwrite = FALSE)

#	format OCR table transcript for table 2
#file <- file.path(path, "Fischer1998Tab2.csv")
#csv2txt(file, 9, width = 4, vertical = FALSE, overwrite = FALSE)

#	get taxa from OCR transcript
tab1 <- file.path(path, "Fischer1998Tab1.txt")
tab2 <- file.path(path, "Fischer1998Tab2.txt")

x1 <- extractTaxon(readLines(tab1),	row = 11, col = 30, blank = "")
x2 <- extractTaxon(readLines(tab1),	row = 11, col = 30, blank = "")
x <- unique(c(x1, x2))
x <- x[x != ""]

#	translate taxa

#	taxonomic reference
z <- read.csv2("~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv",
	colClasses = "character")

#	overwrite = FALSE
linktaxa(x, z$taxon, order = FALSE,
		file = file.path(path, "translate.csv"), overwrite = FALSE)

