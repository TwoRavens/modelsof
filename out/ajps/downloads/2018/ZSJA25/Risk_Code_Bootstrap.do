matrix results1=J(100,12,.)
matrix results2=J(100,48,.)
matrix results3=J(100,24,.)
matrix results4=J(100,24,.)
matrix results5=J(100,24,.)
matrix results6=J(100,24,.)

forvalues i = 1(1)100 {
display `i'
quietly use Risk_Data_Bootstrap_Base.dta, clear
quietly bsample, strata(index) cluster(responseid)

quietly gen p_harm_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="harm" & risknum==`value'
quietly predict p_harmx if risknum==`value'
quietly replace p_harm_risk=p_harmx if risknum==`value'
quietly drop p_harmx
}
quietly drop if index=="harm"

quietly gen p_fairness_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="fairness" & risknum==`value'
quietly predict p_fairnessx if risknum==`value'
quietly replace p_fairness_risk=p_fairnessx if risknum==`value'
quietly drop p_fairnessx
}
quietly drop if index=="fairness"

quietly gen p_responsibility_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint[pweight=rakewt] if index=="responsibility" & risknum==`value'
quietly predict p_responsibilityx if risknum==`value'
quietly replace p_responsibility_risk=p_responsibilityx if risknum==`value'
quietly drop p_responsibilityx
}
quietly drop if index=="responsibility"

quietly gen p_worry_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="worry" & risknum==`value'
quietly predict p_worryx if risknum==`value'
quietly replace p_worry_risk=p_worryx if risknum==`value'
quietly drop p_worryx
}
quietly drop if index=="worry"

quietly gen p_longterm_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="longterm" & risknum==`value', cluster(responseid)
quietly predict p_longtermx if risknum==`value'
quietly replace p_longterm_risk=p_longtermx if risknum==`value'
drop p_longtermx
}
quietly drop if index=="longterm"

quietly gen p_disaster_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="disaster" & risknum==`value', cluster(responseid)
quietly predict p_disasterx if risknum==`value'
quietly replace p_disaster_risk=p_disasterx if risknum==`value'
quietly drop p_disasterx
}

keep if index=="priorityt"

gen rep_harm = republican*p_harm_r
gen rep_fairness = republican* p_fairness_r
gen rep_responsibility = republican* p_responsibility_r
gen rep_longterm=republican* p_longterm_r
gen rep_disaster=republican* p_disaster_r
gen rep_worry=republican* p_worry_r

gen dem_harm = democrat* p_harm_r
gen dem_fairness = democrat* p_fairness_r
gen dem_responsibility = democrat* p_responsibility_r
gen dem_longterm=democrat* p_longterm_r
gen dem_disaster=democrat* p_disaster_r
gen dem_worry=democrat* p_worry_r

gen female_harm = female* p_harm_r
gen female_fairness = female* p_fairness_r
gen female_responsibility = female* p_responsibility_r
gen female_longterm=female* p_longterm_r
gen female_disaster=female* p_disaster_r
gen female_worry=female* p_worry_r

gen college_harm = college* p_harm_r
gen college_fairness = college* p_fairness_r
gen college_responsibility = college* p_responsibility_r
gen college_longterm=college* p_longterm_r
gen college_disaster=college* p_disaster_r
gen college_worry=college* p_worry_r

gen white_harm = white* p_harm_r
gen white_fairness = white* p_fairness_r
gen white_responsibility = white* p_responsibility_r
gen white_longterm=white* p_longterm_r
gen white_disaster=white* p_disaster_r
gen white_worry=white* p_worry_r

gen hiosint_harm = hiosint* p_harm_r
gen hiosint_fairness = hiosint* p_fairness_r
gen hiosint_responsibility = hiosint* p_responsibility_r
gen hiosint_longterm=hiosint* p_longterm_r
gen hiosint_disaster=hiosint* p_disaster_r
gen hiosint_worry=hiosint* p_worry_r

gen higrid_harm = higrid* p_harm_r
gen higrid_fairness = higrid* p_fairness_r
gen higrid_responsibility = higrid* p_responsibility_r
gen higrid_longterm=higrid* p_longterm_r
gen higrid_disaster=higrid* p_disaster_r
gen higrid_worry=higrid* p_worry_r

gen higroup_harm = higroup* p_harm_r
gen higroup_fairness = higroup* p_fairness_r
gen higroup_responsibility = higroup* p_responsibility_r
gen higroup_longterm=higroup* p_longterm_r
gen higroup_disaster=higroup* p_disaster_r
gen higroup_worry=higroup* p_worry_r

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist [pweight=rakewt]

quietly matrix results1[`i',1]=_b[p_harm_risk]
quietly matrix results1[`i',2]=_b[p_fairness_risk]
quietly matrix results1[`i',3]=_b[p_responsibility_risk]
quietly matrix results1[`i',4]=_b[p_longterm_risk]
quietly matrix results1[`i',5]=_b[p_disaster_risk]
quietly matrix results1[`i',6]=_b[p_worry_risk]
quietly matrix results1[`i',7]=_b[rviolence]
quietly matrix results1[`i',8]=_b[renvironment]
quietly matrix results1[`i',9]=_b[rhealth]
quietly matrix results1[`i',10]=_b[rnatural]
quietly matrix results1[`i',11]=_b[rexist]
quietly matrix results1[`i',12]=_b[_cons]

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist rep_harm dem_harm college_harm hiosint_harm female_harm white_harm rep_fairness dem_fairness college_fairness hiosint_fairness female_fairness white_fairness rep_responsibility dem_responsibility college_responsibility hiosint_responsibility female_responsibility white_responsibility rep_longterm dem_longterm college_longterm hiosint_longterm female_longterm white_longterm rep_disaster dem_disaster college_disaster hiosint_disaster female_disaster white_disaster rep_worry dem_worry college_worry hiosint_worry female_worry white_worry [pweight=rakewt]

quietly matrix results2[`i',1]=_b[p_harm_risk]
quietly matrix results2[`i',2]=_b[p_fairness_risk]
quietly matrix results2[`i',3]=_b[p_responsibility_risk]
quietly matrix results2[`i',4]=_b[p_longterm_risk]
quietly matrix results2[`i',5]=_b[p_disaster_risk]
quietly matrix results2[`i',6]=_b[p_worry_risk]
quietly matrix results2[`i',7]=_b[rviolence]
quietly matrix results2[`i',8]=_b[renvironment]
quietly matrix results2[`i',9]=_b[rhealth]
quietly matrix results2[`i',10]=_b[rnatural]
quietly matrix results2[`i',11]=_b[rexist]
quietly matrix results2[`i',12]=_b[_cons]
quietly matrix results2[`i',13]=_b[rep_harm]
quietly matrix results2[`i',14]=_b[dem_harm] 
quietly matrix results2[`i',15]=_b[college_harm] 
quietly matrix results2[`i',16]=_b[hiosint_harm]
quietly matrix results2[`i',17]=_b[female_harm] 
quietly matrix results2[`i',18]=_b[white_harm] 
quietly matrix results2[`i',19]=_b[rep_fairness] 
quietly matrix results2[`i',20]=_b[dem_fairness] 
quietly matrix results2[`i',21]=_b[college_fairness] 
quietly matrix results2[`i',22]=_b[hiosint_fairness] 
quietly matrix results2[`i',23]=_b[female_fairness] 
quietly matrix results2[`i',24]=_b[white_fairness] 
quietly matrix results2[`i',25]=_b[rep_responsibility] 
quietly matrix results2[`i',26]=_b[dem_responsibility] 
quietly matrix results2[`i',27]=_b[college_responsibility] 
quietly matrix results2[`i',28]=_b[hiosint_responsibility] 
quietly matrix results2[`i',29]=_b[female_responsibility] 
quietly matrix results2[`i',30]=_b[white_responsibility] 
quietly matrix results2[`i',31]=_b[rep_longterm] 
quietly matrix results2[`i',32]=_b[dem_longterm] 
quietly matrix results2[`i',33]=_b[college_longterm] 
quietly matrix results2[`i',34]=_b[hiosint_longterm] 
quietly matrix results2[`i',35]=_b[female_longterm] 
quietly matrix results2[`i',36]=_b[white_longterm] 
quietly matrix results2[`i',37]=_b[rep_disaster] 
quietly matrix results2[`i',38]=_b[dem_disaster] 
quietly matrix results2[`i',39]=_b[college_disaster] 
quietly matrix results2[`i',40]=_b[hiosint_disaster] 
quietly matrix results2[`i',41]=_b[female_disaster] 
quietly matrix results2[`i',42]=_b[white_disaster] 
quietly matrix results2[`i',43]=_b[rep_worry] 
quietly matrix results2[`i',44]=_b[dem_worry] 
quietly matrix results2[`i',45]=_b[college_worry] 
quietly matrix results2[`i',46]=_b[hiosint_worry] 
quietly matrix results2[`i',47]=_b[female_worry] 
quietly matrix results2[`i',48]=_b[white_worry]

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist rep_harm dem_harm rep_fairness dem_fairness rep_responsibility dem_responsibility rep_longterm dem_longterm rep_disaster dem_disaster rep_worry dem_worry [pweight=rakewt]
quietly matrix results3[`i',1]=_b[p_harm_risk]
quietly matrix results3[`i',2]=_b[p_fairness_risk]
quietly matrix results3[`i',3]=_b[p_responsibility_risk]
quietly matrix results3[`i',4]=_b[p_longterm_risk]
quietly matrix results3[`i',5]=_b[p_disaster_risk]
quietly matrix results3[`i',6]=_b[p_worry_risk]
quietly matrix results3[`i',7]=_b[rviolence]
quietly matrix results3[`i',8]=_b[renvironment]
quietly matrix results3[`i',9]=_b[rhealth]
quietly matrix results3[`i',10]=_b[rnatural]
quietly matrix results3[`i',11]=_b[rexist]
quietly matrix results3[`i',12]=_b[_cons]
quietly matrix results3[`i',13]=_b[rep_harm]
quietly matrix results3[`i',14]=_b[dem_harm] 
quietly matrix results3[`i',15]=_b[rep_fairness] 
quietly matrix results3[`i',16]=_b[dem_fairness]
quietly matrix results3[`i',17]=_b[rep_responsibility] 
quietly matrix results3[`i',18]=_b[dem_responsibility] 
quietly matrix results3[`i',19]=_b[rep_longterm] 
quietly matrix results3[`i',20]=_b[dem_longterm] 
quietly matrix results3[`i',21]=_b[rep_disaster] 
quietly matrix results3[`i',22]=_b[dem_disaster] 
quietly matrix results3[`i',23]=_b[rep_worry] 
quietly matrix results3[`i',24]=_b[dem_worry] 

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist college_harm hiosint_harm college_fairness hiosint_fairness college_responsibility hiosint_responsibility college_longterm hiosint_longterm college_disaster hiosint_disaster college_worry hiosint_worry [pweight=rakewt]
quietly matrix results4[`i',1]=_b[p_harm_risk]
quietly matrix results4[`i',2]=_b[p_fairness_risk]
quietly matrix results4[`i',3]=_b[p_responsibility_risk]
quietly matrix results4[`i',4]=_b[p_longterm_risk]
quietly matrix results4[`i',5]=_b[p_disaster_risk]
quietly matrix results4[`i',6]=_b[p_worry_risk]
quietly matrix results4[`i',7]=_b[rviolence]
quietly matrix results4[`i',8]=_b[renvironment]
quietly matrix results4[`i',9]=_b[rhealth]
quietly matrix results4[`i',10]=_b[rnatural]
quietly matrix results4[`i',11]=_b[rexist]
quietly matrix results4[`i',12]=_b[_cons]
quietly matrix results4[`i',13]=_b[college_harm]
quietly matrix results4[`i',14]=_b[hiosint_harm] 
quietly matrix results4[`i',15]=_b[college_fairness] 
quietly matrix results4[`i',16]=_b[hiosint_fairness]
quietly matrix results4[`i',17]=_b[college_responsibility] 
quietly matrix results4[`i',18]=_b[hiosint_responsibility] 
quietly matrix results4[`i',19]=_b[college_longterm] 
quietly matrix results4[`i',20]=_b[hiosint_longterm] 
quietly matrix results4[`i',21]=_b[college_disaster] 
quietly matrix results4[`i',22]=_b[hiosint_disaster] 
quietly matrix results4[`i',23]=_b[college_worry] 
quietly matrix results4[`i',24]=_b[hiosint_worry]

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist female_harm white_harm female_fairness white_fairness female_responsibility white_responsibility female_longterm white_longterm female_disaster white_disaster female_worry white_worry [pweight=rakewt]
quietly matrix results5[`i',1]=_b[p_harm_risk]
quietly matrix results5[`i',2]=_b[p_fairness_risk]
quietly matrix results5[`i',3]=_b[p_responsibility_risk]
quietly matrix results5[`i',4]=_b[p_longterm_risk]
quietly matrix results5[`i',5]=_b[p_disaster_risk]
quietly matrix results5[`i',6]=_b[p_worry_risk]
quietly matrix results5[`i',7]=_b[rviolence]
quietly matrix results5[`i',8]=_b[renvironment]
quietly matrix results5[`i',9]=_b[rhealth]
quietly matrix results5[`i',10]=_b[rnatural]
quietly matrix results5[`i',11]=_b[rexist]
quietly matrix results5[`i',12]=_b[_cons]
quietly matrix results5[`i',13]=_b[female_harm]
quietly matrix results5[`i',14]=_b[white_harm] 
quietly matrix results5[`i',15]=_b[female_fairness] 
quietly matrix results5[`i',16]=_b[white_fairness]
quietly matrix results5[`i',17]=_b[female_responsibility] 
quietly matrix results5[`i',18]=_b[white_responsibility] 
quietly matrix results5[`i',19]=_b[female_longterm] 
quietly matrix results5[`i',20]=_b[white_longterm] 
quietly matrix results5[`i',21]=_b[female_disaster] 
quietly matrix results5[`i',22]=_b[white_disaster] 
quietly matrix results5[`i',23]=_b[female_worry] 
quietly matrix results5[`i',24]=_b[white_worry]

quietly logit outcome p_harm_risk p_fairness_risk p_responsibility_risk p_longterm_risk p_disaster_risk p_worry_risk rviolence renvironment rhealth rnatural rexist higrid_harm higroup_harm higrid_fairness higroup_fairness higrid_responsibility higroup_responsibility higrid_longterm higroup_longterm higrid_disaster higroup_disaster higrid_worry higroup_worry [pweight=rakewt]
quietly matrix results6[`i',1]=_b[p_harm_risk]
quietly matrix results6[`i',2]=_b[p_fairness_risk]
quietly matrix results6[`i',3]=_b[p_responsibility_risk]
quietly matrix results6[`i',4]=_b[p_longterm_risk]
quietly matrix results6[`i',5]=_b[p_disaster_risk]
quietly matrix results6[`i',6]=_b[p_worry_risk]
quietly matrix results6[`i',7]=_b[rviolence]
quietly matrix results6[`i',8]=_b[renvironment]
quietly matrix results6[`i',9]=_b[rhealth]
quietly matrix results6[`i',10]=_b[rnatural]
quietly matrix results6[`i',11]=_b[rexist]
quietly matrix results6[`i',12]=_b[_cons]
quietly matrix results6[`i',13]=_b[higrid_harm]
quietly matrix results6[`i',14]=_b[higroup_harm] 
quietly matrix results6[`i',15]=_b[higrid_fairness] 
quietly matrix results6[`i',16]=_b[higroup_fairness]
quietly matrix results6[`i',17]=_b[higrid_responsibility] 
quietly matrix results6[`i',18]=_b[higroup_responsibility] 
quietly matrix results6[`i',19]=_b[higrid_longterm] 
quietly matrix results6[`i',20]=_b[higroup_longterm] 
quietly matrix results6[`i',21]=_b[higrid_disaster] 
quietly matrix results6[`i',22]=_b[higroup_disaster] 
quietly matrix results6[`i',23]=_b[higrid_worry] 
quietly matrix results6[`i',24]=_b[higroup_worry]
}

svmat results1
svmat results2
svmat results3
svmat results4
svmat results5
svmat results6

rename results11 harm1
rename results12 fairness1
rename results13 responsibility1
rename results14 longterm1
rename results15 disaster1
rename results16 worry1
rename results17 violence1
rename results18 environment1
rename results19 health1
rename results110 natural1
rename results111 existential1
rename results112 constant1

rename results21 harm2
rename results22 fairness2
rename results23 responsibility2
rename results24 longterm2
rename results25 disaster2
rename results26 worry2
rename results27 violence2
rename results28 environment2
rename results29 health2
rename results210 natural2
rename results211 existential2
rename results212 constant2
rename results213 rep_harm2
rename results214 dem_harm2
rename results215 college_harm2 
rename results216 hiosint_harm2
rename results217 female_harm2
rename results218 white_harm2
rename results219 rep_fairness2 
rename results220 dem_fairness2 
rename results221 college_fairness2 
rename results222 hiosint_fairness2 
rename results223 female_fairness2 
rename results224 white_fairness2 
rename results225 rep_responsibility2 
rename results226 dem_responsibility2 
rename results227 college_responsibility2 
rename results228 hiosint_responsibility2 
rename results229 female_responsibility2 
rename results230 white_responsibility2 
rename results231 rep_longterm2
rename results232 dem_longterm2 
rename results233 college_longterm2 
rename results234 hiosint_longterm2 
rename results235 female_longterm2 
rename results236 white_longterm2 
rename results237 rep_disaster2 
rename results238 dem_disaster2 
rename results239 college_disaster2 
rename results240 hiosint_disaster2 
rename results241 female_disaster2 
rename results242 white_disaster2 
rename results243 rep_worry2 
rename results244 dem_worry2 
rename results245 college_worry2 
rename results246 hiosint_worry2 
rename results247 female_worry2 
rename results248 white_worry2

rename results31 harm3
rename results32 fairness3
rename results33 responsibility3
rename results34 longterm3
rename results35 disaster3
rename results36 worry3
rename results37 violence3
rename results38 environment3
rename results39 health3
rename results310 natural3
rename results311 existential3
rename results312 constant3
rename results313 rep_harm3
rename results314 dem_harm3
rename results315 rep_fairness3
rename results316 dem_fairness3
rename results317 rep_responsibility3
rename results318 dem_responsibility3
rename results319 rep_longterm3
rename results320 dem_longterm3
rename results321 rep_disaster3
rename results322 dem_disaster3
rename results323 rep_worry3
rename results324 dem_worry3

rename results41 harm4
rename results42 fairness4
rename results43 responsibility4
rename results44 longterm4
rename results45 disaster4
rename results46 worry4
rename results47 violence4
rename results48 environment4
rename results49 health4
rename results410 natural4
rename results411 existential4
rename results412 constant4
rename results413 college_harm4
rename results414 hiosint_harm4
rename results415 college_fairness4
rename results416 hiosint_fairness4
rename results417 college_responsibility4
rename results418 hiosint_responsibility4
rename results419 college_longterm4
rename results420 hiosint_longterm4
rename results421 college_disaster4
rename results422 hiosint_disaster4
rename results423 college_worry4
rename results424 hiosint_worry4

rename results51 harm5
rename results52 fairness5
rename results53 responsibility5
rename results54 longterm5
rename results55 disaster5
rename results56 worry5
rename results57 violence5
rename results58 environment5
rename results59 health5
rename results510 natural5
rename results511 existential5
rename results512 constant5
rename results513 female_harm5
rename results514 white_harm5
rename results515 female_fairness5
rename results516 white_fairness5
rename results517 female_responsibility5
rename results518 white_responsibility5
rename results519 female_longterm5
rename results520 white_longterm5
rename results521 female_disaster5
rename results522 white_disaster5
rename results523 female_worry5
rename results524 white_worry5

rename results61 harm6
rename results62 fairness6
rename results63 responsibility6
rename results64 longterm6
rename results65 disaster6
rename results66 worry6
rename results67 violence6
rename results68 environment6
rename results69 health6
rename results610 natural6
rename results611 existential6
rename results612 constant6
rename results613 higrid_harm6
rename results614 higroup_harm6
rename results615 higrid_fairness6
rename results616 higroup_fairness6
rename results617 higrid_responsibility6
rename results618 higroup_responsibility6
rename results619 higrid_longterm6
rename results620 higroup_longterm6
rename results621 higrid_disaster6
rename results622 higroup_disaster6
rename results623 higrid_worry6
rename results624 higroup_worry6

drop if harm1==.
keep harm1 fairness1 responsibility1 longterm1 disaster1 worry1 violence1 environment1 health1 natural1 existential1 constant1 harm2 fairness2 responsibility2 longterm2 disaster2 worry2 violence2 environment2 health2 natural2 existential2 constant2 rep_harm2 dem_harm2 college_harm2 hiosint_harm2 female_harm2 white_harm2 rep_fairness2 dem_fairness2 college_fairness2 hiosint_fairness2 female_fairness2 white_fairness2 rep_responsibility2 dem_responsibility2 college_responsibility2 hiosint_responsibility2 female_responsibility2 white_responsibility2 rep_longterm2 dem_longterm2 college_longterm2 hiosint_longterm2 female_longterm2 white_longterm2 rep_disaster2 dem_disaster2 college_disaster2 hiosint_disaster2 female_disaster2 white_disaster2 rep_worry2 dem_worry2 college_worry2 hiosint_worry2 female_worry2 white_worry2 harm3 fairness3 responsibility3 longterm3 disaster3 worry3 violence3 environment3 health3 natural3 existential3 constant3 rep_harm3 dem_harm3 rep_fairness3 dem_fairness3 rep_responsibility3 dem_responsibility3 rep_longterm3 dem_longterm3 rep_disaster3 dem_disaster3 rep_worry3 dem_worry3 harm4 fairness4 responsibility4 longterm4 disaster4 worry4 violence4 environment4 health4 natural4 existential4 constant4 college_harm4 hiosint_harm4 college_fairness4 hiosint_fairness4 college_responsibility4 hiosint_responsibility4 college_longterm4 hiosint_longterm4 college_disaster4 hiosint_disaster4 college_worry4 hiosint_worry4 harm5 fairness5 responsibility5 longterm5 disaster5 worry5 violence5 environment5 health5 natural5 existential5 constant5 female_harm5 white_harm5 female_fairness5 white_fairness5 female_responsibility5 white_responsibility5 female_longterm5 white_longterm5 female_disaster5 white_disaster5 female_worry5 white_worry5 harm6 fairness6 responsibility6 longterm6 disaster6 worry6 violence6 environment6 health6 natural6 existential6 constant6 higrid_harm6 higroup_harm6 higrid_fairness6 higroup_fairness6 higrid_responsibility6 higroup_responsibility6 higrid_longterm6 higroup_longterm6 higrid_disaster6 higroup_disaster6 higrid_worry6 higroup_worry6
