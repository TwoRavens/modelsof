/************************************************************************************************************************************
Conti and Pudney
Survey Design and the Analysis of Satisfaction
Review of Economics and Statistics, 2011
************************************************************************************************************************************/

clear
set mem 100m
use "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear

ta lfsat5, g(sat)


******************************************************************TABLE 3*********************************************************************
**********************************************************************************************************************************************
**********************************************Modelling the determinants of discrepant responses**********************************************
****************************************************************Asymmetric********************************************************************

mlogit dsat sat2-sat6 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess ///
    technic cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 if male==1, cl(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/mlogit_dsat_male", replace
mfx, predict(p outcome(1)) 
mfx, predict(p outcome(2)) 
estat su

mlogit dsat sat2-sat6 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess ///
    technic cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 if male==0, b(0) cl(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/mlogit_dsat_female", replace
mfx, predict(p outcome(1)) 
mfx, predict(p outcome(2)) 
estat su



*****************************************************************TABLE 4*********************************************************************
*********************************************************************************************************************************************
******************************************************Static model of job satisfaction*******************************************************

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
reoprob jbsat male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_jbsat", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
reoprob lfsat5 male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_lfsat5", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==1
reoprob jbsat indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_jbsat_males", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==0
reoprob jbsat indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_jbsat_females", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==1
reoprob lfsat5 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_lfsat5_males", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==0
reoprob lfsat5 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_lfsat5_females", replace
estat su


*********************************************************************************************************************************************
******************************************************Static model of job satisfaction*******************************************************
*****************************************************************Chamberlain*****************************************************************

*Chamberlain-type modelling of the individual effects
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob jbsat male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chambjbsat", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob lfsat5 male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chamblfsat5", replace
estat su

*MALES - JBSAT
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==1
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob jbsat indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chambjbsat_male", replace
estat su

*FEMALES - JBSAT
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==0
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob jbsat indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chambjbsat_female", replace
estat su

*MALES - LFSAT5
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==1
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob lfsat5 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chamblfsat5_male", replace
estat su

*FEMALES - LFSAT5
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
keep if male==0
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
reoprob lfsat5 indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_chamblfsat5_female", replace
estat su


*********************************************************************************************************************************************
******************************************************Dynamic model of job satisfaction******************************************************

*Wooldridge-style method for the treatment of the initial conditions.
u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
bys pid: g jbsat0=jbsat[1]
ta jbsat0, g(jbsat0dum)
so pid wave
g ljbsat=l.jbsat
ta ljbsat, g(ljbsatdum)
reoprob jbsat ljbsatdum2-ljbsatdum7 jbsat0dum2-jbsat0dum7 ///
    male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w7-w10 w13-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_dynjbsat", replace
estat su

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", clear
foreach x in age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland {
    egen m`x'=mean(`x'), by(pid)
}
so pid wave
bys pid: g lfsat50=lfsat5[1]
ta lfsat50, g(lfsat50dum)
so pid wave
g llfsat5=l.lfsat5
ta llfsat5, g(llfsat5dum)
reoprob lfsat5 llfsat5dum2-llfsat5dum7 lfsat50dum2-lfsat50dum7 ///
    male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w7-w10 w13-w14 mage-mScotland, i(pid)
outreg2 using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/reoprob_dynlfsat5", replace
estat su


