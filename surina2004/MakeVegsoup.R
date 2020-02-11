require(vegsoup)

###	Not run
if (FALSE) {
#	assign taxon abbreviations
file <- "~/Documents/vegsoup-data/surina2004/Surina2004Tab1.txt"
con <- file(file)
x <- readLines(con)
close(con)

xx <- read.csv2("~/Documents/vegsoup-data/surina2004/taxon2standard.csv",
	stringsAsFactors = FALSE)	
xx <- xx[!is.na(xx[,1]),]

#	width: number of letters of taxon names 
width = 33

for (i in 1:nrow(xx)) {
	x <- gsub(xx[i, 1], format(xx[i, 3],
		width = width - (width - nchar(xx[i, 1])), justiy = "left"), x)	
}

file <- "~/Documents/vegsoup-data/surina2004/Surina2004Tab1taxon2standard.txt"
con <- file(file)
x <- writeLines(x, con)
close(con)
}

#	read digitized table 
file <- "~/Documents/vegsoup-data/surina2004/Surina2004Tab1taxon2standard.txt"
x <- read.verbatim(file, "Releveé number")

# promote to class "Species"
x.df <- data.frame(abbr = rownames(x),
			layer = "hl",
			taxon = NA, x,
			check.names = FALSE)

X <- stackSpecies(x.df)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/surina2004/Surina2004Tab1Locations.csv"
Y <- read.csv2(file, colClasses = "character")
names(Y)[1] <- "plot"
# promote to class "Sites"
Y <- stackSites(Y)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
surina2004 <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")


# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
df.attr <- as.data.frame(attributes(x)[- c(1:3, 11)])
rownames(df.attr) <- colnames(x)
# reorder by plot
df.attr <- df.attr[match(rownames(surina2004), rownames(df.attr)), ] 

# give names and assign variables
surina2004$elevation <- df.attr$"Altitude..m.a.s.l.."
surina2004$expo <- as.character(df.attr$Exposition)
surina2004$expo[surina2004$expo == ""] <- "F"
surina2004$slope <- df.attr$"Inclination...."
surina2004$hcov <- surina2004$hcov <- df.attr$"Coverness.....Herb.layer"
surina2004$mcov <- df.attr$"Moss.layer"
surina2004$pls <- df.attr$"Releveé.area..m2."
surina2004$association <- "Gentiano terglouensis-Caricetum firmae T. Wraber 1970"

rownames(surina2004) <- paste0("surina2004:",
	gsub(" ", "0", format(rownames(surina2004), width = 2, justify = "right")))

Sites(surina2004)
surina2004$expo		
save(surina2004, file = "~/Documents/vegsoup-data/surina2004/surina2004.rda")

rm(list = ls()[-grep("surina2004", ls(), fixed = TRUE)])

#QuickMap(surina2004)