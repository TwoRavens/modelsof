version 9
set more off
capture log close
log using targetgivesoneperyear, replace

use targetgivesoneperyear.dta, clear
stset time, id(id) failure(failed==1)

*generate imilpopshare=((imilitper*100)/ipop)*100
*generate tmilpopshare=(tmilitper*100)/tpop
*generate imilexpmp=imilexp/imp
*generate tmilexpmp=tmilexp/tmp
//tqual=tmilexpmp/imilexpmp
*generate normcpi=cpi/100
*generate irmilexpmp=(imilexpmp/1000)/normcpi
*generate ircost=irmilexpmp*(imilitper/1000)
*generate icost=imilexpmp*imilitper
*icost vs ircost makes no difference to regressions and is less correct
*generate trmilexpmp=(tmilexpmp/1000)/normcpi
*generate trcost=trmilexpmp*(tmilitper/1000)
*generate tcost=tmilexpmp*tmilitper
*tcost strcost makes no difference to regressions and is less correct
*generate ideathpercap=iloss/ipop
*generate tdeathpercap=tloss/tpop
*generate ideathpermilit=iloss/imilitper
*generate tdeathpermilit=tloss/tmilitper
*generate totpop=ipop+tpop
*generate totmilit=imilit+tmilit

*generate tmilpar=(tmilitper-imilitper)/(tmilitper+imilitper)
*generate treservepar=(tpop-ipop)/(tpop+ipop)
//*demdiff=tdem-idem
*generate ilossrate=iloss/imilitper
*generate tlossrate=tloss/tmilitper
*generate trelatloss=(tlossrate)/(ilossrate+tlossrate)
*generate irelatloss=(ilossrate)/(ilossrate+tlossrate)
*generate trelflowloss=tlossperyear/(tlossperyear+ilossperyear)
*generate irelflowloss=ilossperyear/(ilossperyear+tlossperyear)
*generate taudience=(tlossperyear/(imp*1000))*tdem

*MODEL 1

streg imilpopshare  trelflowloss taudience terrain contiguity tqual trelativecap tsalient , dist(weibull) nohr

predict timehat1,mean time
generate err1=timehat1-time
generate abserr1=abs(err1)
generate percentabserr1=abserr1/time
tabstat time timehat1 err1 abserr1 percentabserr1 if failed==1 & tqual<.,statistics(mean median)

*MODEL 2

streg imilpopshare tmilpopshare trelflowloss taudience terrain contiguity tqual trelativecap tsalient , dist(weibull) nohr

predict timehat2,mean time
generate err2=timehat2-time
generate abserr2=abs(err2)
generate percentabserr2=abserr2/time
tabstat time timehat2 err2 abserr2 percentabserr2 if failed==1 & tqual<.,statistics(mean median)


correlate tmilpopshare imilpopshare demdiff taudience trelativecap tqual trelflowloss

//*MODEL 4 best pared down//

streg imilpopshare trelativecap terrain tqual, dist(weibull) nohr

predict timehat3,mean time
generate err3=timehat3-time
generate abserr3=abs(err3)
generate percentabserr3=abserr3/time
tabstat time timehat3 err3 abserr3 percentabserr3 if failed==1 & tqual<.,statistics(mean median)




*Compare to Slantchev

*generate milpar=1-(abs(tmilitper-imilitper))/(imilitper+tmilitper)
*generate reservepar=1-(abs(ipop-tpop))/(ipop+tpop)
*generate branisidem=0
*replace branisidem=1 if idem>6
*generate totpop=ipop+tpop
*generate totmilit=imilitper+tmilitper

streg milpar reservepar terrain contiguity totpop totmilit branisdem if tqual<., dist(llogistic)


predict branistime, mean time
generate branisabserror=abs(branistime-time)
generate branispercentabserror=branisabserror/time

summarize time branistime branisabserror branispercentabserror if failed==1
tabstat time branistime branisabserror branispercentabserror if failed==1, statistics(median mean)

tabstat time branistime branisabserror branispercentabserror if failed==1 & tqual<., statistics(median mean)


///MODEL 3

streg imilpopshare dimilpopshare trelflowloss taudience terrain contiguity tqual trelativecap tsalient , dist(weibull) nohr
predict timehat4,mean time
generate err4=timehat4-time
generate abserr4=abs(err4)
generate percentabserr4=abserr4/time
tabstat time timehat4 err4 abserr4 percentabserr4 if failed==1 & tqual<.,statistics(mean median)

//adding change in imilpopshare does not compromise and is positive

log close
exit

