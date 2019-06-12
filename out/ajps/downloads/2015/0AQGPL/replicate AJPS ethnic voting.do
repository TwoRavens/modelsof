/* FEARON GROUPS */


use ethnicvoting, clear

drop if grouptype~="fearon"


/*
* Figure 2 top: GVF vs PVF


graph twoway   (line PVF PVF, lcolor(black))  ///
 (scatter VF PVF, mlabel(ctry_yr)   mlabsize(vsmall)  mlabcolor(black)  ///
 ytitle(Group Voting Fractionalization, color(black))title(Fractionalization-based measures, color(black)) xtitle(Party Voting Fractionalization, color(black)) graphregion(fcolor(white) ///
 ifcolor(white))  msymbol(O) msize(small) mcolor(black)legend(off))

graph export "GVF_PVF.pdf", replace

* Figure 2 bottom: GVP vs PVP

graph twoway   (line PVP PVP, lcolor(black))  ///
 (scatter VP PVP, mlabel(ctry_yr)   mlabsize(vsmall)  mlabcolor(black)  ///
 ytitle(Group Voting Polarization, color(black))title(Polarization-based measures, color(black)) xtitle(Party Voting Polarization, color(black)) graphregion(fcolor(white) ///
 ifcolor(white))  msymbol(O) msize(small) mcolor(black)legend(off))

graph export "GVP_PVP.pdf", replace

*/

* Correlations in Table 2
pwcorr ELF_ethnic EP_ethnic VF VP PVF PVP ratio1, obs

corrtex ELF_ethnic EP_ethnic VF VP PVF PVP ratio1,  dig(2) file(fearon_correlations) replace  




* Table 3 regressions

reg VF_std lndm_std ELF_std ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m1a, title((1a))
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m1b, title((1b))
reg VF_std pr ELF_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3 , cluster(ccode)
estimates store m1c, title((1c))

reg VP_std lndm_std EP_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3   , cluster(ccode)
estimates store m2a, title((2a))
reg VP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   , cluster(ccode)
estimates store m2b, title((2b))
reg VP_std pr EP_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3   , cluster(ccode)
estimates store m2c,   title((2c))

reg PVF_std lndm_std ELF_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3    , cluster(ccode)
estimates store m3a, title((3a))
reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m3b, title((3b))
reg PVF_std pr ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m3c, title((3c))

reg PVP_std lndm_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   , cluster(ccode)
estimates store m4a, title((4a))
reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m4b, title((4b))
reg PVP_std pr EP_std  ratio1  lngdp polity2 fed resseg_std    wvs  afro2 afro3   , cluster(ccode)
estimates store m4c, title((4c))


estout  m1a m1b m1c m2a m2b m2c m3a m3b m3c m4a m4b m4c  using table3.txt, replace cells(b(star fmt(3)) se(par))  style(tex)  ///             stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///           legend label collabels(none) varlabels(_cons Constant ELF_std ELF EP_std EP  ///
          EV_std "Ethnic Voting" VF_std "Voting Frac." VP_std "Voting Polar." ///
          lndm_std "Avg.DM (ln)" propmmd_std "Prop. MMD" ///          cf_std "CF(std)" bgi_std "BGI(std)" lngdp_std  "(ln)GDP" ///
          resseg_std "Geo. Isol."  fed Federalism  ///          polity2_std "Polity2" wvs WVS cses CSES  ///
          ELF_smd "ELF*SMD" ELF_pr "ELF*PR" afro2 "Afrobarometer 2" afro3 "Afrobarometer 3" ///          afrobarom Afrobarometer wvs WVS cses CSES pr PR fed Federalism ) ///           starlevels(* .10 ** .05 *** .01)
 
 
 *Table C in supplemental materials
           
* Robustness on subsets of data
*Eliminate ELF<.2
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if ELF_e>.2, cluster(ccode)
estimates store m5a, title((5a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if ELF_e>.2, cluster(ccode)
estimates store m5b, title((5b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   if ELF_e>.2, cluster(ccode)
estimates store m5c, title((5c))




cap egen largestparty=rmax(partysize*)

*Eliminate ELF<.2& largest party >.7
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m6a, title((6a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m6b, title((6b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   if ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m6c, title((6c))


*Eliminate ELF<.2& largest party >.7& not afrobarometer2
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro3  if ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m7a, title((7a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro3  if ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m7b, title((7b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro3   if ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m7c, title((7c))



estout  m5a m5b m5c m6a m6b m6c m7a m7b m7c   using tableC.txt, replace cells(b(star fmt(3)) se(par))  style(tex)  ///             stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///           legend label collabels(none) varlabels(_cons Constant ELF_std ELF EP_std EP  ///
          EV_std "Ethnic Voting" VF_std "Voting Frac." VP_std "Voting Polar." ///
          lndm_std "Avg.DM (ln)" propmmd_std "Prop. MMD" ///          cf_std "CF(std)" bgi_std "BGI(std)" lngdp_std  "(ln)GDP" ///
          resseg_std "Geo. Isol."  fed Federalism  ///          polity2_std "Polity2" wvs WVS cses CSES  ///
          ELF_smd "ELF*SMD" ELF_pr "ELF*PR" afro2 "Afrobarometer 2" afro3 "Afrobarometer 3" ///          afrobarom Afrobarometer wvs WVS cses CSES pr PR fed Federalism ) ///           starlevels(* .10 ** .05 *** .01)

* Table 5 regressions with parties/groups as DV

reg ratio1 propmmd, cluster(country)
estimates store m1, title((1))
reg ratio1 propmmd ELF_e, cluster(country)
estimates store m2, title((2))
reg ratio1 propmmd ELF_e  lngdp polity2 fed resseg_std  , cluster(country)
estimates store m3, title((3))
reg ratio1 propmmd ELF_e  lngdp polity2 fed  , cluster(country)
estimates store m4, title((4))



estout  m1 m2 m3 m4   using table5.txt, replace cells(b(star fmt(3)) se(par))  style(tex)  ///             stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///           legend label collabels(none) varlabels(_cons Constant ELF_std ELF EP_std EP  ///
          EV_std "Ethnic Voting" VF_std "Voting Frac." VP_std "Voting Polar." ///
          lndm_std "Avg.DM (ln)" propmmd_std "Prop. MMD" ///          cf_std "CF(std)" bgi_std "BGI(std)" lngdp_std  "(ln)GDP" ///
          resseg_std "Geo. Isol."  fed Federalism  ///          polity2_std "Polity2" wvs WVS cses CSES  ///
          ELF_smd "ELF*SMD" ELF_pr "ELF*PR" afro2 "Afrobarometer 2" afro3 "Afrobarometer 3" ///          afrobarom Afrobarometer wvs WVS cses CSES pr PR fed Federalism ) ///           starlevels(* .10 ** .05 *** .01)




/* Correlations between electoral law and ELF/EP discussed in section entitled
"Why should proportional representation be associated with lower levels of ethnic voting?"
*/


sort country lndm
drop if country==country[_n-1]&lndm==lndm[_n-1]


pwcorr ELF_e EP_e lndm propmmd largestgroup smallgroup, obs sig






/* ENDOGENOUSLY DEFINED GROUPS */

use ethnicvoting, clear



drop VF_std VP_std PVF_std PVP_std 
egen VFmax=max(VF),by(country survey year)
egen VPmax=max(VP),by(country survey year)
egen PVFmax=max(PVF),by(country survey year)
egen PVPmax=max(PVP),by(country survey year)


gen fearonVF=0
replace fearonVF=1 if VFmax==VF& lngdp~=.& polity2~=.& fed~=.& country_isolation~=.&ELF_e~=.&grouptype=="fearon"

tab fearonVF

gen fearonPVP=0
replace fearonPVP=1 if PVPmax~=PVP& lngdp~=.& polity2~=.& fed~=.& country_isolation~=.&ELF_e~=.&grouptype=="fearon"

 tab fearonPVP


sort country survey year 
drop if country==country[_n-1]&survey==survey[_n-1]&year==year[_n-1]



drop VF VP PVF PVP
rename VFmax VF
rename VPmax VP
rename PVFmax PVF
rename PVPmax PVP


egen VF_std=std(VF)
egen VP_std=std(VP)
egen PVF_std=std(PVF)
egen PVP_std=std(PVP)

cap gen ratio1=numparties/numgroups

/* Table D in supplemental materials  */
* All data
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m8a, title((8a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  , cluster(ccode)
estimates store m8b, title((8b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   , cluster(ccode)
estimates store m8c, title((8c))



* Robustness on subsets of data
*Eliminate ELF<.2
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if ELF_e>.2, cluster(ccode)
estimates store m9a, title((9a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if  ELF_e>.2, cluster(ccode)
estimates store m9b, title((9b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   if  ELF_e>.2, cluster(ccode)
estimates store m9c, title((9c))




cap egen largestparty=rmax(partysize*)

*Eliminate ELF<.2& largest party >.7
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if  ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m10a, title((10a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro2 afro3  if  ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m10b, title((10b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro2 afro3   if  ELF_e>.2&largestparty<=.7, cluster(ccode)
estimates store m10c, title((10c))


*Eliminate ELF<.2& largest party >.7& not afrobarometer2
reg VF_std propmmd_std ELF_std  ratio1   lngdp polity2 fed resseg_std   wvs  afro3  if  ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m11a, title((11a))


reg PVF_std propmmd_std ELF_std ratio1   lngdp polity2 fed resseg_std   wvs  afro3  if  ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m11b, title((11b))

reg PVP_std propmmd_std EP_std  ratio1  lngdp polity2 fed resseg_std   wvs  afro3   if  ELF_e>.2&largestparty<=.7&afro2==0, cluster(ccode)
estimates store m11c, title((11c))


estout  m8a m8b m8c m9a m9b m9c m10a m10b m10c m11a m11b m11c  using tableD.txt, replace cells(b(star fmt(3)) se(par))  style(tex)  ///             stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///           legend label collabels(none) varlabels(_cons Constant ELF_std ELF EP_std EP  ///
          EV_std "Ethnic Voting" VF_std "Voting Frac." VP_std "Voting Polar." ///
          lndm_std "Avg.DM (ln)" propmmd_std "Prop. MMD" ///          cf_std "CF(std)" bgi_std "BGI(std)" lngdp_std  "(ln)GDP" ///
          resseg_std "Geo. Isol."  fed Federalism  ///          polity2_std "Polity2" wvs WVS cses CSES  ///
          ELF_smd "ELF*SMD" ELF_pr "ELF*PR" afro2 "Afrobarometer 2" afro3 "Afrobarometer 3" ///          afrobarom Afrobarometer wvs WVS cses CSES pr PR fed Federalism ) ///           starlevels(* .10 ** .05 *** .01)
