// Anna Pechenkina & Andrew Bausch & Kiron Skinner
// Corresponding author: anna.pechenkina@usu.edu
// How do civilians attribute blame for state indiscriminate violence?
// Journal of Peace research


/***  REPLICATION OF THE PAPER  ***/

// Be sure to adjust the pathname:
cd "/Users/.../PechenkinaBauschSkinner_JPR_replication"

clear
use "omnislav_noslovyansk.dta"


/* Table I: Descriptive statistics*/
estpost sum whichstatement_ordinal whichstatement_binary eastern  Donetska fighting bombing ///
female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  

esttab using tableI.tex, label cell((count mean sd min max sum)) nonumber nomtitle


/*** TABLE II. Differences in the characteristics and blame attribution between individuals
 who experienced bombing and those who did not. National sample (N = 2,022) ***/
mat T = J(10,5,.)

ttest female , by(bombing)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  , by(bombing)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary , by(bombing)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian , by(bombing)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus , by(bombing)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other , by(bombing)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both , by(bombing)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus , by(bombing)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal , by(bombing)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary, by(bombing)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = female age education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using ttest_tableII.doc,  statmat(T) varlabels replace ///
	ctitle("", Slovyansk=0, Slovyansk=1, Difference, t-statistic, p-value)
	
	

/*** TABLE III. Differences in the characteristics and blame attribution between individuals who experienced
bombing and those who did not. Donetska province (N = 219) ***/
mat T = J(10,5,.)

ttest female if Donetska ==1, by(bombing)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if Donetska ==1, by(bombing)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if Donetska ==1, by(bombing)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if Donetska ==1, by(bombing)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if Donetska ==1, by(bombing)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if Donetska ==1, by(bombing)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if Donetska ==1, by(bombing)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if Donetska ==1, by(bombing)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if Donetska ==1, by(bombing)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if Donetska ==1, by(bombing)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = female age education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other"  "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using ttest_tableIII.doc, statmat(T) varlabels replace ///
	ctitle("", Slovyansk=0, Slovyansk=1, Difference, t-statistic, p-value)	
	
	

/*** TABLE IV. Effects of experience of bombing on individual attributions of blame 
for provoked state indiscriminate violence ***/

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province1)
eststo full_mfx: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx


save "omnislav_donetska.dta", replace
keep if Donetska ==1
su

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_donetska: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx


esttab full_mfx full_mfx1  full_mfx_donetska full_mfx1_donetska ///
    using tableIV.tex, replace f label booktabs margin se(3) eqlabels(none) ///
	alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic
	

	
/*** Figure 1. Predicted probability of answer by the respondent’s exposure to bombing ***/	

clear
use "omnislav_noslovyansk.dta"


imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing) useweights



logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post
test 1._at == 2._at


clear
use "omnislav_donetska.dta"
keep if Donetska ==1
	
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post
test 1._at == 2._at

clear
use "probs_binary.dta"

set scheme plotplain	

#delimit ;
twoway  (bar mean type4 if  (type4 == 1 |  type4 ==3.5 ), col(black)) 
		(bar mean type4 if (type4 == 2 |  type4 ==4.5 ), col(gray)) 
		(rcap high low type4 if   (type4 <5  ) , lc(gs11)), 
		legend(col(1) row(3) order(1 "No bombing" 2 "Bombing") region(lwidth(none)) pos(4))  
		xlabel(1.5 "National" 4  "Donetska" , noticks) xtitle("")
		ytitle("Probability of answer 'Crime Regardless' ", size(3))  ylab(0(.20)1) xsize(4) ;
		
