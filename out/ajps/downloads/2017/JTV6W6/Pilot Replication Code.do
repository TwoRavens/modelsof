clear all

*set working directory to folder containing data files
use "Pilot Data_Merged.dta"

*High disgust conditions
gen HD = 0
recode HD 0=1 if (hfhd==1 | lfhd==1)
label define hd 0 "L. Disgust" 1 "H. Disgust"
label values HD hd

*High fear conditions
gen HA = 0
recode HA 0=1 if (hfhd==1 | hfld==1)
label define hf 0 "L. Anxiety" 1 "H. Anxiety"
label values HA hf

*Full set of conditions
gen Condition = 0
recode Condition 0=1 if HA==1 & HD==0
recode Condition 0=2 if HA==0 & HD==1
recode Condition 0=3 if HA==1 & HD==1
label variable Condition "Experimental Condition"
label define condl 0 "LA, LD" 1 "HA, LD" 2 "LA, HD" 3 "HA, HD"
label values Condition condl

*renaming emotions
rename emot_1 disgusted
rename emot_2 grossed
rename emot_3 repulsed
rename emot_4 sickened
rename emot_5 afraid
rename emot_6 fright
rename emot_7 anxious
rename emot_8 worried

*recoding symptom knowledge
gen k_joint = ksympt_4
gen k_eye = ksympt_5
gen k_fev = ksympt_6
gen k_vomit = ksympt_7
gen k_bleed = ksympt_8
gen k_organ = ksympt_9
gen k_head = ksympt_10
recode k_joint .=0 if korigin!=.
recode k_eye .=0 if korigin!=.
recode k_fev .=0 if korigin!=.
recode k_vomit .=0 if korigin!=.
recode k_bleed .=0 if korigin!=.
recode k_organ .=0 if korigin!=.
recode k_head .=0 if korigin!=.

*recoding knowledge of how it spreads
gen k_tick = kspread_4
gen k_fluid = kspread_5
gen k_mosq = kspread_6 /* correct answer */
gen k_air = kspread_7
recode k_tick .=0 if korigin!=.
recode k_fluid .=0 if korigin!=.
recode k_mosq .=0 if korigin!=.
recode k_air .=0 if korigin!=.
gen kspread = k_mosq 

*recoding knowledge of location of outbreak
recode korigin 6=1 4/5=0 7=0

*recoding info search
recode search 2=0

*info search
recode search2_4 .=0 if search!=.
recode search2_6 .=0 if search!=.
recode search2_7 .=0 if search!=.
recode search2_8 .=0 if search!=.
recode search2_9 .=0 if search!=.
recode search2_10 .=0 if search!=.
recode search2_11 .=0 if search!=.
rename search2_4 searcharea
rename search2_6 searchinto
rename search2_7 searchsneeze
rename search2_8 searchwho
rename search2_9 searchrate
rename search2_10 searchdeaths
rename search2_11 searchcure
gen searchcount = (searcharea + searchinto + searchsneeze + searchwho + searchrate + searchdeaths + searchcure)

*lookup with base category=0
gen lookup0 = lookup - 1


************
* Analysis *
************

*factor analysis of emotional response
factor disgusted-worried, ml factors(2)
rotate, promax blanks(.3)
predict fanxiety fdisgust

*manipulation check
ttest fdisgust, by(HD)
ttest fanxiety, by(HD)

ttest fanxiety, by(HA)
ttest fdisgust, by(HA)

*H1 - disgust increases knowledge of disgusting symptoms
tab k_eye HD, col chi2

*H2 - disgust decreases knowledge of non-disgusting symptoms
tab k_fev HD, col chi2
tab k_joint HD, col chi2
tab k_vomit HD, col chi2
tab kspread HD, col chi2
tab korigin HD, col chi2

*anxiety and knowledge
tab k_eye HA, col chi2
tab k_fev HA, col chi2
tab k_joint HA, col chi2
tab k_vomit HA, col chi2
tab kspread HA, col chi2
tab korigin HA, col chi2

*info search - students & staff
tab search HA, col chi2
ttest searchcount, by(HA)

tab search HD, col chi2
ttest searchcount, by(HD)

tab search HD if HA==0, col chi2
tab search HD if HA==1, col chi2
logit search HD##HA

tab search HA if HD==0, col chi2
tab search HA if HD==1, col chi2

*info search - mturk
tab lookup
ttest lookup, by(HA)
ttest lookup if HD==0, by(HA)

ttest lookup, by(HD)
tab lookup HD if HA==1, col
ttest lookup if HA==1, by(HD)
ologit lookup HA##HD

*figure a1
graph bar search, over(HD) over(HA, gap(80)) title(Lab Samples) ytitle(Probability of Information Search) scheme(s2mono) ylabel(0(.2).6) graphregion(color(white)) saving(pilotsearch.gph, replace)
graph bar lookup0, over(HD) over(HA, gap(80)) title(MTurk Sample) ytitle(Likelihood of Information Search) scheme(s2mono) ylabel(0(1)3) graphregion(color(white)) saving(pilotlookup.gph, replace)
graph combine pilotsearch.gph pilotlookup.gph, scheme(s2mono) graphregion(color(white)) saving(figurea1.emf, replace)





*
