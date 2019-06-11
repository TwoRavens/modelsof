/*
	Creates Figure 2
*/
clear *
// LaTeX log files
args tlog flog tloga floga

use "auxds/T1_reliabilityTable_data.dta"

local n 0
cap drop newlabs
local offset 25 /* number of plots before the first scatter we want to label */
recode sort (10.2=7.1) (10.3=8.1) (10.4=9.1) , gen(sortNew)
sort sortNew
gen newlabs = .
gen newlabsOS = ""
forval i=1/`=_N' {
	local ss = sortNew[`i']
	local vv = Var[`i']
	if inrange(`vv',1,34) & `ss'!=99 {
		local n = `n'+1
		replace newlabs = `n' in `i'
		makeoldstyle `n' , local(osn)
		replace newlabsOS = "`osn'" in `i'
		local thelab : label (Var) `vv'
		if inrange(`vv',33,34) {
			local thelab : subinstr local thelab "(dichot)" ""
		}
		if index("`thelab'","Emotion:") {
			local thelab : subinstr local thelab "Emotion: " ""
			local thelab = upper(`"`=substr("`thelab'",1,1)'"')+substr("`thelab'",2,.)
		}
		local space=cond(`n'<10,"  ","")
		local leg `"`leg' `=`n'+`offset''  `"`space'`osn' `thelab'"'"'
	}
}
// di `"`leg'"'
// cap drop gLabPos
gen     gLabPos =  6
replace gLabPos =  9 if newlabs==9
replace gLabPos =  9 if newlabs==8
replace gLabPos =  3 if newlabs==12
replace gLabPos = 10 if newlabs==14
replace gLabPos =  7 if newlabs==15
replace gLabPos =  5 if newlabs==17
replace gLabPos =  3 if newlabs==21

forval i=0(.2)1 {
	makeoldstyle `: di %03.1f `i'', local(osn)
	local axisLabs `axisLabs' `i' "`osn'"
}
makeoldstyle 2 , local(two)

local pcarrowopts pstyle(p1) msize(medium) mangle(20) barbsize(medium) mlabsize(vsmall) mlabcolor(black) lcolor(black) 
local scatoptB    pstyle(p1) msize(.75) mlab(newlabsOS) mlabvpos(gLabPos) mlabgap(0.2) mlabsize(vsmall) mlabcolor(black) 
local gname figure2

#delimit ;
twoway 
	|| function y=x, pstyle(p1) range(0 1) lwidth(vthin)  

	/* the arrows */
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==1 , `pcarrowopts' mcolor(black) lcolor(black%30)    
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==2 , `pcarrowopts' mcolor(black) lcolor(black%30)    
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==3 , `pcarrowopts' mcolor(black) lcolor(black%30) 
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==4 , `pcarrowopts' mcolor(black) lcolor(black%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==5 , `pcarrowopts' mcolor(black) lcolor(black%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==6 , `pcarrowopts' mcolor(black) lcolor(black%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==7 , `pcarrowopts' mcolor(red)   lcolor(red%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==8 , `pcarrowopts' mcolor(red)   lcolor(red%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==9 , `pcarrowopts' mcolor(red)   lcolor(red%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==10, `pcarrowopts' mcolor(red)   lcolor(red%30)   
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==11, `pcarrowopts' mcolor(red)   lcolor(red%30)       
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==12, `pcarrowopts' mcolor(red)   lcolor(red%30)       
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==13, `pcarrowopts' mcolor(red)   lcolor(red%30)       
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==14, `pcarrowopts' mcolor(red)   lcolor(red%30)       
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==15, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==16, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==17, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==18, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==19, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==20, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==21, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==22, `pcarrowopts' mcolor(green) lcolor(green%30)     
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==23, `pcarrowopts' mcolor(blue)  lcolor(blue%30)
	|| pcarrow  alpha110 alpha120 alpha100 alpha120 if newlabs==24, `pcarrowopts' mcolor(blue)  lcolor(blue%30)

	/* symbols at base of arrows */
	|| scatter alpha110 alpha120  if newlabs==1,  `scatoptB' mcolor(black) msym(t)  
	|| scatter alpha110 alpha120  if newlabs==2,  `scatoptB' mcolor(black) msym(t)  
	|| scatter alpha110 alpha120  if newlabs==3,  `scatoptB' mcolor(black) msym(t)  

	|| scatter alpha110 alpha120  if newlabs==4,  `scatoptB' mcolor(black) msym(T) msize(.9) mfcolor(white) mlwidth(thin)
	|| scatter alpha110 alpha120  if newlabs==5,  `scatoptB' mcolor(black) msym(T) msize(.9) mfcolor(white) mlwidth(thin)
	|| scatter alpha110 alpha120  if newlabs==6,  `scatoptB' mcolor(black) msym(T) msize(.9) mfcolor(white) mlwidth(thin)

	|| scatter alpha110 alpha120  if newlabs==7,  `scatoptB' mcolor(red)     
	|| scatter alpha110 alpha120  if newlabs==8,  `scatoptB' mcolor(red) msym(O) mfcolor(white)     
	|| scatter alpha110 alpha120  if newlabs==9,  `scatoptB' mcolor(red) 
	|| scatter alpha110 alpha120  if newlabs==10, `scatoptB' mcolor(red) msym(O) mfcolor(white)
	|| scatter alpha110 alpha120  if newlabs==11, `scatoptB' mcolor(red) 
	|| scatter alpha110 alpha120  if newlabs==12, `scatoptB' mcolor(red) msym(O) mfcolor(white)
	|| scatter alpha110 alpha120  if newlabs==13, `scatoptB' mcolor(red) 
	|| scatter alpha110 alpha120  if newlabs==14, `scatoptB' mcolor(red) msym(O) mfcolor(white)

	|| scatter alpha110 alpha120  if newlabs==15, `scatoptB' mcolor(green)                msym(D)
	|| scatter alpha110 alpha120  if newlabs==16, `scatoptB' mcolor(green)                msym(D)         
	|| scatter alpha110 alpha120  if newlabs==17, `scatoptB' mcolor(green)                msym(D)         
	|| scatter alpha110 alpha120  if newlabs==18, `scatoptB' mcolor(green)                msym(D)        
	|| scatter alpha110 alpha120  if newlabs==19, `scatoptB' mcolor(green) mfcolor(white) msym(D)  
	|| scatter alpha110 alpha120  if newlabs==20, `scatoptB' mcolor(green) mfcolor(white) msym(D)
	|| scatter alpha110 alpha120  if newlabs==21, `scatoptB' mcolor(green) mfcolor(white) msym(D)
	|| scatter alpha110 alpha120  if newlabs==22, `scatoptB' mcolor(green) mfcolor(white) msym(D)

	|| scatter alpha110 alpha120  if newlabs==23, `scatoptB' mcolor(blue)   msym(S) 
	|| scatter alpha110 alpha120  if newlabs==24, `scatoptB' mcolor(blue)   msym(S) 

	ytitle("mTurk workers", size(small)) 
	xtitle("Research assistants", size(small))  
	legend(order(`leg') col(1) size(vsmall) pos(3) rowgap(zero)
		note(
			" " " "
			"Figure displays Krippendorff’s α"
			"based on ads with multiple mTurk" 
			"meta-coders." 
			"Arrows show aggregation gain" 
			"from individual mTurk workers (base)"
			"to meta-coders (arrowhead),"
			"plotted against RA reliability.",  
			pos(5) ring(1) just(left) size(vsmall)
		) 
	) 
	aspect(1) 
	xlab(`axisLabs') 
	ylab(`axisLabs')
	title("Figure `two': Reliability comparisons by coding item", size(small) )
	graphregion(margin(t 0))
	name(`gname', replace) 
	;
#delimit cr

nwgexport latexOutput/plots/reliabilityGraphColor.pdf, replace
latexfigure plots/reliabilityGraphColor.pdf, log("`flog'") append width(6in)

