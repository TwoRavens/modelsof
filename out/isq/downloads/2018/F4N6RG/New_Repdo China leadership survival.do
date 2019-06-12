
*Replication do file China and autocratic survival. 
version 11.1
use "SQ regular leadership data", clear

*Define sample
logit leaderfall_reg growthlag lagautopolity   leaderfallregion_reg mduration_reg  if polity2!=. & year>1992 & ctryname!="United States of America",  robust cluster (cowcode) 
gen sample=1 if e(sample)==1


**DURATION: regular leaderfall stcox
sort leaderid year
stset year, id(leaderid)  failure(leaderfall_reg==1) exit(year==2009) origin(syear)  
		
**************TABLE 2: MODELS***************************************************************************************************
*Tab 2, Mod 1
stcox diplomacyAddlag laglnarms laglnexpCHshare  growthlag lngdplag  ///
	lagautopolity   mduration_reg leaderfallregion_reg   if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*Tab 2, Mod 2
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity   if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*Tab 2, Mod 3
stcox lagnoprojectsM  growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity    if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*Tab 2, Mod 4
stcox lagnoprojectsM lagpolitydXChinaaid growthlag lngdplag  ///
	 mduration_reg leaderfallregion_reg lagautopolity  if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*Tab 2, Mod 5
stcox  laglneconcoopMGDP growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity  if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*Tab 2, Mod 6
stcox  laglneconcoopMGDP lagpolitydXlneconcoopMGDP  growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))


***MARGINS*TABLE 3, based on model 2 table 2**********************************************************	
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag ///
	 mduration_reg leaderfallregion_reg lagautopolity lngdplag  if sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
	*demo +/- SD, min, max; auto +/- SD, min, max
margins, atmeans at(lagautopolity=1  laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=-6.37706) at(lagautopolity=1  laglnexpCHshare=1.87976  lagpolitydXlnexpCHshare=1.87976 ) ///
	at(lagautopolity=1  laglnexpCHshare=-13.81551 lagpolitydXlnexpCHshare=-13.81551) at(lagautopolity=1  laglnexpCHshare=3.721473 lagpolitydXlnexpCHshare=3.721473) ///
	at(lagautopolity=0  laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=0) at(lagautopolity=0  laglnexpCHshare=1.87976  lagpolitydXlnexpCHshare=0) ///
	at(lagautopolity=0  laglnexpCHshare=-13.81551  lagpolitydXlnexpCHshare=0) at(lagautopolity=0  laglnexpCHshare=3.721473 lagpolitydXlnexpCHshare=0)

** MARGINS FOR WEIBULL
streg diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag ///
	 mduration_reg leaderfallregion_reg lagautopolity  lngdplag if sample==1, dis (wei) nohr  robust cluster(cowcode)	
	*demo +/- SD, min, max; auto +/- SD, min, max
margins, atmeans  ///
	at(lagautopolity=1  laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=-6.37706) at(lagautopolity=1  laglnexpCHshare=1.87976  lagpolitydXlnexpCHshare=1.87976 ) ///
	at(lagautopolity=1  laglnexpCHshare=-13.81551 lagpolitydXlnexpCHshare=-13.81551) at(lagautopolity=1  laglnexpCHshare=3.721473 lagpolitydXlnexpCHshare=3.721473) ///
	at(lagautopolity=0  laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=0) at(lagautopolity=0  laglnexpCHshare=1.87976  lagpolitydXlnexpCHshare=0) ///
	at(lagautopolity=0  laglnexpCHshare=-13.81551  lagpolitydXlnexpCHshare=0) at(lagautopolity=0  laglnexpCHshare=3.721473 lagpolitydXlnexpCHshare=0)

*********FIGURE 1*****Based on Model 2 in table 2*************************************************
stset year, id(leaderid)  failure(leaderfall_reg==1) exit(year==2009) origin(syear)  
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity   if sample==1, nohr vce(cluster cowcode)
	
sum laglnexpCHshare if e(sample)==1
*display -2.24865 -4.12841
*-6.37706
* display -2.24865 +4.12841
*1.87976

set scheme s1mono
*Effect of Exports in Democracies*
stcurve, survival at1(lagautopolity=1 laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=-6.37706) at2(lagautopolity=1 laglnexpCHshare= 1.87976 ///
	lagpolitydXlnexpCHshare= 1.87976) ylab(,format(%09.1fc)) ytitle("Survival probability") xtitle("Time in years") legend(lab( 1 "Low" "exports") ///
	lab(2 "High" "exports")) lpattern("_" "l") lcolor(black gray) title("Democracies", size(medlarge)) name(repdem1)	
*Effect of Repression in Authoritarian Regimes*
stcurve, survival at1(lagautopolity=0 laglnexpCHshare=-6.37706 lagpolitydXlnexpCHshare=0) at2(lagautopolity=0 laglnexpCHshare= 1.87976 lagpolitydXlnexpCHshare=0) ///
	ylab(,format(%09.1fc)) ytitle("Survival probability") xtitle("Time in years") legend(lab( 1 "Low" "exports") lab(2 "High" "exports")) lpattern("_" "l") lcolor(black gray) ///
	title("Autocracies", size(medlarge)) name(repaut1)
gr combine repdem1 repaut1

	
************ROBUSTNESS****TABLE 5******************************************************************************************************************************** 
sort cowcode year
gen lagtradeGDP=l.tradeGDP
gen lagChinatradeshare=l.Chinatradeshare
sort leaderid year

local US_polityd1 = "laglnUSarms laglnexpUSshare lagvisitsUS "
local oil = "lnoillag laglnoilXlnarms laglnoilXdiplomacyAdd  laglnoilXlnexpCHshare"

*table 5, Mod. 1
streg diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity   if sample==1, dis (wei) nohr  robust cluster(cowcode)	
*table 5, Mod. 2
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity lagtradeGDP if  sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*table 5, Mod. 3
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity lagChinatradeshare if  sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*table 5, Mod. 4
stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity `US_polityd1'  if  sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*table 5, Mod. 5
eststo: stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity subsahara if  sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))
*table 5, Mod. 6
eststo: stcox diplomacyAddlag laglnarms laglnexpCHshare lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms growthlag lngdplag ///
	 mduration_reg leaderfallregion_reg lagautopolity `oil'  if  sample==1, nohr vce(cluster cowcode) ///
	tvc(lagautopolity) texp(ln(_t))



*********************MODEL With IRREGULAR Leaderfall / Regime duration

use "ISQ irrregular leadership data.dta", clear
sort regimeid year
stset year, id(regimeid) failure(fall_irr==1) exit(year==2009) origin(start_irr)
*define sample
logit fall_irr growthlag lagautopolity   fallregion_irr mduration_irr if year>1992 & polity2!=. & ctryname!="United States of America",  robust cluster (cowcode) 
gen sample=1 if e(sample)==1

*****************TABLE 4 ******************************************************************************************************************************************
local duration = "prevleaderfall_irr " /*without time in office*/
local china = "diplomacyAddlag laglnarms laglnexpCHshare"
local lag_polityd ="lagpolitydXdiplomacyAdd lagpolitydXlnexpCHshare lagpolitydXarms"
local controls = "growthlag lagautopolity lngdplag " 

*model 1, tab 4
stcox `china' `duration' `controls' if  sample==1, nohr vce(cluster cowcode) 
*model 2, tab 4
stcox `china' `lag_polityd' `duration' `controls' if  sample==1, nohr vce(cluster cowcode) 
*model 3, tab 4
stcox lagnoprojectsM `duration' `controls' if  sample==1, nohr vce(cluster cowcode) 
*model 4, tab 4
stcox lagnoprojectsM lagpolitydXChinaaid `duration' `controls' if  sample==1, nohr vce(cluster cowcode) 
*model 5, tab 4
stcox laglneconcoopMGDP prevleaderfall_irr `controls' if  sample==1, nohr vce(cluster cowcode) 
*model 6, tab 4
stcox laglneconcoopMGDP lagpolitydXlneconcoopMGDP prevleaderfall_irr `controls' if  sample==1, nohr vce(cluster cowcode) 

