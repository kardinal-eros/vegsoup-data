library(vegsoup)
require(bibtex)
require(terra)

path <- "~/Documents/vegsoup-data/berchtesgaden dta"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "species.csv")
# promote to class "Species"

X <- species(file, sep = ";")
X <- X[, 1:4]

file <- file.path(path, "sites.csv")
# promote to class "Sites"
Y <- sites(file, sep = ";")
Y$value <- gsub(",", ".", Y$value)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
# promote to class "SpeciesTaxonomy"
XZ <- SpeciesTaxonomy(X, file.y = file)
# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "domin")

#	add coordinates from polygon
pg <- vect("~/Documents/vegsoup-data/berchtesgaden dta/sites.shp")
pg0 <- project(pg, CRS("+init=epsg:3857"))
#	calculate accuracy
#	initialize a vector to store maximum diameters
d <- numeric(nrow(pg0))

# Loop through each polygon
for (i in 1:nrow(pg0)) {
  # Extract the i-th polygon
  poly <- pg0[i, ]
  
  # Extract the vertices of the polygon
  boundary <- as.points(poly)
  
  # Calculate pairwise distances between all vertices
  dd <- distance(boundary, boundary)
  
  # Find the maximum distance
  d[i] <- max(dd)
}

pg$accuracy <- 150 # d
	
r <- rep(1:nrow(pg), each = 10)
pt <- centroids(pg)[r, ]
pt$accuracy <- 150
plots <-  paste(pg$SITE[r], sprintf("%02d", 1:10), sep = "-")
pt <- pt[match(rownames(obj), plots), ]

obj$longitude <- geom(pt, df = TRUE)$x
obj$latitude <-  geom(pt, df = TRUE)$y
obj$accuracy <- pt$accuracy
	
coordinates(obj) <- ~longitude+latitude
proj4string(obj) <- CRS("+init=epsg:4326")

obj$plsx <- 2
obj$plsy <- 2

#	order layer
layers(obj)	 <- c("sl", "hl")

#	site variable
obj$site <- sapply(strsplit(rownames(obj), "-"), head, 1)

names(obj)
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
