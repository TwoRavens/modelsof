/*selection models of discrimination by group, 1950-2003*/

clear

#delimit;

log using ethdis-replication.txt, text replace;

set memory 50M;

use ethdis-replicate.dta;

set more off;

set matsize 800;

sort numcode year;
tsset numcode year;

/*recoding "not applicable" codings on parcomp and xrcomp*/

replace xrcomp2=1 if xrcomp2<1;
replace parcomp2=1 if parcomp2<1;

/*rescaling democracy components*/
gen xconst2=1-((7-xconst)/6);
drop xconst;
rename xconst2 xconst;
gen xrcomp=1-((3-xrcomp2)/2);
gen parcomp=1-((5-parcomp2)/4);
drop xrcomp2 parcomp2;

/*recode regional base as dummy*/
replace gc2=0 if gc2==2;

/*interpolating values for gdp2*/

by numcode: ipolate gdp2 year, gen(gdppc);

/*logged variables*/
gen lgdp=ln(gdppc);
gen lpop=ln(gpop);
gen lcntpop=ln(cntpop);

/*coding year1 as years since 1950*/
gen year1=year-1950;

/*recoding openness as decimal*/
replace openk=openk/100;

/*recoding fdi as decimal*/
replace fdiinward=fdiinward/100;

/*recoding gdp growth as decimal*/
replace grgdpch=grgdpch/100;

/*recoding discrimination variables*/
gen pdiscr=.;
replace pdiscr=1 if poldis==4;
replace pdiscr=0 if poldis<4;

gen ediscr=.;
replace ediscr=1 if ecdis==4;
replace ediscr=0 if ecdis<4;

/*lags*/
gen pdiscrl=L.pdiscr;
gen ediscrl=L.ediscr;
gen xconstl=L.xconst;
gen xrcompl=L.xrcomp;
gen parcompl=L.parcomp;
gen polity2l=L.polity2;

/*dummy for majority groups*/

gen maj=0;
replace maj=1 if gpro>.5;

/*dummies for basis, region, country*/

xi i.basis i.region ;

/*predicting selection*/

probit heckman _Iregion* _Ibasis* gc2 lpop _gpop lcntpop _cntpop lgdp immig immig2 maj gpro year1 grgdpch polity2l minaut autpow if dom_min==0;

lstat;
fitstat;

/*interactions for Markov probit models*/
gen yearp=pdiscrl*year1;
gen yeare=ediscrl*year1;
gen gprop=pdiscrl*gpro;
gen gproe=ediscrl*gpro;
gen lgdpp=pdiscrl*lgdp;
gen lgdpe=ediscrl*lgdp;
gen grgdpp=pdiscrl*grgdpch;
gen grgdpe=ediscrl*grgdpch;
gen openkp=pdiscrl*openk;
gen openke=ediscrl*openk;
gen fdip=pdiscrl*fdiinward;
gen fdie=ediscrl*fdiinward;
gen gc2p=pdiscrl*gc2;
gen gc2e=ediscrl*gc2;
gen immigp=pdiscrl*immig;
gen immige=ediscrl*immig;
gen immig2p=pdiscrl*immig2;
gen immig2e=ediscrl*immig2;
gen minautp=pdiscrl*minaut;
gen minaute=ediscrl*minaut;
gen autpowp=pdiscrl*autpow;
gen autpowe=ediscrl*autpow;
gen xconstp=xconstl*pdiscrl;
gen xconste=xconstl*ediscrl;
gen xrcompp=xrcompl*pdiscrl;
gen xrcompe=xrcompl*ediscrl;
gen parcompp=parcompl*pdiscrl;
gen parcompe=parcompl*ediscrl;

summarize year1 lgdp openk grgdpch fdiinward xconstl xrcompl parcompl gc2 immig immig2 minaut autpow if dom_min==0;

/*Tables I-III*/

/*political discrimination, Heckman FIML Markov probit*/

heckprob pdiscr pdiscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow  
	yearp lgdpp grgdpp xconstp xrcompp parcompp gc2p immigp minautp autpowp if dom_min==0, 
	sel(heckman = _Ibasis* _Iregion* lpop _gpop lcntpop _cntpop maj year1 gpro lgdp grgdpch polity2l gc2 immig immig2 minaut autpow) 
	cluster(ccode) fir noskip;
test year1+yearp=0;
test lgdp+lgdpp=0;
test grgdpch+grgdpp=0;
test xconstl+xconstp=0;
test xrcompl+xrcompp=0;
test parcompl+parcompp=0;
test gc2+gc2p=0;
test immig+immigp=0;
test minaut+minautp=0;
test autpow+autpowp=0;

/*economic discrimination, Heckman FIML Markov probit*/

heckprob ediscr ediscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 minaut autpow  immig yeare lgdpe 
	grgdpe xconste xrcompe parcompe gc2e minaute autpowe immige if dom_min==0, 
	sel(heckman = _Ibasis* _Iregion* lpop _gpop lcntpop _cntpop maj year1 gpro lgdp grgdpch polity2l gc2 immig immig2 minaut autpow) 
	cluster(ccode) fir noskip;
test year1+yeare=0;
test lgdp+lgdpe=0;
test grgdpch+grgdpe=0;
test xconstl+xconste=0;
test xrcompl+xrcompe=0;
test parcompl+parcompe=0;
test gc2+gc2e=0;
test minaut+minaute=0;
test immig+immige=0;
test autpow+autpowe=0;

/*robustness checks: no selection correction*/

/*political discrimination, Markov probit*/

probit pdiscr pdiscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow 
	yearp lgdpp grgdpp xconstp xrcompp parcompp gc2p immigp minautp autpowp if dom_min==0, cluster(ccode);
test year1+yearp=0;
test lgdp+lgdpp=0;
test grgdpch+grgdpp=0;
test xconstl+xconstp=0;
test xrcompl+xrcompp=0;
test parcompl+parcompp=0;
test gc2+gc2p=0;
test immig+immigp=0;
test minaut+minautp=0;
test autpow+autpowp=0;

/*economic discrimination, Markov probit*/

probit ediscr ediscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 minaut autpow immig  yeare lgdpe 
	grgdpe xconste xrcompe parcompe gc2e minaute autpowe immige if dom_min==0, cluster(ccode);
test year1+yeare=0;
test lgdp+lgdpe=0;
test grgdpch+grgdpe=0;
test xconstl+xconste=0;
test xrcompl+xrcompe=0;
test parcompl+parcompe=0;
test gc2+gc2e=0;
test minaut+minaute=0;
test autpow+autpowe=0;
test immig+immige=0;

/*robustness checks: Table IV*/

/*FDI & trade*/

/*political discrimination*/

probit pdiscr pdiscrl year1 lgdp openk grgdpch fdiinward xconstl xrcompl parcompl gc2 immig minaut autpow  
	yearp lgdpp openkp grgdpp fdip xconstp xrcompp parcompp gc2p immigp minautp autpowp if dom_min==0, 
	cluster(ccode);
test year1+yearp=0;
test lgdp+lgdpp=0;
test openk+openkp=0;
test grgdpch+grgdpp=0;
test fdiinward+fdip=0;
test xconstl+xconstp=0;
test xrcompl+xrcompp=0;
test parcompl+parcompp=0;
test gc2+gc2p=0;
test immig+immigp=0;
test minaut+minautp=0;
test autpow+autpowp=0;

/*economic discrimination*/

probit ediscr ediscrl year1 lgdp openk grgdpch fdiinward xconstl xrcompl parcompl gc2 immig minaut autpow  yeare lgdpe openke 
	grgdpe fdie xconste xrcompe parcompe gc2e immige minaute autpowe if dom_min==0, cluster(ccode);
test year1+yeare=0;
test lgdp+lgdpe=0;
test openk+openke=0;
test grgdpch+grgdpe=0;
test fdiinward+fdie=0;
test xconstl+xconste=0;
test xrcompl+xrcompe=0;
test parcompl+parcompe=0;
test gc2+gc2e=0;
test immig+immige=0;
test minaut+minaute=0;
test autpow+autpowe=0;

/*trade*/

/*political discrimination*/

probit pdiscr pdiscrl year1 lgdp openk grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow 
	yearp lgdpp openkp grgdpp xconstp xrcompp parcompp gc2p immigp minautp autpowp if dom_min==0, 
	cluster(ccode);
test year1+yearp=0;
test lgdp+lgdpp=0;
test openk+openkp=0;
test grgdpch+grgdpp=0;
test xconstl+xconstp=0;
test xrcompl+xrcompp=0;
test parcompl+parcompp=0;
test gc2+gc2p=0;
test immig+immigp=0;
test minaut+minautp=0;
test autpow+autpowp=0;

/*economic discrimination*/

probit ediscr ediscrl year1 lgdp openk grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow  yeare lgdpe openke 
	grgdpe xconste xrcompe parcompe gc2e immige minaute autpowe if dom_min==0, cluster(ccode);
test year1+yeare=0;
test lgdp+lgdpe=0;
test openk+openke=0;
test grgdpch+grgdpe=0;
test xconstl+xconste=0;
test xrcompl+xrcompe=0;
test parcompl+parcompe=0;
test gc2+gc2e=0;
test immig+immige=0;
test minaut+minaute=0;
test autpow+autpowe=0;

/*no new religious groups*/

drop if basis==2 & heckman==0;
drop _Ibasis_2;

heckprob pdiscr pdiscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow 
	yearp lgdpp grgdpp xconstp xrcompp parcompp gc2p immigp minautp autpowp if dom_min==0, 
	sel(heckman = _Ibasis* _Iregion* lpop _gpop lcntpop _cntpop maj year1 gpro lgdp grgdpch polity2l gc2 immig immig2 minaut autpow) 
	cluster(ccode) fir noskip;
test year1+yearp=0;
test lgdp+lgdpp=0;
test grgdpch+grgdpp=0;
test xconstl+xconstp=0;
test xrcompl+xrcompp=0;
test parcompl+parcompp=0;
test gc2+gc2p=0;
test immig+immigp=0;
test minaut+minautp=0;
test autpow+autpowp=0;

heckprob ediscr ediscrl year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow yeare lgdpe 
	grgdpe xconste xrcompe parcompe gc2e immige minaute autpowe if dom_min==0, 
	sel(heckman = _Ibasis* _Iregion* lpop _gpop lcntpop _cntpop maj year1 gpro lgdp grgdpch polity2l gc2 immig immig2 minaut autpow) 
	cluster(ccode) fir noskip;
test year1+yeare=0;
test lgdp+lgdpe=0;
test grgdpch+grgdpe=0;
test xconstl+xconste=0;
test xrcompl+xrcompe=0;
test parcompl+parcompe=0;
test gc2+gc2e=0;
test minaut+minaute=0;
test autpow+autpowe=0;

log close;

/*weibull*/

clear
#delimit ;
set mem 50M;
set matsize 800;
log using ethdis-replication.txt, text append;
use ethdis-replicate.dta;
set more off;
drop if heckman==0;
sort numcode year;
tsset numcode year;
gen xconst2=1-((7-xconst)/6);
drop xconst;
rename xconst2 xconst;
gen xrcomp=1-((3-xrcomp2)/2);
gen parcomp=1-((5-parcomp2)/4);
replace gc2=0 if gc2==2;
by numcode: ipolate gdp2 year, gen(gdppc);
gen lgdp=ln(gdppc);
gen lpop=ln(gpop);
gen lcntpop=ln(cntpop);
gen year1=year-1950;
replace openk=openk/100;
replace fdiinward=fdiinward/100;
replace grgdpch=grgdpch/100;
gen pdiscr=.;
replace pdiscr=1 if poldis==4;
replace pdiscr=0 if poldis<4;
drop if missing(pdiscr);
gen ediscr=.;
replace ediscr=1 if ecdis==4;
replace ediscr=0 if ecdis<4;
drop if missing(ediscr);
gen pdiscrl=L.pdiscr;
gen ediscrl=L.ediscr;
gen xconstl=L.xconst;
gen xrcompl=L.xrcomp;
gen parcompl=L.parcomp;
gen polity2l=L.polity2;

/*start and end time variables, non-political-discriminatory spells*/

sort numcode year;
drop if pdiscr==pdiscrl & pdiscrl==1;
drop if pdiscr==1 & year==1950;
gen startyr=.;
replace startyr=year if numcode~=numcode[_n-1];
replace startyr=startyr[_n-1] if numcode==numcode[_n-1];
summarize startyr;
gen begin=year-startyr;
gen end=begin+1;

stset end, id(numcode) failure(pdiscr==1) time0(begin) exit(time .);
stdes;

/*establishing strata (groups with multiple failures)*/

sort numcode year;
gen str=1;
replace str=2 if numcode==numcode[_n-1] & begin>end[_n-1];
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=3 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==2;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=4 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==3;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
tab str;

streg year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow if dom_min==0, d(weibull) ;
stcurve, hazard;
log close;

clear
#delimit ;
log using ethdis-replication.txt, text append;
use ethdis-replicate.dta;
set more off;
drop if heckman==0;
sort numcode year;
tsset numcode year;
gen xconst2=1-((7-xconst)/6);
drop xconst;
rename xconst2 xconst;
gen xrcomp=1-((3-xrcomp2)/2);
gen parcomp=1-((5-parcomp2)/4);
replace gc2=0 if gc2==2;
by numcode: ipolate gdp2 year, gen(gdppc);
gen lgdp=ln(gdppc);
gen lpop=ln(gpop);
gen lcntpop=ln(cntpop);
gen year1=year-1950;
replace openk=openk/100;
replace fdiinward=fdiinward/100;
replace grgdpch=grgdpch/100;
gen pdiscr=.;
replace pdiscr=1 if poldis==4;
replace pdiscr=0 if poldis<4;
drop if missing(pdiscr);
gen ediscr=.;
replace ediscr=1 if ecdis==4;
replace ediscr=0 if ecdis<4;
drop if missing(ediscr);
gen pdiscrl=L.pdiscr;
gen ediscrl=L.ediscr;
gen xconstl=L.xconst;
gen xrcompl=L.xrcomp;
gen parcompl=L.parcomp;
gen polity2l=L.polity2;

/*start and end time variables, political-discriminatory spells*/

sort numcode year;
drop if pdiscr==pdiscrl & pdiscrl==0;
drop if pdiscr==0 & year==1950;
gen startyr=.;
replace startyr=year if numcode~=numcode[_n-1];
replace startyr=startyr[_n-1] if numcode==numcode[_n-1];
summarize startyr;
gen begin=year-startyr;
gen end=begin+1;

stset end, id(numcode) failure(pdiscr==0) time0(begin) exit(time .);
stdes;

/*establishing strata (groups with multiple failures)*/

sort numcode year;
gen str=1;
replace str=2 if numcode==numcode[_n-1] & begin>end[_n-1];
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=3 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==2;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=4 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==3;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
tab str;

streg year1 lgdp grgdpch xconstl xrcompl parcompl gc2 immig minaut autpow if dom_min==0, d(weibull) ;
stcurve, hazard;
log close;

clear
#delimit ;
set mem 50M;
set matsize 800;
log using ethdis-replication.txt, text append;
use ethdis-replicate.dta;
set more off;
drop if heckman==0;
sort numcode year;
tsset numcode year;
gen xconst2=1-((7-xconst)/6);
drop xconst;
rename xconst2 xconst;
gen xrcomp=1-((3-xrcomp2)/2);
gen parcomp=1-((5-parcomp2)/4);
replace gc2=0 if gc2==2;
by numcode: ipolate gdp2 year, gen(gdppc);
gen lgdp=ln(gdppc);
gen lpop=ln(gpop);
gen lcntpop=ln(cntpop);
gen year1=year-1950;
replace openk=openk/100;
replace fdiinward=fdiinward/100;
replace grgdpch=grgdpch/100;
gen pdiscr=.;
replace pdiscr=1 if poldis==4;
replace pdiscr=0 if poldis<4;
drop if missing(pdiscr);
gen ediscr=.;
replace ediscr=1 if ecdis==4;
replace ediscr=0 if ecdis<4;
drop if missing(ediscr);
gen pdiscrl=L.pdiscr;
gen ediscrl=L.ediscr;
gen xconstl=L.xconst;
gen xrcompl=L.xrcomp;
gen parcompl=L.parcomp;
gen polity2l=L.polity2;

/*start and end time variables, non-economic-discriminatory spells*/

sort numcode year;
drop if ediscr==ediscrl & ediscrl==1;
drop if ediscr==1 & year==1950;
gen startyr=.;
replace startyr=year if numcode~=numcode[_n-1];
replace startyr=startyr[_n-1] if numcode==numcode[_n-1];
summarize startyr;
gen begin=year-startyr;
gen end=begin+1;

stset end, id(numcode) failure(ediscr==1) time0(begin) exit(time .);
stdes;

/*establishing strata (groups with multiple failures)*/

sort numcode year;
gen str=1;
replace str=2 if numcode==numcode[_n-1] & begin>end[_n-1];
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=3 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==2;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=4 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==3;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
tab str;

streg year1 lgdp grgdpch xconstl xrcompl parcompl gc2 minaut autpow if dom_min==0, d(weibull) ;
stcurve, hazard;
log close;

clear
#delimit ;
set mem 50M;
set matsize 800;
log using ethdis-replication.txt, text append;
use ethdis-replicate.dta;
set more off;
drop if heckman==0;
sort numcode year;
tsset numcode year;
gen xconst2=1-((7-xconst)/6);
drop xconst;
rename xconst2 xconst;
gen xrcomp=1-((3-xrcomp2)/2);
gen parcomp=1-((5-parcomp2)/4);
replace gc2=0 if gc2==2;
by numcode: ipolate gdp2 year, gen(gdppc);
gen lgdp=ln(gdppc);
gen lpop=ln(gpop);
gen lcntpop=ln(cntpop);
gen year1=year-1950;
replace openk=openk/100;
replace fdiinward=fdiinward/100;
replace grgdpch=grgdpch/100;
gen pdiscr=.;
replace pdiscr=1 if poldis==4;
replace pdiscr=0 if poldis<4;
drop if missing(pdiscr);
gen ediscr=.;
replace ediscr=1 if ecdis==4;
replace ediscr=0 if ecdis<4;
drop if missing(ediscr);
gen pdiscrl=L.pdiscr;
gen ediscrl=L.ediscr;
gen xconstl=L.xconst;
gen xrcompl=L.xrcomp;
gen parcompl=L.parcomp;
gen polity2l=L.polity2;

/*start and end time variables, economic-discriminatory spells*/

sort numcode year;
drop if ediscr==ediscrl & ediscrl==0;
drop if ediscr==0 & year==1950;
gen startyr=.;
replace startyr=year if numcode~=numcode[_n-1];
replace startyr=startyr[_n-1] if numcode==numcode[_n-1];
summarize startyr;
gen begin=year-startyr;
gen end=begin+1;

stset end, id(numcode) failure(ediscr==0) time0(begin) exit(time .);
stdes;

/*establishing strata (groups with multiple failures)*/

sort numcode year;
gen str=1;
replace str=2 if numcode==numcode[_n-1] & begin>end[_n-1];
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=3 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==2;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
replace str=4 if numcode==numcode[_n-1] & begin>end[_n-1] & str[_n-1]==3;
replace str=str[_n-1] if numcode==numcode[_n-1] & begin==end[_n-1];
tab str;

streg year1 lgdp grgdpch xconstl xrcompl parcompl gc2 minaut autpow if dom_min==0, d(weibull) ;
stcurve, hazard;

log close;
