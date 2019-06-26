/************************************************************/
/* Determinants of conflict and population change in Aceh   */
/************************************************************/

version 10

capture log close
set more off

/* Redefine as home the library where you put the data */
global home 	"D:\"
cd $home

log using 2_regress.log, replace

use podes_proc, clear


/* Correlates of conflict occurrence */

xi: 	dprobit conflict urban altitude remote poor00 couples00 station03 police00 share_Jawa ///
	kab_* pop00 popsq00 pop3_00 pop4_00, robust nolog cluster(kabkec)

xi: 	dprobit high_cshare urban altitude remote poor00 couples00 station03 police00 share_Jawa ///
	kab_Sel	kab_Timur kab_Tengah kab_Barat kab_Utara kab_BaratD kab_NaganR kab_Banda kab_Langsa kab_Lhoks ///
	pop00 popsq00 pop3_00 pop4_00, robust nolog cluster(kabkec)


/* Explaining population change */

********* OLS ***********

xi: regress dpop conflict urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00, robust cluster(kabkec)

xi: regress dpop high_cshare urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00, robust cluster(kabkec)

********* By conflict ***********

xi: regress dpop urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00 if conflict ==0, cluster(kabkec)

xi: regress dpop urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00 if conflict ==1, cluster(kabkec) 

qui xi: regress dpop urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00 if conflict ==0
est store c0
qui xi: regress dpop urban remote altitude station03 couples00 poor00 police00 share_Jawa ///
		kab_* pop00 popsq00 pop3_00 pop4_00 if conflict ==1
est store c1
suest c0 c1, cluster(kabkec)
test [c0_mean= c1_mean]


#delimit ;
global varlist 	"urban altitude remote poor00 couples00 station03 police00 share_Jawa kab_Tengah kab_Barat
			kab_NaganR kab_BaratD kab_Sel kab_Utara kab_Timur kab_Tamiang kab_La kab_Lh kab_Banda";
#delimit cr

foreach x of global varlist {
	test ([c1_mean]`x' - [c0_mean]`x' = 0) 
	local sign_c10 = sign([c1_mean]_b[`x']-[c0_mean]_b[`x'])
	display "H_0: `x' c1 coef >= `x' c0 coef. p-value = "normal(`sign_c10'*sqrt(r(chi2)))
	display "H_0: `x' c1 coef <= `x' c0 coef. p-value = "1-normal(`sign_c10'*sqrt(r(chi2)))
}


********* Quantile regressions ***********

global varlist	"high_cshare urban remote altitude station03 couples00 poor00 police00 share_Jawa"

xi: sqreg dpop $varlist kab_* pop00 popsq00 pop3_00 pop4_00, q(.25 .50 .75) reps(1000)
est store qreg_c0
estimates save $home\qreg_0, replace

foreach x of global varlist{
	test ([q25]`x' = [q75]`x') 
}

#delimit ;
global varlist 	"high_cshare urban altitude remote poor00 couples00 station03 police00 share_Jawa kab_Tengah kab_Barat
			kab_NaganR kab_BaratD kab_Sel kab_Utara kab_Timur kab_Tamiang kab_La kab_Lh kab_Banda";
#delimit cr

xi: sqreg dpop $varlist kab_* pop00 popsq00 pop3_00 pop4_00, q(.25 .50 .75) reps(1000)
est store qreg_c
estimates save $home\qreg, replace

foreach x of global varlist{
	test ([q25]`x' = [q75]`x') 
}


/*  Descriptives */

sum dpop conflict high_cshare share_Jawa urban remote altitude station03 couples00 poor00 police00 kab_* pop00 if e(sample)

gen pop100 = dpop*100
xtile poptiles = pop100, nq(4)
by poptile, sort: egen minchange = min(pop100)
by poptile, sort: egen maxchange = max(pop100)
by poptile, sort: egen meanchange = mean(pop100)
tab minchange 
tab maxchange

egen sumpop00 = sum(pop00) if pop00!=. 
egen sumpop03 = sum(pop03) if pop00!=. 

gen sumpopchange = 100*(sumpop03-sumpop00)/sumpop00 if pop00!=. 
gen sumdpop = sumpop03 - sumpop00 if pop00!=. 

egen sumpop00_c = sum(pop00) if pop00!=. & conflict==1
egen sumpop00_nc = sum(pop00) if pop00!=. & conflict==0
egen sumpop00_cc = sum(pop00) if pop00!=. & high_cshare==1

egen sumpop03_c = sum(pop03) if pop00!=. & conflict==1
egen sumpop03_nc = sum(pop03) if pop00!=. & conflict==0
egen sumpop03_cc = sum(pop03) if pop00!=. & high_cshare==1

local subs c nc cc
foreach x of local subs{
	gen spopchange_`x' = 100*(sumpop03_`x'-sumpop00_`x')/sumpop00_`x'
	gen sumdpop_`x' = sumpop03_`x' - sumpop00_`x'
}

log close
