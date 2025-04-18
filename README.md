Overview of the vegsoup-data repository
=======================================

A repository of plant species co-occurrence data (vegetation data, phytosociological relevés).

***This is our vegetation database (spatial and temporal explicit species co-occurrence data). Essentially, it serves as an incubator for collecting data on vegetation plots. Currently, the repository contains a bunch of unpublished data sets, as well as computerized data taken from the literature.***
4,289 genuine relevés were observed by R. Kaiser and/or T. Eberl and 2,643 relevés originate from literature sources and were digitized by R. Kaiser. 1,636 relevés are provided by M. Staudinger. 8,568 relevés are available, involving 2,782 and 1,311 taxa (including bryophytes and lichens). Up to now, R. Kaiser, M. Staudinger, and T. Eberl are the main contributors. You are welcome to join the project!

The bibtex file `./refernces.bib` that is contained in each project folder gives intellectual property rights for a particular data set (see also section license). The *URL* field provides a link to a PDF-file in case of a literature source.

![](README.png)

Directory Structure
-------------------

- [adnet dta](adnet dta): Each project is located in a separate folder.
- [überling dta](überling dta): Folder names contain non-ASCII characters
- [zwurms meschach dta](zwurms meschach dta): Each project is named after a toponym.

How to access and use the data sets
-----------------------------------

Data sets containing a file named `transcript.txt` are ready to be used with the [**vegsoup** *R*-package](http://r-forge.r-project.org/projects/vegsoup/).
To install this package from within *R*, type:

```R
# if needed
install.packages("devtools")

library(devtools)

install.packages("vegsoup", repos="http://R-Forge.R-project.org", type = "source")

#   github mirror
install_github("rforge/vegsoup/pkg")
```

To load a data set into an *R* session, you may either download a particular `*.rda` file and attach it to your *R*-session (first navigate to the respective `*.rda` file, then right-click on the file, a further click on *View Raw* will download the file.), or load the data directly from inside an R session:

```R
# if needed
install.packages("RCurl")

library(vegsoup)
library(RCurl)  

URL <- paste0(
	"https://raw.githubusercontent.com/",  # to accesses the raw files
	"kardinal-eros/vegsoup-data/master/",  # this is the repository
	"barmstein%20dta/bs.rda"               # folder and *.rda file
)
load(rawConnection(getBinaryURL(URL)))
```

A condensed object containing all available data in this repository is contained in the [./mirror](https://github.com/kardinal-eros/vegsoup-data/blob/master/mirror) folder as `mirror.rda`.

Licence
-------

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons licnece" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a Creative Commons licence <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Attribution - NonCommercial - ShareAlike 4.0 International</a>.

We ask to contact the [maintainer](https://github.com/kardinal-eros) if you plan to use any data from this repository in a publication that is marked as *unpublished*. See the `@unpublished` tag in the `references.bib` file.

Species designation and taxonomic concepts
------------------------------------------

All data sets link to a standard list ([for further details see here)](https://github.com/kardinal-eros/vegsoup-standards/tree/master/austrian%20standard%20list%202008) or use the *Austrian* setup of the [Turboveg data base system](http://www.synbiosys.alterra.nl/turboveg/).

Notes about computerization of literature data
------------------------------------------

Any project developed from a published source can be seamlessly built using OCR transcripts. First, we supply PDF files of the (table) sources along with their OCR transcripts. This way, it is possible to scrutinize all steps involved in digitizing the data. All data manipulation steps are documented within a *Make* file (`MakeVegsoup.R`). Concerning the interpretation of taxonomic concepts, a table is supplied that translates the taxa in the publication to a reference list (see the `translate*.csv` files). The *URL* tag in the `references.bib` file provides a (stable) link to a full PDF version of the publication – not just the tables and related material used for OCR. A scanned version of the document is stored with the project if no free PDF version is available.

Bibliographic information
-------------------------

Each project folder contains a `references.bib` file that contains bibliographic information related to a data set. Creating and maintaining bibliographic information for the whole repository is easy using the efficient BibTex format and its readable syntax.

Sampling protocol and data standards
====================================

This is a brief summary of the sampling protocol applied by R. Kaiser & T. Eberl and descriptive attributes collected with each sampling unit (plot or relevé) as available in the **vegsoup-data** repository. Of course, this does not apply to data sets taken from the literature.

Sampling procedure
------------------

Different sampling procedures are applied depending on the scope of a particular project.

- *Landscape Sampling* uses area stratification. That means a survey area is divided into strata (forest, meadow, mire, etc.), and samples within a stratum are replicated depending on the areal extent of the stratum. We always aim to sample all vegetation types in a given survey area that are discernible in the field. The size of the surveyed landscape is typically in the range of 5 to 50 hectares.

- In *Type Specific Sampling*, we search a possibly large survey area for a specific vegetation type (e.g. ravine forest or rock shrubbery).

- In *Species Specific Sampling* we sample the vegetation where a particular (rare) species occurs.

- In *Rapid Biodiversity Sampling* we collect instances of (all) vegetation types in an area as we walk (straight) through the landscape. In this way, we typically do not collect area-dependent replicates.

- *Rock Vegetation Sampling* is performed by using mountaineering equipment (rope and climbing harness), occasionally free-climbing. Rock vegetation or forest of steep slopes is sampled using a rope along a vertical transect. Usually, 3 to 4 plots are sampled along a 100 m long rope. The first plot is typically sampled just below the rope betray point. The last relevé is taken at the end of the rope. Depending on how long the rappelling (abseiling) needs to be, non-overlapping plots are taken along this line, with gaps between sampling units of at least half the plot size applied.

- *Systematic sampling* is performed using a rectangular grid or along a (measure tape) transect. We do not give much consideration to homogeneity or other subjective criteria concerning a sample plot, and sampling locations are typically randomly selected. In the case of rock vegetation, the vertical transect's location is constrained by a suitable belay point that can be reached with reasonable effort. Additionally, the danger of falling rocks is significant. Therefore, the vegetation sampled in this context cannot be subjectively selected, and sampling can be considered random.


Estimation scales
-----------------

We typically apply the 9-point modification of the classical 7-point Braun-Blanquet by Barkman et al. (1964). See Roberts & Peet (2013) for details.

Plot sizes
----------

We use strictly equal-sized plots with edge lengths that are powers of 2 (e.g. 1 × 1, 2 × 2, 4 × 4, 8 × 8, 16 × 16). Grasslands (including alpine vegetation and tundra), marshes, fens and mires are sampled using 16m² area plots (4 m × 4m); scrubs and rock shrubbery use 64 m² plots (8m × 8m) and woodlands are sampled within plots of 256 m² (16 m × 16m). Spring vegetation is sampled using small plots of size 1 m² (1 m × 1 m).

Whenever possible, we use square plots. We record both edge lengths of the plot instead of noting the plot area. The shape of non-square plots can then be estimated by dividing *edge max* by *edge min*. In some rare cases (e.g. forests on rock cliffs), it is necessary to switch to elongated plot forms (e.g. 10 × 26 m ≈ 256 m² instead of 16 × 16 m).

Detailed forest surveys use circular plots with a radius of 11m (ca. 380 m²).

Attributes of the sampling units (relevés) that are recorded in the field
------------------------------------------------------------------------

Principal standards of the phytosociological relevé follow the notation of Mucina et al. (2000).

**Data on field record**

> `plot` designation of sample plot (relevé)  
> `date` date of sampling (ISO 8601, yyyy-mm-dd)  
> `observer` name(s) of the author(s) of the relevé  
> `alliance` provisional classification into syntaxon  
> `association` optional  
> `plsx` edge length of plot, parallel to the hillside  
> `plsy` edge length of plot, orthogonal to a hillside  
> `plras` radius of a circular plot  

**Geographic data**  

> `location` locality, topographic name  
> `expo` exposition, aspect (N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW, and F for flat).
> `slope` slope, inclination  

Other fields, such as country, province (district), the nearest village, and altitude, can be obtained with the `reverseGeocode` function.

**Geographic coordinates**  

> `latitude` coordinate of latitude in decimal degrees (decimal is ».«) based on the WGS 1984 ellipsoid (EPSG:4326), a minus sign or a padding letter »S« and »N« means south and north of the equator, respectively (e.g. 12.345678S or -12.345678).  
> `longitude` coordinate of longitude, a minus sign or padding letter »W« and »E» means west and east of the Greenwich zero meridian, respectively  (e.g. 87.654321W or -87.654321)  
> `accuracy` coordinate uncertainty (precision) in meters

**Data on vegetation**  

We supply the stratum/layer notation as defined in Mucina et al. 2000 (E₀, E₁, E₂, E₃)

*Cover of vegetation*

> `cov` total cover, total projection of standing vegetation  


*Cover of tree layer* in % (***E₃***)

> `htl` cover of *tree* layer (***E₃***)  
> `t1cov` cover of *canopy* layer (***E₃ γ***)  
> `t2cov` cover of *sub-canopy* layer (***E₃ β***)  
> `t3cov` cover of *lower tree layer* layer (***E₃ α***)  

*Cover of shrub layer* in % (***E₂***)

> `scov` cover of *shrub* layer (***E₂***)
> `s1cov` cover of *upper shrub layer* layer (***E₂ β***)
> `s2cov` cover of *lower shrub layer* layer (***E₂ α***)


*Cover of herb layer* in % (***E₁***)

> `hcov` cover of *herb* layer (***E₁***)  

We don't estimate the cover of any sub-strata in the terrestrial herb layer (upper, middle and lower herb layer ***E₁ α***, ***E₁ β***, and ***E₁ γ***, respectively), but we do so  for aquatic vegetation:

> `ncov` cover of *natant plants* (***E₁n***)  
> `ucov` cover of *submerged plants* (***E₁s***)  

<!--- *Cover of *emergent plants* (***E₁e***) equals `hcov` (***E₁***) -->


*Cover of cryptogam layer* in % (***E₀***)

> `mcov` cover of cryptogam layer (***E₀***)  


*Cover of non-vegetated ground* in %

> `litter` cover of litter  
> `rock` cover of rocks  
> `bare` cover of bare soil  
> `soil` cover of debris  
> `water` cover of free water  

*Height of vegetation*

*Height of tree layer* in meters, woody plants over 6 m tall or 12 cm in diameter (***E₃***)

> `htl` height of tree layer (***E₃***)  
> `htl0` height of emergent layer (***E₃ δ***), woody plants with crowns towering above the canopy layer (e.g. a tall coniferous tree overtopping the canopy of decidous trees)  
> `htl1` height of canopy layer (***E₃ γ***)  
> `htl2` height of sub-canopy layer (***E₃ β***)  
> `htl3` height of lower tree layer (***E₃ α***)  

*Height of shrub layer* in meters, woody plants ranging 0.5 - 6 m (***E₂***)

> `hsl` height of shrub layer (***E₂***), woody plants ranging 0.5 - 6 m.  s

We do not distinguish a lower (***E₂ α***) and upper shrub layer (***E₂ β***)  

*Height of herb layer* in meters, non-woody phanerogams (***E₁***)

> `hhl` height of herb layer (***E₁***)  
> `hhl1` height of upper herb layer (***E₁ γ***)  
> `hhl2` height of lower herb layer (***E₁ α***)  

We don't distinguish a middle herb layer (***E₁ β***).  
Woody plants that compete with non-woody phanerogams are attributed to the herb layer (juvenile trees).  
The height of the cryptogam layer (***E₀***) is not estimated/measured.  

**Data on habitat and Notes**  

> `comment` optional notes  
> `geology` type of (bed-)rock  
> `hydrology` water regime  
> `soil` type and/or texture of the soil  

References
==========

M Chytrý & Z Otýpková (2003). Plot sizes used for phytosociological sampling of european vegetation. Journal of Vegetation Science, 14(4):563–570.

L Mucina, J Schaminee, & J Rodwell (2000). Common data standards for recording relevés in field survey for vegetation classification. Journal of Vegetation Science, 11: 769-772.

RK Peet & DW Roberts (2013). Classification of natural and semi-natural vegetation. In Vegetation Ecology (E van der Maarel, & J Franklin, eds.). Wiley-Blackwell.
