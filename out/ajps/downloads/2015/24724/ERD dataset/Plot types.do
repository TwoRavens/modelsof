twoway (scatter p3 p2 if case == "B*", mcolor(black) msize(small) msymbol(circle)) ///
(scatter p3 p2 if case == "B", mcolor(black) msize(small) msymbol(circle_hollow)) ///
(scatter p3 p2 if case == "C", mcolor(gray) msize(small) msymbol(diamond)) ///
(scatter p3 p2 if case == "D", mcolor(black) msize(small) msymbol(square_hollow)) ///
(scatter p3 p2 if case == "E", mcolor(black) msize(small) msymbol(square)) ///
, ylabel(0(.1).5) xlabel(0(.1).5) xmtick(0(.1).5) legend (off) xsize(4) ysize(4)

*twoway (scatter p3 p1 if case == "B*", mcolor(black) msize(small) msymbol(lgx)) ///
*(scatter p3 p1 if case == "B", mcolor(blue) msize(small) msymbol(lgx)) ///
*(scatter p3 p1 if case == "C", mcolor(lime) msize(small) msymbol(lgx)) ///
*(scatter p3 p1 if case == "D", mcolor(yellow) msize(small) msymbol(lgx)) ///
*(scatter p3 p1 if case == "E", mcolor(red) msize(small) msymbol(lgx)) ///
*, ylabel(0(.1).5) xlabel(0(.1).5) xmtick(0(.1).5) legend (off) xsize(4) ysize(4)

*twoway (scatter p3 p2 if case == "B*", mcolor(black) msize(small) msymbol(lgx)) ///
*(scatter p3 p2 if case == "B", mcolor(blue) msize(small) msymbol(lgx)) ///
*(scatter p3 p2 if case == "C", mcolor(lime) msize(small) msymbol(lgx)) ///
*(scatter p3 p2 if case == "D", mcolor(yellow) msize(small) msymbol(lgx)) ///
*(scatter p3 p2 if case == "E", mcolor(red) msize(small) msymbol(lgx)) ///
*, ylabel(0(.1).5) xlabel(0(.1).5) xmtick(0(.1).5) legend (off) xsize(4) ysize(4)

* Thresholds

gen thresh12 = (S1 + S2 - W)/ total_seats
gen thresh13 = (S1 + S3 - W)/ total_seats
gen thresh23 = (S2 + S3 - W)/ total_seats

gen censored = 0
replace censored = 1 if  absolute_cab_duration > 1350
stset absolute_cab_duration, failure (censored)

stcox  thresh12 thresh13 thresh23 if minority_parl == 1 & post_election == 1, efron nohr robust
