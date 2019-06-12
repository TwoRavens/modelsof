clear *

args tlog flog tloga floga
local textwidth 6.5

use dataSets/validity_dataset_full

**********************
* Coding
**********************
// economic issues & mentions
gen wmp_issue_someecon = 0
foreach i in 10 11 12 13 18 22 {
	replace wmp_issue_someecon = 1 if wmp_issue`i'==1
}
replace wmp_issue_someecon = 1 if wmp_mention16==1 | wmp_mention15==1
la var wmp_issue_someecon "\textsc{wmp}: Economic issue or mention"
la de wmp_issue_someecon 0 "WMP: no" 1 "WMP: Economic issue or mention"
la val wmp_issue_someecon wmp_issue_someecon
char wmp_issue_someecon[gnote] "Economic issue or mention includes issues Taxes, Deficit, Gov’t Spending, Recession, Stimulus, Wallstreet, Mainstreet"

gen wmp_mention_disgust = 0
foreach i in 12 13 14 16 8 {
	replace wmp_mention_disgust = 1 if wmp_mention`i'==1
}
la var  wmp_mention_disgust "\textsc{wmp}: disgust terms$^{1}$"
la de  wmp_mention_disgust 0 "WMP: no" 1 "WMP: possible disgust mention"
la val  wmp_mention_disgust wmp_mention_disgust
char wmp_mention_disgust[gnote] "$^{1}$ Disgust terms include dishonest, corrupt, dirty campaigner, Wall Street, special interests"

gen wmp_fc_MorP = wmp_f_mention
replace wmp_fc_MorP = 1 if wmp_f_picture==1
la var wmp_fc_MorP "\textsc{wmp}: \textsc{fc} mentioned or pictured"
la de wmp_fc_MorP 0 "Not" 1 "FC mentioned or pictured"
la val  wmp_fc_MorP wmp_fc_MorP

gen wmp_oc_MorP = wmp_o_mention
replace wmp_oc_MorP = 1 if wmp_o_picture==1
la var wmp_oc_MorP "\textsc{wmp}: \textsc{oc} mentioned or pictured"
la de wmp_oc_MorP 0 "Not" 1 "OC mentioned or pictured"
la val  wmp_oc_MorP wmp_oc_MorP

la var bonica_dw "FC \textsc{dw-nominate} ideology score$^{2}$"
char bonica_dw[gnote] "$^{2}$ First-dimension \textsc{dw-nominate} score; available for candidates who held office at some point.  Ideology analyses restricted to candidate-sponsored ads."
la var bonica_oc_dw "OC \textsc{dw-nominate} ideology score"

gen wmp_toughFighterExper = max(wmp_mention9,wmp_mention10,wmp_mention5)
la var wmp_toughFighterExper "\textsc{wmp}: Ad mentions \quotes{tough,} \quotes{fighter,} \quotes{experienced}"

la var wmp_mention11 "\textsc{wmp}: Ad mentions \quotes{honest}"

gen wmp_corruptDishonest = max(wmp_mention12,wmp_mention13)
la var wmp_corruptDishonest "\textsc{wmp}: Ad mentions \quotes{corrupt,} \quotes{dishonest}"

recode wmp_ad_tone (3=1) (2=2) (1=.), gen(wmp_tone2)
la var wmp_tone2      "WMP tone (pos neg)"
recode wmp_ad_tone (3=1) (2=3) (1=2), gen(wmp_tone3)
la var wmp_tone3      "WMP tone (pos contrast neg)"

la var wmp_enthusiasm "\textsc{wmp}: Enthusiasm appeal"
la var wmp_music2     "\textsc{wmp}: Uplifting music"
la var wmp_fear 	  "\textsc{wmp}: Fear appeal"
la var wmp_music1	  "\textsc{wmp}: Ominous or tense music"
la var wmp_anger  	  "\textsc{wmp}: Anger appeal"
la var wmp_flag 	  "\textsc{wmp}: American flag appears"


*********************
* Analysis
*********************

dumptotex , log("`tlog'") append line("\clearpage ")

tabstartend start, log(`tlog', append) caption("Validity Analysis") 

local universe adHasRAcoding==1
local note Analysis among ads for which we have RA coding. Relative validity columns show the \textit{difference} in the correlation, compared with that observed in the research assistant coding. 
local note `note' \item \hspace{-1em}$^{**}$ p$<$0.01, $^{*}$ p$<$0.05 for the difference between correlation coefficients.

// reset globals used to calculate average across all tests
global rho_N 0
global ra_tot 0
global mT_tot 0
global meta_tot 0

// flag
mt_validity flag wmp_flag if `universe', log(`tlog') 

// candiddate mentions
mt_validity mention1Fc wmp_fc_MorP if `universe', log(`tlog') 
mt_validity mention1Oc wmp_oc_MorP if `universe', log(`tlog') 

// economic appeal
mt_validity ecAppeal wmp_issue_someecon if `universe', log(`tlog') 

// emotions
mt_validity emEnthusiasm wmp_enthusiasm if `universe', log(`tlog') 
mt_validity emEnthusiasm wmp_music2 if `universe', log(`tlog') 

mt_validity emFear wmp_fear if `universe', log(`tlog') 
mt_validity emFear wmp_music1 if `universe', log(`tlog') 

mt_validity emAnger wmp_anger if `universe', log(`tlog') 
mt_validity emAnger wmp_music1 if `universe', log(`tlog') 

//traits
mt_validity tFcLeader wmp_toughFighterExper if `universe' , log(`tlog') 
mt_validity tFcInteg  wmp_mention11 if `universe' , log(`tlog') 
mt_validity tOcInteg  wmp_corruptDishonest if `universe' , log(`tlog') 

// ideology
mt_validity ideologyFc bonica_dw if `universe' & wmp_airedGeneral, log(`tlog') 
mt_validity ideologyOc bonica_oc_dw if `universe' & wmp_airedGeneral, log(`tlog') 

tabstartend end, log(`tlog', append) note(`note') 

