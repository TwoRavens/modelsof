ge lpci=log(pc_perinc)
ge lpop26p=log(pop26p)
ge lmin=log(mwdef)
egen lpopmn=mean(lpop)
ge mwpop=mwdef*(lpop-lpopmn)
ge probit1620=invnormal(ANYRATE1620)
ge probit26=invnormal(ANYRATE26)
ge norate1620=(NORATE1620)
ge norate26=(NORATE26)
ge lnorate1620=log(NORATE1620)
ge lnorate26=log(NORATE26)   
egen mwmn=mean(mwdef)
egen btmn=mean(realbeertax)


 
sort state

********* Table 5 Rows 1 - 5 



foreach v of varlist mwdef lnorate1620 lnorate26 lpop realbeertax bac lpc_perinc ur1620_r ur26p_r  {
by state: egen `v'm=mean(`v')
}

*Table 5 row 1:

quietly glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r mwdefm lnorate1620m lpopm realbeertaxm bacm lpc_perincm ur1620_rm yr2-yr9 , l(probit) f(gauss) cluster(state)
predict phat1
ge wgt1=pop1620/(phat1*(1-phat1))

ge rssq1=(ANYRATE1620-phat1)^2
ge iwgt1=1/wgt1
quietly reg rssq1 iwgt1 , cluster(state)
predict iawgt1
ge awgt1=1/iawgt1

quietly glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc mwdefm ur1620_r lnorate1620m lpopm realbeertaxm bacm lpc_perincm ur1620_rm yr2-yr9 [aw=awgt1] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax)eyex


quietly glm ANYRATE26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r ur26p_rm mwdefm  lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 , l(probit) f(gauss) cluster(state)
predict phat2

ge wgt2=pop26p/(phat2*(1-phat2))
ge rssq2=(ANYRATE26-phat2)^2
ge iwgt2=1/wgt2
quietly reg rssq2 iwgt2
predict iawgt2
ge awgt2=1/iawgt2

quietly glm ANYRATE26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r ur26p_rm mwdefm lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 [aw=awgt2] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex

drop phat1 phat2 iawgt1 iawgt2 

*Table 5 row 5 (Note out of order):
quietly xi: glm ANYRATE1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr2-yr9 i.state, l(probit) f(gauss) cluster(state)
predict phat1

quietly xi: glm ANYRATE26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr2-yr9 i.state, l(probit) f(gauss) cluster(state)
predict phat2

replace rssq1=(ANYRATE1620-phat1)^2
replace iwgt1=1/wgt1
quietly reg rssq1 iwgt1 , cluster(state)
predict iawgt1
replace awgt1=1/iawgt1

quietly xi: glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.state yr2-yr9 [aw=awgt1] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax)eyex

replace rssq2=(ANYRATE26-phat2)^2
replace iwgt2=1/wgt2
quietly reg rssq2 iwgt2 , cluster(state)
predict iawgt2
replace awgt2=1/iawgt2

quietly xi: glm ANYRATE26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r i.state yr2-yr9 [aw=awgt2] , l(probit) f(gauss) cluster(state)
mfx, var(mwdef realbeertax) eyex
drop phat1 phat2 iawgt1 iawgt2


*Table 5 row 2:

quietly areg logit1620 mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r yr2-yr9 , absorb(state) cluster(state)
predict loghat1 , xbd
egen logmn=mean(loghat1)
ge pred1=exp(logmn)/1+exp(logmn)
ge phat1=exp(loghat1)/(1+exp(loghat1))
ge wgt1620=pop1620*phat1*(1-phat1)

quietly areg logit26 mwdef lpop lnorate26 realbeertax bac lpc_perinc ur26p_r yr2-yr9 , absorb(state) cluster(state)
predict loghat2 , xbd
egen logmn2=mean(loghat2)
ge pred2=exp(logmn2)/1+exp(logmn2)
ge phat2=exp(loghat2)/(1+exp(loghat2))
ge wgt26=pop26*phat2*(1-phat2)

drop rssq1 rssq2 iwgt1 iwgt2  awgt1  awgt2 
ge rssq1=(logit1620-loghat1)^2
ge iwgt1=1/wgt1620
quietly reg rssq1 iwgt1 , cluster(state)
predict iawgt1
ge awgt1=1/iawgt1

areg logit1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr2-yr9 [aw=awgt1] , absorb(state) cluster(state)
predict loghat3 , xbd
egen logmn3=mean(loghat3)
ge pred3=exp(logmn3)/1+exp(logmn3)
ge phat3=exp(loghat3)/(1+exp(loghat3))
ge factmw=(1-pred3)*mwmn
ge factbt=(1-pred3)*btmn
su factmw factbt
drop factmw factbt

ge rssq2=(logit26-loghat2)^2
ge iwgt2=1/wgt26
quietly reg rssq2 iwgt2 , cluster(state)
predict iawgt2
ge awgt2=1/iawgt2

areg logit26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr2-yr9 [aw=awgt2] , absorb(state) cluster(state)
predict loghat4 , xbd
egen logmn4=mean(loghat4)
ge pred4=exp(logmn4)/1+exp(logmn4)
ge phat4=exp(loghat4)/(1+exp(loghat4))
ge factmw=(1-pred4)*mwmn
ge factbt=(1-pred4)*btmn
su factmw factbt

drop rssq1 rssq2 iwgt1 iwgt2  awgt1  awgt2 phat1 phat2 iawgt1 iawgt2 


* Table 5 row 3:

quietly areg lnANYBAC1620 mwdef lpop1620 lnorate1620 realbeertax bac lpc_perinc ur1620_r yr2-yr9 ,  absorb(state) cluster(state)
mfx, var(mwdef realbeertax) dyex

quietly areg lnANYBAC26 mwdef lpop26 lnorate26 realbeertax bac lpc_perinc ur26p_r yr2-yr9,  absorb(state) cluster(state)
mfx, var(mwdef realbeertax) dyex


*Table 5 row 4:

quietly xi: glm ANYBAC1620 mwdef lpop1620 lnorate1620 realbeertax bac lpc_perinc ur1620_r yr2-yr9 i.state, f(nbinomial) cluster(state)
mfx, var(mwdef realbeertax) eyex

quietly xi: glm ANYBAC26 mwdef lpop26 lnorate26 realbeertax bac lpc_perinc yr2-yr9 i.state, f(nbinomial) cluster(state)
mfx, var(mwdef realbeertax) eyex


* Table 5 row 6

drop factmw factbt wgt1620 wgt26  

quietly xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr1-yr9 i.state*year,  cluster(state)
predict estxb1, xb
ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
ge rssq9=(probit1620-estxb1)^2
ge iwgt1620=1/wgt1620
quietly reg rssq9 iwgt1620 , cluster(state)
predict iawgt1620
ge awgt1620=1/iawgt1620
xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r yr1-yr9 i.state*year [aw=awgt1620],  cluster(state)
predict estxb2, xb
egen xbmn2=mean(estxb2)
ge phifact=normalden(xbmn2)/normal(xbmn2)
ge factmw=phifact*mwmn
ge factbt=phifact*btmn
su factmw factbt
drop phifact factmw factbt

quietly xi: reg probit26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr1-yr9 i.state*year,  cluster(state)
predict estxb3, xb
ge wgt26=(pop26*normalden(estxb3)^2)/(normal(estxb3)*(1-normal(estxb3)))
ge rssq10=(probit26-estxb3)^2
ge iwgt26=1/wgt26
quietly reg rssq10 iwgt26 , cluster(state)
predict iawgt26
ge awgt26=1/iawgt26
xi: reg probit26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r yr1-yr9 i.state*year [aw=awgt26], cluster(state)
predict estxb4, xb
egen xbmn4=mean(estxb4)
ge phifact=normalden(xbmn4)/normal(xbmn4)
ge factmw=phifact*mwmn
ge factbt=phifact*btmn
su factmw factbt
drop phifact factmw factbt

drop  iawgt1 iawgt2 wgt1 wgt2 rssq1  iwgt1 iwgt2 awgt1 awgt2

**Table 5 row 7 (Note: The data used to account for graduated drivers license laws was provided by Michael Morrisey and David Grabowski. The data is their property and could not be provided).

**Table 5 row 8

ge mwstatedif = mw2 - fedmw
egen mwstdiff = mean( mwstatedif), by( state)
tab state if mwstdiff>0
tab state if mw2-fedmw>0

quietly glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r ur1620_rm mwdefm  lnorate1620m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 if mwstdiff>0 , l(probit) f(gauss) cluster(state)
predict phat1
ge wgt1=pop1620/(phat1*(1-phat1))
ge rssq1=(ANYRATE1620-phat1)^2
ge iwgt1=1/wgt1
quietly reg rssq1 iwgt1
predict iawgt1
ge awgt1=1/iawgt1
quietly glm ANYRATE1620 mwdef  lnorate1620 lpop realbeertax bac lpc_perinc  mwdefm lnorate1620m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 [aw=awgt1] if mwstdiff>0 , l(probit) f(gauss) cluster(state)
mfx, eyex var(mwdef realbeertax)

quietly glm ANYRATE26 mwdef lnorate26 lpop realbeertax bac lpc_perinc ur26p_r ur26p_rm mwdefm   lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 if mwstdiff>0  , l(probit) f(gauss) cluster(state)
predict phat2
ge wgt2=pop26p/(phat2*(1-phat2))
ge rssq2=(ANYRATE26-phat2)^2
ge iwgt2=1/wgt2
quietly reg rssq2 iwgt2
predict iawgt2
ge awgt2=1/iawgt2
quietly glm ANYRATE26 mwdef  lnorate26 lpop realbeertax bac lpc_perinc  mwdefm lnorate26m lpopm realbeertaxm bacm lpc_perincm  yr1-yr9 [aw=awgt2] if  mwstdiff>0, l(probit) f(gauss) cluster(state)
mfx, eyex var(mwdef realbeertax)





