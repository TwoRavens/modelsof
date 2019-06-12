clear
set mem 333m
set matsize 333
* Kevlihan, DeRouen and Biglaiser ISQ 2014
use "C:\Users\kderouen\Documents\Kevlihan\Kevlihan\Copy of OFDA_11_15_2011_Alliance.dta", clear

tsset Country_Code year, yearly
*tab country, gen(cdum)
*Louvain_No__Dead  Louvain_No__Affected  Louvain_Total_Damage__US_
*gen s2un4608iL			= L.s2un
*gen louvaintotdamage1 		= 1 + Louvain_Total_Damage__US_
*gen louvaindead1  		= 1 + Louvain_No__Dead 
*gen louvainnumber1  		= 1 + Louvain_No__Affected
*ones below are for use in models with unlagged disaster variables
*gen loglouvtotdam 		= log(louvaintotdamage1)
*gen loglouvdead 			= log(louvaindead1) 
*gen loglouvnumber  		= log(louvainnumber1) 
*gen louvaintotdamagel           = L.Louvain_Total_Damage__US_
*gen louvaindeadl                = L.Louvain_No__Dead
*gen louvainnumberl              = L.Louvain_No__Affected
*gen louvaintotdamagel1          = 1 + louvaintotdamagel
*gen louvaindeadl1               = 1 + louvaindeadl 
*gen louvainnumberl1             = 1 + louvainnumberl 
*gen loglouvtotdaml              = log(louvaintotdamagel1)
*gen loglouvdeadl                = log(louvaindeadl1) 
*gen loglouvnumberl              = log(louvainnumberl1) 

*destring gdp_con_2000_, replace
*gen ofdacongdp			= OFDA_Constant /GDP_Con
gen gdpconlog			= log(GDP_Con)
gen gdpcapcon			= gdpconlog/pop
gen gdpcapconl			=L.gdpcapcon
*gen ofdacon_d			= D.OFDA_Constant
*gen ofdacon1			= 1 + OFDA_Constant
*gen ofdaconlog			= log(ofdacon1)

*gen imrl				=L.imr
*gen battdeaths1			=  1  + PRIO_Battle_Deaths_Low
*gen logbattdeaths			= log(battdeaths1)
*gen logbattdeathsl		=L.logbattdeaths
*recode region_wdi_   (7=1) (1/6=0) , gen (africa)
*recode  OFDA_Constant   (0=0) (.000001/1.14e+09  =1) , gen (ofdaselect)
*gen logpopl				=L.logpop
*drop coldwar
*recode year (1989/1990=1) (1991/2009=0), gen (coldwar)
*recode year (1989/2001=0) (2002/2009=1), gen (psept11)
*gen usfdil			= L.usfdi___us_millions_neg
*gen ofdacongdp_d		= D.ofdacongdp
*gen ofdaconlog_d		= D.ofdaconlog
*gen ofdacongdp_dl		= L.ofdacongdp_d
*gen popl			= L.pop
*gen ofdad			= D.OFDA_Constant
*gen realimpl1		= realimpl + 1
*gen logrealimpl		= log(realimpl1)
*gen usimportsl1		= US_Importsl + 1
*gen logusimportsl		= log(usimportsl1)
*gen tradel1			= tradel+1
*gen logtradel		= log(tradel1)
*gen totbilatl1		= Bilateral_TradeL + 1
*gen logtotbilatl    	= log(totbilatl1)	
*gen logtotbilat		= F.logtotbilatl
*gen troopsl1		=1+troopsl
*gen logtroopsl		=log(troopsl1)	
*gen logimrl			=log(imrl)
*gen loggdcapl		=log(gdp_per_capita_l)
*gen	logimrtotall	=logimrl*loglouvtotdam
*gen	logimrdeadl		=logimrl*loglouvdead
*gen	logimrnumberl	=logimrl*loglouvnumber

*egen logimrlmean 		= mean(logimrl)
*gen logimrl_ct 		= logimrl - logimrlmean
*ones below are unlagged
*egen logloutotmean 	= mean(loglouvtotdam)
*gen lloutot_ct		= loglouvtotdam-logloutotmean
*egen logloudeadmean 	= mean (loglouvdead  )
*gen lloudead_ct 		= loglouvdead - logloudeadmean
*egen loglounummean	= mean(loglouvnumber  )
*gen llounum_ct		= loglouvnumber - loglounummean
*gen imrtot_ct		= logimrl_ct * lloutot_ct
*gen imrdead_ct		= logimrl_ct * lloudead_ct 
*gen imrnum_ct		= logimrl_ct * llounum_ct

*ones below are lagged
*egen logloutotmeanl     = mean(loglouvtotdaml)
*gen lloutot_ctl         =loglouvtotdaml-logloutotmean
*egen logloudeadmeanl    = mean (loglouvdeadl  )
*gen lloudead_ctl        =  loglouvdeadl - logloudeadmean
*egen loglounummeanl     = mean(loglouvnumberl  )
*gen llounum_ctl         =       loglouvnumberl - loglounummean
*gen imrtot_ctl          = logimrl_ct * lloutot_ctl
*gen imrdead_ctl         = logimrl_ct * lloudead_ctl 
*gen imrnum_ctl          = logimrl_ct * llounum_ctl
************************************************************

btscs ofdaselect year Country_Code , gen(aidyears) nspline(3)


***********************

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model1

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model2

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1  , corr(ar1) robust
est store model3

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model4

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model5

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model6

esttab model1 model2 model3 model4 model5 model6, se star (+ .1 * .05 ** .005   ) title (xtgee: selection results)
************

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0 , corr(ar1) robust
est store model1x

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0 , corr(ar1) robust
est store model2x

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0  , corr(ar1) robust
est store model3x

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0 , corr(ar1) robust
est store model4x

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0 , corr(ar1) robust
est store model5x

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl   ///
_spline1 _spline2 _spline3 if psept11==0 , corr(ar1) robust
est store model6x

esttab model1x model2x model3x model4x model5x model6x, se star (+ .1 * .05 ** .005   ) title (xtgee: selection results)

********************
xtregar ofdacongdp_d  loglouvtotdaml  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model8

xtregar ofdacongdp_d  loglouvdeadl  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model9

xtregar ofdacongdp_d loglouvnumberl s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model10

xtregar ofdacongdp_d  lloutot_ctl    s2un4608iL polity4l logimrl_ct  imrtot_ctl   logtotbilatl  logbattdeathsl if psept11==1, fe
est store model11

xtregar ofdacongdp_d lloudead_ctl  s2un4608iL  polity4l logimrl_ct imrdead_ctl   logtotbilatl logbattdeathsl if psept11==1, fe
est store model12

xtregar ofdacongdp_d llounum_ctl s2un4608iL  polity4l logimrl_ct  imrnum_ctl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model13

esttab model8 model9 model10 model11 model12 model13, se star (+ .1 * .05 ** .005   ) title (xtregar: main outcome results with logimrl)
***************************
xtregar ofdacongdp_d  loglouvtotdaml  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==0
est store model8x

xtregar ofdacongdp_d  loglouvdeadl  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==0
est store model9x

xtregar ofdacongdp_d loglouvnumberl s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==0
est store model10x

xtregar ofdacongdp_d  lloutot_ctl    s2un4608iL polity4l logimrl_ct  imrtot_ctl   logtotbilatl  logbattdeathsl if psept11==0
est store model11x

xtregar ofdacongdp_d lloudead_ctl  s2un4608iL  polity4l logimrl_ct imrdead_ctl   logtotbilatl logbattdeathsl if psept11==0
est store model12x

xtregar ofdacongdp_d llounum_ctl s2un4608iL  polity4l logimrl_ct  imrnum_ctl  logtotbilatl logbattdeathsl if psept11==0
est store model13x

esttab model8x model9x model10x model11x model12x model13x, se star (+ .1 * .05 ** .005   ) title (xtregar: main outcome results with logimrl)



