*** The Effectiveness of Tracks of Diplomacy in Third-Party Interventions ***

*** Do.-File 12.11.2008, Tobias Böhmelt, University of Essex, UK ***

*** Recoding of Variables (For Original 'Mediation Project' Data Set Only) ***
* ToDs Effectiveness & Table 1 *
generate effectiveness=cm14
recode effectiveness (.=0)
tab effectiveness

* Tracks of Diplomacy *
generate track_dummy=cm4
recode track_dummy (0=0) (1/1126=1)
tab track_dummy

* Official Diplomacy (Track 1 Diplomacy) *
generate T1=cm19
recode T1 (2 3 5=1) (. 0 1 4 6=0)
tab T1

* Unofficial Diplomacy (Track 2 / 1.5 Diplomacy) *
generate T2=cm19
recode T2 (1 4=1) (. 0 2 3 5 6=0)
tab T2

* Track 1 - Track 2 Mixed Approach *
generate T1_T2=cm19
recode T1_T2 (6=1) (. 0 1 2 3 4 5=0)
tab T1_T2

* Track Strategies *
generate strategies=cm6-1
recode strategies (.=0)
tab strategies

* Incentive Disputants *
generate incentive_disp=cm12
recode incentive_disp (. 0 3 4 5=0) (1=1) (2=2) 
tab incentive_disp

* Incentive Third-Party *
generate incentive_thirdp=cm12
recode incentive_thirdp (. 0 1 2 4 5=0) (3=1)
tab incentive_thirdp

* Power Discrepancy *
generate power_diff_2=p10c
tab power_diff_2

* Intensity *
generate intensity=d6
generate intensity_sq=d6*d6
tab intensity
tab intensity_sq

* Duration *
generate duration=cm10b
tab duration

* Ethnicity *
generate ethnic=d14
recode ethnic (. 0 1 2 3 4 5=0) (6=1)
tab ethnic

* Association *
generate p19a_new=p19a-1
generate p19b_new=p19b-1
generate associate=p19a_new+p19b_new
recode associate (0=0) (1/6=1)
drop p19a_new p19b_new
tab associate

*** Table I ***
tab effectiveness

*** Table II ***
sum effectiveness T1 T2 T1_T2 track_dummy incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate

*** Heckman Selection Models - Table III ***
heckman effectiveness T1 T2 T1_T2, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) robust 
mfx compute
heckman effectiveness power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) robust
mfx compute
heckman effectiveness T1 T2 T1_T2 power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) robust 
mfx compute

*** Sigelman & Zeng (1999) Corrected Coefficient Estimates (Update Table III: Model 2, Model 3) ***
* Model 2 *
heckman effectiveness power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) mills (mills2) robust
predict select_xb , xbs
gen delta2 = mills2*(mills2 + select_xb)
gen b_power_diff_2 = [effectiveness]_b[power_diff_2] - ([track_dummy]_b[power_diff_2]*e(rho)*e(sigma)*delta)
ci b_power_diff_2
gen b_intensity = [effectiveness]_b[intensity] - ([track_dummy]_b[intensity]*e(rho)*e(sigma)*delta)
ci b_intensity
gen b_intensity_sq = [effectiveness]_b[intensity_sq] - ([track_dummy]_b[intensity_sq]*e(rho)*e(sigma)*delta)
ci b_intensity_sq
gen b_ethnic = [effectiveness]_b[ethnic] - ([track_dummy]_b[ethnic]*e(rho)*e(sigma)*delta)
ci b_ethnic
gen b_associate = [effectiveness]_b[associate] - ([track_dummy]_b[associate]*e(rho)*e(sigma)*delta)
ci b_associate

* Model 3 *
heckman effectiveness T1 T2 T1_T2 power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) mills (mills3) robust 
predict select_xb_3 , xbs
gen delta3 = mills3*(mills3 + select_xb_3)
gen b_power_diff_3 = [effectiveness]_b[power_diff_2] - ([track_dummy]_b[power_diff_2]*e(rho)*e(sigma)*delta3)
ci b_power_diff_3
gen b_intensity_3 = [effectiveness]_b[intensity] - ([track_dummy]_b[intensity]*e(rho)*e(sigma)*delta3)
ci b_intensity_3
gen b_intensity_sq_3 = [effectiveness]_b[intensity_sq] - ([track_dummy]_b[intensity_sq]*e(rho)*e(sigma)*delta3)
ci b_intensity_sq_3
gen b_ethnic_3 = [effectiveness]_b[ethnic] - ([track_dummy]_b[ethnic]*e(rho)*e(sigma)*delta3)
ci b_ethnic_3
gen b_associate_3 = [effectiveness]_b[associate] - ([track_dummy]_b[associate]*e(rho)*e(sigma)*delta3)
ci b_associate_3

*** Unreported Robustness Checks ***
* Clustered Standard Errors *
heckman effectiveness T1 T2 T1_T2, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) cluster (d1) 
heckman effectiveness power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) cluster (d1) 
heckman effectiveness T1 T2 T1_T2 power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) cluster (d1) 

* Bootstrapped Standard Errors *
heckman effectiveness T1 T2 T1_T2, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) vce (boot)
heckman effectiveness power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) vce (boot) 
heckman effectiveness T1 T2 T1_T2 power_diff_2 intensity intensity_sq ethnic associate, noconstant select(track_dummy = incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate) vce (boot)

* Cross-Correlation *
pwcorr effectiveness T1 T2 T1_T2 track_dummy incentive_disp incentive_thirdp power_diff_2 intensity intensity_sq duration ethnic associate, sig




















