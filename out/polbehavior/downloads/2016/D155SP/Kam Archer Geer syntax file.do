**********REPLICATION SYNTAX FOR *****
*Courting the Women's Vote
*Kam, Cindy D. Allison M. Archer, John G. Geer 
*Political Behavior
*Version 3 May 2016

*tip: create the directory "C:/PB Replication" and save the data file there

use "C:/PB Replication/Kam Archer Geer replication file.dta", clear
set more off
svyset [pweight=weight_ct]
cd "C:/PB REPLICATION"


*****ADS*****
recode video (1 3 4 8 9 10 11 13 14 15 17 18 19 20 21 22 23 24 25 26 28 29=1 "Negative")(2 5 6 7 12 16 27=0 "Positive")(else=.), gen(negativead)
recode video (1 4 6 7 10 11 12 13 16 17 19 20 24 25 27 29=1 "Pro Obama/Anti-Romney")(2 3 5 8 9 14 15 18 21 22 23 26 28= 0 "Pro-Romney/Anti-Obama")(else=.), gen(pro_O_anti_R_ad)

gen typead = .
replace typead = 1 if negativead==0 & pro_O_anti_R ==1
replace typead = 2 if negativead==1 & pro_O_anti_R ==1
replace typead = 3 if negativead==0 & pro_O_anti_R ==0
replace typead = 4 if negativead==1 & pro_O_anti_R ==0
lab def typead 1"Pro-Obama" 2"Anti-Romney" 3"Pro-Romney" 4"Anti-Obama"
lab val typead typead

//coding women's ads
recode video (7 22 26 =1)(else=0), gen(women_ad)
recode video (7 = 1)(else=0), gen(FL)
recode video (22 = 1)(else=0), gen(DD)
recode video (26 = 1)(else=0), gen(MEL)

*****COVARIATES*****
//PARTISANSHIP
recode pid7 (1 2 3=1 "Dem")(4=2 "Pure Ind")(5 6 7 = 3 "Rep")(else=.), gen(pid3pure)
replace pid3pure = . if pid7==4 & pid3==4
recode pid3pure (1=1 "Dem")(2 3=0)(else=.), gen(Dem)
recode pid3pure (3=1 "Rep")(1 2=0)(else=.), gen(Rep)
recode pid3pure (2=1 "Pure Ind")(1 3=0)(else=.), gen(PureInd)

//SEX OF RESPONDENT
recode gender (1=0 "Male")(2=1 "Female"), gen(female)

//EDUCATION
recode educ (1=0 "<HS")(2=.2)(3=.4)(4=.6)(5=.8)(6=1 "Postgrad")(else=.), gen(ed6cat)

//AGE
gen age01 = ((2012-birthyr)-18)/(102-18)

//ANALYZING WHITES ONLY
recode race (1=1)(2 3=0)(else=.), gen(white)
drop if white~=1

//MARITAL STATUS 
recode marstat (1 4 6=0 "married/partnered/widowed")(2 3 5=1 "single/divorced/separated")(else=.), gen(single)

//HOUSEHOLD INCOME
recode faminc (1/2=0 "<$20K")(3=.15)(4=.29)(5=.43)(6=.57)(7/8=.71)(9/10=.85)(11/31=1)(97=0)(else=.), gen(famincd)
recode faminc (1/31=0)(97=1)(else=.), gen(refinc)

//INTERACTIONS
gen femDem = female*Dem 
gen femRep = female*Rep

program FLvars
foreach v in Dem Rep {
gen FL`v'=FL*`v'
}
end
FLvars

program femFLvars
foreach v in FL FLDem FLRep {
gen fem`v'=female*`v'
}
end
femFLvars

program DDvars
foreach v in Dem Rep {
gen DD`v'=DD*`v'
}
end
DDvars

program femDDvars
foreach v in DD DDDem DDRep {
gen fem`v'=female*`v'
}
end
femDDvars

program MELvars
foreach v in Dem Rep {
gen MEL`v'=MEL*`v'
}
end
MELvars

program femMELvars
foreach v in MEL MELDem MELRep {
gen fem`v'=female*`v'
}
end
femMELvars

*****EMOTIONAL REACTIONS TO ADS
graph hbar q2_disgusted [pweight=weight_ct] , over(female, label(nolabels)) over(video, sort((mean) q2_disgusted) label(labsize(small))) ylabel(1 "Not at all" 2"Slightly" 3"Moderately" 4"Quite a Bit" 5 "Extremely") ytitle("Mean Level of Disgust") exclude0 scheme(s2color) blabel(group, size(vsmall)) ysize(8)
graph hbar q2_angry [pweight=weight_ct] , over(female, label(nolabels)) over(video, sort((mean) q2_angry) label(labsize(small))) ylabel(1 "Not at all" 2"Slightly" 3"Moderately" 4"Quite a Bit" 5 "Extremely") ytitle("Mean Level of Anger") exclude0 scheme(s2color) blabel(group, size(vsmall)) ysize(8)
graph hbar q2_worried [pweight=weight_ct] , over(female, label(nolabels)) over(video, sort((mean) q2_worried) label(labsize(small))) ylabel(1 "Not at all" 2"Slightly" 3"Moderately" 4"Quite a Bit" 5 "Extremely") ytitle("Mean Level of Worry") exclude0 scheme(s2color) blabel(group, size(vsmall)) ysize(8)
graph hbar q2_happy [pweight=weight_ct] , over(female, label(nolabels)) over(video, sort((mean) q2_happy) label(labsize(small))) ylabel(1 "Not at all" 2"Slightly" 3"Moderately" 4"Quite a Bit" 5 "Extremely") ytitle("Mean Level of Happy") exclude0 scheme(s2color) blabel(group, size(vsmall)) ysize(8)
graph hbar q2_hopeful [pweight=weight_ct] , over(female, label(nolabels)) over(video, sort((mean) q2_hopeful) label(labsize(small))) ylabel(1 "Not at all" 2"Slightly" 3"Moderately" 4"Quite a Bit" 5 "Extremely") ytitle("Mean Level of Hopeful") exclude0 scheme(s2color) blabel(group, size(vsmall)) ysize(8)

//RECODING EMOTIONAL REACTIONS
recode q2_disgusted q2_angry q2_worried q2_happy q2_hopeful (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(disgusted angry worried happy hopeful)
gen valence = (hopeful+happy)/2-(disgusted+worried+angry)/3
gen pos_valence = (hopeful+happy)/2
gen neg_valence = (disgusted+worried+angry)/3
corr valence pos_valence neg_valence
factor disgusted angry worried happy hopeful

svy: mean pos_valence if FL==1, over(female)
lincom [pos_valence]Male -[pos_valence]Female
svy: mean neg_valence if FL==1, over(female)
lincom [neg_valence]Male -[neg_valence]Female

svy: mean pos_valence if DD==1, over(female)
lincom [pos_valence]Male -[pos_valence]Female
svy: mean neg_valence if DD==1, over(female)
lincom [neg_valence]Male -[neg_valence]Female

svy: mean pos_valence if MEL==1, over(female)
lincom [pos_valence]Male -[pos_valence]Female
svy: mean neg_valence if MEL==1, over(female)
lincom [neg_valence]Male -[neg_valence]Female

svy: reg valence femFL* FL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==1
est store FL_all
test (femFL+FL)=0
svy: reg valence femDD* DD* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store DD_all
svy: reg valence femMEL* MEL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store MEL_all
//TABLE 1
est table FL_all DD_all MEL_all, b(%9.2f) star(.2 .1 .02) style(col) stats(N) 
est table FL_all DD_all MEL_all, b(%9.2f) se style(col) stats(N) 

//GENERATE GRAPHING DATASET
preserve
collapse female Dem Rep femDem femRep age01 ed6cat famincd refinc single 
replace female =0
replace refinc=0
replace single = 0
replace Dem = 0
replace Rep = 0
expand 3
replace Dem = 1 in 2
replace Rep = 1 in 3
expand 2
replace female = 1 in 4/6
replace femDem =female * Dem
replace femRep =female * Rep
lab def female2 0"male" 1"female"
lab val female female2
gen FL=.
expand 2
replace FL=1 in 1/6
replace FL=0 in 7/12
gen femFL=female*FL
gen femFLDem=female*FL*Dem
gen femFLRep=female*FL*Rep
gen FLDem=FL*Dem
gen FLRep=FL*Rep
gen DD=.
replace DD=1 in 1/6
replace DD=0 in 7/12
gen femDD=female*DD
gen femDDDem=female*DD*Dem
gen femDDRep=female*DD*Rep
gen DDDem=DD*Dem
gen DDRep=DD*Rep
gen MEL=.
replace MEL=1 in 1/6
replace MEL=0 in 7/12
gen femMEL=female*MEL
gen femMELDem=female*MEL*Dem
gen femMELRep=female*MEL*Rep
gen MELDem=MEL*Dem
gen MELRep=MEL*Rep
est restore FL_all
predict yhatFL
table female FL , c(mean yhatFL)
lab def FL 0"Comparison" 1"First Law"
lab val FL FL
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, IND") xtitle(" ") name(FL_IND, replace) ytitle("Emotional Valence") 
twoway (connected yhatFL FL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, DEM") xtitle(" ") name(FL_DEM, replace) ytitle("Emotional Valence")
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, GOP") xtitle(" ") name(FL_REP, replace) ytitle("Emotional Valence")
est restore DD_all
predict yhatDD
table female DD , c(mean yhatDD)
lab def DD 0"Comparison" 1"Dear Daughter"
lab val DD DD
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, IND") xtitle(" ") name(DD_IND, replace) ytitle("Emotional Valence")
twoway (connected yhatDD DD if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, DEM") xtitle(" ") name(DD_DEM, replace) ytitle("Emotional Valence")
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, GOP") xtitle(" ") name(DD_REP, replace) ytitle("Emotional Valence")
est restore MEL_all
predict yhatMEL
table female MEL , c(mean yhatMEL)
lab def MEL 0"Comparison" 1"Melanie"
lab val MEL MEL
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, IND") xtitle(" ") name(MEL_IND, replace) ytitle("Emotional Valence")
twoway (connected yhatMEL MEL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, DEM") xtitle(" ") name(MEL_DEM, replace) ytitle("Emotional Valence")
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, GOP") xtitle(" ") name(MEL_REP, replace) ytitle("Emotional Valence")
restore
graph combine FL_IND FL_DEM FL_REP DD_IND DD_DEM DD_REP MEL_IND MEL_DEM MEL_REP, col(3) ycommon ysize(8) xsize(6) altshrink 
graph export Figure1.tif, replace height(2400) width(1600) 

*****COGNITIVE REACTIONS TO ADS
*MEMORABILITY 
recode q5c (1=1 "very")(2=.75)(3=.5)(4=.25)(5=0 "very unmem")(else=.), gen(memory_ad)
svy: reg  memory_ad femFL* FL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==1
est store FL_all
test (femFL+female)=0
svy: reg memory_ad femDD* DD* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store DD_all
svy: reg memory_ad femMEL* MEL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store MEL_all
test (femMEL+female)=0

//TABLE 2
est table FL_all DD_all MEL_all, b(%9.2f) star(.2 .1 .02) style(col) stats(N) 
est table FL_all DD_all MEL_all, b(%9.2f) se style(col) stats(N) 

//predicted values
preserve
collapse female Dem Rep femDem femRep age01 ed6cat famincd refinc single 
replace female =0
replace refinc=0
replace single = 0
replace Dem = 0
replace Rep = 0
expand 3
replace Dem = 1 in 2
replace Rep = 1 in 3
expand 2
replace female = 1 in 4/6
replace femDem =female * Dem
replace femRep =female * Rep
lab def female2 0"male" 1"female"
lab val female female2
gen FL=.
expand 2
replace FL=1 in 1/6
replace FL=0 in 7/12
gen femFL=female*FL
gen femFLDem=female*FL*Dem
gen femFLRep=female*FL*Rep
gen FLDem=FL*Dem
gen FLRep=FL*Rep
gen DD=.
replace DD=1 in 1/6
replace DD=0 in 7/12
gen femDD=female*DD
gen femDDDem=female*DD*Dem
gen femDDRep=female*DD*Rep
gen DDDem=DD*Dem
gen DDRep=DD*Rep
gen MEL=.
replace MEL=1 in 1/6
replace MEL=0 in 7/12
gen femMEL=female*MEL
gen femMELDem=female*MEL*Dem
gen femMELRep=female*MEL*Rep
gen MELDem=MEL*Dem
gen MELRep=MEL*Rep

est restore FL_all
predict yhatFL
table female FL , c(mean yhatFL)
lab def FL 0"Comparison" 1"First Law"
lab val FL FL
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, IND") xtitle(" ") name(FL_IND, replace) ytitle("Memorability")
twoway (connected yhatFL FL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, DEM") xtitle(" ") name(FL_DEM, replace) ytitle("Memorability")
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, GOP") xtitle(" ") name(FL_REP, replace) ytitle("Memorability")
est restore DD_all
predict yhatDD
table female DD , c(mean yhatDD)
lab def DD 0"Comparison" 1"Dear Daughter"
lab val DD DD
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, IND") xtitle(" ") name(DD_IND, replace) ytitle("Memorability")
twoway (connected yhatDD DD if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, DEM") xtitle(" ") name(DD_DEM, replace) ytitle("Memorability")
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, GOP") xtitle(" ") name(DD_REP, replace) ytitle("Memorability")
est restore MEL_all
predict yhatMEL
table female MEL , c(mean yhatMEL)
lab def MEL 0"Comparison" 1"Melanie"
lab val MEL MEL
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, IND") xtitle(" ") name(MEL_IND, replace) ytitle("Memorability")
twoway (connected yhatMEL MEL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, DEM") xtitle(" ") name(MEL_DEM, replace) ytitle("Memorability")
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, GOP") xtitle(" ") name(MEL_REP, replace) ytitle("Memorability")
restore
graph combine FL_IND FL_DEM FL_REP DD_IND DD_DEM DD_REP MEL_IND MEL_DEM MEL_REP, col(3) ycommon ysize(8) xsize(6) altshrink 
graph export Figure2.tif, replace height(2400) width(1600)

*COGNITIVE ELABORATION
gen lnword = ln(wordcount+1)
svy: mean word if video==7, over(female)
lincom [wordcount]Female -[wordcount]Male
svy: mean word if video==22, over(female)
lincom [wordcount]Female -[wordcount]Male
svy: mean word if video==26, over(female)
lincom [wordcount]Female -[wordcount]Male

//TABLE 3
svy: reg lnword femFL* FL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==1
est store FL_all
svy: reg lnword femDD* DD* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store DD_all
svy: reg lnword femMEL* MEL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store MEL_all
est table FL_all DD_all MEL_all, b(%9.2f) star(.2 .1 .02) style(col) stats(N) 
est table FL_all DD_all MEL_all, b(%9.2f) se style(col) stats(N) 

//predicted values
preserve
collapse female Dem Rep femDem femRep age01 ed6cat famincd refinc single 
replace female =0
replace refinc=0
replace single = 0
replace Dem = 0
replace Rep = 0
expand 3
replace Dem = 1 in 2
replace Rep = 1 in 3
expand 2
replace female = 1 in 4/6
replace femDem =female * Dem
replace femRep =female * Rep
lab def female2 0"male" 1"female"
lab val female female2
gen FL=.
expand 2
replace FL=1 in 1/6
replace FL=0 in 7/12
gen femFL=female*FL
gen femFLDem=female*FL*Dem
gen femFLRep=female*FL*Rep
gen FLDem=FL*Dem
gen FLRep=FL*Rep
est restore FL_all
predict yhatFL
table female FL , c(mean yhatFL)
lab def FL 0"Comparison" 1"First Law"
lab val FL FL
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, IND") xtitle(" ") name(FL_IND, replace) ytitle("Logged Words")
twoway (connected yhatFL FL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, DEM") xtitle(" ") name(FL_DEM, replace) ytitle("Logged Words")
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, GOP") xtitle(" ") name(FL_REP, replace) ytitle("Logged Words")

gen DD=.
replace DD=1 in 1/6
replace DD=0 in 7/12
gen femDD=female*DD
gen femDDDem=female*DD*Dem
gen femDDRep=female*DD*Rep
gen DDDem=DD*Dem
gen DDRep=DD*Rep
est restore DD_all
predict yhatDD
table female DD , c(mean yhatDD)
lab def DD 0"Comparison" 1"Dear Daughter"
lab val DD DD
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, IND") xtitle(" ") name(DD_IND, replace) ytitle("Logged Words")
twoway (connected yhatDD DD if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, DEM") xtitle(" ") name(DD_DEM, replace) ytitle("Logged Words")
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, GOP") xtitle(" ") name(DD_REP, replace) ytitle("Logged Words")

gen MEL=.
replace MEL=1 in 1/6
replace MEL=0 in 7/12
gen femMEL=female*MEL
gen femMELDem=female*MEL*Dem
gen femMELRep=female*MEL*Rep
gen MELDem=MEL*Dem
gen MELRep=MEL*Rep
est restore MEL_all
predict yhatMEL
table female MEL , c(mean yhatMEL)
lab def MEL 0"Comparison" 1"Melanie"
lab val MEL MEL
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, IND") xtitle(" ") name(MEL_IND, replace) ytitle("Logged Words")
twoway (connected yhatMEL MEL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, DEM") xtitle(" ") name(MEL_DEM, replace) ytitle("Logged Words")
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, GOP") xtitle(" ") name(MEL_REP, replace) ytitle("Logged Words")
restore

//FIGURE 3
graph combine FL_IND FL_DEM FL_REP DD_IND DD_DEM DD_REP MEL_IND MEL_DEM MEL_REP, col(3) ycommon ysize(8) xsize(6) altshrink 
graph export Figure3.tif, replace height(2400) width(1600)


*****VOTE CHOICE
recode q10 (1=1 "Obama")(2=0 "Romney")(3=.)(4=. )(else=.), gen(voteO)
*new analyses
svy: probit voteO femFL* FL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==1
est store FL_all
svy: probit voteO femDD* DD* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store DD_all
svy: probit voteO femMEL* MEL* femDem femRep female Dem Rep age01 ed6cat famincd refinc single if typead==4
est store MEL_all

//TABLE 4
est table FL_all DD_all MEL_all, b(%9.2f) star(.2 .1 .02) style(col) stats(N) 
est table FL_all DD_all MEL_all, b(%9.2f) se style(col) stats(N) 

//predicted values
preserve
collapse female Dem Rep femDem femRep age01 ed6cat famincd refinc single 
replace female =0
replace refinc=0
replace single = 0
replace Dem = 0
replace Rep = 0
expand 3
replace Dem = 1 in 2
replace Rep = 1 in 3
expand 2
replace female = 1 in 4/6
replace femDem =female * Dem
replace femRep =female * Rep
lab def female2 0"male" 1"female"
lab val female female2
gen FL=.
expand 2
replace FL=1 in 1/6
replace FL=0 in 7/12
gen femFL=female*FL
gen femFLDem=female*FL*Dem
gen femFLRep=female*FL*Rep
gen FLDem=FL*Dem
gen FLRep=FL*Rep
est restore FL_all
predict yhatFL
table female FL , c(mean yhatFL)
lab def FL 0"Comparison" 1"First Law"
lab val FL FL
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, IND") xtitle(" ") name(FL_IND, replace) ytitle("Vote for Obama")
twoway (connected yhatFL FL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, DEM") xtitle(" ") name(FL_DEM, replace) ytitle("Vote for Obama")
twoway (connected yhatFL FL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatFL FL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("First Law, GOP") xtitle(" ") name(FL_REP, replace) ytitle("Vote for Obama")

gen DD=.
replace DD=1 in 1/6
replace DD=0 in 7/12
gen femDD=female*DD
gen femDDDem=female*DD*Dem
gen femDDRep=female*DD*Rep
gen DDDem=DD*Dem
gen DDRep=DD*Rep
est restore DD_all
predict yhatDD
table female DD , c(mean yhatDD)
lab def DD 0"Comparison" 1"Dear Daughter"
lab val DD DD
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, IND") xtitle(" ") name(DD_IND, replace) ytitle("Vote for Obama")
twoway (connected yhatDD DD if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, DEM") xtitle(" ") name(DD_DEM, replace) ytitle("Vote for Obama")
twoway (connected yhatDD DD if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatDD DD if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Dear Daughter, GOP") xtitle(" ") name(DD_REP, replace) ytitle("Vote for Obama")

gen MEL=.
replace MEL=1 in 1/6
replace MEL=0 in 7/12
gen femMEL=female*MEL
gen femMELDem=female*MEL*Dem
gen femMELRep=female*MEL*Rep
gen MELDem=MEL*Dem
gen MELRep=MEL*Rep
est restore MEL_all
predict yhatMEL
table female MEL , c(mean yhatMEL)
lab def MEL 0"Comparison" 1"Melanie"
lab val MEL MEL
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, IND") xtitle(" ") name(MEL_IND, replace) ytitle("Vote for Obama")
twoway (connected yhatMEL MEL if female==1 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==1 & Rep==0, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, DEM") xtitle(" ") name(MEL_DEM, replace) ytitle("Vote for Obama")
twoway (connected yhatMEL MEL if female==1 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel) xscale(range(-.5 1.5))) (connected yhatMEL MEL if female==0 & Dem==0 & Rep==1, msymbol(i) xlabel(0 1, valuelabel)), legend(label(1 "Female") label(2 "Male")) title("Melanie, GOP") xtitle(" ") name(MEL_REP, replace) ytitle("Vote for Obama")
restore

graph combine FL_IND FL_DEM FL_REP DD_IND DD_DEM DD_REP MEL_IND MEL_DEM MEL_REP, col(3) ycommon ysize(8) xsize(6) altshrink 
graph export Figure4.tif, replace height(2400) width(1600)

