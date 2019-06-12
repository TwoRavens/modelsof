
cd "C:\Users\Will\Dropbox\Will\Papers\Jennings & Wlezien - MIP & Preferences\PSRM\R1\Replication Files\"

****************
**CORRELATIONS**
****************

******
**UK**
******
use UK_MIPPrefs.dta, clear

*TABLE 1
pwcorr prefs_13 mipshare_13, sig obs
pwcorr prefs_16 mipshare_16, sig obs
pwcorr prefs_03 mipshare_03, sig obs
pwcorr prefs_06 mipshare_06, sig obs

*TEXT ON P.40, CORRELATION OF FIRST DIFFERENCES
tsset year
pwcorr d.prefs_13 d.mipshare_13, sig obs
pwcorr d.prefs_16 d.mipshare_16, sig obs
pwcorr d.prefs_03 d.mipshare_03, sig obs
pwcorr d.prefs_06 d.mipshare_06, sig obs

*TABLE 2
gen mipshare_lib = mipshare_02 + mipshare_03 + mipshare_06 + mipshare_07 + mipshare_13 + mipshare_14
pwcorr  mipshare_lib mood if tin(1975,1995), sig obs

gen prefs_lib=(prefs_03+prefs_06+prefs_13)/3
pwcorr  mipshare_lib prefs_lib if tin(1975,1995), sig obs

*FOOTNOTE 17 
pwcorr  mipshare_01 mood, sig obs

*FOOTNOTE 18: REGRESSION & TIME TREND
gen count=_n-32 if tin(1975,1995)
reg prefs_13 mipshare_13 count
reg prefs_16 mipshare_16 count
reg prefs_03 mipshare_03 count
reg prefs_06 mipshare_06 count

*SUPPLEMENTARY APPENDIX: CLUSTERING OF MIP RESPONSES
keep if tin(1975,1995)
pwcorr mipshare_*, sig obs

*FIGURE 5 & FOOTNOTE 15

* MIP
use UK_MIPPrefs.dta, clear
keep if tin(1975,1995)

stack mipshare_03 mipshare_06 mipshare_13 mipshare_16, into (pct_mip) 
sum pct_mip, detail
ksmirnov pct_mip = normal((pct_mip-r(mean))/r(sd))
swilk pct_mip

* 
histogram  /*
*/ pct_mip if pct_mip<1000 /*
*/ , scheme(s2mono) graphregion(color(white)) /*
*/ fcolor(black) /*
*/ width(1.5) /*
*/ freq /*
*/ normal normopts(lcolor(gs11))  /*
*/ xtitle("MIP (%)", size(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(5)25, labsize(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(0(10)50, gmax angle(horizontal) labsize(medsmall)) /*
*/ ytitle("Frequency", size(medsmall))  /*
*/ title("Most Important Problem (UK)")  /*
*/ saving(histogram_uk_pct_mip, replace) 


* PREFERENCES
use UK_MIPPrefs.dta, clear
keep if tin(1975,1995)

ipolate prefs_03 year, gen(iprefs_03)
ipolate prefs_06 year, gen(iprefs_06)
ipolate prefs_10 year, gen(iprefs_10)
ipolate prefs_13 year, gen(iprefs_13)
ipolate prefs_16 year, gen(iprefs_16)

stack iprefs_03 iprefs_06 iprefs_13 iprefs_16, into (pct_prefs) 
sum pct_prefs, detail
ksmirnov pct_prefs = normal((pct_prefs-r(mean))/r(sd))
swilk pct_prefs

* 
histogram  /*
*/ pct_prefs /*
*/ , scheme(s2mono) graphregion(color(white)) /*
*/ fcolor(black) /*
*/ width(10) /*
*/ freq /*
*/ normal normopts(lcolor(gs11))  /*
*/ xtitle("Net Support (%)", size(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(-100(50)100, labsize(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(0(5)25, gmax angle(horizontal) labsize(medsmall)) /*
*/ ytitle("Frequency", size(medsmall))  /*
*/ title("Relative Preferences (UK)")  /*
*/ saving(histogram_uk_pct_prefs, replace) 




******
**US**
******
use US_MIPPrefs.dta, clear
tsset year

*TABLE 1
pwcorr prefs_03a mipshare_03 if tin(1973,2006), sig obs
pwcorr prefs_06 mipshare_06 if tin(1973,2006), sig obs
pwcorr prefs_07 mipshare_07 if tin(1973,2006), sig obs
pwcorr prefs_12 mipshare_12 if tin(1973,2006), sig obs
pwcorr prefs_13b mipshare_13 if tin(1973,2006), sig obs
pwcorr prefs_14 mipshare_14 if tin(1973,2006), sig obs
pwcorr prefs_16 mipshare_16 if tin(1973,2006), sig obs
pwcorr prefs_17 mipshare_17 if tin(1973,2006), sig obs
pwcorr prefs_19 mipshare_19 if tin(1973,2006), sig obs

*TEXT ON P.40, CORRELATION OF FIRST DIFFERENCES
pwcorr d.prefs_03a d.mipshare_03 if tin(1973,2006), sig obs
pwcorr d.prefs_06 d.mipshare_06 if tin(1973,2006), sig obs
pwcorr d.prefs_07 d.mipshare_07 if tin(1973,2006), sig obs
pwcorr d.prefs_12 d.mipshare_12 if tin(1973,2006), sig obs
pwcorr d.prefs_13b d.mipshare_13 if tin(1973,2006), sig obs
pwcorr d.prefs_14 d.mipshare_14 if tin(1973,2006), sig obs
pwcorr d.prefs_16 d.mipshare_16 if tin(1973,2006), sig obs
pwcorr d.prefs_17 d.mipshare_17 if tin(1973,2006), sig obs
pwcorr d.prefs_19 d.mipshare_19 if tin(1973,2006), sig obs

*TABLE 2
gen mipshare_lib = mipshare_02 + mipshare_03 + mipshare_06 + mipshare_07 + mipshare_13 + mipshare_14
pwcorr  mipshare_lib mood if tin(1973,2006), sig obs

gen prefs_lib=(prefs_03a+prefs_06+prefs_07+prefs_13b+prefs_14)/5
pwcorr  mipshare_lib prefs_lib, sig obs

*FOOTNOTE 17
pwcorr mipshare_01 mood, sig obs

*FOOTOTE 18
gen count=_n-26 if tin(1973,2008)
reg prefs_03a mipshare_03 count if tin(1973,2006)
reg prefs_06 mipshare_06 count if tin(1973,2006)
reg prefs_07 mipshare_07 count if tin(1973,2006)
reg prefs_12 mipshare_12 count if tin(1973,2006)
reg prefs_13b mipshare_13 count if tin(1973,2006)
reg prefs_14 mipshare_14 count if tin(1973,2006)
reg prefs_16 mipshare_16 count if tin(1973,2006)
reg prefs_17 mipshare_17 count if tin(1973,2006)
reg prefs_19 mipshare_19 count if tin(1973,2006)

*SUPPLEMENTARY APPENDIX: CLUSTERING OF MIP RESPONSES
keep if tin(1973,2006)
pwcorr mipshare_*, sig obs

*FIGURE 5 & FOOTNOTE 15

* MIP
use US_MIPPrefs.dta, clear
keep if tin(1973,2006)
stack mipshare_03 mipshare_06 mipshare_07 mipshare_12 mipshare_13 mipshare_14 mipshare_16 mipshare_17 mipshare_19, into (pct_mip)
sum pct_mip, detail
ksmirnov pct_mip = normal((pct_mip-r(mean))/r(sd))
swilk pct_mip

* 
histogram  /*
*/ pct_mip /*
*/ , scheme(s2mono) graphregion(color(white)) /*
*/ fcolor(black) /*
*/ width(2) /*
*/ freq /*
*/ normal normopts(lcolor(gs11))  /*
*/ xtitle("MIP (%)", size(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(10)40, labsize(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(0(25)150, gmax angle(horizontal) labsize(medsmall)) /*
*/ ytitle("Frequency", size(medsmall))  /*
*/ title("Most Important Problem (US)")  /*
*/ saving(histogram_us_pct_mip, replace) 

* PREFS
use US_MIPPrefs.dta, clear
keep if tin(1973,2006)
ipolate prefs_03a year, gen(iprefs_03a)
ipolate prefs_03b year, gen(iprefs_03b)
ipolate prefs_06 year, gen(iprefs_06)
ipolate prefs_07 year, gen(iprefs_07)
ipolate prefs_10a year, gen(iprefs_10a)
ipolate prefs_10b year, gen(iprefs_10b)
ipolate prefs_12 year, gen(iprefs_12)
ipolate prefs_13a year, gen(iprefs_13a)
ipolate prefs_13b year, gen(iprefs_13b)
ipolate prefs_14 year, gen(iprefs_14)
ipolate prefs_16 year, gen(iprefs_16)
ipolate prefs_17 year, gen(iprefs_17)
ipolate prefs_19 year, gen(iprefs_19)
ipolate prefs_21 year, gen(iprefs_21)

stack iprefs_03a iprefs_06 iprefs_07 iprefs_12 iprefs_13b iprefs_14 iprefs_16 iprefs_17 iprefs_19, into (pct_prefs) 
sum pct_prefs, detail
ksmirnov pct_prefs = normal((pct_prefs-r(mean))/r(sd))
swilk pct_prefs

* 
histogram  /*
*/ pct_prefs /*
*/ , scheme(s2mono) graphregion(color(white)) /*
*/ fcolor(black) /*
*/ width(10) /*
*/ freq /*
*/ normal normopts(lcolor(gs11))  /*
*/ xtitle("Net Support (%)", size(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(-100(50)100, labsize(medsmall)) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(0(10)50, gmax angle(horizontal) labsize(medsmall)) /*
*/ ytitle("Frequency", size(medsmall))  /*
*/ title("Relative Preferences (US)")  /*
*/ saving(histogram_us_pct_prefs, replace) 

** COMBINE GRAPHS FOR FIGURE 5 **

graph combine histogram_us_pct_mip.gph histogram_us_pct_prefs.gph histogram_uk_pct_mip.gph histogram_uk_pct_prefs.gph, col(2) title("Distribution of MIP/Preferences") saving(pct.gph, replace)
graph export FIG_PCT.tif

graph combine histogram_us_chg_pct_mip.gph histogram_us_chg_pct_prefs.gph histogram_uk_chg_pct_mip.gph histogram_uk_chg_pct_prefs.gph, col(2) title("Distribution of Percentage Change in MIP/Preferences") saving(pct_chg.gph, replace)
graph export FIG_CHG_PCT.tif

graph combine histogram_us_chg_net_mip.gph histogram_us_chg_net_prefs.gph histogram_uk_chg_net_mip.gph histogram_uk_chg_net_prefs.gph, col(2) title("Distribution of Net Change in MIP/Preferences") saving(net_chg.gph, replace)
graph export FIG_CHG_NET.tif


* GRAPHS FOR FIGURE 3
use US_MIPPrefs.dta, clear
graph set window fontface "Calibri"

* 
twoway /*
*/ (line prefs_03a year, yaxis(1)) /* 
*/ (line mipshare_03 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Health") /*  
*/ ylabel(35(10)75, gmax angle(horizontal)) /*  
*/ ylabel(0(10)40, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_03, replace)

* 
twoway /*
*/ (line prefs_06 year, yaxis(1)) /* 
*/ (line mipshare_06 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Education") /*  
*/ ylabel(35(10)85, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_06, replace)

* 
twoway /*
*/ (line prefs_07 year, yaxis(1)) /* 
*/ (line mipshare_07 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Environment") /*  
*/ ylabel(35(10)75, gmax angle(horizontal)) /*  
*/ ylabel(0(2)8, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*    
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_07, replace)

* 
twoway /*
*/ (line prefs_10a year, yaxis(1)) /* 
*/ (line mipshare_10 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Mass Transit") /*  
*/ ylabel(0(10)50, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_10a, replace)

* 
twoway /*
*/ (line prefs_10b year, yaxis(1)) /* 
*/ (line mipshare_10 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Roads") /*  
*/ ylabel(0(10)50, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_10b, replace)

* 
twoway /*
*/ (line prefs_12 year, yaxis(1)) /* 
*/ (line mipshare_12 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Crime") /*  
*/ ylabel(55(5)75, gmax angle(horizontal)) /*  
*/ ylabel(0(10)40, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_12, replace)

* 
twoway /*
*/ (line prefs_13a year, yaxis(1)) /* 
*/ (line mipshare_13 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Social Programs") /*  
*/ ylabel(35(5)60, gmax angle(horizontal)) /*  
*/ ylabel(0(3)15, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_13a, replace)

* 
twoway /*
*/ (line prefs_13b year, yaxis(1)) /* 
*/ (line mipshare_13 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Welfare") /*  
*/ ylabel(-60(15)0, gmax angle(horizontal)) /*  
*/ ylabel(0(5)20, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_13b, replace)

* 
twoway /*
*/ (line prefs_14 year, yaxis(1)) /* 
*/ (line mipshare_14 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Cities") /*  
*/ ylabel(0(10)50, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*   
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_14, replace)

* 
twoway /*
*/ (line prefs_16 year, yaxis(1)) /* 
*/ (line mipshare_16 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Defense") /*  
*/ ylabel(-40(20)60, gmax angle(horizontal)) /*  
*/ ylabel(0(6)30, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_16, replace)

* 
twoway /*
*/ (line prefs_17 year, yaxis(1)) /* 
*/ (line mipshare_17 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Space") /*  
*/ ylabel(-60(10)-10, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_17, replace)

* 
twoway /*
*/ (line prefs_19 year, yaxis(1)) /* 
*/ (line mipshare_19 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Foreign Aid") /*  
*/ ylabel(-90(10)-40, gmax angle(horizontal)) /*  
*/ ylabel(0(3)15, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_19, replace)

* 
twoway /*
*/ (line prefs_21 year, yaxis(1)) /* 
*/ (line mipshare_21 year, yaxis(2)) /*
*/ if tin(1973,2007) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Parks") /*  
*/ ylabel(0(10)50, gmax angle(horizontal)) /*  
*/ ylabel(0(2)10, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(8)2007) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(mip_prefs_21, replace)

*
grc1leg /* 
*/ mip_prefs_03.gph /* 
*/ mip_prefs_06.gph /* 
*/ mip_prefs_07.gph /* 
*/ mip_prefs_10b.gph /* 
*/ mip_prefs_12.gph /* 
*/ mip_prefs_13b.gph /* 
*/ mip_prefs_14.gph /* 
*/ mip_prefs_16.gph /* 
*/ mip_prefs_17.gph /* 
*/ mip_prefs_19.gph /* 
*/ mip_prefs_21.gph /* 
*/ , col(3) iscale(0.5) /*  
*/ saving(US_Prefs_MIP.gph, replace)

graph export US_Prefs_MIP.tif

* GRAPHS FOR FIGURE 4
use UK_MIPPrefs.dta, clear
graph set window fontface "Calibri"

* 
twoway /*
*/ (line prefs_03 year, yaxis(1)) /* 
*/ (line mipshare_03 year, yaxis(2)) /*
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Health") /*  
*/ ylabel(30(10)90, gmax angle(horizontal)) /*  
*/ ylabel(0(5)30, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(uk_mip_prefs_03, replace)

* 
twoway /*
*/ (line prefs_06 year, yaxis(1)) /* 
*/ (line mipshare_06 year, yaxis(2)) /*
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Education") /*  
*/ ylabel(25(10)85, gmax angle(horizontal)) /*  
*/ ylabel(0(1)6, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(uk_mip_prefs_06, replace)

* 
twoway /*
*/ (line prefs_10 year, yaxis(1)) /* 
*/ (line mipshare_10 year, yaxis(2)) /*
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Roads") /*  
*/ ylabel(0(10)60, gmax angle(horizontal)) /*  
*/ ylabel(0(1)6, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(uk_mip_prefs_10, replace)

* 
twoway /*
*/ (line prefs_13 year, yaxis(1)) /* 
*/ (line mipshare_13 year, yaxis(2)) /*
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Pensions") /*  
*/ ylabel(40(10)90, gmax angle(horizontal)) /*  
*/ ylabel(0(1)5, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(uk_mip_prefs_13, replace)

* 
twoway /*
*/ (line prefs_16 year, yaxis(1)) /* 
*/ (line mipshare_16 year, yaxis(2)) /*
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("Defense") /*  
*/ ylabel(-60(15)30, gmax angle(horizontal)) /*  
*/ ylabel(0(1)6, axis(2) gmax angle(horizontal)) /*  
*/ ytitle("Net Preferences (%)", axis(1) size(small))  /*
*/ ytitle("MIP (%)", axis(2) angle(rvertical) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Preferences") /*  
*/ label(2 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(uk_mip_prefs_16, replace)

*
grc1leg /* 
*/ uk_mip_prefs_03.gph /* 
*/ uk_mip_prefs_06.gph /* 
*/ uk_mip_prefs_10.gph /* 
*/ uk_mip_prefs_13.gph /* 
*/ uk_mip_prefs_16.gph /* 
*/ , col(3) iscale(0.5) /*  
*/ saving(UK_Prefs_MIP.gph, replace) 

graph export UK_Prefs_MIP.tif

* FIGURE 6
use US_MIPPrefs.dta, clear
graph set window fontface "Calibri"

gen mipshare_lib = mipshare_02 + mipshare_03 + mipshare_06 + mipshare_07 + mipshare_13 + mipshare_14
gen prefs_lib=(prefs_03a+prefs_06+prefs_07+prefs_13b+prefs_14)/5

egen std_prefs_lib=std(prefs_lib)
egen std_mipshare_lib=std(mipshare_lib)
egen std_mood=std(mood)

* 
twoway /*
*/ (line std_mood std_prefs_lib std_mipshare_lib year, yaxis(1)) /* 
*/ if tin(1973,2006) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("") /*  
*/ ylabel(-2.5(.5)2.5, gmax angle(horizontal)) /*  
*/ ytitle("", axis(1) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1973(4)2006) /*  
*/ legend( /* 
*/ label(1 "Public Policy Mood") /*  
*/ label(2 "Aggregated Spending Preferences") /*  
*/ label(3 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(std_mip_prefs_mood_lib, replace)

graph export US_AggregatePrefs_MIP.tif

* FIGURE 7
use UK_MIPPrefs.dta, clear
graph set window fontface "Calibri"

gen mipshare_lib = mipshare_02 + mipshare_03 + mipshare_06 + mipshare_07 + mipshare_13 + mipshare_14
gen prefs_lib=(prefs_03+prefs_06+prefs_13)/3

egen std_prefs_lib=std(prefs_lib)
egen std_mipshare_lib=std(mipshare_lib)
egen std_mood=std(mood)

* 
twoway /*
*/ (line std_mood std_prefs_lib std_mipshare_lib year, yaxis(1)) /* 
*/ if tin(1975,1995) /*
*/ , scheme(s2mono) graphregion(color(white)) /*  
*/ xtitle("") /*  
*/ ytitle("") /*  
*/ title("") /*  
*/ ylabel(-2.5(.5)2.5, gmax angle(horizontal)) /*  
*/ ytitle("", axis(1) size(small))  /*
*/ xscale(titlegap(2)) /*  
*/ xlabel(1975(5)1995) /*  
*/ legend( /* 
*/ label(1 "Public Policy Mood") /*  
*/ label(2 "Aggregated Spending Preferences") /*  
*/ label(3 "MIP") /*  
*/ rows(1) size(vsmall) symysize(2) symxsize(5)) /*  
*/ saving(std_mip_prefs_mood_lib, replace)

graph export UK_AggregatePrefs_MIP.tif
