library(vegsoup)
require(bibtex)


path <- "~/Documents/vegsoup-data/rosenheim-mühldorf fields dta"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	cd 'relevees'
#	sudo /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 species.ods
#	token 76 is the number of the UTF-8 encoding, 44 the comma, and 34 the double quote character ASCII

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ",")#[, 1:4]

table(unique(X$cov))
table(unique(X$layer))

file <- file.path(path, "sites wide.csv")

#	promote to class "Sites"
Y <- stackSites(file = file, sep = ",")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
i <- Coverscale("simple", codes = c("l", "x", "d"), lims = c(5,25,50))
obj <- Vegsoup(x = XZ, y = Y, coverscale = i)

#	richness
obj$richness <- richness(obj, "sample")

#	order layer
#	cl: crop layer, fl: field layer
layers(obj)	 <- c("cl", "fl")

#	assign result object
assign(key, obj)

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])

#	change taxonomy of vegsoup object
source("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/LFUcodepage.R")


