*Owsiak, Andrew P., and Derrick V. Frazier. (2012) The Conflict Management Effects of Allies in Interstate Disputes. Foreign Policy Analysis.

*The following commands replicate the results presented in the tables within the manuscript.

*Table 1, Models 1-4
logit diintmedhigh atopally tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
logit diintmedhigh defense offense nonagg consul tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
logit diintmedhigh summilinst tpmaj tpdicont sameregion kgd06endriv Fatality capratio numdisp territor if defense>0, cluster(midnum)
logit diintmedhigh sumformal tpmaj tpdicont sameregion kgd06endriv Fatality capratio numdisp territor if defense>0, cluster(midnum)

*Table 2, Models 5-8
logit dimed atopally tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
logit dimed defense offense nonagg consul tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
logit dimed summilinst tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor if defense>0, cluster(midnum)
logit dimed sumformal tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor if defense>0, cluster(midnum)

*Table 3, Predicted Probabilities
estsimp logit diintmedhigh atopally tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
setx atopally 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx atopally 1 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx atopally 2 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
drop b1-b10


estsimp logit diintmedhigh defense offense nonagg consul tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
setx defense 0 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx defense 1 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx defense 2 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
drop b1-b13

estsimp logit diintmedhigh summilinst tpmaj tpdicont sameregion kgd06endriv Fatality capratio numdisp territor if defense>0, cluster(midnum)
setx summilinst 0 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx summilinst 6 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx summilinst 12 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
drop b1-b10

estsimp logit diintmedhigh sumformal tpmaj tpdicont sameregion kgd06endriv Fatality capratio numdisp territor if defense>0, cluster(midnum)
setx sumformal 0 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx sumformal 12 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi 
setx sumformal 24 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi 
drop b1-b10

estsimp logit dimed atopally tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
setx atopally 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx atopally 1 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx atopally 2 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
drop b1-b10

estsimp logit dimed defense offense nonagg consul tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor, cluster(midnum)
setx defense 0 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx defense 1 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
setx defense 2 offense 0 nonagg 0 consul 0 tpmaj 0 tpdicont 0 kgd06endriv 0 capratio mean Fatality 0 numdisp 2 territor 0
simqi
drop b1-b13

estsimp logit dimed summilinst tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor if defense>0, cluster(midnum)
setx summilinst 0 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx summilinst 6 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx summilinst 12 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
drop b1-b10

estsimp logit dimed sumformal tpmaj tpdicont sameregion kgd06endriv capratio Fatality numdisp territor if defense>0, cluster(midnum)
setx sumformal 0 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi
setx sumformal 12 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi 
setx sumformal 24 tpmaj 0 tpdicont 0 kgd06endriv 0 Fatality 0 capratio mean numdisp 2 territor 0
simqi 
drop b1-b10
