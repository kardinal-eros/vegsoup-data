require(vegsoup)

file <- "~/Documents/vegsoup-data/medicus2010/species wide 1.csv"
X <- stackSpecies(file = file, schema = c("abbr", "layer", "taxon"))[, 1:4]

#
file <- "~/Documents/vegsoup-data/medicus2010/sites wide 1.csv"
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

tab1 <- obj
