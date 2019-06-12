
set more off

set seed 123456789

preserve 

* Variable labels as reported in the manuscript 

label var acc1nomvx "ACC State A
label var majmaj "Major-Major
label var minmaj "Minor-Major
label var majmin "Major-Minor
label var powerratio "Powerratio
label var allies "Allies
label var s_wt_glo "Portfolio Similarity
label var s_ld_1 "Regional Similarity A
label var s_ld_2 "Regional Similarity B
label var contig400 "Contiguity
label var terr1 "Territory
label var regime1 "Regime
label var policy1 "Policy
label var other1 "Other

label var personal1w "Personalist
label var single1w "Single-Party
label var military1w "Military
label var hybrid1w "Hybrid
label var other1w "Other Autocracy
label var dynastic1w "Dynastic
label var nondynastic1w "Non-Dynastic
label var interregnaw "Interregna Aut
label var interregnademw "Interregna Dem

label var d6a "Democracy


* Table 3

* Model 1, all disputes, 1946-2000
logit cowrecipx acc1nomvx majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* Model 2: Weeks model through 2000
logit cowrecipx personal1w single1w military1w hybrid1w other1w dynastic1w nondynastic1w interregnaw interregnademw majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* Model 3: ACC + Weeks
logit cowrecipx acc1nomvx personal1w single1w military1w hybrid1w other1w dynastic1w nondynastic1w interregnaw interregnademw majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* Model 4, ACC all disputes, 1816-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1, cluster(cwkeynum)

* Model 5, all disputes, 1816-1945
logit cowrecipx acc1nomvx  majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year <= 1945 & originator ==1, cluster(cwkeynum)

* Model 6, ACC decomposed into lowACC_Autocracy, lowACC_Democracy, highACC_autocracy
* Base category = highACC_democracy
* Democracy = Polity2 score >= 6
* Low ACC = ACC = 0 or 1; High ACC = ACC = 2 or 3
* Model 6, all disputes, 1946-2000
logit cowrecipx   lowaccautoc lowaccdemoc highaccautoc majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)


* Footnote 10: Autocracies only, different time periods

*  Only Autocracies, 1946-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & d6a==0 & originator ==1, cluster(cwkeynum)

* Only Autocracies, 1816-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if d6a==0 & originator ==1, cluster(cwkeynum)


* Footnote 10: Bilateral disputes only, different time periods

* Bilateral disputes, 1946-2000

logit cowrecipx acc1nomvx majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1 & bilateral==1, cluster(cwkeynum)

* Bilateral disputes, 1816-2000

logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral ==1, cluster(cwkeynum)

* Bilateral only disputes, 1816-2000, drop World War years (1914-1918, 1939-1945)

logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral ==1 & worldwar !=1, cluster(cwkeynum)


* Footnote 10: Politically relevant dyads only

*  Politically relevant dyads, all disputes, 1946-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & pol_rel==1 & originator ==1, cluster(cwkeynum)

*  Politically relevant dyads, all disputes, 1816-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if pol_rel==1 & originator ==1, cluster(cwkeynum)


*  Politically relevant dyads, Only Autocracies, 1946-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & d6a==0 & originator ==1 & pol_rel==1, cluster(cwkeynum)

* Politically relevant dyads, Only Autocracies, 1816-2000
logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if d6a==0 & originator ==1 & pol_rel==1, cluster(cwkeynum)


* Politically relevant dyads, Bilateral disputes, 1946-2000

logit cowrecipx acc1nomvx majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1 & bilateral==1 & pol_rel==1, cluster(cwkeynum)

* Politically relevant dyads, Bilateral disputes, 1816-2000

logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral ==1 & pol_rel==1, cluster(cwkeynum)

* Politically relevant dyads, Bilateral only disputes, 1816-2000, drop World War years (1914-1918, 1939-1945)

logit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral ==1 & worldwar !=1 & pol_rel==1, cluster(cwkeynum)



* More checks on Model 6: ACC decomposed into xrmod and parcomp dummy variables; parcomp dichotomized at 0

* all disputes, 1946-2000
logit cowrecipx   xrmod1nomvx parmodnomvdum1x parxrnomvdum1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* ACC decomposed, bilateral, 1946-2000
logit cowrecipx   xrmod1nomvx parmodnomvdum1x parxrnomvdum1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1 & bilateral==1, cluster(cwkeynum)

* ACC decomposed, all disputes, 1816-2000
logit cowrecipx   xrmod1nomvx parmodnomvdum1x parxrnomvdum1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1, cluster(cwkeynum)

* ACC decomposed, bilateral, 1816-2000
logit cowrecipx   xrmod1nomvx parmodnomvdum1x parxrnomvdum1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral==1, cluster(cwkeynum)


* Footnote 6: ACC with Polity scores of -88, -77, and -66 coded as missing

* Model 1, all disputes, 1946-2000
logit cowrecipx acc1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* Model 3: ACC + Weeks: Response to Point 4 in the Memo

logit cowrecipx acc1x personal1w single1w military1w hybrid1w other1w dynastic1w nondynastic1w interregnaw interregnademw majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)

* Model 4, ACC all disputes, 1816-2000
logit cowrecipx acc1x   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1, cluster(cwkeynum)

* Model 5, all disputes, 1816-1945
logit cowrecipx acc1x  majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year <= 1945 & originator ==1, cluster(cwkeynum)

* ACC and Polity all disputes, 1946-2000
logit cowrecipx acc1x polity majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, cluster(cwkeynum)


*  Only Autocracies, 1946-2000
logit cowrecipx acc1x   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & d6a==0 & originator ==1, cluster(cwkeynum)

* Only Autocracies, 1816-2000
logit cowrecipx acc1x   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if d6a==0 & originator ==1, cluster(cwkeynum)

* Bilateral disputes, 1946-2000

logit cowrecipx acc1x majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1 & bilateral==1, cluster(cwkeynum)

* Bilateral disputes, 1816-2000

logit cowrecipx acc1x   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1 & bilateral ==1, cluster(cwkeynum)



* clogit models: Footnote 13

* Model 1, all disputes, 1946-2000
clogit cowrecipx acc1nomvx majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, group(ccode2) robust

* Model 2: Weeks model through 2000
clogit cowrecipx personal1w single1w military1w hybrid1w other1w dynastic1w nondynastic1w interregnaw interregnademw majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, group(ccode2) robust

* Model 3: ACC + Weeks

clogit cowrecipx acc1nomvx personal1w single1w military1w hybrid1w other1w dynastic1w nondynastic1w interregnaw interregnademw majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if year>1945 & year<=2000 & originator ==1, group(ccode2) robust

* Model 4, ACC all disputes, 1816-2000
clogit cowrecipx acc1nomvx   majmaj minmaj majmin powerratio allies  s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1 if originator ==1, group(ccode2) robust


restore

* Difference-of-means tests reported on page 25 of the manuscript 

/* Is there a difference in reciprocation rates between low-ACC autocracies
and low-ACC democracies? 
lowacc = 0 = ACC score of 0 or 1 and Polity index score below 6 (i.e. autocracies)
lowacc = 1 = ACC score of 0 or 1 and Polity index score 6 or higher (i.e. democracies) */

ttest cowrecipx, by(lowacc)


/* Is there a difference in reciprocation rates between high-ACC autocracies
and high-ACC democracies? 
highacc = 0 = ACC score of 2 or 3 and Polity index score below 6 (i.e. autocracies)
highacc = 1 = ACC score of 2 or 3 and Polity index score 6 or higher (i.e. democracies) */

ttest cowrecipx, by(highacc)

/* Is there a difference in reciprocation rates between low-ACC autocracies
and high-ACC autocracies? 
autocacc = 0 = ACC score of 0 or 1 and Polity index score below 6 (i.e. autocracies)
autocacc = 1 = ACC score of 2 or 3 and Polity index score below 6 (i.e. autocracies) */

ttest cowrecipx, by(autocacc)

/* Is there a difference in reciprocation rates between low-ACC democracies
and high-ACC democracies? 
democacc = 0 = ACC score of 0 or 1 and Polity index score 6 or higher (i.e. democracies)
democacc = 1 = ACC score of 2 or 3 and Polity index score 6 or higher (i.e. democracies) */

ttest cowrecipx, by(democacc)
