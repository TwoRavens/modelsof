*******************************
*Does Choice Bring Loyalty?   *
*Replication File, Elias Dinas*
*******************************


clear all
set more off

use ReplicationAJPS_MainDataset.dta

sort v222 v220 v221

keep v222 v220 v221 strngonly73 v1-v11 eligible68

gen newtr=.
forvalues x=1/31 {
replace newtr=32-`x' if v221==`x' & v220==3 & v222==48
}

forvalues x=1/29 {
replace newtr=61-`x' if v221==`x' & v220==2 & v222==48
}

forvalues x=1/31 {
replace newtr=92-`x' if v221==`x' & v220==1 & v222==48
}

forvalues x=1/31 {
replace newtr=123-`x' if v221==`x' & v220==12 & v222==47
}

forvalues x=1/30 {
replace newtr=153-`x' if v221==`x' & v220==11 & v222==47
}

forvalues x=1/31 {
replace newtr=184-`x' if v221==`x' & v220==10 & v222==47
}

forvalues x=1/30 {
replace newtr=214-`x' if v221==`x' & v220==9 & v222==47
}

forvalues x=1/31 {
replace newtr=245-`x' if v221==`x' & v220==8 & v222==47
}

forvalues x=1/31 {
replace newtr=276-`x' if v221==`x' & v220==7 & v222==47
}

forvalues x=1/30 {
replace newtr=306-`x' if v221==`x' & v220==6 & v222==47
}

forvalues x=1/31 {
replace newtr=337-`x' if v221==`x' & v220==5 & v222==47
}

forvalues x=1/30 {
replace newtr=367-`x' if v221==`x' & v220==4 & v222==47
}


gen newtr1=newtr if eligible68==0
gen newtr2=newtr if eligible68==1

*twoway lowess strngonly73 newtr1 || lowess strngonly73 newtr2, name(graph1, replace)
sort newtrsave Bootstrapped.dta"forvalues x=1/1000 {use Bootstrapped.dta, clearbsample, strata(v7)save Boot`x'.dta, replace}forvalues x=1/1000 {use Boot`x'.dta, clearsort newtrlowess strngonly73 newtr1, gen (l`x') nographlowess strngonly73 newtr2, gen (h`x') nograph
sort newtrsave Boot`x'.dta, replace}forvalues x=1/1000 {use Boot`x'.dtacollapse strngonly73 h`x' l`x' newtr1 newtr2 eligible68,by(newtr)

save Boot`x'Collapsed.dta, replace}







use Boot1Collapsed.dta, replace
sort newtr
forvalues x=2/1000 {
merge m:m newtr using Boot`x'Collapsed.dta,keepusing(l`x' h`x') nogen
sort newtr
}
save BootALLCollapsed.dta, replace

aorder

drop eligible68


xpose, clear varname


gen id=_n

forvalues x=1/89 {

egen vmeanlo`x'=mean (v`x') if id>1000 & id<2001
egen vp5lo`x'=pctile(v`x') if id>1000 & id<2001, p(2.5)
egen vp95lo`x'=pctile(v`x') if id>1000 & id<2001, p(97.5)

}


forvalues x=90/298 {

egen vmeanhi`x'=mean (v`x') if id<1001 
egen vp5hi`x'=pctile(v`x') if id<1001 , p(2.5)
egen vp95hi`x'=pctile(v`x') if id<1001, p(97.5)

}

keep vmeanlo* vp5lo* vp95lo* vmeanhi* vp5hi* vp95hi* id

aorder


**********************************************************************************************
*Final dataset manually transposed by copying to excel, transposing and pasting back to stata*
*This is done by editing vars by groups, copying their values into excel, transposing the    * 
*row into column and then copying back the resulting matrix into stata                       *
**********************************************************************************************


edit vmeanlo1-vmeanlo89
edit vp5lo1-vp5lo89
edit vp95lo1-vp95lo89


edit vmeanhi90-vmeanhi298
edit vp5hi90-vp5hi298
edit vp95hi90-vp95hi298


clear all
edit
gen id=_n

use Figure1.dta


twoway lowess strng73inel_mean id || lowess strng73inel_p5 id || lowess strng73inel_p95 id || /*
*/ lowess strng73el_mean id || lowess strng73el_p5 id || lowess strng73el_p95 id, /*
*/ aspect(1) legend(off) scheme(s1color) xline(90) ylabel(-.1(.1).6)


************************************
*Graph labelled and edited manually*
************************************



