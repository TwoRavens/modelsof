
 set more off 
  
  cd "~/Dropbox/Attribution Analysis Feb 2012/"

    use attribution.dta, clear

bys session period subject: egen tndp = total(ndp)
bys session period (subject): gen index = _n
bys session period: egen mndp = mean(tndp)

twoway scatter mndp allocdm if index==1, jitter(5) m(Oh) mc(black) msize(medlarge) || ///
lowess mndp allocdm if index==1, bwidth(0.8) lp(dash) lc(black) ///
xtitle("Amount kept by DMs (in £)") xscale(range(5 25)) xlab(5(5)25) ///
ytitle("Average deduction points used") yscale(range(0 30)) ///
ylabel(0(5)30, angle(horizontal) nogrid) ///
legend(order(2 "Lowess smoother") ring(0) pos(5) col(1)) ///
graphregion(color(white) margin(zero))

graph export graphics/figure1.eps, replace logo(off)


