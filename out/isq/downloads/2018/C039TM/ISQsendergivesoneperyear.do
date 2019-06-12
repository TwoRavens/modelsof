version 9.0
set more off 
capture log close
log using sendergivesoneperyear2, replace

use sendergivesoneperyear2007october.dta, clear
stset time, id(warid) failure(failed==1)

//*models compare relative and absolute measures and are comprehensive//
*generate demdiff=tdem-idem
//*tmilpopshare as measure of target war costs//
//*regression uses relative measures//
*generate tmilpopshare=(tmp/tpop)*100
*generate imilpopshare=(imp/ipop)*100
*generate irelativecap=icowcap/(tcowcap+icowcap)
*generate imilpar=(imp-tmp)/(imp+tmp)

*generate irmilex=imilex/cpi
*generate irmilexpermp=irmilex/imp
*generate trmilex=tmilex/cpi
*generate trmilexpermp=trmilex/tmp
*generate trmilexpercap=trmilex/tpop
*generate irmilexpercap=irmilex/ipop
*generate irelativequality=irmilexpermp/(trmilexpermp+irmilexpermp)
*generate ideath=iloss/imp
*generate tdeath=tloss/tmp
*generate irelatloss=ideath/(ideath+tdeath)
//*definiion of relative quality (relqual) is as in bennett and Stamm//
*generate iqual=irmilexpermp/trmilexpermp
*generate relqual=trmilexpermp/irmilexpermp
*replace relqual=iqual if iqual>relqual

*generate iflowlosspercap=ilossperyear/ipop
*generate tflowlosspercap=tlossperyear/tpop
*generate irelflowwloss=ilossperyear/(ilossperyear+tlossperyear)
*generate trelflowloss=tlossperyear/(tlossperyear+ilossperyear)

*generate ibranisdem=0
*replace ibranisdem=1 if idem>6//

*generate iaudience=(ilossperyear/(imp*1000))*idem
*generate izpopshare=((imilper*1000-ilossperyear)/(ipop*1000))*100
*generate tzpopshare=((tmilper*1000-tlossperyear)/(tpop*1000))*100


*MODEL 1

streg tmilpopshare irelativecap isalient irelflowloss iaudience terrain contiguity iqual, dist(weibull) nohr

predict t1hat, mean time
generate err1=t1hat-time
generate abs1err=abs(t1hat-time)
generate percent1abserr=abs1err/time


tabstat time t1hat err1 abs1err percent1abserr if failed==1 & iqual<., statistics(mean median sd min max)

*MODEL 2

streg tmilpopshare imilpopshare irelativecap isalient irelflowloss iaudience terrain contiguity iqual, dist(weibull) nohr

predict t2hat, mean time
generate err2=t2hat-time
generate abs2err=abs(t2hat-time)
generate percent2abserr=abs2err/time

tabstat time t2hat err2 abs2err percent2abserr if failed==1 & iqual<., statistics(mean median sd min max)


*MODEL 4
 
streg tmilpopshare irelativecap isalient terrain iqual, dist(weibull)
predict t3hat, mean time
generate err3=t3hat-time
generate abs3err=abs(t3hat-time)
generate percent3abserr=abs3err/time

tabstat time t3hat err3 abs3err percent3abserr if failed==1 & iqual<., statistics(mean median sd min max)


//*compare to Slantchev//
*generate milpar=1-abs((imilper-tmilper)/(tmilper+imilper))
*generate totpop=ipop+tpop
*generate totmilit=imilper+tmilper
*generate reservepar=1-abs((tpop-ipop)/(tpop+ipop))

*generate branisidem=0
*replace branisidem=1 if idem>6//

streg milpar reservepar terrain contiguity totpop totmilit branisidem if iqual<., dist(llogistic)

predict branistime, mean time
generate braniserr=branistime-time
generate branisabserror=abs(branistime-time)
generate branispercentabserror=branisabserror/time


tabstat time branistime braniserr branisabserror branispercentabserror if failed==1, statistics(mean median sd min max)
tabstat time branistime braniserr branisabserror branispercentabserror if failed==1 & iqual<., statistics(mean median sd min max)



//MODEL 3 
streg tmilpopshare  tmilpopsharepct irelativecap isalient irelflowloss iaudience terrain contiguity iqual, dist(weibull) nohr
predict t4hat, mean time
generate err4=t4hat-time
generate abs4err=abs(t4hat-time)
generate percent4abserr=abs4err/time
tabstat time t4hat err4 abs4err percent4abserr if failed==1 & iqual<., statistics(mean median sd min max)


log close
exit


