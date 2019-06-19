drop _all

set more off
capture log close
log using "restat.log", replace

use "ReStatdatafinal.dta", clear

*variables of interest
keep country countryid year cyc indq k p pq r tca tcm tce tda tdm tde tea tem tee qnew popnew polity2 

* generate log of tariff variables
gen ltca = log(1+tca)
gen ltcm = log(1+tcm)
gen ltce = log(1+tce)


* these are the 'Nye' tariffs
gen ltda = log(1+tda)
gen ltdm = log(1+tdm)
gen ltde = log(1+tde)


* and these are the ones with raw silk and cotton in exotics
gen ltea = log(1+tea)
gen ltem = log(1+tem)
gen ltee = log(1+tee)

sort year countryid

gen period = 1

replace period = 2 if year == 1877

replace period = 3 if year == 1882

replace period = 4 if year == 1887

replace period = 5 if year == 1892

replace period = 6 if year == 1897

replace period = 7 if year == 1902

replace period = 8 if year == 1907

replace period = 9 if year == 1912

sort year countryid

xtset countryid period

tab year, gen (time)


* generate growth and other variables

gen lynew = log(qnew/popnew)

gen indgrowth = 100*(log(indq[_n+1])-log(indq))/5

gen popgrowthnew = 100*(log(popnew[_n+1])-log(popnew))/5

gen kgrowth = 100*(log(k[_n+1])-log(k))/5

gen rgrowth = 100*(log(r[_n+1])-log(r))/5

gen klgrowthnew = kgrowth - popgrowthnew

gen rlgrowthnew = rgrowth - popgrowthnew

gen growthnew = 100*(lynew[_n+1]-lynew)/5 

gen percapindgrowthnew = indgrowth - popgrowthnew

gen kl = log(k/popnew)

gen rl = log(r/popnew)

gen democtimeskl = polity2*kl

gen democtimesrl = polity2*rl


* generate old and new world dummy variables

gen old = 1

replace old = 0 if countryid==1

replace old = 0 if countryid==7

replace old = 0 if countryid==8

gen new=1-old




* generate tariff variables used in Table 3 (specific tariffs and tariffs by continent)

gen specltca = log(1+(tca*p))

gen specltcm = log(1+(tcm*p))

gen specltce = log(1+(tce*p))



gen ltcaold = ltca*old

gen ltcanew = ltca*new

gen ltcmold = ltcm*old

gen ltcmnew = ltcm*new

gen ltceold = ltce*old

gen ltcenew = ltce*new



* generate tariffs interacted with business cycle
gen ltcacyc = ltca*cyc

gen ltcmcyc = ltcm*cyc

gen ltcecyc = ltce*cyc






*generate demeaned tariffs, (subtract the country means of the tariff variable)

sort countryid
egen cmean_tca=mean(tca), by(countryid)
egen cmean_tcm=mean(tcm), by(countryid)
egen cmean_tce=mean(tce), by(countryid)

gen dm_tca=tca-cmean_tca
gen dm_tcm=tcm-cmean_tcm
gen dm_tce=tce-cmean_tce

* this is to get 'within country' standard deviations for tariffs
sum dm_*



* this gets the information in Table 1
sum growthnew lynew klgrowthnew rlgrowthnew  ltca ltcm ltce polity2 specltca specltcm specltce percapindgrowthnew democtimeskl democtimesrl if year > 1872

* this gets the mean and s.d. per country, allowing us to calculate the coefficient of variation for each country
* the text reports the average of these across countries
by countryid: sum ltca ltcm


* the text also reports correlations between tariffs
cor ltca ltcm ltce


* table 2 in ReStat paper
*specification 'c': Irwin
* Beer and spirits in manufactures; wine in agriculture for wine producers and in exotics elsewhere

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltca ltcm ltce , fe vce(cluster countryid)

outreg using "restatT2.out", bdec(4) nolabel  3aster coefastr se bracket replace

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltca ltcm ltce if countryid>1, fe vce(cluster countryid)

outreg using "restatT2.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltce (ltcm ltca = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltce ltca (ltcm  = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2.out", bdec(4) nolabel  3aster coefastr se bracket append


* Robustness check, not included in ReStat paper
*specification 'd': Nye
* Beer and spirits in manufactures; wine in agriculture for wine producers and in manufacturing elsewhere

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltda ltdm ltde , fe vce(cluster countryid)

outreg using "restatT2a.out", bdec(4) nolabel  3aster coefastr se bracket replace

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltda ltdm ltde if countryid>1, fe vce(cluster countryid)

outreg using "restatT2a.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltde (ltdm ltda = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2a.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltde ltda (ltdm  = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2a.out", bdec(4) nolabel  3aster coefastr se bracket append

* Robustness check, not included in ReStat paper
*specification 'e': Silk and cotton in exotics
* Beer and spirits in manufactures; wine in agriculture for wine producers and in exotics elsewhere

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltea ltem ltee , fe vce(cluster countryid)

outreg using "restatT2b.out", bdec(4) nolabel  3aster coefastr se bracket replace

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltea ltem ltee if countryid>1, fe vce(cluster countryid)

outreg using "restatT2b.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltee (ltem ltea = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2b.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltee ltea (ltem  = polity2 democtimeskl democtimesrl) if countryid>1, fe first robust

outreg using "restatT2b.out", bdec(4) nolabel  3aster coefastr se bracket append




* Table 3 in ReStat paper 

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew specltca specltcm specltce      , fe vce(cluster countryid)

outreg using "restatT3.out", bdec(4) nolabel  3aster coefastr se bracket replace

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew specltce   specltca  ( specltcm = polity2  democtimeskl democtimesrl) if countryid>1, fe robust

outreg using "restatT3.out", bdec(4) nolabel  3aster coefastr se bracket append

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltcaold ltcanew ltcmold ltcmnew ltceold ltcenew      , fe vce(cluster countryid)

outreg using "restatT3.out", bdec(4) nolabel  3aster coefastr se bracket append

xtivreg2 growthnew time2-time7 lynew klgrowthnew rlgrowthnew ltcaold ltcanew ltceold ltcenew ltcmold  (ltcmnew  = polity2  democtimeskl democtimesrl)  if countryid>1  , fe robust endog(ltcmnew)

outreg using "restatT3.out", bdec(4) nolabel  3aster coefastr se bracket append



* interacted with business cycle: reported in paper, but regressions not shown

xtreg growthnew time2-time7 lynew klgrowthnew rlgrowthnew cyc ltca ltcm ltce ltcacyc ltcmcyc ltcecyc, fe vce(cluster countryid)

outreg using "restatT6.out", bdec(4) nolabel  3aster coefastr se bracket replace



* mentioned in paper
reg growthnew percapindgrowthnew

* Table 4 in ReStat paper

xtreg percapindgrowthnew time2-time7 lynew klgrowthnew rlgrowthnew ltca ltcm ltce  , fe vce(cluster countryid)

outreg using "restatT4.out", bdec(4) nolabel  3aster coefastr se bracket replace

xtivreg2 percapindgrowthnew time2-time7 lynew klgrowthnew rlgrowthnew ltce ltca ( ltcm = polity2 democtimeskl democtimesrl) if countryid>1 , fe first robust

outreg using "restatT4.out", bdec(4) nolabel  3aster coefastr se bracket append


* finally generate the figures in the paper

xtline tca tda,i(country) t(year)

graph save ReStatFig1raw, replace

xtline tcm tdm,i(country) t(year)

graph save ReStatFig2raw, replace

xtline tce tde,i(country) t(year)

graph save ReStatFig3raw, replace


scatter growthnew ltca || lfit growthnew ltca

graph save ReStatfig4araw, replace

scatter growthnew ltcm|| lfit growthnew ltcm

graph save ReStatfig4braw, replace

scatter growthnew ltce || lfit growthnew ltce

graph save ReStatfig4craw, replace

graph combine ReStatfig4araw.gph ReStatfig4braw.gph ReStatfig4craw.gph, saving(ReStatfig4raw, replace)











