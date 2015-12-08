library(vegsoup)
require(bibtex)

#	Note, species data for 45 plots was not digitized, although sites data is available

path <- "~/Documents/vegsoup-data/kalkalpen lichen dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

file <- "~/Documents/vegsoup-data/kalkalpen lichen dta/species.csv"
# promote to class "Species"

X <- species(file, sep = ";")[, 1:4]

X$cov <- gsub(",", ".", X$cov, fixed = TRUE)
#X$plot <- sprintf("kal%03d", as.numeric(X$plot))

file <- "~/Documents/vegsoup-data/kalkalpen lichen dta/sites.csv"
# promote to class "Sites"
Y <- sites(file, sep = ";")
#Y$plot <- sprintf("kal%03d", as.numeric(Y$plot))

file <- "~/Documents/vegsoup-data/kalkalpen lichen dta/taxonomy.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)
# promote to class "Vegsoup"

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "percentage")

#	unique rownames
rownames(obj) <- paste(key, sprintf("%03d", as.numeric(rownames(obj))), sep = ":")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
