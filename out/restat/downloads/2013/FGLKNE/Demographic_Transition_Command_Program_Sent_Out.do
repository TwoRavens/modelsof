*Table 1 - Stat Des

br year mean2fert mean2death mean2infantmort mean2fmsoto mean2y if iso=="FRA"&(year==1870|year==1910|year==1960|year==2000)

* Table 2 Correlation Matrix

pwcorr fert lDeath lInfantMort fmsoto ly if OKfert==1
pwcorr fert lDeath lInfantMort fmsoto ly if sample==1

* Table 3 OLS FERTILITY REGRESSION

reg lFert  fmsoto p30joint p40joint d1*  if OKfert>0  
reg lFert  lInfantMort lDeath p30joint p40joint d1*  if OKfert>0 
reg lFert  lyact  p30joint p40joint d1*  if OKfert>0 
reg lFert  fmsoto lInfantMort lDeath lyact  p30joint p40joint d1* if OKfert>0 
reg lFert  lyact lyactsq lyactcub p30joint p40joint d1* if OKfert>0
reg lFert  fmsoto lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if OKfert>0

* TABLE 4 FE FERTILITY REGRESSION

xtreg lFert  fmsoto p30joint p40joint d1*  if OKfert>0, fe
xtreg lFert  lInfantMort lDeath p30joint p40joint d1*  if OKfert>0, fe 
xtreg lFert  lyact  p30joint p40joint d1*  if  OKfert>0 , fe
xtreg lFert  fmsoto lInfantMort lDeath lyact  p30joint p40joint d1* if OKfert>0 , fe
xtreg lFert  lyact lyactsq lyactcub p30joint p40joint d1* if OKfert>0, fe
xtreg lFert  fmsoto lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if OKfert>0,fe


* TABLE 5 FE FERTILITY REGRESSION BALANCED PANEL

xtreg lFert  fmsoto p30joint p40joint d1*  if sample>0& OKfert>0, fe
xtreg lFert  lInfantMort lDeath p30joint p40joint d1*  if sample>0& OKfert>0, fe 
xtreg lFert  lyact  p30joint p40joint d1*  if  sample>0& OKfert>0 , fe
xtreg lFert  fmsoto lInfantMort lDeath lyact  p30joint p40joint d1* if sample>0& OKfert>0 , fe
xtreg lFert  lyact lyactsq lyactcub p30joint p40joint d1* if sample>0& OKfert>0, fe
xtreg lFert  fmsoto lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if sample>0& OKfert>0,fe


* TABLE 6 DECOMPOSITION OF SCHOOLING

reg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if OKfert>0
xtreg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if OKfert>0,fe
reg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if oecd==1& OKfert>0
xtreg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if oecd==1&OKfert>0,fe
reg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if oecd==0& OKfert>0
xtreg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if oecd==0&OKfert>0,fe
reg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if sample==1& OKfert>0
xtreg lFert fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub p30joint p40joint  d1* if sample==1&OKfert>0,fe


* TABLE 7 GMM FERTILITY

tsset ctry period

xtabond2 lFert  l(1).(lFert)  l(0).(fmsoto lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert , lag(3 7)) iv(d1*)  two robust  
xtabond2 lFert  l(1).(lFert)  l(0).(fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert, lag(3 7)) iv(d1*)  two robust  

xtabond2 lFert  l(1).(lFert)  l(0).(fmsoto lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert fmsoto, lag(3 4)) iv(d1*)  two robust  
xtabond2 lFert  l(1).(lFert)  l(0).(fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert fmsoto, lag(3 4)) iv(d1*)  two robust  

xtabond2 lFert  l(1).(lFert)  l(0).(fmsoto lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert lInfantMort, lag(3 4)) iv(d1*)  two robust  
xtabond2 lFert  l(1).(lFert)  l(0).(fmsotop fmsotosh lInfantMort lDeath lyact lyactsq lyactcub  p30joint p40joint) d1*  if OKfert==1, gmm(lFert lInfantMort, lag(3 4)) iv(d1*)  two robust  



* TABLE 8 DETERMINANTS LOG INFANT MORTALITY


reg lInfantMort fmsoto lyact d1*  if OKfert>0&sample==1
reg lInfantMort fmsotop fmsotosh  lyact d1*  if OKfert>0&sample==1
xtreg lInfantMort fmsoto lyact d1*  if OKfert>0&sample==1,fe
xtreg lInfantMort fmsotop fmsotosh lyact  d1*  if OKfert>0&sample==1,fe

reg lInfantMort fmsoto lyact d1*  if OKfert>0
reg lInfantMort fmsotop fmsotosh  lyact  d1*  if OKfert>0
xtreg lInfantMort fmsoto lyact d1*  if OKfert>0,fe
xtreg lInfantMort fmsotop fmsotosh  lyact d1*  if OKfert>0,fe

xtabond2 lInfantMort   l(0).(fmsoto lyact ) d1*  if OKfert==1,  gmm(fmsoto lyact, lag(6 6)) gmm(fmsoto lyact, lag(8 8)) gmm(fmsoto lyact, lag(10 10))  iv(d1*)  two robust  
xtabond2 lInfantMort    l(0).(fmsotop fmsotosh  lyact) d1*  if OKfert==1, gmm(fmsoto lyact, lag(6 6)) gmm(fmsoto lyact, lag(8 8)) gmm(fmsoto lyact, lag(10 10)) iv(d1*)  two robust  


* TABLE 9 DETERMINANTS OF LOG DEATH RATE


reg lDeath  fmsoto lyact p20joint p30joint p40joint p50joint p60joint d1*  if OKfert>0&sample==1
reg lDeath  fmsoto fmsoto2 lyact lyactsq  p20joint p30joint p40joint p50joint p60joint d1*  if OKfert>0&sample==1
xtreg lDeath fmsoto lyact  p20joint p30joint p40joint p50joint p60joint  d1*  if OKfert>0&sample==1,fe
xtreg lDeath fmsoto fmsoto2 lyact lyactsq p20joint p30joint p40joint p50joint p60joint  d1*  if OKfert>0&sample==1,fe

reg lDeath  fmsoto lyact p20joint p30joint p40joint p50joint p60joint d1*  if OKfert>0
reg lDeath  fmsoto fmsoto2 lyact lyactsq p20joint p30joint p40joint p50joint p60joint d1*  if OKfert>0
xtreg lDeath fmsoto lyact  p20joint p30joint p40joint p50joint p60joint  d1*  if OKfert>0,fe
xtreg lDeath fmsoto fmsoto2 lyact lyactsq p20joint p30joint p40joint p50joint p60joint  d1*  if OKfert>0,fe

xtabond2 lDeath  l(0).(fmsoto lyact p20joint p30joint p40joint p50joint p60joint) d1*  if OKfert==1, gmm(fmsoto lyact, lag(6 6)) gmm(fmsoto lyact, lag(8 8)) gmm(fmsoto lyact, lag(10 10)) iv(d1*)  two robust  
xtabond2 lDeath  l(0).(fmsoto fmsoto2 lyact lyactsq p20joint p30joint p40joint p50joint p60joint) d1*  if OKfert==1, gmm( fmsoto lyact, lag(6 6))  gmm( fmsoto lyact, lag(8 8)) gmm( fmsoto lyact, lag(10 10)) iv(d1*)  two robust  


* TABLE 10 DETERMINANTS OF LIFE EXPECTANCY


tsset ctry period
reg logle  fmsoto lyact  d1*  if OKfert>0&sample==1
reg logle  fmsoto fmsoto2 lyact lyactsq  d1*  if OKfert>0&sample==1

xtreg logle fmsoto lyact    d1*  if OKfert>0&sample==1,fe
xtreg logle fmsoto fmsoto2 lyact lyactsq  d1*  if OKfert>0&sample==1,fe


reg logle  fmsoto lyact  d1*  if OKfert>0
reg logle  fmsoto fmsoto2 lyact lyactsq  d1*  if OKfert>0

xtreg logle fmsoto lyact    d1*  if OKfert>0,fe
xtreg logle fmsoto fmsoto2 lyact lyactsq  d1*  if OKfert>0,fe

xtabond2 logle l(0).(fmsoto lyact ) d1*  if OKfert==1, gmm( fmsoto lyact, lag(6 6))  gmm( fmsoto lyact, lag(8 8)) gmm( fmsoto lyact, lag(10 10)) iv(d1*)  two robust  
xtabond2 logle   l(0).(fmsoto fmsoto2 lyact lyactsq) d1*  if OKfert==1, gmm( fmsoto lyact, lag(6 6))  gmm( fmsoto lyact, lag(8 8)) gmm( fmsoto lyact, lag(10 10)) iv(d1*)  two robust  

