**Use file "REPSL Sample Representativeness Tests.dta". Used to compare sample of states to remaining 36 states (see pg. 11)
use "REPSL Sample Representativeness Tests.dta", clear
ttest blackpct, by( sample)
ttest hisppct, by( sample)
ttest pci, by( sample)
ttest ecvotes, by( sample)
ttest obama, by( sample)
ttest citideol, by( sample)
ttest govideoln, by( sample)
ttest govideol, by( sample)
ttest turnover_all, by( sample)
ttest legsize_tot, by( sample)
ttest squire_2003, by( sample)
ttest clucas, by( sample)
ttest beyle, by( sample)


**Use file "REPSL Replication Dataset.dta"
use "REPSL Replication Data.dta", clear

**Calculate descriptive statistics for dependent variables (bills referred and bills passed), as discussed on pg. 12. Also illustrates overdispersion of dependent variables as basis for using negative binomial regression.
sum referred passed if noelec==0, d
tabstat referred passed if noelec==0, by(stch)

*Create Figure 1
graph dot referred passed if noelec==0, over(stch_name)
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .plotregion1.points[27].style.editstyle marker(symbol(square)) editcopy
	gr_edit .plotregion1.points[19].style.editstyle marker(fillcolor(black)) editcopy
	gr_edit .plotregion1.points[19].style.editstyle marker(linestyle(color(black))) editcopy
	gr_edit .legend.plotregion1.label[1].text = {}
	gr_edit .legend.plotregion1.label[1].text.Arrpush Mean Referred Bills
	gr_edit .legend.plotregion1.label[2].text = {}
	gr_edit .legend.plotregion1.label[2].text.Arrpush Mean Passed Bills
	gr_edit .legend.caption.text = {}
	gr_edit .legend.caption.text.Arrpush Note: Number of cases in each chamber in parentheses
	gr_edit .legend.caption.style.editstyle size(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .plotregion1.bars[12].grstyle.editstyle dottype(line) editcopy
	gr_edit .plotregion1.points[26].style.editstyle marker(fillcolor(black)) editcopy
	gr_edit .plotregion1.points[26].style.editstyle marker(linestyle(color(black))) editcopy
	gr_edit .plotregion1.bars[12].grstyle.editstyle dottype(line) editcopy
	gr_edit .plotregion1.bars[12].grstyle.editstyle dot_linestyle(width(thin)) editcopy
	gr_edit .plotregion1.bars[12].grstyle.editstyle dot_linestyle(pattern(solid)) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(width(thin))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(black))) editcopy

**Calculate descriptive statistics for jurisdiction change and retention variables, as discussed on pg. 13-14
tabstat jurischg if noelec==0
sum retainpct if noelec==0
tabstat retainpct if noelec==0, by(jurischg)

**Calculate descriptive statistics for control variables 
sum cmtesize samechair ideoldist reportpct chambersize aggchg majchg majsize autonomy unified turnover squire if noelec==0


**Negative binomial models for Table 3. Calculate marginal effects associated with changes in key independent variables and control variables. Note that variables involved in interaction terms are mean-centered here.

*Model 1
menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq if noelec==0  || stch: mcretain

*Estimates of substantive effects sizes on pg. 16-17
margins, at(mcretain=(-0.198 0 0.198)) asbalanced vsquish
margins, at(mcjuris=(-.144 .856)) asbalanced vsquish
margins, at(cmtesize=(6.62 19.76)) asbalanced vsquish
margins, at(aggchg=(0 .333)) asbalanced vsquish

*Model 2
menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq if noelec==0  || stch: mcretain

*Calculate the values of professionalism and turnover at which the marginal effect of retention is no longer statisically significant. Note that the uncentered means for professionalism and turnover are 0.201 and 0.209, respectively. 
margins, dydx(mcretain) at(mcsq=(-.10 (.01) .10)) asbalanced vsquish
margins, dydx(mcretain) at(mcto=(-.10 (.01) .10)) asbalanced vsquish

*Create Figure 2.  
*Panel A
margins, dydx(mcretain) at(mcsq=(-.10 (.04) .14)) asbalanced vsquish
marginsplot, yline(0) recastci (rarea)
	gr_edit .title.style.editstyle size(medsmall) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Panel A: Marginal Effect of Committee Retention, by Professionalism
	gr_edit .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Referred)
	gr_edit .yaxis1.title.text = {}  
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Referred)
	gr_edit .title.style.editstyle margin(medium) editcopy
	gr_edit .xaxis1.title.style.editstyle margin(medsmall) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Squire Professionalism Index
*Since model values are mean-centered, values on x-axis manually replaced with non-centered values for ease of interpretation.
	gr_edit .xaxis1.edit_tick 1 -0.1 `"0.10"', tickset(major)
	gr_edit .xaxis1.edit_tick 2 -0.06 `"0.14"', tickset(major)
	gr_edit .xaxis1.edit_tick 3 -0.02 `"0.18"', tickset(major)		
	gr_edit .xaxis1.edit_tick 4 0.02 `"0.22"', tickset(major)
	gr_edit .xaxis1.edit_tick 5 0.06 `"0.26"', tickset(major)
	gr_edit .xaxis1.edit_tick 6 0.1 `"0.30"', tickset(major)
	gr_edit .xaxis1.edit_tick 7 0.14 `"0.34"', tickset(major)
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(black))) editcopy
*Panel B
margins, dydx(mcretain) at(mcto=(-.119 (.04) .121)) asbalanced vsquish
marginsplot, yline(0) recastci (rarea)
	gr_edit .title.style.editstyle size(medsmall) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Panel B: Marginal Effect of Committee Retention, by Turnover
	gr_edit .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Referred)
	gr_edit .yaxis1.title.text = {}  
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Referred)
	gr_edit .title.style.editstyle margin(medium) editcopy
	gr_edit .xaxis1.title.style.editstyle margin(medsmall) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Legislative Turnover 
*Since model values are mean-centered, values on x-axis manually replaced with non-centered values for ease of interpretation.
	gr_edit .xaxis1.edit_tick 1 -0.119 `"0.09"', tickset(major)
	gr_edit .xaxis1.edit_tick 2 -0.079 `"0.13"', tickset(major)
	gr_edit .xaxis1.edit_tick 3 -0.039 `"0.17"', tickset(major)		
	gr_edit .xaxis1.edit_tick 4 0.001 `"0.21"', tickset(major)
	gr_edit .xaxis1.edit_tick 5 0.041 `"0.25"', tickset(major)
	gr_edit .xaxis1.edit_tick 6 0.081 `"0.29"', tickset(major)
	gr_edit .xaxis1.edit_tick 7 0.121 `"0.33"', tickset(major)
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(black))) editcopy

**Negative binomial models for Table 4. Calculate marginal effects associated with changes in key independent variables and control variables. Note that variables involved in interaction terms are mean-centered here.

*Model 3
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq if noelec==0  || stch: mcretain

*Estimates of substantive effects sizes on pg. 18-19
margins, at(mcretain=(-0.198 0.198)) asbalanced vsquish
margins, at(mcjuris=(-.144 .856)) asbalanced vsquish
margins, at(chambersize=(20 203)) asbalanced vsquish
margins, at(aggchg=(0 .333)) asbalanced vsquish
margins, at(unified=(0 1)) asbalanced vsquish
margins, at(autonomy=(3 5)) asbalanced vsquish

*Model 4
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq if noelec==0  || stch: mcretain

*Calculate the values of professionalism and turnover at which the marginal effect of retention is no longer statisically significant. Recall that the uncentered means for professionalism and turnover are 0.201 and 0.209, respectively. 
margins, dydx(mcretain) at(mcsq=(-.10 (.01) .10)) asbalanced vsquish
margins, dydx(mcretain) at(mcto=(-.010 (.01) .10)) asbalanced vsquish

*Create Figure 3  
*Panel A
margins, dydx(mcretain) at(mcsq=(-.10 (.04) .14)) asbalanced vsquish
marginsplot, yline(0) recastci (rarea)
	gr_edit .title.style.editstyle size(medsmall) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Panel A: Marginal Effect of Committee Retention, by Professionalism
	gr_edit .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Passed)
	gr_edit .yaxis1.title.text = {}  
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Passed)
	gr_edit .title.style.editstyle margin(medium) editcopy
	gr_edit .xaxis1.title.style.editstyle margin(medsmall) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Squire Professionalism Index
*Since model values are mean-centered, values on x-axis manually replaced with non-centered values for ease of interpretation.
	gr_edit .xaxis1.edit_tick 1 -0.1 `"0.10"', tickset(major)
	gr_edit .xaxis1.edit_tick 2 -0.06 `"0.14"', tickset(major)
	gr_edit .xaxis1.edit_tick 3 -0.02 `"0.18"', tickset(major)		
	gr_edit .xaxis1.edit_tick 4 0.02 `"0.22"', tickset(major)
	gr_edit .xaxis1.edit_tick 5 0.06 `"0.26"', tickset(major)
	gr_edit .xaxis1.edit_tick 6 0.1 `"0.30"', tickset(major)
	gr_edit .xaxis1.edit_tick 7 0.14 `"0.34"', tickset(major)
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(black))) editcopy
*Panel B
margins, dydx(mcretain) at(mcto=(-.119 (.04) .121)) asbalanced vsquish
marginsplot, yline(0) recastci (rarea)
	gr_edit .title.style.editstyle size(medsmall) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Panel B: Marginal Effect of Committee Retention, by Turnover
	gr_edit .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Passed)
	gr_edit .yaxis1.title.text = {}  
	gr_edit .yaxis1.title.text.Arrpush Marginal Effect (Bills Passed)
	gr_edit .title.style.editstyle margin(medium) editcopy
	gr_edit .xaxis1.title.style.editstyle margin(medsmall) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Legislative Turnover 
*Since model values are mean-centered, values on x-axis manually replaced with non-centered values for ease of interpretation.
	gr_edit .xaxis1.edit_tick 1 -0.119 `"0.09"', tickset(major)
	gr_edit .xaxis1.edit_tick 2 -0.079 `"0.13"', tickset(major)
	gr_edit .xaxis1.edit_tick 3 -0.039 `"0.17"', tickset(major)		
	gr_edit .xaxis1.edit_tick 4 0.001 `"0.21"', tickset(major)
	gr_edit .xaxis1.edit_tick 5 0.041 `"0.25"', tickset(major)
	gr_edit .xaxis1.edit_tick 6 0.081 `"0.29"', tickset(major)
	gr_edit .xaxis1.edit_tick 7 0.121 `"0.33"', tickset(major)
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(black))) editcopy


**Run Models 5 and 6
mixed reportpct referred_100s mcretain samechair mcjuris cmtesize mcideol chambersize aggchg majchg majsize auto unified mcto mcsq if noelec==0 || stch:
mixed reportpct referred_100s samechair cmtesize mcideol chambersize aggchg majchg majsize auto unified mcto mcsq c.mcretain##c.mcjuris if noelec==0 || stch:


**Robustness checks

*Endnote (ii). Re-run main models (Models 2 and 4), including the 44 cases where there was no intervening election between biennia. Note that Model 2 no longer requires inclusion of random slope term under this condition. 

menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq  || stch:
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq   || stch: mcretain


*Endnote (iv). Re-run models 2 and 4, excluding all Colorado cases. Note that Model 4 no longer requires inclusion of random slope term under this condition. 

menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq if noelec==0 & statenum!=6 || stch: mcretain
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq if noelec==0 & statenum!=6 || stch:


*Endnote (vi). Re-run models 2 and 4, including an interaction between committee retention and jurisdiction change 

menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq c.mcretain##c.mcjuris if noelec==0  || stch: mcretain
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq c.mcretain##c.mcjuris if noelec==0  || stch: mcretain


*Endnote (vi). Re-run model 4 with “divided branch government” and “divided legislature government” included as separate covariates. Test difference between coefficients.

menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize divleg divbranch auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq  if noelec==0  || stch: mcretain
test divleg = divbranch


*Endnote (x). Re-run models 2 and 4, including interaction between committee retention and ideological distance between committee and floor medians. 

menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq c.mcretain##c.mcideol if noelec==0  || stch: mcretain
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto mcto mcsq c.mcretain##c.mcto c.mcretain##c.mcsq c.mcretain##c.mcideol if noelec==0  || stch: mcretain


*Endnote (xi). Re-run models 2 and 4, using term limits in lieu of turnover to condition the effect of retention on productivity. 

menbreg referred mcretain samechair mcjuris cmtesize mcideoldist chambersize aggchg majchg majsize auto termlim mcsq c.mcretain##c.termlim c.mcretain##c.mcsq if noelec==0  || stch: mcretain
menbreg passed mcretain samech mcjuris cmtesize mcideold chambersize aggchg majchg majsize unified auto termlim mcsq c.mcretain##c.term c.mcretain##c.mcsq if noelec==0  || stch: mcretain


*Endnote (xi). Re-run model 6 with logit transformation of dependent variable.

mixed report_logit_trans referred_100s samechair cmtesize mcideol chambersize aggchg majchg majsize auto unified mcto mcsq c.mcretain##c.mcjuris if noelec==0 || stch:
