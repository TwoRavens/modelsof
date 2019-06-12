* Stata/MP 13.1 for Mac (64-bit Intel)

* Change directory to location where replication files have been downloaded

use "data.for.analysis.dta", clear

**** Online Appendix A ****

*** Table 1: Summary Statistics ***
sum ctIDdistance , detail
sum berryCitDif , detail
sum bornInCitedState, detail
sum distanceS, detail
sum diffPopMil, detail
sum citedSquireProf, detail
sum citedLegCapS, detail
sum citedPopMil, detail
sum s2sCites2, detail
sum s2sCitesCrim2, detail
sum s2sCitesCivil2, detail
sum citedTortScore, detail
tab geobucket
tab sameMethod
tab citedElected
tab citingElected
tab citedLA
tab citingLA


*** Table 2 ***
* Outward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount  crimCiteCount civilCiteCount, by(citingCourt citingMethod citingWestRegion)
order citingCourt citeCount crimCiteCount civilCiteCount citingMethod citingWestRegion
list

* Inward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount  crimCiteCount civilCiteCount, by(citedCourt)
order citedCourt citeCount crimCiteCount civilCiteCount
list


*** Table 3 ***
* Judicial Selection - Outward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount crimCiteCount civilCiteCount, by(citingCourt citingMethod)
collapse (mean) citeCount crimCiteCount civilCiteCount, by(citingMethod)
list
* Judicial Selection - Inward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount crimCiteCount civilCiteCount, by(citedCourt citedMethod)
collapse (mean) citeCount crimCiteCount civilCiteCount, by(citedMethod)
order citedMethod citeCount crimCiteCount civilCiteCount
list
* West Region - Outward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount crimCiteCount civilCiteCount, by(citingCourt citingWestRegion)
collapse (mean) citeCount crimCiteCount civilCiteCount, by(citingWestRegion)
order citingWestRegion  citeCount crimCiteCount civilCiteCount
list
* West Region - Inward Citations
use "data.for.analysis.dta", clear
collapse (sum) citeCount crimCiteCount civilCiteCount, by(citedCourt citedWestRegion)
collapse (mean) citeCount crimCiteCount civilCiteCount, by(citedWestRegion)
order citedWestRegion citeCount crimCiteCount civilCiteCount
list


*** Table 4: Predicted Outcomes ***
** Model 1 - All
use "data.for.analysis.dta", clear
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post
estimates store baseline
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=(0 1 2 3 4 5 6 7) sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post 
estimates store west
estout baseline west, cells("b(star fmt(2))") starlevels(* 0.05)
display 2.42 - 1.89
display 2.33 - 1.89
display 1.84 - 1.89
display 2.69 - 1.89
display 3.31 - 1.89
display 2.85 - 1.89
display 3.37 - 1.89

nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=(.32 1.13) berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store idcourt
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=(7.06 26.39) bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store idcit
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=(.11 .71) distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store culink
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=(6.04 15.78) diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store dis
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=(1.73 8.48) geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store difpop
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=(0 1) citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store meth
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=(.48 .67) citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store prof
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=(2.23 7.21) citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store cap
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=(1.84 7.36) citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store pop
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=(0 1) citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store elecj
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=(0 1) citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store eleci
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=(0 1) citedLA=0 citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store lai
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=(0 1) citedTortScore=61.25 s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store laj
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=(55.65 64.8) s2sCites2=108) post contrast(atcontrast(ar._at))
estimates store tort
nbreg citeCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCites2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCites2=(70 157)) post contrast(atcontrast(ar._at))
estimates store cites
estout idcourt idcit culink dis difpop meth prof cap pop elecj eleci laj lai cites tort, cells("b(star fmt(2))") starlevels(* 0.05)

** Model 2 - Criminal
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post 
estimates store baseline
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=(0 1 2 3 4 5 6 7) sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post
estimates store west
estout baseline west
display .56 - .46
display .65 - .46
display .35 - .46
display .59 - .46
display .68 - .46
display .60 - .46
display .58 - .46

nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=(.32 1.13) berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store idcourt
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=(7.06 26.39) bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store idcit
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=(.11 .71) distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store culink
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=(6.04 15.78) diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store dis
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=(1.73 8.48) geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store difpop
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=(0 1) citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store meth
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=(.48 .67) citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store prof
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=(2.23 7.21) citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store cap
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=(1.84 7.36) citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store pop
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=(0 1) citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store elecj
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=(0 1) citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store eleci
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=(0 1) citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store laj
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=(0 1) citedLA=0 citedTortScore=61.25 s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store lai
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCrim2=(13 50)) post contrast(atcontrast(ar._at))
estimates store cites
nbreg crimCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCrim2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=(55.65 64.8) s2sCitesCrim2=23) post contrast(atcontrast(ar._at))
estimates store tort
estout idcourt idcit culink dis difpop meth prof cap pop elecj eleci laj lai cites tort, cells("b(star fmt(2))") starlevels(* 0.05)

** Model 3 - Civil
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post
estimates store baseline
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=(0 1 2 3 4 5 6 7) sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post 
estimates store west
estout baseline west, cells("b(star fmt(2))") starlevels(* 0.05)
display 1.67 - 1.29
display 1.65 - 1.29
display 1.44 - 1.29
display 1.97 - 1.29
display 2.57 - 1.29
display 2.23 - 1.29
display 2.67 - 1.29

nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=(.32 1.13) berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store idcourt
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=(7.06 26.39) bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store idcit
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=(.11 .71) distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store culink
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=(6.04 15.78) diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store dis
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=(1.73 8.48) geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store difpop
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=(0 1) citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store meth
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=(.48 .67) citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store prof
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=(2.23 7.21) citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store cap
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=(1.84 7.36) citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store pop
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=(0 1) citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store elecj
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=(0 1) citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store eleci
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=(0 1) citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store laj
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=(0 1) citedLA=0 citedTortScore=61.25 s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store lai
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=61.25 s2sCitesCivil2=(46 117)) post contrast(atcontrast(ar._at))
estimates store cites
nbreg civilCiteCount ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil i.geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citedLA citingLA s2sCitesCivil2 citedTortScore, cluster(citingCourt)
margins, at(ctIDdistance=.67 berryCitDif=15.08 bornInCitedState=.28 distanceS=9.96 diffPopMil=3.9 geobucket=0 sameMethod=0 citedSquireProf=.58 citedLegCapS=4.47 citedPopMil=4.44 citedElected2=0 citingElected2=0 citingLA=0 citedLA=0 citedTortScore=(55.65 64.8) s2sCitesCivil2=74) post contrast(atcontrast(ar._at))
estimates store tort
estout idcourt idcit culink dis difpop meth prof cap pop elecj eleci laj lai cites tort, cells("b(star fmt(2))") starlevels(* 0.05)

