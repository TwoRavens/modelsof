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



u  $dir\created_data_public\reg_uruguay, replace

capture drop newdum*
g newdum=dumdu-3
g newdum2=newdum^2
g newdum3=newdum^3
g newdum4=newdum^4
capture drop x 
g x=newdum<=0



cap drop gr1

egen gr1=group(year depend newcursoant dumdu)

capture program drop grnow
program define grnow
capture drop if xxx==1
capture drop m$z
egen m$z=mean($z), by(dumdu)
set obs 150000
capture drop a0 a1

xi: reg m$z i.x|newdum i.x|newdum2  if x==0
predict a0
replace dumdu=3 if x==.
replace newdum=0 if x==.
capture drop xxx
g xxx=x==.
for any 2 3 4: replace newdumX=0 if x==.
replace x=1 if x==.
xi: reg m$z i.x|newdum i.x|newdum2 if x==1 & xxx!=1
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

scatter a1 a3 a2 a0  m$z dumdu [aw=freq] , c(l l l l) lpattern(solid dot dash solid )  ylabel($min  ($gap) $max) xlabel(0(1)9) ytitle("") legend(off)  lw(thick medium medthick thick ) s(i i i i)
restore
drop if id==.
*sample 2
end


global z="repite"
global min=0
global max=1
global gap=0.2
grnow




global z="gap_c"
global min=0
global max=3
global gap=0.5
grnow


capture drop if xxx==1
capture drop sumf*
egen sumf=count(dumdu)  , by(dumdu) 
egen sumft=count(dumdu) 
capture drop prop
g prop=sumf/sumft

graph bar (mean) prop , over(dumdu, label(labsize(vsmall))) ylabel(0(.1).5) ytitle(" ")

capture drop if xxx==1

cap drop mnotamat*
egen mnotamat=rmean(notamat9-notamat1) if newcursoant<9
egen mnotamat1=rmean(notamat11-notamat1) if newcursoant==9
replace mnotamat=mnotamat1 if newcursoant==9
for any 10 11: replace notamatX=99 if newcursoant<9 & dumdu!=.



g newcens=cens
replace newcens=1 if year==96 & pres4==1 & repite==0
replace newcens=1 if year==97 & pres3==1 & repite==0
capture log close
log using $dir\created_data_public\tables , text replace
keep if dumdu!=.
replace distage=.  if distage==99
tabstat repite gap_c  newcens  dumdu mnotamat newfaltas  newcursoant age distage sexo if sample==1, by(repite)   f(%9.3f)
tabstat repite gap_c  newcens  dumdu newfaltas  distage sexo if sample==1 & repite==1, by(newcursoant)   f(%9.3f)
tabstat repite gap_c  newcens  dumdu newfaltas  distage sexo if sample==1 & repite==0, by(newcursoant)   f(%9.3f)

tab newcursoant if sample==1
tab newcursoant if sample==1 & repite==1
tab newcursoant if sample==1 & repite==0

	
log close


capture program drop initial
program define initial
xi: reg repite repite
outreg repite using "$dir\created_data_public\fs_reg_${y}${label1}${label2}.doc",  replace nolabel nocons   3aster coefastr  se tdec(3) 
end

capture program drop initialiv
program define initialiv
xi: reg repite repite
outreg repite using "$dir\created_data_public\iv_reg_${y}${label1}${label2}.doc",  replace nolabel nocons   3aster coefastr  se tdec(3)  
end

capture program drop reg1
program define reg1
xi: reg $y x $polynomial $controls $condition, cluster(gr1)
outreg x using "$dir\created_data_public\fs_reg_${y}${label1}${label2}.doc",  append nolabel nocons   3aster coefastr  se tdec(3) 
end



capture program drop ivreg1
program define ivreg1
xi: ivreg $y (repite=x) $polynomial $controls $condition  , cluster(gr1)
outreg repite using "$dir\created_data_public\iv_reg_${y}${label1}${label2}.doc",  append nolabel nocons   3aster coefastr  se tdec(3) 
end

capture program drop reg2
program define reg2


global polynomial=" " 
global argument =" "
${iv}reg1


global polynomial="i.x|newdum" 
global argument =" "
${iv}reg1
d

global polynomial="i.x|newdum i.x|newdum2" 
global argument =""
${iv}reg1

global polynomial="i.x|newdum i.x|newdum2 i.x|newdum3" 
global argument =""
${iv}reg1

global polynomial="i.x|newdum i.x|newdum2 i.x|newdum3 i.x|newdum4" 
global argument =""
${iv}reg1


end


capture program drop reg3
program define reg3
initial${iv}

global controls=""
cap drop gr1
egen gr1=group(dumdu)
reg2


global controls=" i.newcursoant  i.year i.dep "
cap drop gr1
egen gr1=group(dumdu year newcursoant dep)
reg2

global controls="i.age i.distage i.newcursoant  i.sexo  i.year i.dep i.newfaltas i.notamat1 i.notamat2 i.notamat3 i.notamat4 i.notamat5 i.notamat6 i.notamat7 i.notamat8 i.notamat9 i.notamat10 i.notamat11"
cap drop gr1
egen gr1=group(dumdu year newcursoant dep)
reg2
end


capture program drop reg3_saturated
program define reg3_saturated
global iv="iv"
initial${iv}
global controls="i.age i.distage i.newcursoant  i.sexo  i.year i.dep i.newfaltas i.notamat1 i.notamat2 i.notamat3 i.notamat4 i.notamat5 i.notamat6 i.notamat7 i.notamat8 i.notamat9 i.notamat10 i.notamat11"
global polynomial="i.x|newdum i.x|newdum2 i.x|newdum3 i.x|newdum4" 
global argument =""
cap drop gr1
egen gr1=group(dumdu year newcursoant dep)

xi: ivreg $y (repite=x) $polynomial $controls $condition  , cluster(gr1)
outreg repite using "$dir\created_data_public\iv_reg_${y}${label1}${label2}.doc",  append nolabel nocons   3aster coefastr  se tdec(3) 
global iv=""

end

capture program drop reg3_nocontrols
program define reg3_nocontrols
global iv=""
initial${iv}
global controls="i.newcursoant  i.year "
global polynomial="i.x|newdum i.x|newdum2 i.x|newdum3 i.x|newdum4" 
global argument =""
cap drop gr1
egen gr1=group(dumdu year newcursoant dep)

xi: areg $y x $polynomial $controls $condition  , a(dep) cluster(gr1)
outreg x using "$dir\created_data_public\fs_reg_${y}${label1}${label2}.doc",  append nolabel nocons   3aster coefastr  se tdec(3) 

end
	

capture program drop reg4
program define reg4

global y="repite"
global iv=""
reg3

global y="gap_c"
global iv=""
reg3

global y="gap_c"
global iv="iv"
reg3


end

capture program drop reg4others
program define reg4others


local i=1
while `i'<=4 {
global y="pres`i'"
global iv="iv"
reg3_saturated
local i=`i'+1
}

global y="dur"
global iv="iv"
reg3_saturated


global y="intermitt"
global iv="iv"
reg3_saturated

local i=1
while `i'<=4 {	
global iv="iv"
global y="maxnewcursoant`i'"
reg3_saturated
local i=`i'+1
}

	

end


capture program drop reg4controls
program define reg4controls

global condition=""
global y="newfaltas"
global iv=""
reg3_nocontrols

cap drop age1
g age1=age if age<99
global y="age1"
reg3_nocontrols


global y="distage"
global iv=""
reg3_nocontrols

global y="sexo"  
global iv=""
reg3_nocontrols

global y="mnotamat" 
reg3_nocontrols

/*
global g =1
while $g<=9 {
global y="notamat$g" 
reg3_nocontrols
global g=$g+1
}
*/


global y="notamat" 
reg3_nocontrols

cap drop notaesp1
g notaesp1=notaesp
replace notaesp1=notalit if newcursoant==9
global y="notaesp1" 
reg3_nocontrols

global y="notaidi" 
reg3_nocontrols


global y="notahist" 
reg3_nocontrols

global y="notageo" 
reg3_nocontrols

global y="notabio" 
reg3_nocontrols


cap drop notafis1
g notafis1=notacsfis
replace notafis1=notafis if newcursoant==9
global y="notafis1" 
reg3_nocontrols

global y="notaedf" 
reg3_nocontrols


cap drop notadibmus
g notadibmus=notadib
replace notadibmus=notamus if newcursoant==9
global y="notadibmus" 

/*global y="notadib" 
reg3_nocontrols

global y="notamus" 
reg3_nocontrols
*/

global y="notaqui" 
reg3_nocontrols


global y="notaeds" 
reg3_nocontrols


*typical curricula

*7 grade curriculum
*esp mat eng/fra hist geo dib bio csfis edfis (tallexp) 

*8 grade curriculum
*esp mat eng/fra hist geo dib bio csfis edfis (dib expart)
	
*9th grade
*lit mat eng/fra hist geo edsoc bio fis edfis qui edmus (eds tallsoc)


end

capture program drop reg5
program define reg5
global condition=""
global label1=""
reg4${others}
end


capture program drop reg5curso
program define reg5curso
global condition "if newcursoant==7"
global label1="_curso7"
preserve
keep $condition
reg4${others}
restore

global condition "if newcursoant==8"
global label1="_curso8"
preserve
keep $condition
reg4${others}
restore
global condition "if newcursoant==9"
global label1="_curso9"
preserve
keep $condition
restore
reg4${others}
end




	
global others=""
reg5
reg5curso

global others="others"
reg5


global label1=""
reg4controls


