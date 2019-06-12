*Replication data for Owsiak, Andrew P., and John A. Vasquez. 2016. The Cart and the Horse Redux: The Timing of Border Settlement and Joint Democracy. British Journal of Political Science, forthcoming.

*log using "Replication - Owsiak Vasquez - 2016 - BJPS - Cart and Horse.scml", replace

use "Owsiak Vasquez - 2016 - Cart and Horse - Replication Data.dta", replace
drop if year>2001
set more off	

*TABLE 1
*CREATE TIME PERIOD VARIABLES
gen t1644=1 
replace t1644=0 if year>1944

gen t4589=0
replace t4589=1 if year>1944
replace t4589=0 if year>1989

gen t9001=0
replace t9001=1 if year>1989

gen t1601=1

gen t=1 if t1644==1
replace t=2 if t4589==1
replace t=3 if t9001==1

drop if conttype!=1

*FOR JTDEM AT 6+
sort cdyad year
by cdyad: gen runsumdem6=sum(jtdem6)
by cdyad: gen count6=[_n]
by cdyad: gen ratio6=runsumdem6/count6

sort cdyad t year 
by cdyad t: gen runsumdem6t=sum(jtdem6)
by cdyad t: gen count6t=[_n]
by cdyad t: gen ratio6t=runsumdem6t/count6t

*Flags
gen flag1601a=1 if t1601==1 & ratio6<1
gen flag1644a=1 if t1644==1 & ratio6t<1
gen flag4589a=1 if t4589==1 & ratio6t<1
gen flag9001a=1 if t9001==1 & ratio6t<1

replace flag1601a=0 if flag1601a==. 
replace flag1644a=0 if flag1644a==. & t1644==1
replace flag4589a=0 if flag4589a==. & t4589==1
replace flag9001a=0 if flag9001a==. & t9001==1

by cdyad: egen maxflag1601a=max(flag1601a)
by cdyad t: egen maxflag1644a=max(flag1644a)
by cdyad t: egen maxflag4589a=max(flag4589a)
by cdyad t: egen maxflag9001a=max(flag9001a)

*Identify the dyads
tab cdyad if t1601==1 & maxflag1601a==0
tab cdyad if t1644==1 & maxflag1644a==0
tab cdyad if t4589==1 & maxflag4589a==0
tab cdyad if t9001==1 & maxflag9001a==0

*Mark first instance of joint democracy
by cdyad: gen firstdem6=1 if runsumdem6==1 & count6==1
by cdyad: replace firstdem6=1 if runsumdem6==1 & runsumdem6[_n-1]==0
by cdyad: replace firstdem6=0 if firstdem6==.

*Identify dyads with years - +6
list cdyad year bordersettleyear if t1601==1 & maxflag1601a==0 & firstdem6==1
list cdyad year bordersettleyear if t1644==1 & maxflag1644a==0 & firstdem6==1
list cdyad year bordersettleyear if t4589==1 & maxflag4589a==0 & firstdem6==1
list cdyad year bordersettleyear if t9001==1 & maxflag9001a==0 & firstdem6==1

*FOR JTDEM AT 5+
gen jtdem5=0
replace jtdem5=1 if dem1>4 & dem1!=. & dem2>4 & dem2!=.

sort cdyad year
by cdyad: gen runsumdem5=sum(jtdem5)
by cdyad: gen count5=[_n]
by cdyad: gen ratio5=runsumdem5/count5

sort cdyad t year 
by cdyad t: gen runsumdem5t=sum(jtdem5)
by cdyad t: gen count5t=[_n]
by cdyad t: gen ratio5t=runsumdem5t/count5t

*Flags
gen flag1601b=1 if t1601==1 & ratio5<1
gen flag1644b=1 if t1644==1 & ratio5t<1
gen flag4589b=1 if t4589==1 & ratio5t<1
gen flag9001b=1 if t9001==1 & ratio5t<1

replace flag1601b=0 if flag1601b==. 
replace flag1644b=0 if flag1644b==. & t1644==1
replace flag4589b=0 if flag4589b==. & t4589==1
replace flag9001b=0 if flag9001b==. & t9001==1

by cdyad: egen maxflag1601b=max(flag1601b)
by cdyad t: egen maxflag1644b=max(flag1644b)
by cdyad t: egen maxflag4589b=max(flag4589b)
by cdyad t: egen maxflag9001b=max(flag9001b)

*Identify the dyads
tab cdyad if t1601==1 & maxflag1601b==0
tab cdyad if t1644==1 & maxflag1644b==0
tab cdyad if t4589==1 & maxflag4589b==0
tab cdyad if t9001==1 & maxflag9001b==0

*Mark first instance of joint democracy
by cdyad: gen firstdem5=1 if runsumdem5==1 & count5==1
by cdyad: replace firstdem5=1 if runsumdem5==1 & runsumdem5[_n-1]==0 & count5!=1
by cdyad: replace firstdem5=0 if firstdem5==.

*Identify dyads wih years +5
list cdyad year bordersettleyear if t1601==1 & maxflag1601b==0 & firstdem5==1
list cdyad year bordersettleyear if t1644==1 & maxflag1644b==0 & firstdem5==1
list cdyad year bordersettleyear if t4589==1 & maxflag4589b==0 & firstdem5==1
list cdyad year bordersettleyear if t9001==1 & maxflag9001b==0 & firstdem5==1


*TABLE 2
gen nondem6=1 if jtdem6==0 & jtdem6!=.
replace nondem6=0 if jtdem6==1 & jtdem6!=.

sort cdyad year
by cdyad: gen runsumnondem6=sum(nondem6)
by cdyad: egen maxdem6=max(runsumdem6)
by cdyad: egen maxnondem6=max(runsumnondem6)

sort settlem cdyad year
by settlem cdyad: gen setcountdem6=sum(jtdem6)
by settlem cdyad: gen setcountnon6=sum(nondem6)
by settlem cdyad: egen maxsetdem6=max(setcountdem6)
by settlem cdyad: egen maxsetnon6=max(setcountnon6)
by settlem cdyad: gen countersetdyad=_n

gen dem6byset=maxsetdem6 if countersetdyad==1
gen non6byset=maxsetnon6 if countersetdyad==1

ttest dem6byset, by (settlem)
ttest non6byset, by (settlem)


*At 5 level
gen nondem5=1 if jtdem5==0 & jtdem5!=.
replace nondem5=0 if jtdem5==1 & jtdem5!=.

sort cdyad year
by cdyad: gen runsumnondem5=sum(nondem5)
by cdyad: egen maxdem5=max(runsumdem5)
by cdyad: egen maxnondem5=max(runsumnondem5)

sort settlem cdyad year
by settlem cdyad: gen setcountdem5=sum(jtdem5)
by settlem cdyad: gen setcountnon5=sum(nondem5)
by settlem cdyad: egen maxsetdem5=max(setcountdem5)
by settlem cdyad: egen maxsetnon5=max(setcountnon5)
*by settlem cdyad: gen countersetdyad=_n

gen dem5byset=maxsetdem5 if countersetdyad==1
gen non5byset=maxsetnon5 if countersetdyad==1

ttest dem5byset, by (settlem)
ttest non5byset, by (settlem)

*TABLE 3
gen demyear6=year if firstdem6==1
gen difference=demyear6-bordersettleyear
summ difference, detail

*At Polity5
gen demyear5=year if firstdem5==1
gen difference5=demyear5-bordersettleyear
summ difference5, detail


*TABLE 4

use "Owsiak Vasquez - 2016 - Cart and Horse - Replication Data.dta", clear

drop if conttype==1
drop if year<1919
sort cdyad year
by cdyad: gen obs=_n

*Mark first instance of joint democracy
by cdyad: gen runsumdem6=sum(jtdem6)
by cdyad: gen count6=[_n]
by cdyad: gen firstdem6=1 if runsumdem6==1 & count6==1
by cdyad: replace firstdem6=1 if runsumdem6==1 & runsumdem6[_n-1]==0
by cdyad: replace firstdem6=0 if firstdem6==.

by cdyad: gen sumfirstdem = sum(firstdem6)
by cdyad: gen sumbothallset=sum(bothallsettle)

gen diffdemset = sumfirstdem-sumbothallset

gen violation=1 if firstdem==1 & sumbothallset==0
replace violation=0 if violation==. & sumbothallset!=.
by cdyad: egen maxviolation=max(violation)

tab maxviolation if conttype!=1 & conttype!=.
tab maxviolation if obs==1 & conttype!=1 & conttype!=.

gen simuldyad=1 if sumbothallset==1 & firstdem==1
replace simuldyad=0 if simuldyad==. & sumbothallset!=.
by cdyad: egen maxsimul=max(simuldyad)

tab maxsimul if conttype!=1 & conttype!=.
tab maxsimul if obs==1 & conttype!=1 & conttype!=.

by cdyad: egen maxsumfirstdem=max(sumfirstdem)
by cdyad: egen maxsumbothallset=max(sumbothallset)
by cdyad: gen neither=1 if maxsumfirstdem==0 & maxsumbothallset==0
by cdyad: replace neither=0 if neither==. & sumbothallset!=.

tab neither if conttype!=1 & conttype!=.
tab neither if obs==1 & conttype!=1 & conttype!=.

gen settlefirst=1 if neither==0 & maxviolation==0 & maxsimul==0
replace settlefirst=0 if settlefirst==. & sumbothallset!=.

tab settlefirst if conttype!=1 & conttype!=.
tab settlefirst if obs==1 & conttype!=1 & conttype!=.

*For table: use only settlefirst and violation (which is joint dem first)
*Dyad= 5666/(5666+2642)=68.20
*Dyad-year= 244185/(244185+100720)=70.80%

*With polity at 5
drop firstdem6 sumfirstdem diffdemset violation maxviolation simuldyad maxsimul maxsumfirstdem maxsumbothallset sumbothallset
drop neither settlefirst

gen jtdem5=0
replace jtdem5=1 if dem1>4 & dem1!=. & dem2>4 & dem2!=.

by cdyad: gen runsumdem5=sum(jtdem5)
by cdyad: gen count5=[_n]
by cdyad: gen firstdem5=1 if runsumdem5==1 & count5==1
by cdyad: replace firstdem5=1 if runsumdem5==1 & runsumdem5[_n-1]==0
by cdyad: replace firstdem5=0 if firstdem5==.

by cdyad: gen sumfirstdem=sum(firstdem5)
by cdyad: gen sumbothallset=sum(bothallsettle)

gen diffdemset=sumfirstdem-sumbothallset

gen violation=1 if firstdem==1 & sumbothallset==0
replace violation=0 if violation==. & sumbothallset!=.
by cdyad: egen maxviolation=max(violation)

tab maxviolation if conttype!=1 & conttype!=.
tab maxviolation if obs==1 & conttype!=1 & conttype!=.

gen simuldyad=1 if sumbothallset==1 & firstdem==1
replace simuldyad=0 if simuldyad==. & sumbothallset!=.
by cdyad: egen maxsimul=max(simuldyad)

tab maxsimul if conttype!=1 & conttype!=.
tab maxsimul if obs==1 & conttype!=1 & conttype!=.

by cdyad: egen maxsumfirstdem=max(sumfirstdem)
by cdyad: egen maxsumbothallset=max(sumbothallset)
by cdyad: gen neither=1 if maxsumfirstdem==0 & maxsumbothallset==0
by cdyad: replace neither=0 if neither==. & sumbothallset!=.

tab neither if conttype!=1 & conttype!=.
tab neither if obs==1 & conttype!=1 & conttype!=.

gen settlefirst=1 if neither==0 & maxviolation==0 & maxsimul==0
replace settlefirst=0 if settlefirst==. & sumbothallset!=.

tab settlefirst if conttype!=1 & conttype!=.
tab settlefirst if obs==1 & conttype!=1 & conttype!=.

*For table: use only settlefirst and violation (which is joint dem first)
*Dyad= 5550/(5550+3050)=64.53%
*Dyad-year= 239422/(239422+112207)=68.09%


*Timing in contiguous, mixed dyads
use "Owsiak Vasquez - 2016 - Cart and Horse - Replication Data.dta", replace

sort cdyad year
drop if conttype!=1
gen mixed=1 if dem1>5 & dem1!=. & dem2<6 & dem2!=.
replace mixed=1 if dem1<6 & dem1!=. & dem2>5 & dem2!=.
replace mixed=0 if mixed==.
sort cdyad year

gen cdem1=1 if dem1>5 & dem1!=.
replace cdem1=0 if cdem1==. & dem1!=.

gen cdem2=1 if dem2>5 & dem2!=.
replace cdem2=0 if cdem2==. & dem2!=.

by cdyad: gen sumdem1=sum(cdem1)
by cdyad: gen sumdem2=sum(cdem2)
by cdyad: gen obs=_n
by cdyad: gen firstdem1=1 if obs==1 & sumdem1==1
by cdyad: replace firstdem1=1 if sumdem1==1 & sumdem1[_n-1]==0
by cdyad: replace firstdem1=0 if firstdem1==. & sumdem1!=.

by cdyad: gen firstdem2=1 if obs==1 & sumdem2==1
by cdyad: replace firstdem2=1 if sumdem2==1 & sumdem2[_n-1]==0
by cdyad: replace firstdem2=0 if firstdem2==. & sumdem2!=.

by cdyad: gen firstdemall= firstdem1+firstdem2
by cdyad: replace firstdemall=1 if firstdemall>1
*by cdyad: gen firstdemall=firstdem1
*by cdyad: replace firstdemall=1 if firstdem2==1 & firstdem1==0
by cdyad: gen runsumdem=sum(firstdemall)

sort cdyad year
by cdyad: gen runsumsettle=sum(settlem) if conttype==1
by cdyad: gen cdiffsumset=runsumdem-runsumsettle

by cdyad: gen cviolation=1 if firstdemall==1 & runsumdem==1 & runsumsettle==0
by cdyad: replace cviolation=0 if cviolation==. & runsumsettle!=.
by cdyad: egen cmaxviolation=max(cviolation)

tab cmaxviolation if conttype==1
tab cmaxviolation if obs==1 & conttype==1

by cdyad: gen csimuldyad=1 if firstdemall==1 & runsumsettle==1
by cdyad: replace csimuldyad=0 if csimuldyad==. & runsumsettle!=.
by cdyad: egen cmaxsimul=max(csimuldyad)

tab cmaxsimul if conttype==1
tab cmaxsimul if obs==1 & conttype==1
replace cmaxsim=0 if cdyad==551565

by cdyad: egen cmaxrunsumdem=max(runsumdem)
by cdyad: egen cmaxsumsettle=max(runsumsettle)
by cdyad: gen cneither=1 if cmaxrunsumdem==0 & cmaxsumsettle==0 & conttype==1 
by cdyad: replace cneither=0 if cneither==. & cmaxsumsettle!=.

tab cneither if conttype==1
tab cneither if obs==1 & conttype==1

by cdyad: gen csettlefirst=1 if cneither==0 & cmaxviol==0 & cmaxsimul==0
by cdyad: replace csettlefirst=0 if csettlefirst==. & cneither!=. & cmaxviol!=. & cmaxsim!=.

tab csettlefirst if conttype==1
tab csettlefirst if obs==1 & conttype==1

*For table: use only settlefirst and violation (which is joint dem first)
*Dyad= 173/(173+87)=66.54%
*Dyad-year= 10321/(10321+4353)=70.34%

*log close


