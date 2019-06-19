#delimit;

* generate missings where sentiment indexes are not available;
gen bgs=.;
gen dks=.;
gen fns=.;
gen nls=.;
gen sds=.;
gen sps=.;

gen linTrend=_n;
*replace usnw=usnw2;
replace uspop2=uspop2/1e3;
replace auced=100*auced;
replace auy = 4*1000*auy; 			* rescale the GDP;
replace cnnw=cnnw2;					* use wealth series from Nathalie Girouard for Canada;
replace nlnw=nlnw2;
replace ukpop2=ukpop/1e6;
replace uknw=uknfw;					* all wealth variables are (consistently) measured as FINANCIAL WEALTH;

* adjust for the definition of flow series (c and y) in US&AU vs non US (annualization);
replace usc=usc/4;
replace usrpdi=usrpdi/4;
replace uscomp=uscomp/4;
replace auc=auc/4;
replace aurpdi=aurpdi/4;
replace aucomp=aucomp/4;

local allCountries "au bg cn dk fn fr ge it nl sd sp uk us";	* country list (for for loops); 
foreach cName of local allCountries {;
	replace `cName'c=4*`cName'c;				* annualize back all series (to be in line with the US def);
	replace `cName'rpdi=4*`cName'rpdi;		* annualize back all series (to be in line with the US def);
	replace `cName'comp=4*`cName'comp;		* annualize back all series (to be in line with the US def);
	
	replace `cName'ced=`cName'ced/100;		* rescale consumption deflator;
	
	gen l`cName'c  =  log(`cName'c/`cName'pop2);
	gen d`cName'c = D.l`cName'c;

	gen `cName'rpdiPerCap = `cName'rpdi/`cName'pop2;
	gen `cName'compPerCap = `cName'comp/(`cName'pop2*`cName'ced);
	
	gen l`cName'rpdi=log(`cName'rpdiPerCap);
	gen l`cName'comp=log(`cName'compPerCap);

	gen `cName'income = `cName'rpdiPerCap;
	
	gen l`cName'income = log(`cName'income);
	gen d`cName'income = D.l`cName'income;
	
	gen `cName'w = `cName'nw/(`cName'ced*`cName'pop2);
	gen l`cName'w = log(`cName'nw/(`cName'pop2*`cName'ced));
	gen `cName'wealthIncRatio=`cName'w/`cName'income;
	gen wyRatio`cName'=`cName'wealthIncRatio;

	gen l`cName'ced = log(`cName'ced);
	gen `cName'cinfl = 400*D.l`cName'ced;
	gen `cName'cinflY =100*(l`cName'ced-L4.l`cName'ced);
	gen `cName'irSpread = `cName'lr-`cName'r3m;
	gen `cName'rr3m = `cName'r3m-`cName'cinflY;
	
	replace `cName'r3m = `cName'rr3m;	* use real rates, not nominal;
	*replace `cName'lr = `cName'lr-`cName'cinflY;

	gen l`cName'qp=log(`cName'eqp);
	gen d`cName'qp = 400*D.l`cName'qp;
	gen `cName'sent = `cName's;
	
	* generate new infl vol series based on PCE deflator;
	gen annmeanpce=(`cName'ced+L.`cName'ced+L2.`cName'ced+L3.`cName'ced)/4;
	gen annstdevpce=.5*sqrt((`cName'ced-annmeanpce)^2+(L.`cName'ced-annmeanpce)^2+(L2.`cName'ced-annmeanpce)^2+(L3.`cName'ced-annmeanpce)^2);
	gen `cName'pceinfvol=annstdevpce/annmeanpce;
	
	drop annmeanpce annstdevpce;
};

gen canpceinfvol=cnpceinfvol;
gen deupceinfvol=gepceinfvol;
gen frapceinfvol=frpceinfvol;
gen gbrpceinfvol=ukpceinfvol;
gen itapceinfvol=itpceinfvol;
gen usapceinfvol=uspceinfvol;

gen au_c_star=aus_c_star;
gen cn_c_star=can_c_star;
gen ge_c_star=deu_c_star;
gen fr_c_star=fra_c_star;
gen uk_c_star=gbr_c_star;
gen it_c_star=ita_c_star;
gen us_c_star=usa_c_star;

* Summary Stats;
*summ dusc dauc dbgc dcnc ddkc dfnc dfrc dgec dirc ditc djpc dnlc doec dsdc dspc dukc;
*summ dusincome dauincome dbgincome dcnincome ddkincome dfnincome dfrincome dgeincome dirincome ditincome djpincome dnlincome doeincome dsdincome dspincome dukincome;
*summ wyRatious wyRatioau wyRatiobg wyRatiocn wyRatiodk wyRatiofn wyRatiofr wyRatioge wyRatioir wyRatioit wyRatiojp wyRationl wyRatiooe wyRatiosd wyRatiosp wyRatiouk;
