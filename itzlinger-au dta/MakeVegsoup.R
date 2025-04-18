library(vegsoup)
require(bibtex)


path <- "/Users/roli/Documents/vegsoup-data/itzlinger-au dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	cd 'path'
#	sudo /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 species.ods
#	token 76 is the number of the UTF-8 encoding, 44 the comma, and 34 the double quote character ASCII

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ",")#[, 1:4]

table(unique(X$cov))

file <- file.path(path, "sites wide.csv")

#	promote to class "Sites"
Y <- stackSites(file = file, sep = ";")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet")

#	richness
obj$richness <- richness(obj, "sample")

#	order layer
layers(obj)	 <- rev(c("hl", "sl2", "sl1", "tl3", "tl2", "tl1"))

#	total canopy value
obj$canopy <- apply(sites(obj)[ , match(c("s1cov", "s2cov", "t1cov", "t2cov", "t3cov"), names(obj)) ], 1,
	function (x) {
	round((1 - prod(1 - x / 100)) * 100, digits = 0)
	} )


#	assign result object
assign(key, obj)


#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])

