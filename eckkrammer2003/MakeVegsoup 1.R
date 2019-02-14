require(vegsoup)

file <- file.path(path, "species wide 1.csv")
X0 <- stackSpecies(file = file)[, 1:4]

file <- file.path(path, "footer species 1.csv")
X1 <- read.csv2(file, colClasses = "character")
X1 <- X1[, -grep("taxon", names(X1))]
X1 <- species(X1)
X <- vegsoup::bind(X0, X1)

file <- file.path(path, "sites wide 1.csv")
Y <- stackSites(file = file)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab1", sprintf("%03d", as.numeric(rownames(obj))), sep = ":")

tab1 <- obj
