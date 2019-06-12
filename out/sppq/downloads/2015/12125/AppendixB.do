* Stata/MP 13.1 for Mac (64-bit Intel)

* Change directory to location where replication files have been downloaded

* Appendix B: Caldeira Replication 
use "data.for.analysis.appB.dta", clear

regress citesStandardized citedPrestige citedSquireProf citedPop2010 citedLegCap citedCaseload citedCaseload2 diffPrestige diffProf diffPop diffLegCap bornInCitedState distance distancesq bothAtlantic bothNE bothSE bothSouthern bothPacific bothNW 
estimates store rep
estout rep, cells("b(star) t(fmt(2))") starlevels(* 0.05) stats( N)  varlabels(_cons Constant) label 
