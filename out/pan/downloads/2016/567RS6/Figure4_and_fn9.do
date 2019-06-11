**** Figure 4 and footnote 9 in Erikson and Rader "Much Ado about Nothing: RDD and the Incumbency Advantage"

use "RD_IP.dta"

encode IncStatus, gen(inc)
gen IDif=DifDPc if inc==1
replace IDif=DifDPc if inc==2
replace IDif=-DifDPc if inc==6
replace IDif =-DifDPc if inc==5
gen ibin=.25 if IDif>0&IDif<.5
replace ibin=.75 if IDif>.5&IDif<1
replace ibin=1.25 if IDif>1&IDif<1.5
replace ibin=1.75 if IDif>1.5&IDif<2
replace ibin=2.25 if IDif>2&IDif<2.5
replace ibin=2.75 if IDif>2.5&IDif<3
replace ibin=3.25 if IDif>3&IDif<3.5
replace ibin=3.75 if IDif>3.5&IDif<4
replace ibin=4.25  if IDif>4&IDif<4.5
replace ibin =-.25 if IDif>-.5&IDif<0
replace ibin=-.75 if IDif>-1&IDif<-.5
replace ibin=-1.25 if IDif>-1.5&IDif<-1
replace ibin=-1.75 if IDif>-2&IDif<-1.5
replace ibin=-2.25 if IDif>-2.5&IDif<-2
replace ibin=-2.75 if IDif>-3&IDif<-2.5
replace ibin=-3.25 if IDif>-3.5&IDif<-3
replace ibin=-3.75 if IDif>-4&IDif<-3.5
replace ibin=-4.25 if IDif>-4.5&IDif<-4
tab ibin,gen(IBIN)
sort StIC CD Year
gen ivote=DemPct[_n+1]  if Year[_n+1]==Year+2&StICPSR==StIC[_n+1]&CD==CD[_n+1]&inc==1
replace ivote=DemPct[_n+1]  if Year[_n+1] ==Year+2&StICPSR==StIC[_n+1]&CD==CD[_n+1]&inc==2
replace ivote=100-DemPct[_n+1]  if Year[_n+1]==Year+2&StICPSR==StI[_n+1]&CD==CD[_n+1]&inc==6
replace ivote=100-DemPct[_n+1]  if Year[_n+1]==Year+2&StICPSR==StI[_n+1]&CD==CD[_n+1]&inc==5
replace ivote=.  if NxtE==.
replace ivote=.  if ivote==100
replace ivote=. if ivote==0
replace ivote=. if DemPct==.
reg ivote IBIN* if Use==1
predict xivote

gen win=0
replace win=1 if IDif>0

**** Footnote 9

reg ivote IDif win if abs(IDif)<7 
reg ivote IDif win if abs(IDif)<7&abs(ibin)>.5
reg ivote win if abs(ibin)<.5

**** Figure 4

scatter xivote ibin, xline(0) yline(50) yla(40 45 50 55 60) xla(-4 -2 0 2 4) l1(Incumbent Party Vote at t+1) b2(Incumbent Party Lead at time t) xtitle("") ytitle("") scheme(s1mono) 

