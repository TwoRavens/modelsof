clear
set obs 1

g tmp1=.
save c:\temp\tmp1, replace

*basic regressions based on admin data (fix_repet)	
clear
set matsize 1000
set more 1
set mem 1000m
program drop _all
macro drop _all


*basic regressions based on admin data (fix_repet)	
clear
set matsize 1000
set more 1
set mem 1000m
program drop _all
macro drop _all


macro define totc="c:\temp\repeticion"
macro define totj="c:\temp\repeticion"

macro define dir="${totc}"
macro define dir1="${totc}"
macro define dir2="${totj}"
macro define dir5="${totj}"
macro define dir6="${totc}"







****************************************************************




	
u "$dir\created_data_public\reg_uruguay", replace
capture drop newdum*
g newdum=dumdu-3
g newdum2=newdum^2
g newdum3=newdum^3
g newdum4=newdum^4
capture drop x 
g x=newdum>0



cap drop gr1

egen gr1=group(year depend newcursoant dumdu)

capture program drop grnow
program define grnow
capture drop if xxx==1
capture drop m$z
egen m$z=mean($z), by(dumdu)
set obs 150000
capture drop a0 a1

xi: reg m$z i.x|newdum i.x|newdum2  if x==1
predict a0
replace dumdu=3 if x==.
replace newdum=0 if x==.
capture drop xxx
g xxx=x==.
for any 2 3 4: replace newdumX=0 if x==.
replace x=0 if x==.
xi: reg m$z i.x|newdum i.x|newdum2 if x==0 & xxx!=1
predict a1
replace a0 = . if newdum<0
replace a1 = . if newdum>0
capture drop a2
g a2=a0 if newdum==0 & xxx==0
replace a2=a1 if newdum==0 & xxx==1
replace a2=a0 if newdum==1   
replace a0=. if newdum==0
replace dumdu=3-.001 if xxx==1
sort dumdu
label var dumdu "Failed subjects"

preserve
collapse a2 a0 a1 m$z (count) freq=$z, by(dumdu) fast
drop if dumdu>9
cap drop a3
g a3 = a2 if dumdu<=3
replace a2=. if dumdu<3

replace freq=. if dumdu!=int(dumdu)
g true=$true
append using c:\temp\tmp1
save $dir\created_data_confidential\tmp1, replace 
restore
end



global z="gap_c"
global min=0
global max=3
global gap=0.5
global true="1" 
grnow

	
capture drop if xxx==1
capture drop sumf*
egen sumf=count(dumdu)  , by(dumdu) 
egen sumft=count(dumdu) 
capture drop prop
g prop=sumf/sumft

*graph bar (mean) prop , over(dumdu, label(labsize(vsmall))) ylabel(0(.1).5) ytitle(" ")




drop if newdum==.
cap drop gr2 
*egen gr2=group(dep newcursoant age year sex)
egen gr2=group(dep newcursoant  year )

xi: areg gap_c if dumdu==3, a(gr2)
cap drop res
predict res, res
cap drop max
egen max=max(gap_cens) if dumdu==4, by(gr2)
cap drop max1
egen max1=max(max), by(gr2)
replace max=max1
drop max1

cap drop missclass
g missclass=gap_c>max if gap_c<. & dumdu==3
gsort dumdu gr2 missclass res 

cap drop n
cap drop N

qui by dumdu gr2 missclass: g N=_N if dumdu==3
cap drop max2
egen max2=max(N), by(gr2 missclass)
replace N=max2
qui by dumdu gr2 missclass: g n=_n  if dumdu==3 & gap_c>max
replace n=n/N if dumdu==3 & gap_c>max


cap drop adumdu
g adumdu=dumdu
replace adumdu=4 if n<=1

capture drop sumaf*
egen sumaf=count(adumdu)  , by(adumdu) 
egen sumaft=count(adumdu) 
capture drop aprop
g aprop=sumaf/sumaft

graph bar (mean) aprop , over(adumdu, label(labsize(vsmall))) ylabel(0(.1).5) ytitle(" ") bar(1, color(gs3))



	
cap drop anewdum*
g anewdum =adum-3
for any 2 3 4: g anewdumX=anewdum^X

cap drop ax 
g ax=anewdum>0
cap drop cou*
egen count1=sum(newdum!=anewdum), by(gr2 anewdum)
egen count2=count(anewdum), by(gr2 anewdum)
cap drop p_missclass
g p_missclass=count1/count2 if anewdum==1





cap drop axn*
g axnewdum=ax*anewdum
g axnewdum2=ax*anewdum^2
g axnewdum3=ax*anewdum^3
g axnewdum4=ax*anewdum^4

replace missclass=0 if missclass==.
global polynomial="anewdum anewdum2 axnewdum axnewdum2  anewdum3 axnewdum3  anewdum4 axnewdum4 "
cap drop new
g new=p_m
replace new=0 if new==.
constraint define 1 ax+new=0
cap drop newax 
g newax=ax-new
xi: reg gap_c newax $polynomial $controls     ,  cluster(gr1)  
cap drop newgap_c
g newgap_c=	gap_c
replace newgap_c=gap_c+_coef[newax]*missc
global polynomial="anewdum anewdum2 axnewdum axnewdum2   "
xi: reg newgap_c ax $polynomial $controls   ,  cluster(gr1) 
cap drop newrepite
g newrepite = repite
replace newrepite =1 if anewdum!=newdum
xi: reg newr ax $polynomial $controls   ,  cluster(gr1) 
replace newrepite =1 if anewdum!=newdum
xi: ivreg newg (newr=ax) $polynomial $controls   ,  cluster(gr1) 


capture program drop grnowa
program define grnowa
capture drop if xxx==1
capture drop m$z
egen m$z=mean($z), by(adumdu)
set obs 150000
capture drop a0 a1

xi: reg m$z i.ax|anewdum i.ax|anewdum2    if ax==1
predict a0
replace adumdu=3 if ax==.
replace anewdum=0 if ax==.
capture drop xxx
g xxx=x==.
for any 2 3 4: replace anewdumX=0 if ax==.
replace ax=0 if ax==.
xi: reg m$z i.ax|anewdum i.ax|anewdum2   if ax==0 & xxx!=1
predict a1
replace a0 = . if anewdum<0
replace a1 = . if anewdum>0
capture drop a2
g a2=a0 if anewdum==0 & xxx==0
replace a2=a1 if anewdum==0 & xxx==1
replace a2=a0 if anewdum==1   
replace a0=. if anewdum==0
replace adumdu=3-.001 if xxx==1
sort adumdu
label var adumdu "Failed subjects"

preserve
collapse a2 a0 a1 m$z (count) freq=$z, by(adumdu) fast
rename adumdu dumdu
drop if dumdu>9
cap drop a3
g a3 = a2 if dumdu<=3
replace a2=. if dumdu<3

replace freq=. if dumdu!=int(dumdu)
g true=$true
append using $dir\created_data_confidential\tmp1
save $dir\created_data_confidential\tmp1, replace 
restore
end



global z="newg"
global min=0
global max=3
global gap=0.5
global true="0" 
grnowa


u $dir\created_data_confidential\tmp1, replace
replace mg=mn if mg==.
for any 1 2 3 0: g aX1=aX if true==1
for any 1 2 3 0: g aX0=aX if true==0
g freq0=freq if true==0
for any 0 1: g mgap_cX =mgap_c if true==X
sort dumdu
scatter a10 a30 a20 a00  a11 a31 a21 a01   mgap_c0 mgap_c1  dumdu  [aw=freq0], c(l l l l l l l l ) lpattern(solid dot dash solid solid dot dash solid  )  ylabel($min  ($gap) $max) xlabel(0(1)9) ytitle("") legend(off)  lw(thick thin medthick thick thin thin thin thin  ) s(i i i i i i i i O) lcolor(black black black black black black black black black black)
