*STATA code to replicate Taylor, Pevehouse, and Straus "The Perils of Pluralism..."*

set more off

use PerilsPluralism1.dta

label var lnpcGDP_ "Per capita gdp"
label var entry21 "Path to Power"
label var first "Post War"
label var ongoing "Civil War"
label var incumbentprez_new "Incumbent running"
label var foundingff "Free/Fair First Elec"
label var previosumspl "Previous Violence"
label var postviosumspl "Previous Violence"
label var nelda45jp "Monitors"
label var previodum "Pre-Election Violence"
label var previolev "Pre-Election Violence"
label var postviodum "Post-Election Violence"
label var postviolev "Post-Election Violence"
label var democ_ "Democracy-Polity"
label var anoc_ "Anocracy-Polity"
label var logavedur "Social conflict"
label var democracy_ "Democracy"
label var ttd5 "Democratization"
label var tta5 "Autocratization"
label var nelda45jp "Observers"
label var compete1a "Likely incumbent victory"
label var compete2 "Incumbent Dominant"
label var pluralsys "Plurality system"
label var mixed "Mixed system"
label var incumbencynew "Incumbent running (alt)"
label var previouspostviolev "Lagged Post-Election Violence"
label var previouspreviolev "Lagged Pre-Election Violence"
label var date "Election Date"
label var ccode "COW country code"

**core models

*Table 1; column 1
ologit previolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing /// 
previosumspl democracy_ tta5 ttd5 , cluster(ccode)

outreg2 using printtable1, lab word dec(3) stat(coef se) replace 2aster

est store previo_olig

margins, dydx(incumbentprez_new) atmeans saving(file1, replace)

*left portion of Figure 2*
marginsplot, level(95) recast(scatter) yline(0)

**Alternative model: restricted incumbency coding [Appendix]
ologit previolev incumbencynew lnpcGDP_ entry21 first ongoing /// 
previosumspl democracy_ tta5 ttd5 , cluster(ccode)

*note models in online appendix have different destination file for the outreg command*
outreg2 using onlineapptable1, lab word dec(3) stat(coef se) replace 2aster

est store previo_olig_res

*Alternative model: ordered logit with social conflict var*

ologit previolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing /// 
previosumspl democracy_ tta5 ttd5 logavedur, cluster(ccode)

outreg2 using onlineapptable1, lab word dec(3) stat(coef se) append 2aster

est store previo_olig_scad

*Table 2; column 2

logit previodum i.incumbentprez_new lnpcGDP_ entry21 first ongoing /// 
previosumspl democracy_ tta5 ttd5 logavedur, cluster(ccode)

outreg2 using printtable1, lab word dec(3) stat(coef se) append 2aster

est store previo_logit

*creates right portion of Figure 2*
margins, dydx(incumbentprez_new) atmeans saving(file2, replace)

marginsplot, level(95) recast(scatter) yline(0)


*fixed-effects logit: pre-election violence
clogit previolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing /// 
previosumspl democracy_ tta5 ttd5 logavedur, group(ccode) vce(cluster ccode)

outreg2 using onlineapptable1, lab word dec(3) stat(coef se) append 2aster

est store previo_clogit

set scheme s2mono

*this command re-creates Figure 1*
coefplot (previo_olig, label(Ord. Logit) msymbol(t)) (previo_olig_res, label(Ord. Logit) msymbol(O)) ///
  (previo_olig_scad, label(Ord. Logit (SCAD)) msymbol(s)) ///
  (previo_logit, label(Logit) msymbol(x)) (previo_clogit, label(Cond. Logit) msymbol(o)), drop(_cons) xline(0) ///
 title("Pre-Election Violence") legend(row(1)) coeflabels(incumbencynew = "Incumbent (alt)") ///
 relocate(incumbentprez_new=1 incumbencynew=2 lnpcGDP_=3 entry21=4 first=5 ongoing=6 previosumspl=7 democracy_=8 tta5=9 ttd5=10)


***post-election violence models
*Table 2, Column 3

ologit postviolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing ///
 postviosumspl previodum democracy_ tta5 ttd5 , cluster(ccode)

outreg2 using printtable1, lab word dec(3) stat(coef se) append 2aster

est store postvio_olig

margins, dydx(incumbentprez_new) atmeans saving(file3, replace)

*creates left portion of Figure 4*
marginsplot, level(95) recast(scatter) yline(0)

*Alternative model: Restricted incumbency coding

ologit postviolev incumbencynew lnpcGDP_ entry21 first ongoing ///
 postviosumspl previodum democracy_ tta5 ttd5 , cluster(ccode)

outreg2 using onlineapptable2, lab word dec(3) stat(coef se) replace 2aster

est store postvio_olig_res

*Alternative model: includes social conflict (SCAD)*

ologit postviolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing ///
 postviosumspl previodum democracy_ tta5 ttd5 logavedur, cluster(ccode)

outreg2 using onlineapptable2, lab word dec(3) stat(coef se) append 2aster

est store postvio_olig_scad

*Table 2; column 4
logit postviodum i.incumbentprez_new lnpcGDP_ entry21 first ongoing ///
 postviosumspl previodum democracy_ tta5 ttd5 logavedur, cluster(ccode)

outreg2 using printtable1, lab word dec(3) stat(coef se) append 2aster

est store postvio_logit

*creates right portion of Figure 4*
margins, dydx(incumbentprez_new) atmeans saving(file4, replace)

marginsplot, level(95) recast(scatter)


*Fixed-effects model for post-election violence
clogit postviolev i.incumbentprez_new lnpcGDP_ entry21 first ongoing ///
 postviosumspl previodum democracy_ tta5 ttd5 logavedur, group(ccode) vce(cluster ccode)

outreg2 using onlineapptable2, lab word dec(3) stat(coef se) append 2aster

est store postvio_clogit

set scheme s2mono

*creates Figure 3*
coefplot (postvio_olig, label(Ord. logit) msymbol(t)) (postvio_olig_res, label(Ord. logit) msymbol(O))  ///
 (postvio_olig_scad, label(Ord. logit (SCAD)) msymbol(s)) ///
 (postvio_logit, label(Logit) msymbol(X)) (postvio_clogit, label(Cond. logit) msymbol(o)), drop(_cons) xline(0) ///
 title("Post-election violence") legend(row(1)) coeflabels(incumbencynew = "Incumbent (alt)") ///
 relocate(incumbentprez_new=1 incumbencynew=2 lnpcGDP_=3 entry21=4 first=5 ongoing=6 postviosumspl=7 previodum=8 democracy_=9 tta5=10 ttd5=11)

-------------------

**Appendix runs

** presence of monitors

ologit previolev lnpcGDP_ entry21 first incumbentprez_new ongoing /// 
democracy_ ttd5 tta5 previosumspl logavedur nelda45jp, cluster(ccode)

outreg2 using onlineapptable5, lab word dec(3) stat(coef se) replace 2aster

ologit postviolev lnpcGDP_ entry21 first incumbentprez_new ongoing /// 
democracy_ ttd5 tta5 postviosumspl previodum logavedur nelda45jp, cluster(ccode)

outreg2 using onlineapptable5, lab word dec(3) stat(coef se) append 2aster


** closeness of election


ologit previolev lnpcGDP_  entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5 previosumspl logavedur compete1a, cluster(ccode)

outreg2 using onlineapptable3, lab word dec(3) stat(coef se) replace 2aster

ologit previolev lnpcGDP_  entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5 previosumspl logavedur compete2, cluster(ccode)

outreg2 using onlineapptable3, lab word dec(3) stat(coef se) append 2aster

ologit postviolev lnpcGDP_  entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5 previosumspl previodum logavedur compete1a, cluster(ccode)

outreg2 using onlineapptable3, lab word dec(3) stat(coef se) append 2aster

ologit postviolev lnpcGDP_  entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5 previosumspl previodum logavedur compete2, cluster(ccode)

outreg2 using onlineapptable3, lab word dec(3) stat(coef se) append 2aster

** electoral type

ologit previolev lnpcGDP_  entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5 previosumspl logavedur pluralsys mixed, cluster(ccode)

outreg2 using onlineapptable5, lab word dec(3) stat(coef se) append 2aster

ologit postviolev lnpcGDP_ entry21 first incumbentprez_new ongoing /// 
democracy_ tta5 ttd5  postviosumspl previodum logavedur pluralsys mixed, cluster(ccode)

outreg2 using onlineapptable5, lab word dec(3) stat(coef se) append 2aster


** endogeneity checks

logit incumbentprez_new previouspostviolev, cluster(ccode)

outreg2 using onlineapptable4, lab word dec(3) stat(coef se) replace 2aster

logit incumbentprez_new previouspreviolev, cluster(ccode)

outreg2 using onlineapptable4, lab word dec(3) stat(coef se) append 2aster

logit incumbentprez_new previouspostviolev previouspreviolev, cluster(ccode)

outreg2 using onlineapptable4, lab word dec(3) stat(coef se) append 2aster





