****make table 1

use DA_final, clear


tab AP disp_cap
tab AP disp_cap if DV == 1



**** make table 2
use DA_final, clear

logit DV alliance_port cap, robust
logit DV alliance_port cap cap_AP, robust
logit DV alliance_port cap cap_AP depend_ally ext_security, robust
logit DV alliance_port cap cap_AP depend_ally ext_security o_cap powershare lndist ln_odist sever, robust
logit DV alliance_port cap cap_AP depend_ally ext_security o_cap powershare powershare2 lndist ln_odist sever, robust
																																				
																																																																																																												
**** Make Figue 1
use DA_final, clear

logit DV alliance_port cap cap_AP, robust

gen cond_slope = _b[alliance_port] + _b[cap_AP]*cap
gen cond_se = sqrt(.00010881+ cap^2*.00105415 + 2*cap*-.00023313)
gen up = cond_slope + 1.96*cond_se
gen lo = cond_slope - 1.96*cond_se
		
egen tag = tag(cond_slope)
twoway (rarea up lo cap if tag == 1, color(gs12) sort)(connected cond_slope cap if tag == 1 , sort lcolor(black) lpattern(solid) msymbol(i)) , xtitle("Disputant Capabilities") ytitle("Conditional Slope of Alliance Portfolio Size") scheme(s1manual) xsize(5) ysize(5) legend(off) yline (0)


********TAble 3
use DU_final, clear

tab AP disp_cap
tab AP disp_cap if DV !=0


****table 4
use DU_final, clear

logit DV alliance_port cap, robust
logit DV alliance_port cap cap_AP, robust
logit DV alliance_port cap cap_AP o_cap powershare sever, robust
	
nbreg DV alliance_port cap , robust
nbreg DV alliance_port cap cap_AP, robust
nbreg DV alliance_port cap cap_AP o_cap powershare sever, robust
	

****Figure2
use DU_final, clear

logit DV alliance_port cap cap_AP o_cap powershare sever, robust

capture matrix drop alliance
forvalues count = 1(1)50 {
   local cap = .4
   local inter = `count'*`cap'
   prvalue, x(cap=`cap' alliance_port=`count' cap_AP=`inter') rest(mean) delta
   praccum, using(alliance) xis(`count')
}
praccum, using(alliance) gen(cap40)

capture matrix drop alliance
forvalues count = 1(1)50 {
   local cap = .3
   local inter = `count'*`cap'
   prvalue, x(cap=`cap' alliance_port=`count' cap_AP=`inter') rest(mean) delta
   praccum, using(alliance) xis(`count')
}
praccum, using(alliance) gen(cap30)

capture matrix drop alliance
forvalues count = 1(1)50 {
   local cap = .2
   local inter = `count'*`cap'
   prvalue, x(cap=`cap' alliance_port=`count' cap_AP=`inter') rest(mean) delta
   praccum, using(alliance) xis(`count')
}
praccum, using(alliance) gen(cap20)

capture matrix drop alliance
forvalues count = 1(1)50 {
   local cap = .1
   local inter = `count'*`cap'
   prvalue, x(cap=`cap' alliance_port=`count' cap_AP=`inter') rest(mean) delta
   praccum, using(alliance) xis(`count')
}
praccum, using(alliance) gen(cap10)

label var cap10p1 ".10"
label var cap20p1 ".20"
label var cap30p1 ".30"
label var cap40p1 ".40"

twoway (line cap10p1 cap10x, lpattern(dash)) (line cap20p1 cap10x, lpattern(dash_dot)) (line cap30p1 cap10x, lpattern(solid)) (line cap40p1 cap10x, lpattern(longdash_dot)) , xtitle("Number of Alliances") ytitle("Pr(Joiners > 0)") scheme(s1manual) xsize(5) ysize(5) ylabel(0(.2)1) legend(subtitle("Disputant Capabilities", size(medsmall)) region(lstyle(none)) size(small) ring (0) position(10))


*******
**Table 5
logit DV ext_security ,robust 
logit DV ext_security ext_security2, robust 
logit DV ext_security ext_security2 o_cap powershare  severity , robust

nbreg DV ext_security,robust 
nbreg DV ext_security ext_security2, robust 
nbreg DV ext_security ext_security2 o_cap powershare severity , robust

***Figure 3
logit DV ext_security ext_security2 o_cap powershare  severity , robust

capture matrix drop alliance
forvalues count = 0(.01)1 {
   local inter = `count'*`count'
   prvalue, x(ext_security=`count' ext_security2=`inter') rest(mean) delta
   praccum, using(alliance) xis(`count')
}
praccum, using(alliance) gen(ext)



twoway (line extp1 extx) , xtitle("Dependence on Alliance Portfolio") ytitle("Pr(Joiners > 0)") scheme(s1manual) xsize(5) ysize(5) ylabel(0(.025).1) 


