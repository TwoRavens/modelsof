do reconstruct_extrad /*pools the various sets of earnings moments*/

set more off


sort bobt bobs cohot cohos yt ys
local i=1
cap drop corre elast
sca drop _all
ge corre=.
ge elast=.
while `i' <= _N {
	di "`i'"
	sca num=m[`i']
	local bt=bobt[`i']
	local bs=bobs[`i']
	local ct=cohot[`i']
	local cs=cohos[`i']	
	local yt=yt[`i']		
	local ys=ys[`i']	
	cap drop d1
	qui ge d1 = m if bobt== `bt' &  bobs== `bt' & cohot== `ct' & cohos== `ct' & yt== `yt' & ys== `yt'  
	qui summ d1
	local d1=sqrt(r(mean))
	cap drop d2
	qui ge d2 = m if bobt== `bs' &  bobs== `bs' & cohot== `cs' & cohos== `cs' & yt== `ys' & ys== `ys'  
	qui summ d2
	local d2=sqrt(r(mean))
	sca correlazia=num/(`d1'*`d2')  
	sca elastizia = correlazia*(`d2'/`d1')
	qui replace corre=correlazia in `i'/`i'
	qui replace elast=elastizia in `i'/`i'	
	local i = `i' + 1
 }



cap drop pino*
cap drop age_s2

cap drop covinter
cap drop covinter35 

cap drop abstds

cap drop corrinter
cap drop corrinter35 
cap drop pino*
ge corrinter=.
ge corrinter35=.
 
ge age_s2=.
ge covinter=.
ge covinter35=.
ge abstds=abs(yt-ys)



cap drop covinters1 covinters2 corrinters1 corrinters2
ge covinters1=.
ge covinters2=.
ge corrinters1=.
ge corrinters2=.


local i=0
 forvalues as = 0(1)26 {
	local i= `i' +1
	
	ge pino=bobt==0&bobs>0&agetA==`as'&agesA==`as'
	ge pino1=bobt==0&bobs>0&agetA==10 & agesA==`as'
	
	ge pinos1=bobt==0&bobs==1&agetA==`as'&agesA==`as'
	ge pinos2=bobt==0&bobs==2&agetA==`as'&agesA==`as'
	
	
	gen pinom= sum(pino*m)/sum(pino)
	gen pino1m= sum(pino1*m)/sum(pino1)
	gen pinos1m= sum(pinos1*m)/sum(pinos1)
	gen pinos2m= sum(pinos2*m)/sum(pinos2)
	
	
	sca covinter_`as' = pinom[_N]
	sca covinter35_`as' = pino1m[_N]
	sca covinters1_`as' = pinos1m[_N]
	sca covinters2_`as' = pinos2m[_N]	

	gen pinoc= sum(pino*corre)/sum(pino)
	gen pino1c= sum(pino1*corre)/sum(pino1)
	gen pinos1c= sum(pinos1*corre)/sum(pinos1)
	gen pinos2c= sum(pinos2*corre)/sum(pinos2)
	
	sca corrinter_`as' = pinoc[_N]
	sca corrinter35_`as' = pino1c[_N]
	sca corrinters1_`as' = pinos1c[_N]
	sca corrinters2_`as' = pinos2c[_N]	
	
	sca age_s2_`as' = `as' + 25
	replace age_s2 = age_s2_`as' in `i'/`i' 
	replace covinter = covinter_`as' in `i'/`i' 
	replace covinter35 = covinter35_`as' in `i'/`i' 
	replace corrinter = corrinter_`as' in `i'/`i' 
	replace corrinter35 = corrinter35_`as' in `i'/`i' 	

	replace covinters1 = covinters1_`as' in `i'/`i' 
	replace covinters2 = covinters2_`as' in `i'/`i' 
	replace corrinters1 = corrinters1_`as' in `i'/`i' 
	replace corrinters2 = corrinters2_`as' in `i'/`i' 

	drop pino*
 }




cap drop pino*
cap drop covbro
cap drop covbro35

cap drop corrbro
cap drop corrbro35

ge covbro=.
ge covbro35=.

ge corrbro=.
ge corrbro35=.


local i=0
 forvalues as = 0(1)26 {
	local i= `i' +1

	ge pino=bobt==1&bobs==2&agetA==`as'&agesA==`as'   
	ge pino1=bobt==1&bobs==2&agetA== 10 &agesA==`as'	 

	gen pinom= sum(pino*m)/sum(pino)
	sca covbro_`as' = pinom[_N]
	replace covbro = covbro_`as' in `i'/`i' 
	
	
	gen pinoc= sum(pino*corre)/sum(pino)
	sca corrbro_`as' = pinoc[_N]
	replace corrbro = corrbro_`as' in `i'/`i'

	gen pino1m= sum(pino1*m)/sum(pino1)
	sca covbro35_`as' = pino1m[_N]
	replace covbro35 = covbro35_`as' in `i'/`i' 

	gen pino1c= sum(pino1*corre)/sum(pino1)
	sca corrbro35_`as' = pino1c[_N]
	replace corrbro35 = corrbro35_`as' in `i'/`i' 
	
	drop pino*
 }

 


label var corrbro "Same age"
label var corrbro35 "Fixed age"
label var age_s2 "Brother-2's Age"
graph twoway connect corrbro corrbro35 age_s2, lcolor(black black ) mcolor(black black ) lpattern(solid dash) symbol(d + )  xlabel(25(5)50) /// 
ylabel(0(.05).2 ,angle(0)) xtick(25(1)51)	graphregion(color(white)) ytitle("Correlation", color(black)) title("A) Sibling", color(black)) saving(corrsibs.gph, replace) 


label var corrinter "Same age"
label var corrinter35 "Fixed age"
label var age_s2 "Sons' Age"
graph twoway connect corrinter corrinter35 age_s2, lcolor(black black ) mcolor(black black ) lpattern(solid dash) symbol(d + )  xlabel(25(5)50) /// 
ylabel(0(.05).2 ,angle(0)) xtick(25(1)51)	 graphregion(color(white)) title("B) Intergenerational", color(black)) ytitle("Correlation", color(black)) saving(corrinter.gph, replace) 

















	
