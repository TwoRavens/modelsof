*Generation of log of GDP per capita*
generate loggdpcap= log(gdppercapitaconstant2005uswb)

xtset countrycode year 


*Generate singleparty government dummy*
generate singlepartygov=0
replace singlepartygov=1 if herfgov==1 


*Rescale labor market regulation*
generate labormarketregulationsrs= 10-labormarketregulations 

* Pure parisan model*
xtreg labormarketregulations leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1


*Part with rescaled variables*

*Non-lagged version*

* Table 1: Descriptive statistics*
xtsum labormarketregulationsrs leftwingchiefexecutive  gini_market gggrossdebtpctgdpimf  loggdpcap gdpgrowthpctwb unemploymentrateimf checks  underimfprogramme if oecd==1 & labormarketregulationsrs!=. &  leftwingchiefexecutive!=. & gini_market!=. & gggrossdebtpctgdpimf!=. & checks!=. & underimfprogramme!=.

*Table 2 Non-lagged models*
xtreg labormarketregulationsrs   gini_market c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs  c.gini_market##c.leftwingchiefexecutive gggrossdebtpctgdpimf  i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs  c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs loggdpcap c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks  i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  i.year, fe cluster (countrycode), if oecd==1

*Foot note 13: Empty model*
xtreg labormarketregulationsrs   i.year, fe cluster (countrycode), if oecd==1

*Figure 1a: High debt*
xtreg labormarketregulationsrs  c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1
margins, dydx(gini_market) over(leftwingchiefexecutive), if gggrossdebtpctgdpimf>60 
marginsplot, level(90)  title("")xlabel( 0 "Non-left" 1 "Left") xtitle (Government type) ytitle (Effect of market inequality on labor regulation)yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))graphregion(color(white))legend (off) scheme(s2mono)  
graph export mygraph.tif, width(4000)

*Figure 1b: Low debt*
xtreg labormarketregulationsrs  c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1
margins, dydx(gini_market) over(leftwingchiefexecutive), if gggrossdebtpctgdpimf<60 
marginsplot, level(90)title("") xlabel( 0 "Non-left" 1 "Left") xtitle (Government type) ytitle (Effect of market inequality on labor regulation)yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))graphregion(color(white))legend (off) scheme(s2mono)  
graph export mygraph2.tif, width(4000)


*Table 3: Robustness tests*

*Limited index*
generate laborregindexlow= (hiringregulationsandminimumwage + hiringandfiringregulations + hoursregulations + mandatedcostofworkerdismissal)/4
generate laborregindexlowrv= 10-laborregindexlow
xtreg laborregindexlowrv gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  i.year, fe cluster (countrycode), if oecd==1

*Control for union density*
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme ud  i.year, fe cluster (countrycode), if oecd==1

*Control for revenue*
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  ggrevenuepctgdpimf i.year, fe cluster (countrycode), if oecd==1

* Control for post crisis dummy*
generate postcrisis=0
replace postcrisis=1 if year>2008
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  postcrisis i.year, fe cluster (countrycode), if oecd==1

*Excluding countries with over 120 pct. debt to GDP*
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & gggrossdebtpctgdpimf<120.1


*Foot note 17: Removing of one country at the time*
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=7
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=8
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=15
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=30
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=33
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=43
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=44
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=53
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=56
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=57
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=61
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=63
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=72
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=73
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  i.year, fe cluster (countrycode), if oecd==1 & countrycode!=78
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=79
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=80
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=82
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=86
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=97
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=108
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=118
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=122
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=131
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=132
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=146
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=147
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=151
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=159
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=160
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=171
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=177
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=178
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme   i.year, fe cluster (countrycode), if oecd==1 & countrycode!=187

*Foot note 17: The analysis of the limited labor market regulatin index excluding Ireland*
xtreg laborregindexlowrv gdpgrowthpctwb loggdpcap unemploymentrateimf c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive checks underimfprogramme  i.year, fe cluster (countrycode), if oecd==1 & countrycode!=78

*Table 4: The effect of unemployment* 
xtreg labormarketregulationsrs gdpgrowthpctwb loggdpcap  checks underimfprogramme    c.unemploymentrateimf##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive c.gini_market##c.gggrossdebtpctgdpimf##c.leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1 



*Appendix A: Basic model with controls and explanatory variables lagged *
xtreg labormarketregulationsrs  l.gini_market c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs  c.l.gini_market##c.l.leftwingchiefexecutive l.gggrossdebtpctgdpimf  i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs  c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs l.loggdpcap c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs l.gdpgrowthpctwb l.loggdpcap c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive   i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs l.gdpgrowthpctwb l.loggdpcap l.unemploymentrateimf c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive  i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs l.gdpgrowthpctwb l.loggdpcap l.unemploymentrateimf c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive  l.checks i.year, fe cluster (countrycode), if oecd==1
xtreg labormarketregulationsrs l.gdpgrowthpctwb l.loggdpcap l.unemploymentrateimf c.l.gini_market##c.l.gggrossdebtpctgdpimf##c.l.leftwingchiefexecutive l.checks l.underimfprogramme i.year, fe cluster (countrycode), if oecd==1


