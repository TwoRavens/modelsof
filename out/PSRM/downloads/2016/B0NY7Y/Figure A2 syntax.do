clear 
 /// diff mean control lib
	
	
input str40 varname rank mean lower upper 
    "Certain to vote" -1 -.026796 -.0388825   -.0147096
    "Very likely to vote" -2  -.1220605  -.1639117   -.0802092
    "Somewhat likely to vote" -3 -.1727908 -.2325439   -.1130377 
	"Somewhat unlikely to vote" -4  -.287381 -.3664877   -.2082742
    "Very unlikely to vote" -5  -.2632444  -.3489535   -.1775353
    "Certain not to vote" -6  -.2410254 -.3037526   -.1782982
	end
	
label def rank -1 "Certain to vote" -2 "Very likely to vote" -3"Somewhat likely to vote" -4 "Somewhat unlikely to vote" -5 "Very unlikely to vote" -6 "Certain not to vote"
label val rank rank
 
***  twoway(dot mean rank if rank!=0 , base(0) horizontal yscale(range(1 6)) ylabel(0(1)13) ytick(0/13) xscale(range(5 -15)) xline(-6.06332) xlabel(10(5)-20))  || rcap  lower upper rank, horizontal name(figurea,replace)

twoway (bar mean rank , base(0) legend(off) barw(.8) color(gs6*.3) lcolor(gs6) ///
xtitle("") xscale(range(-1 -6))  xlab(-6 `""Certain" "not to vote""' -5 `""Very unlikely" "to vote""' -4 `""Somewhat unlikely" "to vote""' -3 `""Somewhat" "likely to vote""' -2 `""Very likely" "to vote""' -1 `""Certain" "to vote""',labsize(small)) xtick(-1/-6) ///
ytitle(P(Voted=1)) yscale(range(-.35 0)) ylab(-.3(.1) 0, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)) ymtick(-.35 -.25 -.15 -.05) yline(0))   || rcap  lower upper rank,  name(figurea,replace)

clear 

  
  
