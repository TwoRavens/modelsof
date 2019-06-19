***Estimation File, Tables 2 - 4, Use data file "Adams Blackburn Cotti Data File 1"

*Table 2
sum ANYBAC1620 ANYBAC26 ANYRATE1620 ANYRATE26 NOBAC1620 NOBAC26 NORATE1620b NORATE26b ur1620 ur26p  mwdef realbeertax bac lpc_perinc lpop

ge lpci=log(pc_perinc)
ge lpop26p=log(pop26p)
ge lmin=log(mwdef)
egen lpopmn=mean(lpop)
ge mwpop=mwdef*(lpop-lpopmn)
ge probit1620=invnormal(ANYRATE1620)
ge probit26=invnormal(ANYRATE26)
ge norate1620=(NORATE1620b)
ge lnorate1620 = ln(norate1620)
ge norate26=(NORATE26b)
ge lnorate26 = ln(norate26)
egen mwmn=mean(mwdef)
egen btmn=mean(realbeertax)


******** Table 3 Estimates

*OLS Table 3 Column 1
areg probit1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr1-yr9,  absorb(state) cluster(state)
predict estxb1, xbd
ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))

egen xbmn1=mean(estxb1)
ge phifact=normalden(xbmn1)/normal(xbmn1)
ge factmw=phifact*mwmn
ge factbt=phifact*btmn
su factmw factbt

ge rssq9=(probit1620-estxb1)^2
ge wgt1620i=1/wgt1620
quietly reg rssq9 wgt1620i
predict iawgt9
ge awgt9=1/iawgt9


* WLS Table 3 Column 3
areg probit1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr1-yr9 [aw=awgt9], absorb(state) cluster(state)
predict estxb999, xbd

egen xbmn999=mean(estxb999)
ge phifact999=normalden(xbmn999)/normal(xbmn999)
ge factmw999=phifact999*mwmn
ge factbt999=phifact999*btmn
su factmw999 factbt999



* QMLE with probit functional form, with Papke-Wooldridge suggestion for FE

sort state

foreach v of varlist mwdef lnorate1620 lnorate26 lpop realbeertax bac lpc_perinc ur1620_r ur26p_r {
by state: egen `v'm=mean(`v')
}

* 
* NLS QMLE Table 3 Column 2
glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r ur1620_rm mwdefm lnorate1620m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex
predict phat1


ge wgt1=pop1620/(phat1*(1-phat1))
ge rssq1=(ANYRATE1620-phat1)^2
ge iwgt1=1/wgt1
quietly reg rssq1 iwgt1
predict iawgt1
ge awgt1=1/iawgt1

* WNLS QMLE Table 3 Column 4 (error variance be a linear function of p(1-p)/n)
glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r ur1620_rm mwdefm lnorate1620m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 [aw=awgt1] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex




*****Table 4 26+ year old estimates ( 16-20 year olds Repeated from Table 3)

** OLS Table 4 Col 1 (26+)
areg probit26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr1-yr9 , absorb(state) cluster(state)
predict estxb3, xbd

ge wgt26=(pop26*normalden(estxb3)^2)/(normal(estxb3)*(1-normal(estxb3)))
egen xbmn3=mean(estxb3)
ge phifact3=normalden(xbmn3)/normal(xbmn3)
ge factmw3=phifact3*mwmn
ge factbt3=phifact3*btmn
su factmw3 factbt3


ge rssq888=(probit26-estxb3)^2
ge wgt26i=1/wgt26
quietly reg rssq888 wgt26i
predict iawgt88
ge awgt88=1/iawgt88

** WLS (26+) Not Shown In Table
areg probit26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr1-yr9 [aw=awgt88], absorb(state) cluster(state)
predict estxb888, xbd

egen xbmn888=mean(estxb888)
ge phifact888=normalden(xbmn888)/normal(xbmn888)
ge factmw888=phifact888*mwmn
ge factbt888=phifact888*btmn
su factmw888 factbt888


* NLS QMLE Table 4 Column 2 (26+)
glm ANYRATE26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r ur26p_rm mwdefm  lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex
predict phat2


ge wgt2=pop26p/(phat2*(1-phat2))
ge rssq2=(ANYRATE26-phat2)^2
ge iwgt2=1/wgt2
quietly reg rssq2 iwgt2
predict iawgt2
ge awgt2=1/iawgt2


*WNLS QMLE Table 4 Column 3 (26+) 
glm ANYRATE26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r ur26p_rm mwdefm lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 [aw=awgt2] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex
