How this data set was (re-)digitized
====================================

The data set was supplied by Johan Peter Gruber on 2014-01-10 in electronic form (see `Gruber2006.zip`) and was reformatted.

Dummy variables for land use and geology were renamed and collapsed into factors, where each level represents a dummy variable of the original source.

Original columns with suffix `OBD*` and their translation into factor levels of column `geology` is as follows:

+ OBD1_Kalkbraunlehm = Terra fusca
+ OBD2_Sediment_fluviatil = fluviatil sediments
+ OBD3_Sand_schlick_Rohboden = sand and mud
+ OBD4_Alluvionen_Pedimente = alluvium
+ OBD5_Anmoorbildung = half-bog
* OBD6_Kalksinter = calc sinter
+ OBD7_penninische_Schhiefer = schist

Original columns with suffix `Nutzung*` and their translation into column `grazing.intensity` is as follows:

+ wenig_Weide = low
+ mittel_beweidet = medium
+ stark_beweidet = high
+ *missing value* = absent (either `unmanaged` or `skislope`, c.p. column `landuse`)

Additional descriptions of localities where obtained from the printed publication (Appendix 10, 157-160 pp).

The suffix `JARC_` from plot names was stripped of and leading zeros were discarded (e.g. `JARC_056` was renamed to `56`)

Note, the supplied spread-sheet by the author uses a custom scale (values from 1 to 5), whereas the printed table uses the 9-point Braun-Blanquet scale. We interpret the values from 1 to 5 as 7-point Braun-Blanquet scale, although, this is not strictly correct.
