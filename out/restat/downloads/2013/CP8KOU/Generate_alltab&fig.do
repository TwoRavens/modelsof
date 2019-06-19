*** Do file to generate all tables and figures of Growth and lightning paper ***

set more off

**** Table 1, individual states ****

use tab1fig1, clear

xtset id year

forvalues x = 1/40{
varsoc lightning if id==`x', maxlag(5)
} /* Calculates lag length for each state */

mat sic=(1\2\0\0\0\0\0\2\0\0\0\1\2\1\2\1\0\0\0\0\0\2\0\2\1\1\0\2\0\0\3\0\0\0\1\1\0\0\0\0) /*lag-vector for Schwartz*/

forvalues x =1/40{
local lag = sic[`x',1]
dfuller lightning if id==`x', lags(`lag')
} /* Calculates Dickey-Fuller test */

*** Table 1, total US ***

gen wlight = lightning*totalarea
collapse (sum) wlight totalarea, by(year)
gen avglight = wlight/totalarea

tsset year
varsoc avglight, maxlag(5)
dfuller avglight, lags(1)

label var avglight "Average US lightning, flashes per sq km"

*** Figure 1 ***

twoway (tsline avglight) 

*** Table 2 and Figure 2 ***

use tab2+10-12fig2, clear
sum growth7787 growth8797 growth9707 growth7707 growth9107 lightning itcapex2007 internetpresence2003 comppresence2003, det

scatter lightning lightning7795, mlabel(statealpha)
corr lightning lightning7795
reg lightning lightning7795

*** Figure 6 ***
use fig6, clear
forvalues x = 1987/2007{
reg growth`x' ini`x' loglightning, r
}

*** Table 3 (1) ***
use tab3_1, clear
reg  growth logrypw0 tdXloglightning* td_*, r cl(statename)
*** Table 3 (2) ***
use tab3_2tab4-9, clear
reg  growth logrypw0 tdXloglightning* td_*, r cl(statename)

*** Table 3 (3) ***
use tab3_3fig4+5, clear
reg  growth logrypw0 tdXloglightning* td_*, r cl(statename)

*** Figure 4 and 5 ***
reg growth logrypw0 loglightning if year1==1992, r cl(statename)
avplot loglightning, mlabel(statealpha)
reg growth logrypw0 loglightning if year1==2007, r cl(statename)
avplot loglightning, mlabel(statealpha)

*** Table 4 ***
use tab3_2tab4-9, clear
reg growth logrypw0 tdXloglightning* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXenrollrate* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXhighschool* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_* bea8d*, r cl(statename)

*** Table 5 ***
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogtemp* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogpcp* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogtorn* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloghail* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogwind* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloghumid* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogcloud* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogsunsh* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogelev* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglat* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)

*** Table 6 ***
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogtemp* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogpcp* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogtorn* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXloghail* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogwind* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXloghumid* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogcloud* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogsunsh* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogelev* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXloglat* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)

*** Table 7 ***
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXpworkfmining* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXavcoolingdays* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXpslavery* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXnavigable* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXslaveplant* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXsettlerorigin_e* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXsettlerorigin_f* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXsettlerorigin_s* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXsettlerorigin_d* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXsoldierm* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)

*** Table 8 ***
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXpworkfmining* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXavcoolingdays* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXpslavery* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXnavigable* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXslaveplant* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXsettlerorigin_e* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXsettlerorigin_f* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXsettlerorigin_s* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXsettlerorigin_d* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXsoldierm* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)

*** Table 9 ***
reg growth logrypw0 tdXloglightning* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogagrexportspc* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXlogfdipc* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogagrexportspc* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)
reg growth logrypw0 tdXloglightning* tdXlogfdipc* tdXenrollrate* tdXhighschool* tdXbaaspc* td_*, r cl(statename)

*** Table 10 ***
use tab2+10-12fig2, clear
reg comppresence2003 loglightning, r
reg comppresence2003 loglightning logrypw1991, r
reg comppresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg comppresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg internetpresence2003 loglightning, r
reg internetpresence2003 loglightning logrypw1991, r
reg internetpresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning, r
reg itcapex2007 loglightning logrypw1991, r
reg itcapex2007 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg itcapex2007 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r

*** Table 11, panel A ***
reg comppresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning share_Agriculture1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning share_Government1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning share_Manufacturing1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning logfdipc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning logagrexportspc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning logpop91 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning avsoldiermortality18291854 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning pworkfmining1880 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning pslavery1860 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning churchattendance200406_almosteve logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning p1990_white logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning p1990_black logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning p1990_hispanicoriginofanyrace logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning urbanp_1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning popunder15_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg comppresence2003 loglightning popbetween1564_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r

*** Table 11, panel B ***
reg internetpresence2003 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg internetpresence2003 loglightning share_Agriculture1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning share_Government1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning share_Manufacturing1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning logfdipc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning logagrexportspc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning logpop91 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning avsoldiermortality18291854 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning pworkfmining1880 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning pslavery1860 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg internetpresence2003 loglightning churchattendance200406_almosteve logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning p1990_white logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning p1990_black logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning p1990_hispanicoriginofanyrace logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning urbanp_1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning popunder15_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r
reg internetpresence2003 loglightning popbetween1564_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r

*** Table 11, panel C ***
reg itcapex2007 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning share_Agriculture1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning share_Government1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning share_Manufacturing1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning logfdipc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning logagrexportspc1991 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning logpop91 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning avsoldiermortality18291854 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning pworkfmining1880 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning pslavery1860 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning churchattendance200406_almosteve logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning p1990_white logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning p1990_black logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning p1990_hispanicoriginofanyrace logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning urbanp_1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning popunder15_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg itcapex2007 loglightning popbetween1564_p1990 logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r

*** Table 12 ***
reg growth9107 logrypw1991 loglightning, r
reg growth9107 logrypw1991 comppresence2003, r
reg growth9107 logrypw1991 internetpresence2003, r
reg growth9107 logrypw1991 itcapex2007, r
reg growth9107 logrypw1991 loglightning comppresence2003, r
reg growth9107 logrypw1991 loglightning internetpresence2003, r
reg growth9107 logrypw1991 loglightning itcapex2007, r
reg growth9107 logrypw1991 loglightning comppresence2003 internetpresence2003 itcapex2007, r
reg growth9107 logrypw1991 loglightning comppresence2003 internetpresence2003 itcapex2007 enrollrate1991 highschool_higher1990 baaspc1991, r
reg growth9107 logrypw1991 loglightning comppresence2003 internetpresence2003 itcapex2007 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg growth9107 logrypw1991 comppresence2003 internetpresence2003 itcapex2007 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg growth9107 logrypw1991 itcapex2007 enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
reg growth9107 logrypw1991 itcapex2007 enrollrate1991 highschool_higher1990 baaspc1991, r
ivreg2 growth9107 logrypw1991 (itcapex2007=loglightning) enrollrate1991 highschool_higher1990 baaspc1991 bea8d*, r
ivreg2 growth9107 logrypw1991 (itcapex2007=loglightning) enrollrate1991 highschool_higher1990 baaspc1991, r

*** Figure 7-9 ***

scatter internetpresence2003 loglightning, mlabel(statealpha)
scatter comppresence2003 loglightning, mlabel(statealpha)
scatter  itcapex2007 loglightning, mlabel(statealpha)

*** Figure 10 ***

* First stage:
reg itcapex2007 loglightning logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r   
predict itcapex2007hat if e(sample), xb
mat b = e(b)
mat s = e(V)
scal b_l = round(b[1,1],.01)
scal s_l = round(sqrt(s[1,1]),.01)
scal t_l = round(b[1,1]/sqrt(s[1,1]),.01)
local b_l = b_l
local s_l = s_l
local t_l = t_l
avplot loglightning, mlabel(statealpha) note("coef = `b_l', (robust) se = `s_l', t = `t_l'") 

* Second stage:
ivreg2 growth9107 (itcapex2007=loglightning) logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r  
mat b = e(b)
mat s = e(V)
scal b_l = round(b[1,1],.01)
scal s_l = round(sqrt(s[1,1]),.001)
scal z_l = round(b[1,1]/sqrt(s[1,1]),.01)
local b_l = b_l
local s_l = s_l
local z_l = z_l
qui reg growth9107 itcapex2007hat logrypw1991 enrollrate1991 highschool_higher1990 baaspc1991, r 
avplot itcapex2007hat, mlabel(statealpha) note("coef = `b_l', (robust) se = `s_l', z = `z_l'")
