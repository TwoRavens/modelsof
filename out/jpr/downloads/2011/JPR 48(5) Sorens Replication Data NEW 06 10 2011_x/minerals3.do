/*mineral resources & rebellion, 1950-2003*/

clear

#delimit;

log using C:\data\mineralreb3.txt, text replace;

set memory 100M;

use C:\data\combined.dta;

set more off;

set matsize 1600;

sort numcode year;
tsset numcode year;

/*recode regional base as dummy*/
replace gc2=0 if gc2==2;

/*interpolating values for gdp2*/

by numcode: ipolate gdp2 year, gen(gdppc);

/*per capita resources*/
gen pcresource=resource/(1000*gpop); gen pcoil=rpoil/(1000*gpop); gen pcpetrol=(rpoil+rpgas)/(1000*gpop); gen pcdiam=(rpgem+rpind)/(1000*gpop); 
gen pcsec=pcdiam*regsecondary; gen natdiam=(npgemi*valgem+npindi*valind)/(1000*gpop); gen pcnatsec=natdiam*csecondary;

/*logged variables*/
gen lgdp=ln(gdppc); gen lpop=ln(gpop); gen lcntpop=ln(cntpop); gen lresource=ln(1+pcresource); gen loil=ln(1+pcoil); gen lpetrol=ln(1+pcpetrol);
gen lsec=ln(pcsec+1); gen lnatsec=ln(pcnatsec+1);

/*resources moving averages*/

tssmooth ma res_ma=lresource, window(5 1); tssmooth ma oil_ma=loil, window(5 1); tssmooth ma petrol_ma=lpetrol, window(5 1); 
tssmooth ma sec_ma=lsec, window(5 1); tssmooth ma natsec_ma=lnatsec, window(5 1); tssmooth ma pcres_ma=pcresource, window(5 1);

/*coding year1 as years since 1950*/
gen year1=year-1950;

/*recoding discrimination variables*/
gen pdiscr=.; replace pdiscr=1 if poldis==4; replace pdiscr=0 if poldis<4; gen ediscr=.; replace ediscr=1 if ecdis==4; replace ediscr=0 if ecdis<4;

/*northern ireland*/

replace igc=itc if numcode==20003; replace itc=0 if numcode==20003; 

/*lags*/
gen pdiscrl=L.pdiscr; replace pdiscrl=pdiscr if numcode~=numcode[_n-1]; gen ediscrl=L.ediscr; replace ediscrl=ediscr if numcode~=numcode[_n-1]; gen polity2l=L.polity2; replace 
polity2l=polity2 if numcode~=numcode[_n-1]; gen lgdpl=L.lgdp; replace lgdpl=lgdp if numcode~=numcode[_n-1]; gen autpowl=L.autpow; replace autpowl=autpow if numcode~=numcode[_n-1]; gen 
civwarl=L.civwar; replace civwarl=civwar if numcode~=numcode[_n-1]; gen sdkinl=L.sdkin; replace sdkinl=sdkin if numcode~=numcode[_n-1]; gen sdl=L.sd; gen dom_minl=L.dom_min;
replace dom_minl=dom_min if numcode~=numcode[_n-1]; gen lresourcel=L.lresource; replace lresourcel=lresource if numcode~=numcode[_n-1]; gen pcresourcel=L.pcresource; 
replace pcresourcel=pcresource if numcode~=numcode[_n-1]; gen anoc=.; replace anoc=0 if polity2<-5; replace anoc=0 if polity2>5; replace anoc=1 if polity2>-6 & polity2<6;
gen anocl=L.anoc; replace anocl=anoc if numcode~=numcode[_n-1]; gen loill=L.loil; replace loill=loil if numcode~=numcode[_n-1]; gen pcoill=L.pcoil; gen lpetroll=L.lpetrol; 
replace lpetroll=lpetrol if numcode~=numcode[_n-1]; gen pcpetroll=L.pcpetrol; gen lsecl=L.lsec; replace lsecl=lsec if numcode~=numcode[_n-1]; gen pcsecl=L.pcsec; 
gen lnatsecl=L.lnatsec; replace lnatsecl=lnatsec if numcode~=numcode[_n-1]; gen pcnatsecl=L.pcnatsec;

/*decade dummies*/
gen year50s=0; replace year50s=1 if year<1961; gen year60s=0; replace year60s=1 if year>1960 & year<1971; gen year70s=0; replace year70s=1 if year>1970 & year<1981;
gen year80s=0; replace year80s=1 if year>1980 & year<1991; gen year90s=0; replace year90s=1 if year>1990 & year<2001;

/*dummies for basis, region, year*/
xi i.basis i.region;

preserve;
collapse (mean) heckman _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop lgdp gc2 gpro itc igc sovdom largest sdkin anoc polity2 dom_min irr_pot immig2, by(numcode) ;
probit heckman _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop lgdp gc2 gpro itc igc;
restore;

/*intrastate conflict onset*/
gen drop=0; replace drop=1 if gc2==0; replace drop=1 if dom_minl==1; replace drop=1 if immig2==1; 
sort numcode year;
gen ic=itc+igc; tab ic; 
gen iconset=.; replace iconset=0 if L.itc==1; replace iconset=0 if L.igc==1; replace iconset=1 if itc==1 & L.itc==0; replace iconset=1 if itc==1 & numcode~=numcode[_n-1] & year~=1950; 
replace iconset=1 if numcode==62501 & year==1956; replace iconset=1 if numcode==71005 & year==1950; replace iconset=1 if numcode==85014 & year==1950; 
replace iconset=1 if numcode==205 & year==1950; replace iconset=2 if igc==1 & L.igc==0; replace iconset=2 if igc==1 & numcode~=numcode[_n-1] & year~=1950; replace iconset=0 if ic==0; 
replace drop=1 if ic>0 & iconset==0;
gen itconset=.; replace itconset=1 if iconset==1; replace itconset=0 if iconset==0; replace itconset=0 if itconset==2; gen igconset=.; replace igconset=1 if iconset==2; replace igconset=0 if
iconset==0; replace igconset=0 if iconset==1;

btscs ic year numcode, gen(noic) nspline(3);
summarize sec lresourcel pcresourcel lpop dist seaacc irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl  terr anocl *0s noic _spline1-_spline3 res_ma if 
	drop==0;
label var sec "Secessionism"; label var lresourcel "Log PC Resources"; label var pcresourcel "PC Resources"; label var lpop "Log(Group pop.)";
label var dist "Noncontiguity"; label var seaacc "Coastal"; label var irr_pot "Irredentist Potential"; label var largest "Relative Size";
label var polity2l "Democracy"; label var pdiscrl "Pol. Discrim."; label var ediscrl "Econ. Discrim."; label var autlost "Lost Autonomy";
label var sovdom "Soviet Domination"; label var regmin "Regional Plurality"; label var civwarl "Conflict Elsewhere"; label var sdkinl "Kin Self-Det.";
label var lgdpl "Log(GDPPC)"; label var terr "High Elevation"; label var anocl "Anocracy"; label var lsecl "Log Reg'l Sec'y Diamonds";
label var lnatsecl "Log Nat'l Sec'y Diamonds"; label var loill "Log Oil Production";
tabstat sec lresourcel pcresourcel lpop dist seaacc irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s 
noic _spline1-_spline3 loill lpetroll pcoill pcpetroll lsecl lnatsecl pcsecl pcnatsecl res_ma oil_ma petrol_ma sec_ma natsec_ma if drop==0 & iconset~=., 
casewise s(mean median sd n) columns(statistics) varwidth(16) longstub;
tab iconset if drop==0;

/*one-year lag - for reference only*/
mlogit iconset lresourcel lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic 
_spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset lresourcel lpop dist irr_pot largest polity2l pdiscrl ediscrl sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic  
_spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset lresourcel lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl 
lsecl lnatsecl *0s noic _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset lresourcel lpop dist irr_pot largest polity2l pdiscrl ediscrl sovdom regmin civwarl sdkinl lgdpl terr anocl lsecl lnatsecl loill 
*0s noic  _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset lresourcel lpop dist irr_pot largest polity2l pdiscrl ediscrl sovdom regmin civwarl sdkinl lgdpl terr anocl lsecl lnatsecl lpetroll 
*0s noic _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset lresourcel lpop dist irr_pot largest polity2l sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
cluster(numcode);
fitstat;
mlogit iconset lresourcel pcresourcel lpop dist irr_pot largest polity2l sovdom regmin civwarl sdkinl lgdpl terr anocl lsecl lnatsecl *0s noic  
_spline1-_spline3 if drop==0, cluster(numcode);
fitstat;

/*for testing parabolic relationship*/
gen ressq_ma=res_ma^2;

/*Table II*/
mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic 
_spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
test [1=2];
test [1=2]: res_ma;
sum res_ma pcres_ma sec_ma natsec_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl if e(sample);
mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic  _spline1-_spline3 
if drop==0, cluster(numcode);
fitstat;
mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl sec_ma natsec_ma *0s 
noic _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
test sec_ma natsec_ma;
mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl oil_ma *0s noic  _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl petrol_ma *0s noic  _spline1-_spline3 if drop==0, cluster(numcode);
fitstat;
mlogit iconset res_ma lpop dist irr_pot largest polity2l sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
cluster(numcode);
fitstat;
mlogit iconset res_ma ressq_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
cluster(numcode);
test res_ma ressq_ma;
fitstat;

/*simulations*/
centile res_ma if e(sample), centile(90);
tab group year if res_ma>6.6724 & res_ma<6.6725;
estsimp mlogit iconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, sims(1000);
setx median; setx anocl 1 res_ma 0 ;
simqi; simqi, fd(prval(1 2)) changex(res_ma 0 p90);

/*Table III: selection models*/
heckprob itconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, cluster(numcode)
	sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
fitstat;
summarize itconset if e(sample);
heckprob igconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, cluster(numcode)
	sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
fitstat;
summarize igconset if e(sample);
heckprob itconset res_ma sec_ma natsec_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
	cluster(numcode) sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
test sec_ma natsec_ma;
fitstat;
heckprob igconset res_ma sec_ma natsec_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
	cluster(numcode) sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
fitstat;
heckprob itconset res_ma petrol_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if 
	drop==0, cluster(numcode) sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
fitstat;
heckprob igconset res_ma petrol_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, 
	cluster(numcode) sel(heckman = _Iregion* _Ibasis* lpop _gpop lcntpop _cntpop gpro) ;
fitstat;

relogit itconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0 & sovdom==0, cluster(numcode);
relogit itconset res_ma sec_ma natsec_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0 & sovdom==0, cluster(numcode);
relogit igconset res_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, cluster(numcode);
relogit igconset res_ma sec_ma natsec_ma lpop dist irr_pot largest polity2l pdiscrl ediscrl autlost sovdom regmin civwarl sdkinl lgdpl terr anocl *0s noic _spline1-_spline3 if drop==0, cluster(numcode);

/*Table IV - armed self-determination movements onset - relogit models*/

sort numcode year;
replace sd=0 if numcode==20003;
drop _spline1-_spline3;
btscs sd year numcode, gen(nosd) nspline(3);
drop if sd==sdl & sdl==1;
drop if sd==1 & year==1950;
drop if numcode==36504 & year==1992;
drop if numcode==52901 & year==1993;
drop if numcode==52904 & year==1993;
drop if numcode==52905 & year==1993;
summarize sd if sovdom==1;
summarize sd if drop==0 & sovdom==0;
relogit sd res_ma lpop dist irr_pot largest pdiscrl autlost regmin civwarl sdkinl lgdpl if drop==0 & sovdom==0, cluster(numcode) pc(0.0020 0.0035) level(90);
summarize sd if e(sample);
summarize sd if sec_ma>0;
relogit sd res_ma natsec_ma lpop dist irr_pot largest pdiscrl autlost regmin civwarl sdkinl lgdpl if drop==0 & sovdom==0 & sec_ma==0, cluster(numcode) pc(0.0020 0.0035) level(90);
setx median; setx res_ma 0;
relogitq;
relogitq, fd(pr) changex(res_ma 0 p90);
relogit sd res_ma petrol_ma lpop dist irr_pot largest pdiscrl autlost regmin civwarl sdkinl lgdpl if drop==0 & sovdom==0, cluster(numcode) pc(0.0020 0.0035) level(90);
relogit sd res_ma ressq_ma lpop dist irr_pot largest pdiscrl autlost regmin civwarl sdkinl lgdpl if drop==0 & sovdom==0, cluster(numcode) pc(0.0020 0.0035) level(90);
test res_ma ressq_ma;

log close;
