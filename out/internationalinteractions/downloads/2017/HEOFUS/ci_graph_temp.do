
matrix b=e(b)  
matrix V=e(V)  
scalar b1=b[1,1]  
scalar b2=b[1,2] 
scalar b3=b[1,3] 
scalar varb1=V[1,1]  
scalar varb2=V[2,2]  
scalar varb3=V[3,3] 
scalar covb1b3=V[1,3]  
scalar covb2b3=V[2,3] 
*scalar list _all

generate Z=((_n-1))

***to use the original 1 to 5 barglev2
*replace Z=. if _n>51 & _n<10

***to use the 0 to 2 categorical union centralization
replace Z=. if _n>3

***to use the 1 to 3 categorical union centralization
*replace Z=. if _n>31 | _n<10

*generate Z=((_n-1)/100)
*replace Z=. if _n>501

*range Z 0.1 100 1000
*replace Z=. if _n>964 | _n<74

gen conb=b1+b3*Z if _n<=3
gen conse=sqrt(varb1+varb3*Z^2+2*covb1b3*Z)  if _n<=3

*gen conb=b1+b3*Z if _n<=51
*gen conse=sqrt(varb1+varb3*Z^2+2*covb1b3*Z)  if _n<=51

*gen conb=b1+b3*Z
*gen conse=sqrt(varb1+varb3*Z^2+2*covb1b3*Z)


gen a=1.96*conse  
*gen a=1.684*conse  
gen top=conb+a  
gen bottom=conb-a 
set textsize 100

*twoway (line conb Z, lcolor(black) lpattern(solid) lwidth(medium)) (line top Z, lcolor(black) lpattern(dash) lwidth(thin)) (line bottom Z, lcolor(black) lpattern(dash) lwidth(thin)), ytitle(Marginal Effect of Partisanship, size(small)) yline(0) xtitle(Centralization of Wage Setting) title("Marginal Effect of Partisanship on ILM levels", size(medium)) legend(off) scheme(s2mono) graphregion(ifcolor(white)) yscale(noline) xscale(noline) yline(-.4 -.2 .2 .4 , lcolor(white))


