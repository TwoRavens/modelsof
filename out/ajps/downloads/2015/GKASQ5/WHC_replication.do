************************************************************************
************************************************************************
*** Replication Data and Code for:                                   ***
*** WHO INHERITS THE STATE? COLONIAL RULE AND POST-COLONIAL CONFLICT ***
*** Julian Wucherpfennig, Philipp Hunziker, and Lars-Erik Cederman   ***
*** American Journal of Political Science                            ***
************************************************************************
*** This file replicates all tables, and creates coefficient vectors ***
***  and variance-covariance matrices for Figures 3 and 6 (R code)   ***
************************************************************************
************************************************************************

* load data
cd "YOUR-WORKING-DIRECTORY-HERE"
use WHC_replication, clear

* model specifications
global X   britishcol_flag groupsize lnarea lncarea lnpop lngdp indep 
global Z0  coastdist 
global Z0a brit_coastdist
global Z1  lncity_av
global Z1a brit_lncity_avdist_km

****************
*** TABLE  1 ***
****************
* Model 1
probit status_egip $Z0 $X if sample1==1, cluster(cowid) nolog
* Model 2
probit status_egip $Z0 $Z0a $X if sample1==1, cluster(cowid) nolog

***************	
*** TABLE 2 ***
***************
* Model 3a
probit status_egip $Z0 $Z0a $X if sample1==1, cluster(cowid) nolog
* Model 3b
probit family_onset_fe_flag status_egip $Z0 $X if sample1==1, cluster(cowid) nolog
* Model 4
biprobit (status_egip= $Z0 $Z0a $X) (family_onset_fe_flag= status_egip $Z0 $X) if sample1==1, cluster(cowid) nolog


****************
*** APPENDIX ***
****************

****************
*** TABLE A1 ***
****************
* Model 5: Share Agriculture
biprobit (status_egip= $Z0 $Z0a $X agri50) (family_onset_fe_flag= status_egip $Z0 $X agri50)  if sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 6: Agricultural land area per capita
biprobit (status_egip= $Z0 $Z0a $X lnagripc) (family_onset_fe_flag= status_egip $Z0 $X lnagripc)  if sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 7: Soil Quality
biprobit (status_egip= $Z0 $Z0a $X agricult6_frac) (family_onset_fe_flag= status_egip $Z0 $X agricult6_frac) if sample1==1, cluster(cowid) nolog
* Model 8: North Africa
biprobit (status_egip= $Z0 $Z0a $X nafrica) (family_onset_fe_flag= status_egip $Z0 $X nafrica) if sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 9: Latitude
biprobit (status_egip= $Z0 $Z0a $X cntrd_lat) (family_onset_fe_flag= status_egip $Z0 $X cntrd_lat) if sample1==1, cluster(cowid) nolog difficult


****************
*** TABLE A2 ***
****************
* Model 10: Islamic Groups
biprobit (status_egip= $Z0 $Z0a $X islamic) (family_onset_fe_flag= status_egip $Z0 $X islamic)  if sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 11: Terrain
biprobit (status_egip= $Z0 $Z0a $X lnelevation) (family_onset_fe_flag= status_egip $Z0 $X lnelevation) if sample1==1, cluster(cowid) nolog
* Model 12: Number of groups
biprobit (status_egip= $Z0 $Z0a $X lngrps) (family_onset_fe_flag= status_egip $Z0 $X lngrps) if sample1==1, cluster(cowid) nolog
* Model 13: Spatial Lag: share of groups that are excluded other than the group itself
biprobit (status_egip= $Z0 $Z0a $X inclgrpsharej) (family_onset_fe_flag= status_egip $Z0 $X inclgrpsharej) if sample1==1, cluster(cowid) nolog difficult

****************
*** TABLE A3 ***
****************
* Model 14: Group GDP 1990
reg lnrgdp90 $Z0a $Z0  $X if sample1==1, cluster(cowid)
* Model 15: Groupsize
reg groupsize $Z0 $Z0a britishcol_flag lnarea lncarea lnpop lngdp  indep  if sample1==1, cluster(cowid)
* Model 16: Groupsize
reg groupsize $Z0 $Z0a britishcol_flag  lncarea lnpop lngdp  indep  if sample1==1, cluster(cowid)


****************************
*** TABLE A4 **
****************************
* Model 17: Landlocked
biprobit (status_egip= $Z0 $Z0a $X landlock) (family_onset_fe_flag= status_egip $Z0 $X landlock) if sample1==1, cluster(cowid) nolog
* Model 18: w/o landlocked countries
biprobit (status_egip= $Z0 $Z0a $X) (family_onset_fe_flag= status_egip $Z0 $X) if landlock==0 & sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 18: alternative instrument
biprobit (status_egip= $Z1 $Z1a $X) (family_onset_fe_flag= status_egip $Z1 $X) if sample1==1, cluster(cowid) nolog difficult
* Model 19: 2 Stage Residual Inclusion
qui: probit status_egip $Z0 $Z0a $X  if sample1==1, cluster(cowid) nolog
predict xb, xb
gen genresid = cond(status_egip == 1, normalden(xb)/normal(xb), -normalden(xb)/(1-normal(xb)))
probit family_onset_fe_flag status_egip $Z0 $X genresid if sample1==1, cluster(cowid) nolog
drop xb genresid

****************
*** TABLE A5 ***
****************
* Model 21: Early Conflicts Only
biprobit (status_egip= $Z0 $Z0a $X ) (family_onset_f10y_flag= status_egip $Z0 $X) if sample1==1, cluster(cowid) nolog difficult technique(nr bfgs)
* Model 22: Late Conflicts Only 
biprobit (status_egip= $Z0 $Z0a $X ) (family_onset_p10y_flag= status_egip $Z0 $X) if sample1==1, cluster(cowid) nolog 
* Model 23: Length of colonial rule
biprobit (status_egip= $Z0 $Z0a $X lncolonyear) (family_onset_fe_flag= status_egip $Z0 $X lncolonyear) if sample1==1, cluster(cowid) nolog
* Model 24: Early statehood
biprobit (status_egip= $Z0 $Z0a $X statehistn10v3) (family_onset_fe_flag= status_egip $Z0 $X statehistn10v3) if sample1==1, cluster(cowid) nolog


****************
*** TABLE A6 ***
****************
* Model 25: Other Colonies
probit status_egip britishcol_flag coastdist other_coastdist othercol_flag brit_coastdist groupsize lnarea lncarea lnpop lngdp  indep, cl(cowid)
* Model 26: Others like British
biprobit (status_egip = coastdist brit_oth_col_flag brit_oth_coastdist groupsize lnarea lncarea lnpop lngdp  indep) (family_onset_fe_flag = status_egip brit_oth_col_flag coastdist groupsize lnarea lncarea lnpop lngdp  indep), cluster(cowid) nolog
* Model 27: Others like French
biprobit (status_egip = britishcol_flag coastdist brit_coastdist groupsize lnarea lncarea lnpop lngdp  indep) (family_onset_fe_flag = status_egip britishcol_flag coastdist groupsize lnarea lncarea lnpop lngdp  indep), cluster(cowid) nolog


****************************************
*** Code to create coefficients and  ***
*** vcv matrices for figures 3 and 6 ***
*** (to be used in R)                ***
****************************************

* Model 2 (for Figure 3)
probit status_egip $Z0 $Z0a $X if sample1==1, cluster(cowid) nolog
	est store reg1
	mat beta = e(b)
	mat vcov = e(V)	
	preserve
		svmat beta, names("model2")
		outsheet model2* in 1 using "M2-beta.txt", replace nolabel
	restore	
	preserve
		svmat vcov, names("model2vcv")
		outsheet model2vcv* in 1/10 using "M2-vcv.txt", replace nolabel
	restore
		
* Model 3 (for Figure 6)
probit family_onset_fe_flag status_egip $Z0 $X if sample1==1, cluster(cowid) nolog	
	est store reg3
	mat beta = e(b)
	mat vcov = e(V)		
	preserve
		svmat beta, names("model3")
		outsheet model3* in 1 using "M3-beta.txt", replace nolabel
	restore		
	preserve
		svmat vcov, names("model3vcv")
		outsheet model3vcv* in 1/10 using "M3-vcv.txt", replace nolabel
	restore	

* Model 4 (for Figure 6)
biprobit (status_egip= $Z0 $Z0a $X) (family_onset_fe_flag= status_egip $Z0 $X) if sample1==1, cluster(cowid) nolog
	est store reg4
	mat beta = e(b)
	mat vcov = e(V)
	preserve
		svmat beta, names("model4")
		outsheet model4* in 1 using "M4-beta.txt", replace nolabel
	restore
	preserve
		svmat vcov, names("model4vcv")
		outsheet model4vcv* in 1/21 using "M4-vcv.txt", replace nolabel
	restore
