require(vegsoup)
require(raster)

path <- "~/Documents/vegsoup-data/prebersee dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species.csv")
#	promote to class "Species"
X <- species(file, sep = ";")[, c(1:4)]

file <- file.path(path, "sites wide.csv")
#	promote to class "Sites"
Y <- stackSites(file = file, sep = ";")

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
#	promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)

#	build "Vegsoup" object
obj <- Vegsoup(XZ, Y, coverscale = "pa")

#	complement missing values from interpolated data
i <- is.na(obj$ph)

#	measurement taken from wells
file <- file.path(path, "variables.tif")
r <- brick(file)
names(r) <- c("ph", "conductivity", "watertable")
r <- as.data.frame(extract(r, obj))
obj$ph[i] <- round(r$ph[i], 1)
obj$conductivity[i] <- round(r$conductivity[i], 0)
obj$watertable[i] <- round(r$watertable[i], 0) * -1
#	we need to subtract the well's height for measurements
obj$watertable[!i] <- obj$watertable[!i] - obj$wellheight[!i]

#	interpolated slope and aspect map from high precision GNSS measurements
#	taken at each plot
file <- file.path(path, "slope.tif")
r <- raster(file)
obj$slope <- extract(r, obj)

file <- file.path(path, "aspect.tif")
r <- raster(file)
obj$aspect <- compass(extract(r, obj))

#	order layer
layers(obj)	 <- c("sl", "hl", "ml")

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "", add.lines = TRUE, select = "richness")

#	tidy up
rm(list = ls()[-grep(key, ls())])

detach("package:raster")