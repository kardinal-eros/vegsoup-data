library(vegsoup)

setwd("~/Documents/vegsoup-data/mountain hay meadows dta")

load("Staudinger027_028.rda")

x <- Staudinger027_028

#	set up object
decostand(x) <- "total"
vegdist(x) <- "bray"

#	authors classification in alliance
#	groome levels
levels(x$verband)[levels(x$verband) == "Calthion (incl. Filipendulion)"] <- "Calthion"
levels(x$orig_diag)[levels(x$orig_diag) == "Astrantio-Tristetum"] <- "Astrantio-Trisetetum" 
levels(x$orig_diag)[levels(x$orig_diag) == "Poo-Tristetetum"] <- "Poo-Trisetetum"
levels(x$orig_diag)[levels(x$orig_diag) == "Festuco-Cynocuretum"] <- "Festuco-Cynosuretum"

#	climate and elevation
r1 <- raster("~/Dropbox/öklim/dta/asc/00_Niederschlag-Jahr.asc")
r2 <- raster("~/Dropbox/öklim/dta/asc/01_Temperatur-Jahr.asc")
r3 <- raster("~/Google Drive/autdem/autdem.tif")

x$prec <- extract(r1, x)
x$temp <- extract(r2, x)
x$elev <- extract(r3, spTransform(x, CRS("+init=epsg:31287")))

p0 <- VegsoupPartition(x, clustering = "verband")
as.table(p0, "verband")
d0 <- as.dendrogram(p0, labels = "verband")
plot(d0, main = "Apriori classification into alliance")

#	we subset Arrhenatherion (2), Cynosurion (5) and Trisetion (7) for this analysis
x1 <- do.call("bind", sapply(c(2,5,7), function (x) partition(p0, x)))
plot(as.dendrogram(x1, labels = "verband"))
as.table(x1, "verband")

#	OptimClass for k = 20, will take a while () to complete
#os <- OptimStride(x1, k = 20, fast = TRUE)
plot(os)
print(os)
# higher is better
boxplot(t(optimclass1(os)))
boxplot(t(apply(optimclass1(os), 2, rank, ties = "first")))

#	alliances
p0 <- VegsoupPartition(x1, clustering = "verband")
Latex(fidelity(p0, "TCR"), file = "./tex/selected alliances", template = TRUE, stat.min = 0.1, taxa.width = "70mm")

Latex(fidelity(p0, "TCR"), file = "./tex/selected alliances summary", template = TRUE, stat.min = 0.1, taxa.width = "70mm", mode = 2)

#	select candidate, fuzzy c-means
p <- VegsoupPartition(x1, k = 7, method = "FCM")
#	try to optimize
pp <- optsil(p)

confusion(p, pp)
as.table(p, "verband")
as.table(pp, "verband")
as.table(p, "orig_diag")
as.table(pp, "orig_diag")

#	results
Latex(fidelity(p, "TCR"), file = "./tex/FCM TCR k7", template = TRUE, stat.min = 0.1, taxa.width = "70mm")
Latex(fidelity(pp, "TCR"), file = "./tex/FCM TCR k7 optsil", template = TRUE, stat.min = 0.1, taxa.width = "70mm")

#	reorder to dendrogram
ppp <- reorder(p, as.dendrogram(ppp))

Latex(fidelity(ppp, "TCR"), file = "./tex/FCM TCR k7 order", template = TRUE, stat.min = 0.1, taxa.width = "70mm")

Latex(fidelity(ppp, "TCR"), file = "./tex/FCM TCR k7 order", template = TRUE, stat.min = 0.1, taxa.width = "70mm")

#	r <- raster("~/Google Drive/autdem/autdem.tif")


table(ppp$prec < 1200, partitioning(ppp))

pppp <- ppp[which(ppp$prec > 1200), ]
par(mfrow =c(1,3))
boxplot(prec ~ partitioning(ppp), data = sites(ppp))
boxplot(temp ~ partitioning(ppp), data = sites(ppp))
boxplot(elev ~ partitioning(ppp), data = sites(ppp))