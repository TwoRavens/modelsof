* aggrport.do FILE

* TABLE 1 in the paper
* Show aggregate statistics
* statistics are recorded in the log file "AvgPort.txt"
* within the "Portfolios" folder.

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



clear
capture log close
set mem 100m
set more off

log using "AvgPort.txt", text replace
disp("from aggrport.do file")
local i 1
while `i'< 6 {
	use SCF04all, clear /* The SCF dataset with portfolios */

	*****
	keep if imp == `i'
	qui {
		rename x42001 wgt
		egen swgt = sum(wgt)
		gen nwgt = wgt/swgt

		gen tran2 = tran*nwgt
		egen stran = sum(tran2)
		gen tranchk2 = tranchk*nwgt
		egen stranchk = sum(tranchk2)
		gen transav2 = transav*nwgt
		egen stransav = sum(transav2)
		gen tranbrok2 = tranbrok*nwgt
		egen stranbrok = sum(tranbrok2)
		gen tranira2 = tranira*nwgt
		egen stranira = sum(tranira2)
		gen tranret2 = tranret*nwgt
		egen stranret = sum(tranret2)
		gen tranann2 = tranann*nwgt
		egen stranann = sum(tranann2)
		gen trantru2 = trantru*nwgt
		egen strantru = sum(trantru2)
		
		gen govdebt2 = govdebt*nwgt
		egen sgovdebt = sum(govdebt2)

		gen govbnd2 = govbond*nwgt
		egen sgovbnd = sum(govbnd2)
		gen govcrt2 = govcrt*nwgt
		egen sgovcrt = sum(govcrt2)
		gen govsav2 = govsav*nwgt
		egen sgovsav = sum(govsav2)
		gen govtax2 = govtax*nwgt
		egen sgovtax = sum(govtax2)
		gen govmut2 = govmut*nwgt
		egen sgovmut = sum(govmut2)
		gen govlif2 = govlif*nwgt
		egen sgovlif = sum(govlif2)

		gen govmorthous2 = govmorthous*nwgt
		egen sgovmorthous = sum(govmorthous2)
		gen govlineshous2 = govlineshous*nwgt
		egen sgovlineshous = sum(govlineshous2)
		gen govmortrest2 = govmortrest*nwgt
		egen sgovmortrest = sum(govmortrest2)

		gen corbnd2 = corbond*nwgt
		egen scorbnd = sum(corbnd2)
		gen cormkt2 = cormkt*nwgt
		egen scormkt = sum(cormkt2)
		gen coroth2 = coroth*nwgt
		egen scoroth = sum(coroth2)
		gen corbal2 = corbal*nwgt
		egen scorbal = sum(corbal2)
		gen corotm2 = corotm*nwgt
		egen scorotm = sum(corotm2)
		gen corira2 = corira*nwgt
		egen scorira = sum(corira2)
		gen corret2 = corret*nwgt
		egen scorret = sum(corret2)
		gen corann2 = corann*nwgt
		egen scorann = sum(corann2)
		gen cortru2 = cortru*nwgt
		egen scortru = sum(cortru2)

		gen stock2 = stock*nwgt
		egen sstock = sum(stock2)
		gen stosh2 = stosh*nwgt
		egen sstosh = sum(stosh2)
		gen stomut2 = stomut*nwgt
		egen sstomut = sum(stomut2)
		gen stobal2 = stobal*nwgt
		egen sstobal = sum(stobal2)
		gen stooth2 = stooth*nwgt
		egen sstooth = sum(stooth2)
		gen stoira2 = stoira*nwgt
		egen sstoira = sum(stoira2)
		gen storet2 = storet*nwgt
		egen sstoret = sum(storet2)
		gen stoann2 = stoann*nwgt
		egen sstoann = sum(stoann2)
		gen stotru2 = stotru*nwgt
		egen sstotru = sum(stotru2)

		gen restate2 = restate*nwgt
		egen srestate = sum(restate2)
		gen reshous2 = reshous*nwgt
		egen sreshous = sum(reshous2)
		gen resoth2 = resoth*nwgt
		egen sresoth = sum(resoth2)
		gen resira2 = resira*nwgt
		egen sresira = sum(resira2)
		gen resret2 = resret*nwgt
		egen sresret = sum(resret2)
		gen resann2 = resann*nwgt
		egen sresann = sum(resann2)
		gen restru2 = restru*nwgt
		egen srestru = sum(restru2)

		gen hcap2 = hc*nwgt
		egen shcap = sum(hcap2)

		* FINANCIAL WEIGHTS

		gen ssumfin = tran + govbnd + corbnd + stock
		gen msumfin = stran + sgovbnd + scorbnd + sstock

		gen mfintran = stran/msumfin
		gen mfintranchk = stranchk/msumfin
		gen mfintransav = stransav/msumfin
		gen mfintranbrok = stranbrok/msumfin
		gen mfintranira = stranira/msumfin
		gen mfintranret = stranret/msumfin
		gen mfintranann = stranann/msumfin
		gen mfintrantru = strantru/msumfin

		gen mfingovbnd = sgovbnd/msumfin
		gen mfingovcrt = sgovcrt/msumfin
		gen mfingovsav = sgovsav/msumfin
		gen mfingovtax = sgovtax/msumfin
		gen mfingovmut = sgovmut/msumfin
		gen mfingovlif = sgovlif/msumfin
		gen mfincorbnd = scorbnd/msumfin
		gen mfincormkt = scormkt/msumfin
		gen mfincoroth = scoroth/msumfin
		gen mfincorbal = scorbal/msumfin
		gen mfincorotm = scorotm/msumfin
		gen mfincorira = scorira/msumfin
		gen mfincorret = scorret/msumfin
		gen mfincorann = scorann/msumfin
		gen mfincortru = scortru/msumfin
		gen mfinbond = mfingovbnd + mfincorbnd

		gen mfinstock = sstock/msumfin
		gen mfinstosh = sstosh/msumfin
		gen mfinstomut = sstomut/msumfin
		gen mfinstobal = sstobal/msumfin
		gen mfinstooth = sstooth/msumfin
		gen mfinstoira = sstoira/msumfin
		gen mfinstoret = sstoret/msumfin
		gen mfinstoann = sstoann/msumfin
		gen mfinstotru = sstotru/msumfin


		* FINANCIAL AND REAL WEIGHTS

		gen msumtot = stran + sgovbnd + sgovdebt + scorbnd + sstock + srestate + shcap
		gen ssumtot = tran + govbnd + govdebt + corbnd + stock + restate + hc

		gen mtottran = stran/msumtot
		gen mtottranchk = stranchk/msumtot
		gen mtottransav = stransav/msumtot
		gen mtottranbrok = stranbrok/msumtot
		gen mtottranira = stranira/msumtot
		gen mtottranret = stranret/msumtot
		gen mtottranann = stranann/msumtot
		gen mtottrantru = strantru/msumtot

		gen mtotgovbnd = (sgovbnd+sgovdebt)/msumtot
		gen mtotgovcrt = sgovcrt/msumtot
		gen mtotgovsav = sgovsav/msumtot
		gen mtotgovtax = sgovtax/msumtot
		gen mtotgovmut = sgovmut/msumtot
		gen mtotgovlif = sgovlif/msumtot

		gen mtotgovmorthous = sgovmorthous/msumtot
		gen mtotgovlineshous = sgovlineshous/msumtot
		gen mtotgovmortrest = sgovmortrest/msumtot

		gen mtotcorbnd = scorbnd/msumtot
		gen mtotcormkt = scormkt/msumtot
		gen mtotcoroth = scoroth/msumtot
		gen mtotcorbal = scorbal/msumtot
		gen mtotcorotm = scorotm/msumtot
		gen mtotcorira = scorira/msumtot
		gen mtotcorret = scorret/msumtot
		gen mtotcorann = scorann/msumtot
		gen mtotcortru = scortru/msumtot
		gen mtotbond = mtotgovbnd + mtotcorbnd

		gen mtotstock = sstock/msumtot
		gen mtotstosh = sstosh/msumtot
		gen mtotstomut = sstomut/msumtot
		gen mtotstobal = sstobal/msumtot
		gen mtotstooth = sstooth/msumtot
		gen mtotstoira = sstoira/msumtot
		gen mtotstoret = sstoret/msumtot
		gen mtotstoann = sstoann/msumtot
		gen mtotstotru = sstotru/msumtot

		gen mtotrestate = srestate/msumtot
		gen mtotreshous = sreshous/msumtot
		gen mtotresoth = sresoth/msumtot
		gen mtotresira = sresira/msumtot
		gen mtotresret = sresret/msumtot
		gen mtotresann = sresann/msumtot
		gen mtotrestru = srestru/msumtot

		gen mtothcap = shcap/msumtot
	}

	sum mfintran mfinbond mfinstock
	sum mtottran mtotbond mtotstock mtothcap mtotrestate mtotreshous
	save imp`i', replace
	local i = `i'+1

}

clear
use imp1
append using imp2
append using imp3
append using imp4
append using imp5
drop wftran wfbond wfstok wttran wtbond wtstok wtrest wthous wthcap

qui {
	* FINANCIAL WEALTH
	egen wftran = mean(mfintran)
	egen wftranchk = mean(mfintranchk)
	egen wftransav = mean(mfintransav)
	egen wftranbrok = mean(mfintranbrok)
	egen wftranira = mean(mfintranira)
	egen wftranret = mean(mfintranret)
	egen wftranann = mean(mfintranann)
	egen wftrantru = mean(mfintrantru)
	egen wfgovbnd = mean(mfingovbnd)
	egen wfgovcrt = mean(mfingovcrt)
	egen wfgovsav = mean(mfingovsav)
	egen wfgovtax = mean(mfingovtax)
	egen wfgovmut = mean(mfingovmut)
	egen wfgovlif = mean(mfingovlif)
	egen wfcorbnd = mean(mfincorbnd)
	egen wfcormkt = mean(mfincormkt)
	egen wfcoroth = mean(mfincoroth)
	egen wfcorbal = mean(mfincorbal)
	egen wfcorotm = mean(mfincorotm)
	egen wfcorira = mean(mfincorira)
	egen wfcorret = mean(mfincorret)
	egen wfcorann = mean(mfincorann)
	egen wfcortru = mean(mfincortru)
	egen wfstock = mean(mfinstock)
	egen wfstosh = mean(mfinstosh)
	egen wfstomut = mean(mfinstomut)
	egen wfstobal = mean(mfinstobal)
	egen wfstooth = mean(mfinstooth)
	egen wfstoira = mean(mfinstoira)
	egen wfstoret = mean(mfinstoret)
	egen wfstoann = mean(mfinstoann)
	egen wfstotru = mean(mfinstotru)

	* FINANCIAL + REAL WEALTH
	egen wttran = mean(mtottran)
	egen wttranchk = mean(mtottranchk)
	egen wttransav = mean(mtottransav)
	egen wttranbrok = mean(mtottranbrok)
	egen wttranira = mean(mtottranira)
	egen wttranret = mean(mtottranret)
	egen wttranann = mean(mtottranann)
	egen wttrantru = mean(mtottrantru)
	egen wtgovbnd = mean(mtotgovbnd)
	egen wtgovcrt = mean(mtotgovcrt)
	egen wtgovsav = mean(mtotgovsav)
	egen wtgovtax = mean(mtotgovtax)
	egen wtgovmut = mean(mtotgovmut)
	egen wtgovlif = mean(mtotgovlif)
	egen wtgovmorthous = mean(mtotgovmorthous)
	egen wtgovlineshous = mean(mtotgovlineshous)
	egen wtgovmortrest = mean(mtotgovmortrest)
	egen wtcorbnd = mean(mtotcorbnd)
	egen wtcormkt = mean(mtotcormkt)
	egen wtcoroth = mean(mtotcoroth)
	egen wtcorbal = mean(mtotcorbal)
	egen wtcorotm = mean(mtotcorotm)
	egen wtcorira = mean(mtotcorira)
	egen wtcorret = mean(mtotcorret)
	egen wtcorann = mean(mtotcorann)
	egen wtcortru = mean(mtotcortru)
	egen wtstock = mean(mtotstock)
	egen wtstosh = mean(mtotstosh)
	egen wtstomut = mean(mtotstomut)
	egen wtstobal = mean(mtotstobal)
	egen wtstooth = mean(mtotstooth)
	egen wtstoira = mean(mtotstoira)
	egen wtstoret = mean(mtotstoret)
	egen wtstoann = mean(mtotstoann)
	egen wtstotru = mean(mtotstotru)
	egen wtrestate = mean(mtotrestate)
	egen wtreshous = mean(mtotreshous)
	egen wtresoth = mean(mtotresoth)
	egen wtresira = mean(mtotresira)
	egen wtresret = mean(mtotresret)
	egen wtresann = mean(mtotresann)
	egen wtrestru = mean(mtotrestru)
	egen wthcap = mean(mtothcap)
	replace wtgovmorthous = -wtgovmorthous
	replace wtgovlineshous = -wtgovlineshous
	replace wtgovmortrest = -wtgovmortrest
}
keep if imp == 1
gen wfbond = wfgovbnd + wfcorbnd
gen wtbond = wtgovbnd + wtcorbnd

disp("Average from imputations")
disp("Financial portfolio")
sum wftran* wfgov* wfcor* wfsto*
sum wftran wfbond wfstock
disp("Financial and real portfolio")
sum wttran* wtgov* wtcor* wtsto* wtres* wthcap
sum wttran wtbond wtstock wtrestate wtreshous wthcap

log close
