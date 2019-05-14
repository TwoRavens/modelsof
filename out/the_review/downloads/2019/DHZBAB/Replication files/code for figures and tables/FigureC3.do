set scheme s1color
use wait_times, clear

gen german=(nationality=="German")
gen post=(yearpet>=1917)
gen diff=datenat-datepet
gen inter=post*german

collapse (mean) diff (sd) sd=diff (count) n=diff, by(german post)

generate hi = diff + invttail(n-1,0.025)*(sd / sqrt(n))
generate low = diff - invttail(n-1,0.025)*(sd / sqrt(n))

generate germanpost = german    if post == 0
replace  germanpost = german+3  if post == 1
	
twoway (bar diff germanpost if german==0, color(gs1) barwidth(0.7)) (bar diff germanpost if german==1, color(gs10) barwidth(0.7)) ///
	(rcap hi low germanpost, lcolor(black)), legend(row(1) order(1 "Other" 2 "German") ) ///
      xlabel( 0.5 "1913" 3.5 "1917", noticks) ///
       xtitle("Year petition filed", size(small)) ytitle("Days elapsed between petition and approval", size(small))  ///
	   plotregion(style(none)) xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small))	///
xsca(titlegap(2)) legend(size(small))
	

