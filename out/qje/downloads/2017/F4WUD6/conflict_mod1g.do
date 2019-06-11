*check how different movements are
g diff_nums=abs(abs(m_mod1g1_)-abs(m_mod1g2_))
summ diff_nums, detail

*make sure scores do not move in opposite directions - this shouldn't happen given the nature of the space; if it did it would be indicative of an error
g diff_sign=0
replace diff_sign=1 if m_mod1g1>0 & m_mod1g2<0
replace diff_sign=1 if m_mod1g2<0 & m_mod1g1>0
drop diff_sign 

*create a variable with the max movement in the mod1g direction, in absolute value
g temp1=abs(m_mod1g1)
g temp2=abs(m_mod1g2)
egen m_mod1g_=rowmax(temp1 temp2)
replace m_mod1g_=-m_mod1g_ if m_mod1g1<0 /*assign the correct sign*/
drop temp1 temp2

****now need to re-calculate to see if moving both the sub-model num scores the max mod1g amount changes the HES score relative to moving each one separately. If so, drop the observation


*first merge in with original mod1 scores
tempfile mod1g
save `mod1g', replace

use proj, clear
keep corps-date ham mod1*_num
merge 1:n corps-date ham using `mod1g'
keep if _merge==3
drop _merge
drop mod4 /*original mod4 score of the point, not relevant for current exercise and leads to name conflict*/
rename mod4pert mod4_threshold

*create perturbed mod1 num scores - using the max mod1g movement
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	quietly g `M'_pert=`M'_num+m_`M'_
}

**create perturbed mod1 letter scores - using the max mod1g movement
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	quietly g `M'=""
	quietly replace `M'="A" if (`M'_pert>=4.5 & `M'_pert!=.)
	quietly replace `M'="B" if (`M'_pert>=3.5 & `M'_pert<4.5)
	quietly replace `M'="C" if (`M'_pert>=2.5 & `M'_pert<3.5)
	quietly replace `M'="D" if (`M'_pert>=1.5 & `M'_pert<2.5)
	quietly replace `M'="E" if (`M'_pert<1.5)
	quietly replace `M'="N" if (`M'_pert==.)	
}

*calculate the hes70 mod4 score for the perturbed value, where mod1g has been constrained to be perturbed the same amount in both mod3a and mod3b
do hes70_mod4_compute

*create a dummy if using the max mod1g movement leads to a different HES score than perturbing mod1g in mod3a and mod1g in mod3b independently
g diff_mod4=0
replace diff_mod4=1 if mod4_pert!=mod4_thresh

*check that diff_mod4 is 0 when diff_nums is zero /*the two mod1g movements are the same*/
tab diff_mod4 if diff_nums==0

*keep observations where this is the case, such moves are not possible and thus cannot be the shortest cost way to reach the threshold
*this creates a list of perturbations to drop from the list of possible movements to the threshold
keep id m_mod1g_ diff_mod4

