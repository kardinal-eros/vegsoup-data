library(vegsoup)
require(rgdal)

file <- "~/Documents/vegsoup-data/salzkammergut lichen dta/species.csv"
# promote to class "Species"

X <- species(file, sep = ";")
X <- X[, 1:4]
X$cov <- gsub(",", ".", X$cov, fixed = TRUE)

file <- "~/Documents/vegsoup-data/salzkammergut lichen dta/sites.csv"
# promote to class "Sites"
Y <- sites(read.csv2(file))

file <- "~/Documents/vegsoup-data/salzkammergut lichen dta/taxonomy.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)
# promote to class "Vegsoup"
sgl <- Vegsoup(XZ, Y, coverscale = "percentage")
dim(sgl)

save(sgl, file = "~/Documents/vegsoup-data/salzkammergut lichen dta/sgl.rda")
rm(list = ls()[-grep("sgl", ls(), fixed = TRUE)])

