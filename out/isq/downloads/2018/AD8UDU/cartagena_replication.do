
/**************************************************************************
** 
** File name   : Cartagena.do
** Date        : June 10th, 2011
** Author      : Christina J. Schneider (cjschneider@ucsd.edu)
** Paper Title : Distributional Conflict Between Powerful States and International Treaty Ratification
** Purpose     : Produce graphs & estimate the quantitative models
** Requires    : cartagena_replication.dta, cartagena_replication.do
** Output      : cartagena_replication.smcl 
**
**************************************************************************/
version 11.1

#delimit ;
set more off;
cd "/Users/Christina/Dropbox/Work/Projects/2011/Cartagena/analysis/replication package\";


use cartagena_replication, replace;
log using cartagena_replication, replace;


**Figure 3**;

stset cartafail_mths1, fail(cartafail_dum1) id(ccode); 
sts graph, failure ci legend(off) scheme(s1mono)  xtitle("Months") title(""); 

**Descriptive Statistics**;

drop missind;

gen missind = missing(cartafail_mths1) +missing(aid_us) + missing(aid_eu)+missing(mnna)+missing(gmo_tot) + missing(euapplicant)
	+ missing(eumember) + missing(population_ln) + missing(polity) + missing(gdp_percap_ln)+missing(pta_us)+missing(pta_eu)
	+missing(military)+missing(govright)+missing(presidential)+missing(carta_sign)+missing(carta_rat_pct)+missing(nato)+missing(export_us)
	+missing(export_eu);

sum cartafail_mths1 aid_us aid_eu mnna gmo_tot euapplicant eumember population_ln polity gdp_percap_ln pta_us pta_eu 
	export_eu export_us military govright presidential carta_sign carta_rat_pct europe americas africa asia nato 
	if year>1999&missind==0;


**Table 3**;

stset cartafail_mths1, fail(cartafail_dum1) id(ccode);

*Model 1*;

stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln) texp(ln(_t));

*Model 2*;

stcox  if ccode!=663&oecd_rich==0, vce( cluster ccode) tvc(aid_us aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln) texp(ln(_t));

*Model 3*;

stcox if ccode!=663&euappmem==0, vce( cluster ccode) tvc(aid_us aid_eu mnna  gmo_tot population_ln polity gdp_percap_ln  ) texp(ln(_t));


**Table 4**;

*Model 4*;
stcox  if ccode!=663, vce( cluster ccode) tvc(mnna gmo_tot eumember  population_ln polity gdp_percap_ln pta_us pta_eu) texp(ln(_t));

*Model 5*;
stcox  if ccode!=663, vce( cluster ccode) tvc(export_eu export_us mnna gmo_tot eumember  population_ln polity gdp_percap_ln) texp(ln(_t));

*Model 6*;
stcox if ccode!=663, vce( cluster ccode) tvc(aid_us  aid_eu mnna gmo_tot eumember population_ln polity gdp_percap_ln carta_sign carta_rat_pct ) texp(ln(_t));

*Model 7*;
stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln europe americas africa asia  ) texp(ln(_t));



**Table 5**


*Model 8*;

stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us aid_eu mnna gmo_tot euapplicant eumember population_ln polity gdp_percap_ln) texp(ln(_t));

*Model 9*;
stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln military govright presidential ) texp(ln(_t));

*Model 10*;
stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us aid_eu mnna gmo_tot eumember population_ln polity gdp_percap_ln nato) texp(ln(_t));


**Table 6**

*Model 11*;

stcox aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln if ccode!=663, vce( cluster ccode);

*Model 12*;

stset cartafail_mths, fail(cartafail_dum) id(ccode);
stcox  if ccode!=663, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember population_ln polity gdp_percap_ln  ) texp(ln(_t));

*Model 13*;

drop  cartafail_years _spline*;
btscs cartafail_dum1 year ccode, g(cartafail_years) nspline(4);
logit cartafail_dum1  aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln _spline* if ccode!=663;


**Table 7**;

stset cartafail_mths1, fail(cartafail_dum1) id(ccode);

*Model 14*;

stcox if year>=1999, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln ) texp(ln(_t));

*Model 15*;

stcox if year>=1999&ccode!=663&ccode!=666, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln ) texp(ln(_t));

*Model 16*;
stcox if year>=1999&ccode!=663&ccode!=651, vce( cluster ccode) tvc(aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln ) texp(ln(_t));




log close;
exit;

**Outlier Analysis**

set matsize 11000;
drop esr*;
*drop s1-s8;
stset cartafail_mths1, fail(cartafail_dum1) id(ccode);
stcox  aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln, vce( cluster ccode) esr(esr*);
mkmat esr*, matrix(esr);
mat V = e(V);
mat Inf = esr*V;
svmat Inf, names(s);

label variable s1 "Dfbeta p.c. USA Aid";
label variable s2 "Dfbeta p.c. EC Aid";
label variable s3 "Dfbeta Major Non-NATO Alliance";
label variable s4 "Dfbeta Total GMO Area";
label variable s5 "Dfbeta EU Memhber";
label variable s6 "Dfbeta Population";
label variable s7 "Dfbeta Level of Democracy";
label variable s8 "Dfbeta GDP per capita";

scatter s1 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s2 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s3 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s4 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s5 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s6 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s7 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

scatter s8 _t, yline(0) mlabel(country_name_short) msymbol(i) scheme(s1mono) legend(off) xtitle("Months");

log close;



drop  cartafail_years _spline*
btscs cartafail_dum1 year ccode, g(cartafail_years) nspline(4)
logit cartafail_dum1  aid_us   aid_eu mnna gmo_tot eumember  population_ln polity gdp_percap_ln _spline* if ccode!=663



