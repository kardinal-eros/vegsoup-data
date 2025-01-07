library(vegsoup)
require(bibtex)


path <- "~/Documents/vegsoup-data/tauglboden lichen dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	cd 'relevees'
#	sudo /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 species.ods
#	token 76 is the number of the UTF-8 encoding, 44 the comma, and 34 the double quote character ASCII

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ",")[, 1:4]
X$cov <- as.numeric(X$cov)
#	table(unique(X$cov))

file <- file.path(path, "sites wide.csv")

#	promote to class "Sites"
Y <- stackSites(file = file, sep = ";")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "percentage")

#	set coordinates
coordinates(obj) <- ~ longitude.tree + latitude.tree
obj$accuracy <- obj$accuracy.tree
proj4string(obj) <- CRS("+init=epsg:4326")

#	richness
obj$richness <- richness(obj, "sample")

#	assign result object
assign(key, obj)

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))

#	trick cover values
obj2 <- obj
obj2@species$cov <- "1"

write.verbatim(obj2, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE, pad = 2)

#	write.csv2(taxon(obj), file.path(path, "taxa.csv"))

#	tidy up
rm(list = ls()[-grep(key, ls())])

