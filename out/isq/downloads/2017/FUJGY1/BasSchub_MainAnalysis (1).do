**********************************************************************************
**** MUTUAL OPTIMISM AS A CAUSE OF CONFLICT: SECRET ALLIANCES AND CONFLICT ONSET 
**** BAS AND SCHUB
**** ISQ REPLICATION FILE 
**********************************************************************************

***********************
** CONTENTS OVERVIEW
***********************

* (I) Main results:
  * Manuscript Table 1: Models 1-4
  * Manuscript Table 2: Models 6-7
  * Online Appendix Table 2
  * Online Appendix Table 3
  * Online Appendix Table 5
  * Online Appendix Table 6
  * Manuscript Figure 2: Substantive Simulations 
  * Manuscript Figure 3: Substantive Simulations (partial)
  
* (II) Results dropping recent signers:
  * Manuscript Table 2: Model 5
  * Online Appendix Table 4
  * Manuscript Figure 3: Substantive Simulations (partial)

* (III) Results for target specific alliances:
  * Manuscript Table 2: Models 8-9
  * Online Appendix Table 7
  * Manuscript Figure 3: Substantive Simulations (partial)



*************************************************************************
** (I) Reproduce main results
*************************************************************************

clear
use "MOmain_BasSchub.dta"
 
** Manuscript Table 1: Models 1-4 ** 
logit mid msod relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit mid msodind relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
logit mid msodpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)

** Manuscript Table 2: Model 6
logit mid msdindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
** Manuscript Table 2: Model 7
logit mid msodindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)

** Online Appendix Table 2 (Summary Statistics)
summ msod msodind msodpri msodindpri relcap cont jdem2 ally pceyrs if ongomid==0

** Online Appendix Table 3 (Force as Outcome Variable): Models 1-4
logit force msod relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit force msodind relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
logit force msodpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit force msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)

** Online Appendix Table 5 (Secret Defensive Allies Only): Models 1-4
logit mid msd relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit mid msdind relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
logit mid msdpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit mid msdindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)

** Online Appendix Table 6 (Dyads with Allies Only): Models 1-4
logit mid msod relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)
logit mid msodind relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)
logit mid msodpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)
logit mid msodindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)

** Substantive Simulations Manuscript Figure 2: 
estsimp logit mid msodind relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx msodind 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msodind 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx msodindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msodindpri 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo5 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo5 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo5 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo10 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo10 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo10 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo15 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo15 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo15 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo20 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo20 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo20 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo25 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo25 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo25 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo30 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo30 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo30 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo35 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo35 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo35 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid mo40 relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx mo40 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(mo40 0 1) level(90)


** Substantive Simulations Manuscript Figure 3 (partial--base; defensive alliances; alliance dyads): 
drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx msodindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msodindpri 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid msdindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
setx median
setx msdindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msdindpri 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if (po11>0|po22>0|so11m>0|so22m>0|pd11>0|pd22>0|sd11m>0|sd22m>0) & ongomid==0 , cluster(dyad)
setx median
setx msodindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msodindpri 0 1) level(90)





*************************************************************************
** (II) Reproduce results dropping recent signers
*************************************************************************

clear
use "MOnorecentsigners_BasSchub.dta"

** Manuscript Table 2: Model 5
logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)

** Online Appendix Table 4 (Drop Recent Signers): Models 1-4
logit mid msod relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
logit mid msodind relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
logit mid msodpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)
logit mid msodindpri relcap ally cont jdem2 pceyrs pceyrs2 pceyrs3 if ongomid==0, cluster(dyad)

** Substantive Simulations Manuscript Figure 3 (partial--no recent signers):
estsimp logit mid msodindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 , cluster(dyad)
setx median
setx msodindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(msodindpri 0 1) level(90)






*************************************************************************
** (III) Reproduce results for target specific alliances
*************************************************************************

clear 
use "MOtargetspecific_BasSchub.dta"


** Manuscript Table 2: Models 8-9
logit mid motargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
logit mid monotargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)

** Online Appendix Table 7 (Target Specificty): Models 1-4
logit mid msodtind relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
logit mid motargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
logit mid monontargind relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
logit mid monotargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)

** Substantive Simulations Manuscript Figure 3 (partial--target specific; non-target specific):
estsimp logit mid motargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
setx median
setx motargindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(motargindpri 0 1) level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9
estsimp logit mid monotargindpri relcap cont jdem2 ally pceyrs pceyrs2 pceyrs3 if ongomid==0 & mox==0, cluster(dyad)
setx median
setx monotargindpri 0 pceyrs 3 pceyrs2 9 pceyrs3 27
simqi, listx fd(pr) changex(monotargindpri 0 1) level(90)





