/* Regression code used in "Too Much Pay Performance Sensitivity?" by Ivan Brick, Oded Palmon, and John Wald.  This code was written by John Wald.
Please contact me at john.wald@utsa.edu with questions about the code.

This is not a complete version of every regression or statistical test for the paper, but it does contain the bulk of the results.

Typically, a p1 indicates plus one year in the future, an m1 means one year in the past.  excessff stands for Fama-French excess returns.  The data file
was created by Ivan Brick, ibrick@andromeda.rutgers.edu.

*/


clear
set memory 500m
set matsize 800
set type double, perm

insheet using "X:\lie480\Nbpw\wald.accountrestat2.csv"

sort gvkey year 
tsset gvkey year, yearly

tab year, gen(yd)
gen sic2 = int(sic/100)
replace sic = int(sic/1000)
tab sic2, gen(indud)
tab sic, gen(indd)

/* generate some control variables */

gen smdebt = (ltdm+clm)/(ltdm+clm+equitym)
gen fmdebt = (ltd1+cl1)/(ltd1+cl1+equity1)
gen mktbk = (equity0 + ltd0 + curlib)/ta0
gen lev0 = (ltd0+curlib)/ta0
gen fdebt = (ltd1+cl1)/ta1
gen sdebt = (curlib+ltd0)/ta0
gen debtdif = fdebt-sdebt
gen debtmdif = fmdebt-smdebt
gen fcapx = capx1/ta1
gen capxdif = fcapx-scapx
gen pceonc = (tdc1-tcc)/tdc1 
drop sempl
gen sempl = log(empl0)

gen ltdc1 = log(tdc1)
gen lsales = log(sales0)
gen sppe = ppe0/ta0

gen chair = n1ceochair 

gen excess = excess12
gen excessff = excess12ff136m
gen excessff3 = excess3ff136m


drop srd sadv
gen srd = rd0/ta0
replace srd = 0 if srd == .
gen sadv = adv0/ta0
replace sadv = 0 if sadv == .

/* gen chair = mceochair */

gen alphap36 = valpha36
gen betap36 = vbeta36
gen psdresi = vsdresi36
gen alpham36 = valpham36
gen betam36 = vbetam36
gen msdresi = vsdresmi36
gen nexcessff12 = excess12ff136
gen nexcessff36 = excess36ff136
gen  excess1t3n = excess3

summarize mattend mindep ndid chair chair tenure bsvola bsyield annvol roam sppe srd sadv scapx sempl sdebt salesm lsales cfrisk8 cfrisk7  ltdc1 pceonc 
summarize ppscurrent vegacurrent totpps totvega dirpps dirvega excess excessff alphap36 betap36 pvariance psdresi alpham36 betam36 mvariance msdresi


drop if totpps == .

gen ltotpps = ln(totpps)
gen ltotvega = ln(totvega+1)
gen ldirpps = log(1+dirpps)
gen ldirpps2 = ldirpps^2
gen ldirvega = log(1+dirvega)
gen ldirvega2 = ldirvega^2

gen ceoshrown = shrown/(shrsout*1000)
gen ceoshrown2 = ceoshrown^2


gen optpps = totcurpps1+ppsprevex+ppsprevun
gen loptpps = log(1+optpps)
gen stkpps = totcurpps-totcurpps1
gen lstkpps = log(1+stkpps)

gen optper = optpps/totpps

gen excess9 = excess-excess3
gen excessff9 = excessff-excessff3

sort gvkey year


gen ceocash = (1-pceonc)*tdc1
gen lsales0 = log(sales0)
gen lpsdresi = log(psdresi)
gen lceocash = log(ceocash+1)

winsor psdresi, gen(wpsdresi) p(.005)
winsor lpsdresi, gen(wlpsdresi) p(.005)
winsor msdresi, gen(wmsdresi) p(.005)


winsor totvega, gen(wtotvega) p(.005)
winsor ltotvega, gen(wltotvega) p(.005)
winsor totpps, gen(wtotpps) p(.005)
winsor ltotpps, gen(wltotpps) p(.005)
gen wltotpps2 = wltotpps^2

winsor ceocash, gen(wceocash) p(.005)
winsor lceocash, gen(wlceocash) p(.005)
winsor sales0, gen(wsales0) p(.005)
winsor sempl, gen(wsempl) p(.005)
winsor lsales0, gen(wlsales0) p(.005)
winsor roam, gen(wroam) p(.005)
winsor roa1, gen(wroa1) p(.005)
winsor roa0, gen(wroa0) p(.005)
winsor roa3, gen(wroa3) p(.005)
winsor mktbk, gen(wmktbk) p(.005)
winsor srd, gen(wsrd) p(.005)
winsor sadv, gen(wsadv) p(.005)
winsor scapx, gen(wscapx) p(.005)
winsor fcapx, gen(wfcapx) p(.005)
winsor lev0, gen(wlev0) p(.005)
winsor fdebt, gen(wfdebt) p(.005)
winsor sppe, gen(wsppe) p(.005)
winsor betam36, gen(wbetam36) p(.005)
winsor betap36, gen(wbetap36) p(.005)
winsor sdebt, gen(wsdebt) p(.005)
winsor bsyield, gen(wbsyield) p(.005)
winsor pceonc, gen(wpceonc) p(.005)
winsor ldirpps, gen(wldirpps) p(.005)
winsor loptpps, gen(wloptpps) p(.005)
winsor lstkpps, gen(wlstkpps) p(.005)


winsor excess12, gen(wexcess12) p(.005)
winsor excess36, gen(wexcess36) p(.005)
winsor excessff, gen(wexcessff12) p(.005)
winsor excess36ff136m, gen(wexcessff36) p(.005)

winsor nexcess12, gen(wnexcess12) p(.005)
winsor nexcess36, gen(wnexcess36) p(.005)
winsor nexcessff12, gen(wnexcessff12) p(.005)
winsor nexcessff36, gen(wnexcessff36) p(.005)
/* winsor meanp, gen(wmeanp) p(.005)
winsor meanm, gen(wmeanm) p(.005) */
winsor excess1t3n, gen(wexcess1t3n) p(.005)
/* winsor excess4t12n, gen(wexcess4t12n) p(.005)
winsor eqexcess4t12n, gen(weqexcess4t12n) p(.005) */
winsor valpha1, gen(wvalpha1) p(.005)
winsor valpham36, gen(wvalpha0) p(.005) /* note var name change */



summarize rawret12 rawret24 rawret36 eqexcess12 eqexcess36 neqxcess12 neqxcess36
winsor rawret12, gen(wrawret12) p(.005)
winsor rawret24, gen(wrawret24) p(.005)
winsor rawret36, gen(wrawret36) p(.005)
winsor eqexcess12, gen(weqexcess12) p(.005)
winsor eqexcess36, gen(weqexcess36) p(.005)
winsor neqxcess12, gen(wneqxcess12) p(.005)
winsor neqxcess36, gen(wneqxcess36) p(.005)
/* winsor excess4t39, gen(wexcess4t39) p(.005) */
winsor alphap36, gen(walphap) p(.005)
winsor alpham36, gen(walpham) p(.005)
winsor cfrisk8, gen(wcfrisk8) p(.005)
winsor bsvola, gen(wbsvola) p(.005)

/* winsor beta160, gen(wbeta160) p(.005) */
/* winsor beta601, gen(wbeta601) p(.005) */


/* Coles regressions with 1-year total risk: */
 winsor varp, gen(wvar1) p(.005)
winsor var0, gen(wvar0) p(.005)
gen lvar1 = log(wvar1)
gen lvar0 = log(wvar0)
gen std1 = wvar1^.5
gen std0 = wvar0^.5
tabstat varp var0 lvar1 lvar0 std1 std0, statistics(mean median skewness kurtosis) columns(statistics)

gen vgpsrat = wltotvega/wltotpps 
gen vgpsnlog = totvega/totpps
winsor vgpsnlog, gen(wvgpsnlog) p(.005)
sum vgpsnlog wvgpsnlog


log using "X:\lie480\Nbpw\restatfinal.out", text replace

/*
tabstat wexcess4t15 wexcess4t39 weqexcess4t15 weqexcess4t39, statistics( mean median sd count skewness kurtosis) columns(statistics)
*/

tab sic

pwcorr wltotpps wtotpps wltotvega wtotvega vgpsrat wvgpsnlog, sig
gen ceotcomp = exp(ltdc1)

tabstat wtotpps wltotpps wtotvega wltotvega vgpsrat wbetap36 wpsdresi wrawret12 wrawret36 wexcess12 wexcess36 weqexcess12 weqexcess36 wexcessff12 wexcessff36 tenure wceocash wlsales0 wmktbk wsrd wscapx wsdebt wroam wsadv wsppe wsempl wsdebt wlsales wcfrisk8 wbsvola chair mindep ndid walphap lvar1 ltdc1 ceotcomp wpceonc wroam wldirpps, statistics( mean median sd count skewness kurtosis) columns(statistics) 
pwcorr wbetap36 wrawret12 wpsdresi wexcess12 wexcess36 wexcessff12 wexcessff36 wltotpps wltotvega, sig 

tabstat wrawret12 wrawret24 wrawret36 weqexcess12 weqexcess36 wneqxcess12 wneqxcess36, statistics( mean median sd count skewness kurtosis) columns(statistics)


/* With year dummies */

regress lvar1 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt indu*  yd*, cluster(gvkey)
xtreg lvar1 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt yd*, fe cluster(gvkey)



/* With twice lagged tot standard deviation  */
regress lvar1 lvar0 L.lvar0 L2.lvar0 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt indu*  yd*, cluster(gvkey)
xtreg lvar1 lvar0 L.lvar0 L2.lvar0 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt yd*, fe cluster(gvkey)


/* similar sample */
 regress lvar1 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt indu*  yd* if gvkey == L2.gvkey & L.lvar0 != . & L2.lvar0 != ., cluster(gvkey)
xtreg lvar1 wltotvega wltotpps tenure wlceocash wlsales0 wmktbk wsrd wscapx wsdebt yd* if gvkey == L2.gvkey & L.lvar0 != . & L2.lvar0 != ., fe cluster(gvkey)



/* Granger Causality */
regress lvar1 lvar0 wltotpps, cluster(gvkey)
regress wtotpps L.wtotpps L.lvar0 if year == L.year+1 & gvkey == L.gvkey, cluster(gvkey)

regress lvar1 lvar0 wltotvega, cluster(gvkey)

/*
summarize wbeta160 wbeta601
*/

/* Do levels in PPS lead to changes in beta? */
/* regress wbeta160 wbeta601 wltotpps indud* yd*, cluster(gvkey)
xtreg wbeta160 wbeta601 wltotpps yd*, fe cluster(gvkey)


regress wbeta160 wbeta601 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wbeta160 wbeta601 wltotpps wltotvega yd*, fe cluster(gvkey) */

/*
regress wbeta160 wbeta601 L.wbeta601 wltotpps if year == L.year+1 & gvkey == L.gvkey, cluster(gvkey)
regress wbeta160 wbeta601 L.wbeta601 wtotpps if year == L.year+1 & gvkey == L.gvkey, cluster(gvkey)
regress wltotpps L.wtotpps L2.wtotpps wbeta601 if year == L.year+1 & gvkey == L2.gvkey, cluster(gvkey)
regress wtotpps L.wtotpps L2.wtotpps wbeta601 if year == L.year+1 & gvkey == L2.gvkey, cluster(gvkey)
*/

/* Does higher PPS imply lower idiosyncratic risk? */
regress wpsdresi wltotpps wmsdresi indud* yd*, cluster (gvkey)
xtreg wpsdresi wltotpps wmsdresi yd*, fe cluster(gvkey)


regress wpsdresi wltotpps wltotvega wmsdresi indud* yd*, cluster (gvkey)
xtreg wpsdresi wltotpps wltotvega wmsdresi yd*, fe cluster(gvkey)



/* Granger causality with investment */
regress wfcapx wscapx L.wscapx wltotpps, cluster(gvkey)
regress wltotpps L.wltotpps wscapx , cluster(gvkey)
xtreg wfcapx wscapx L.wscapx wltotpps, fe cluster(gvkey)
xtreg wltotpps L.wltotpps wscapx , fe cluster(gvkey)


/* Does higher PPS imply lower alpha? */
regress walphap wltotpps wltotvega walpham indud* yd*, cluster (gvkey)
xtreg walphap wltotpps wltotvega walpham yd*, fe cluster(gvkey)
regress walphap wltotpps wltotvega indud* yd*, cluster (gvkey)
xtreg walphap wltotpps wltotvega yd*, fe cluster(gvkey)


/* Does higher PPS imply lower beta? */
regress wbetap36 wltotpps wbetam36 indud* yd*, cluster (gvkey)
xtreg wbetap36 wltotpps wbetam36 yd*, fe cluster(gvkey)
regress wbetap36 wltotpps wltotvega wbetam36 indud* yd*, cluster (gvkey)
xtreg wbetap36 wltotpps wltotvega wbetam36 yd*, fe cluster(gvkey)


/* Does higher PPS imply lower mean returns? */
/*
regress wmeanp wltotpps wmeanm indud* yd*, cluster (gvkey)
xtreg wmeanp wltotpps wmeanm yd*, fe cluster(gvkey)
regress wmeanp wltotpps wltotvega wmeanm indud* yd*, cluster (gvkey)
xtreg wmeanp wltotpps wltotvega wmeanm yd*, fe cluster(gvkey)
*/

/* New tests with more raw returns */
regress wrawret12 wltotpps indud* yd*, cluster (gvkey)
xtreg wrawret12 wltotpps yd*, fe cluster(gvkey)

regress wrawret24 wltotpps indud* yd*, cluster (gvkey)
xtreg wrawret24 wltotpps yd*, fe cluster(gvkey)

regress wrawret36 wltotpps indud* yd*, cluster (gvkey)
xtreg wrawret36 wltotpps yd*, fe cluster(gvkey)


regress wrawret12 wltotpps wltotvega indud* yd*, cluster (gvkey)
xtreg wrawret12 wltotpps wltotvega yd*, fe cluster(gvkey)

regress wrawret24 wltotpps wltotvega indud* yd*, cluster (gvkey)
xtreg wrawret24 wltotpps wltotvega yd*, fe cluster(gvkey)

regress wrawret36 wltotpps wltotvega indud* yd*, cluster (gvkey)
xtreg wrawret36 wltotpps wltotvega yd*, fe cluster(gvkey)



/* Does more total pps help or not? */
regress wexcess12 wltotpps indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps yd*, fe cluster(gvkey)

regress wexcess12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega yd*, fe cluster(gvkey)

/* regressions with vega pps ratios */
regress wexcess12 wltotpps wltotvega vgpsrat indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega vgpsrat yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega vgpsrat indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega vgpsrat yd*, fe cluster(gvkey)

regress wexcess12 wltotpps wltotvega wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega wvgpsnlog yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega wvgpsnlog yd*, fe cluster(gvkey)

regress wexcess12 wltotpps vgpsrat indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps vgpsrat yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps vgpsrat indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps vgpsrat yd*, fe cluster(gvkey)

regress wexcess12 wltotpps wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wvgpsnlog yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wvgpsnlog yd*, fe cluster(gvkey)


regress wexcess12 wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcess12 wvgpsnlog yd*, fe cluster(gvkey)
regress wexcessff12 wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wexcessff12 wvgpsnlog yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega wvgpsnlog yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega wvgpsnlog yd*, fe cluster(gvkey)

regress wnexcess12 wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wnexcess12 wvgpsnlog yd*, fe cluster(gvkey)
regress wnexcessff12 wvgpsnlog indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wvgpsnlog yd*, fe cluster(gvkey)


bysort year: regress wexcess12 wltotpps wltotvega indud*, robust

/* What if excess returns are calculated ex-post? */
regress wnexcess12 wltotpps indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega vgpsrat indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega vgpsrat yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega vgpsrat indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega vgpsrat yd*, fe cluster(gvkey)



/* New test with equally weighted excess returns */
regress weqexcess12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg weqexcess12 wltotpps wltotvega yd*, fe cluster(gvkey)
regress weqexcess36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg weqexcess36 wltotpps wltotvega yd*, fe cluster(gvkey)

regress wneqxcess12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wneqxcess12 wltotpps wltotvega yd*, fe cluster(gvkey)
regress wneqxcess36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wneqxcess36 wltotpps wltotvega yd*, fe cluster(gvkey)

/* Robustness check - does leaving 3 months after matter? */

gen excess4t12 = excess12/excess3
winsor excess4t12, gen(wexcess4t12) p(.005)
gen nexcess4t12 = nexcess12twel/nexcess3twel
winsor nexcess4t12, gen(wnexcess4t12) p(.005)

regress wexcess4t12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wexcess4t12 wltotpps wltotvega indud* yd*, fe cluster(gvkey)

regress wnexcess4t12 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcess4t12 wltotpps wltotvega indud* yd*, fe cluster(gvkey)

/* regress wexcess4t12n wltotpps wltotvega indud* yd*, cluster(gvkey)
regress weqexcess4t12n wltotpps wltotvega indud* yd*, cluster(gvkey)

xtreg wexcess4t12n wltotpps wltotvega indud* yd*, fe cluster(gvkey)
xtreg weqexcess4t12n wltotpps wltotvega indud* yd*, fe cluster(gvkey) */

/* How about alpha?  */
/* regress wvalpha1 wltotpps indud* yd*, cluster(gvkey)
xtreg wvalpha1 wltotpps yd*, fe cluster(gvkey)
regress wvalpha1 wvalpha0 wltotpps indud* yd*, cluster(gvkey)
xtreg wvalpha1 wvalpha0 wltotpps yd*, fe cluster(gvkey)
regress walphap wltotpps indud* yd* if excess36 != ., cluster(gvkey)
xtreg walphap wltotpps yd* if excess36 != ., fe cluster(gvkey) */

/* What happens over a longer time horizon? */
regress wexcess36 wltotpps indud* yd*, cluster(gvkey)
xtreg wexcess36 wltotpps yd*, fe cluster(gvkey)
regress wexcessff36 wltotpps indud* yd*, cluster(gvkey)
xtreg wexcessff36 wltotpps yd*, fe cluster(gvkey)

regress wexcess36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wexcess36 wltotpps wltotvega yd*, fe cluster(gvkey)
regress wexcessff36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wexcessff36 wltotpps wltotvega yd*, fe cluster(gvkey)


regress wnexcess36 wltotpps indud* yd*, cluster(gvkey)
xtreg wnexcess36 wltotpps yd*, fe cluster(gvkey)
regress wnexcessff36 wltotpps indud* yd*, cluster(gvkey)
xtreg wnexcessff36 wltotpps yd*, fe cluster(gvkey)

regress wnexcess36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcess36 wltotpps wltotvega yd*, fe cluster(gvkey)
regress wnexcessff36 wltotpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcessff36 wltotpps wltotvega yd*, fe cluster(gvkey)


/* Is it the PPS or the level or compensation? */
regress wexcess12 wltotpps wltotvega ltdc1 indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega ltdc1 yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega ltdc1 indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega ltdc1 yd*, fe cluster(gvkey)


regress wnexcess12 wltotpps wltotvega ltdc1 indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega ltdc1 yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega ltdc1 indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega ltdc1 yd*, fe cluster(gvkey)

/* How about the Gindex */
regress wexcess12 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega gindex yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega gindex yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega gindex yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega gindex yd*, fe cluster(gvkey)

regress wexcess36 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wexcess36 wltotpps wltotvega gindex yd*, fe cluster(gvkey)
regress wexcessff36 wltotpps wltotvega gindex indud* yd*, cluster(gvkey)
xtreg wexcessff36 wltotpps wltotvega gindex yd*, fe cluster(gvkey)

regress wexcess12 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega entrench yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega entrench yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega entrench yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega entrench yd*, fe cluster(gvkey)


regress wexcess36 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wexcess36 wltotpps wltotvega entrench yd*, fe cluster(gvkey)
regress wexcessff36 wltotpps wltotvega entrench indud* yd*, cluster(gvkey)
xtreg wexcessff36 wltotpps wltotvega entrench yd*, fe cluster(gvkey)


/* Is it the PPS or the percentage non-cash? */

regress wexcess12 wltotpps wltotvega wpceonc indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega wpceonc yd*, fe cluster(gvkey)

regress wexcessff12 wltotpps wltotvega wpceonc indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega wpceonc yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega wpceonc indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega wpceonc yd*, fe cluster(gvkey)

regress wnexcessff12 wltotpps wltotvega wpceonc indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega wpceonc yd*, fe cluster(gvkey)

/* Is it the PPS or the percentage option compensation? */
/*
regress wexcess12 wltotpps wpceonc wpoptc indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wpceonc wpoptc yd*, fe cluster(gvkey)

regress wexcessff12 wltotpps wpceonc wpoptc indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wpceonc wpoptc yd*, fe cluster(gvkey)


/* Is it PPS or current PPS? */
/*
regress wexcess12 wltotpps wlppsc indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wlppsc yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wlppsc indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wlppsc yd*, fe cluster(gvkey)
*/


/* Is it Director PPS? */
regress wexcess12 wltotpps wltotvega wldirpps indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega wldirpps yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega wldirpps indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega wldirpps yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega wldirpps indud* yd*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega wldirpps yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega wldirpps indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega wldirpps yd*, fe cluster(gvkey)



/* Could it be other controls?  */

regress wexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wexcessff12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)

regress wexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)
regress wexcessff36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wexcessff36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)

regress weqexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg weqexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)

regress weqexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg weqexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)

regress wnexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wnexcess12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)
regress wnexcessff12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wnexcessff12 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)

regress wnexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wnexcess36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)
regress wnexcessff36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
xtreg wnexcessff36 wltotpps wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, fe cluster(gvkey)



/* Is it abnormal PPS and Vega? */
regress wltotpps wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
predict err1 if e(sample), resid
predict yhat if e(sample), xb

regress wltotvega wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd* indud*, cluster(gvkey)
predict errv if e(sample), resid
predict yhatv if e(sample), xb

regress wexcess12 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wexcess12 yhat err1 yhatv errv yd*, fe cluster(gvkey)
regress wexcessff12 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wexcessff12 yhat err1 yhatv errv yd*, fe cluster(gvkey)

regress wexcess36 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wexcess36 yhat err1 yhatv errv yd*, fe cluster(gvkey)
regress wexcessff36 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wexcessff36 yhat err1 yhatv errv yd*, fe cluster(gvkey)

regress wnexcess12 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wnexcess12 yhat err1 yhatv errv yd*, fe cluster(gvkey)
regress wnexcessff12 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wnexcessff12 yhat err1 yhatv errv yd*, fe cluster(gvkey)

regress wnexcess36 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wnexcess36 yhat err1 yhatv errv yd*, fe cluster(gvkey)
regress wnexcessff36 yhat err1 yhatv errv indud* yd*, cluster(gvkey)
xtreg wnexcessff36 yhat err1 yhatv errv yd*, fe cluster(gvkey)
 

xtreg wltotpps wroam wsadv wsrd wsppe wscapx wsempl wsdebt wlsales wcfrisk8 tenure wbsvola chair mindep ndid yd*, cluster(gvkey)
predict err2, e

regress wexcess12 wltotpps err2 indud* yd*, cluster(gvkey)
xtreg wexcess12 wltotpps err2 yd*, fe cluster(gvkey)
regress wexcessff12 wltotpps err2 indud* yd*, cluster(gvkey)
xtreg wexcessff12 wltotpps err2 yd*, fe cluster(gvkey)

/* Is it the stock or option component of pps */
regress wexcess12 wlstkpps wloptpps indud* yd*, cluster(gvkey)
xtreg wexcess12 wlstkpps wloptpps indud* yd*, fe cluster(gvkey)
regress wexcessff12 wlstkpps wloptpps indud* yd*, cluster(gvkey)
xtreg wexcessff12 wlstkpps wloptpps indud* yd*, fe cluster(gvkey)

regress wexcess36 wlstkpps wloptpps indud* yd*, cluster(gvkey)
xtreg wexcess36 wlstkpps wloptpps indud* yd*, fe cluster(gvkey)
regress wexcessff36 wlstkpps wloptpps indud* yd*, cluster(gvkey)
xtreg wexcessff36 wlstkpps wloptpps indud* yd*, fe cluster(gvkey)

regress wnexcess12 wlstkpps wloptpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcess12 wlstkpps wloptpps wltotvega indud* yd*, fe cluster(gvkey)
regress wnexcessff12 wlstkpps wloptpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcessff12 wlstkpps wloptpps wltotvega indud* yd*, fe cluster(gvkey)

regress wnexcess36 wlstkpps wloptpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcess36 wlstkpps wloptpps wltotvega indud* yd*, fe cluster(gvkey)
regress wnexcessff36 wlstkpps wloptpps wltotvega indud* yd*, cluster(gvkey)
xtreg wnexcessff36 wlstkpps wloptpps wltotvega indud* yd*, fe cluster(gvkey)


/* How does pps impact debt policy? */
/* xtreg fdebt wsdebt ltotpps ltotvega tenure lceocash lsales0 mktbk srd scapx indud* yd*, fe cluster(gvkey)
regress fdebt wsdebt ltotpps ltotvega tenure lceocash lsales0 mktbk srd scapx indud* yd*, cluster(gvkey)
*/


bysort year: summarize wtotpps wltotpps wtotvega wltotvega

log close

stop

/* How about Fama-Macbeth? */

statsby "reg excess12 ltotpps indud*" _b e(r2), by(year) clear noisily
tabstat b_cons b_ltotpps _stat_2, stats (mean semean)

/* statsby "reg excessff12 ltotpps indud*" _b e(r2), by(year) clear noisily
tabstat b_cons b_ltotpps _stat_2, stats (mean semean) */


