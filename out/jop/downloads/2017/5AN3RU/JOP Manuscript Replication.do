
/******************************************************************************

Replication Materials for Tables and Figures in:

"The Changing Norms of Racial Political Rhetoric and the End of Racial Priming"

By Nicholas A. Valentino, Fabian G. Neuner, and L. Matthew Vandenbroek

The Journal of Politics 


Notes: 
Codebook can be found at the end of this Do File;
Please see separate Do File for Replication of Online Appendix Materials;
To output the Tables the package "estout" is required; Run "ssc install estout, replace" to install

******************************************************************************/

clear all
set more off 
cd "" // set working directory to where data sets are saved; 

// Table 1 

use study1.dta, replace
reg hc101 c.symrac01##i.three_conditions
est store A 
reg provs01 c.symrac01##i.three_conditions  
est store B
reg affects01_in c.symrac01##i.three_conditions  
est store C
reg angry01_in c.symrac01##i.three_conditions 
est store D
reg obamaapp01 c.symrac01##i.three_conditions
est store E
reg teaopp201_in c.symrac01##i.three_conditions 
est store F
reg beckapp01_in c.symrac01##i.three_conditions  
est store G
reg palinapp01_in c.symrac01##i.three_conditions 
est store H 

esttab A B C D E F G H using "Table1.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table 1) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H


// Figure 2 

use study1.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s1hc_index_exim) 

use study2.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions if race==1
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s2hc_index_exim) 

use study3.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s3hc_index_exim) 

use study4.dta, replace
quietly reg support_social_welfare01 c.symrac01##i.three_conditions 
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s4socwelf_index_exim) 

graph combine s1hc_index_exim.gph s2hc_index_exim.gph s3hc_index_exim.gph s4socwelf_index_exim.gph


// Figure 3

use study1.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s1le_index_exim) 

use study2.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions if race==1
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s2le_index_exim) 

use study3.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions 
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s3le_index_exim) 

use study4.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1))
quietly marginsplot,  scheme(s1mono) saving(s4le_index_exim) 

graph combine s1le_index_exim.gph s2le_index_exim.gph s3le_index_exim.gph s4le_index_exim.gph


// Table 2

use study1.dta, replace
reg hc_index c.rt_secs##i.three_conditions
est store A 
reg leader_index c.rt_secs##i.three_conditions
est store B
esttab A B using "Table2.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table 2) replace
drop _est_A _est_B


// Table 3 

use study1.dta, replace
reg hc_index c.symrac01##i.implicit_lag
est store A
reg hc_index c.symrac01##i.implicit_nolag
est store B
reg hc_index c.symrac01##i.implicit_post
est store C 
reg leader_index c.symrac01##i.implicit_lag
est store D 
reg leader_index c.symrac01##i.implicit_nolag
est store E 
reg leader_index c.symrac01##i.implicit_post
est store F

esttab A B C D E F using "Table3.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table 3) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F


// Table 4 

use study4.dta, replace
ttest story_insensitive01, by(explicit_implicit)
ttest story_insensitive01 if symrac_devmed==0, by(explicit_implicit)
ttest story_insensitive01 if symrac_devmed==1, by(explicit_implicit)

ttest story_conflict01, by(explicit_implicit)
ttest story_conflict01 if symrac_devmed==0, by(explicit_implicit)
ttest story_conflict01 if symrac_devmed==1, by(explicit_implicit)

// Figure 4

use study4.dta, replace
quietly reg story_insensitive01 i.explicit_implicit##c.symrac01
quietly margins, at(explicit_implicit=(0 1) symrac01=(.25 .75))
quietly marginsplot, scheme(s1mono) saving(s4_insen)
quietly reg angdis i.explicit_implicit##c.symrac01
quietly margins, at(explicit_implicit=(0 1) symrac01=(.25 .75))
quietly marginsplot, scheme(s1mono) saving(s4_angdis)

graph combine s4_insen.gph s4_angdis.gph, rows(2)


/******************************************************************************

Codebook:

N.B.: Please consult the paper and the Online Appendix for exact question wordings

Study 1: 

hc101 - Healthcare Approval; 0-1; higher values = higher approval 
provs01 -  Additive index of Support for 4 Healthcare Policy Provisions (see Appendix); 0-1; higher values = higher approval 
affects01_in - Predict Less Negative Effects (Inverse coding of: Optimism about about effects of HC law - See Appendix);   0-1; higher values = make things better
angry01_in -  Not angry at HC Bill (Inverse coding of: Angry about HC Bill); 0-1; higher values = less angry at Bill
obamaapp01 -  Obama Approval; 0-1; higher values = higher approval 
teaopp201_in -  Tea Party Movement Disapproval; 0-1; higher values = less approval  
beckapp01_in -  Glenn Beck Disapproval; 0-1; higher values = less approval  
palinapp01_in -  Sara Palin Disapproval; 0-1; higher values = less approval  
hc_index -  Additive Index of Healthcare Items; 0-1; higher values = higher approval 
leader_index -  Additive Index of Leader Evaluations; 0-1; higher values = higher approval
symrac01 -  Symbolic Racism; 0-1; higher values = more racially conservative
rt_secs -  Brief IAT; higher values = higher implicit preference for Whites
three_conditions - Experimental conditions; 0 = Explicit; 1 = Implicit; 2 = Control 
implicit_lag - Experimental Conditions; Lagged SR measurement only; 0 = Explicit; 1= Implicit
implicit_nolag - Experimental Conditions; No Lag SR measurement only; 0 = Explicit; 1= Implicit
implicit_post - Experimental Conditions; Post-test SR measurement only; 0 = Explicit; 1= Implicit
south - Respondent Location; 1 = 11 Former Confederate States; 0 = All other States
libcon01 - Ideology; 0-1; higher values = more Conservative
egal01 - Egalitarianism; 0-1; higher values = more Egalitarian


Study 2: 

hc101 - Healthcare Approval; 0-1; higher values = higher approval 
provs01 -  Additive index of Support for 4 Healthcare Policy Provisions (Public Option, HC Exchange, Pre-Existing Conditions, Remain on Parent Plan); 0-1; higher values = higher approval 
affects01_in - Predict Less Negative Effects (Inverse coding of: Optimism about about effects of HC law - See Appendix);   0-1; higher values = make things better
obamajo0 - Obama Approval; 0-1; higher values = higher approval 
teaopp201_in -  Tea Party Movement Disapproval; 0-1; higher values = less approval
beck01_in - Glenn Beck Disapproval; 0-1; higher values = less approval 
hc_index - Additive Index of Healthcare Items; 0-1; higher values = higher approval
leader_index - Additive Index of Leader Evaluations; 0-1; higher values = higher approval 
symrac01 - Symbolic Racism; 0-1; higher values = more racially conservative
rt_secs - Brief IAT; higher values = higher implicit preference for Whites
race - Respondent race; White = 1; 2-8 = Other races

Study 3: 

hc101 -  Healthcare Approval; 0-1; higher values = higher approval 
provisions1 -  Additive index of Support for 4 Healthcare Policy Provisions (Public Option, HC Exchange, Pre-Existing Conditions, Remain on Parent Plan); 0-1; higher values = higher approval 
affects01_in -  Predict Less Negative Effects (Inverse coding of: Optimism about about effects of HC law - See Appendix);   0-1; higher values = make things better
obamaapp01 -  Obama Approval; 0-1; higher values = higher approval
palinapp01_in -  Sara Palin Disapproval; 0-1; higher values = less approval 
beckapp01_in -  Glenn Beck Disapproval; 0-1; higher values = less approval
teaopp01_in -  Tea Party Movement Disapproval; 0-1; higher values = less approval
hc_index -  Additive Index of Healthcare Items; 0-1; higher values = higher approval 
leader_index -  Additive Index of Leader Evaluations; 0-1; higher values = higher approval
symrac01 -  Symbolic Racism; 0-1; higher values = more racially conservative
rt_secs - Brief IAT; higher values = higher implicit preference for Whites
lazy_blk01 - Stereotype that Blacks are lazy (vs hardworking); 0-1; higher values = more lazy
viol_blk01 - Stereotype that Blacks are violent (vs peaceful); 0-1; higher values = more violent



Study 4: 

support_aca01 - Opposition to Repealing ACA (Inverse of Support for Repeal); 0-1; higher values = higher ACA support
support_unemployed01 -  Support for increasing government aid to the unemployed; 0-1; higher values = higher support
support_poor01 - Support for increasing food assistance for the poor; 0-1; higher values = higher support
support_pensions01 - Support for pensions for retired government workers; 0-1; higher values = higher support
support_medicaid01 - Support increasing Medicaid benefits; 0-1; higher values = higher support
favor_Obama01 - Obama Approval; 0-1; higher values = higher approval 
favor_Palin01_in - Sara Palin Disapproval; 0-1; higher values = less approval
favor_Romney01_in - Mitt Romney Disapproval; 0-1; higher values = less approval
favor_Limbaugh01_in - Rush Limbaugh Disapproval; 0-1; higher values = less approval
favor_TeaPartyAct01_in - Tea Party Activists Disapproval; 0-1; higher values = less approval
support_social_welfare01 -  Additive Index of Healthcare + Welfare Items; 0-1; higher values = higher approval 
leader_index - Additive Index of Leader Evaluations; 0-1; higher values = higher approval
symrac01 - Symbolic Racism; 0-1; higher values = more racially conservative
story_conflict01 - How strongly ad they read focused on conflict between Blacks and Whites; 0-1; higher values = more strongly
story_insensitive01 - How racially insensitive was ad; 0-1; higher values = more insensitive
angry01 - How angry story they read made them feel; 0-1; higher values = more angry
disgusted01 - How disgusted story they read made them feel; 0-1; higher values = more disgusted
angdis - Additive Index of anger and disgust; 0-1; higher values = more angry/disgusted
three_conditions - Experimental conditions; 0 = Explicit; 1 = Implicit; 2 = Control 
explicit_implicit - Binary Experimental Conditions; 0 = Implicit; 1 = Explicit
implicit_distal - Experimental Conditions; Lagged SR measurement only; 0 = Explicit; 1= Implicit
implicit_proximal - Experimental Conditions; No Lag SR measurement only; 0 = Explicit; 1= Implicit
implicit_post - Experimental Conditions; Post-test SR measurement only; 0 = Explicit; 1= Implicit
symrac_devmed - Median Split of SR measure; 0 = Below Median; 1 = Above Median
south - Respondent Location; 1 = 11 Former Confederate States; 0 = All other States


******************************************************************************/

