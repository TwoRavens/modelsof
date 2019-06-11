*** New Tables for R&R ***


use "/Users/mattluttig/Desktop/Trump Experiment Paper/Research and Politics Submission/trump replication data.dta"

reg oppmort01 blk if white==1, hc3
reg anger01 blk if white==1, hc3
reg indblame01 blk if white==1, hc3


///Table 1a
///Oppose mortgage assistance
///model and marginal effects:
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using table1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word replace
display e(r2_a)
margins, dydx(blk) at(trumpfta=(0 1))
margins, dydx(trumpfta) at(blk=(0 1))
///graph:
quietly margins, dydx(blk) at(trumpfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Trump Favorability") ytitle("Conditional Effect of Racial Cue") title ("Opposition to Mortgage Program") saving (dv1, replace)

///Table 1b	
//////anger.
///model and marginal effects:
reg anger01 age income01 gender educ01 unem  c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using table1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
display e(r2_a)
margins, dydx(blk) at(trumpfta=(0 1))
margins, dydx(trumpfta) at(blk=(0 1))
///graph:
quietly margins, dydx(blk) at(trumpfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Trump Favorability") ytitle("Conditional Effect of Racial Cue") title ("Anger at Mortgage Program") saving (dv2, replace)

////Table 1c
//////blame.
///model and marginal effects:
reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using table1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
display e(r2_a)
margins, dydx(blk) at(trumpfta=(0 1))
margins, dydx(trumpfta) at(blk=(0 1))
///graph:
quietly margins, dydx(blk) at(trumpfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Trump Favorability") ytitle("Conditional Effect of Racial Cue") title ("Target Blame") saving (dv3, replace)
///////combine all three graphs:
graph combine dv1.gph dv2.gph dv3.gph, cols(3) altshrink ycommon ysize(2) saving(fig1, replace)


///Testing diff. between the two interaction terms
///Table 1
reg oppmort01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction if white==1, hc3
test trumpinteraction = clintoninteraction

reg anger01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction if white==1, hc3
test trumpinteraction = clintoninteraction

reg indblame01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction if white==1, hc3
test trumpinteraction = clintoninteraction

///Table 2
reg oppmort01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
test trumpinteraction = clintoninteraction

reg anger01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
test trumpinteraction = clintoninteraction

reg indblame01 age income01 gender educ01 unem blk trumpfta clintonfta trumpinteraction clintoninteraction c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
test trumpinteraction = clintoninteraction

///Clinton Figure
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
///graph:
quietly margins, dydx(blk) at(clintonfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Clinton Favorability") ytitle("Conditional Effect of Racial Cue") title ("Opposition to Mortgage Program") saving (dv1c, replace)

	
reg anger01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
quietly margins, dydx(blk) at(clintonfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Clinton Favorability") ytitle("Conditional Effect of Racial Cue") title ("Anger at Mortgage Program") saving (dv2c, replace)


reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
quietly margins, dydx(blk) at(clintonfta=(0 (.1) 1))
marginsplot, recast(line) recastci(rline) plotop(lcolor(black)) ciopt(color(gs8) lp(dash)) ylabel(-.3 (.1) .3) xlabel(0 (.2) 1) ///
	xtitle("Clinton Favorability") ytitle("Conditional Effect of Racial Cue") title ("Target Blame") saving (dv3c, replace)

	///////combine all three graphs:
graph combine dv1c.gph dv2c.gph dv3c.gph, cols(3) altshrink ycommon ysize(2) saving(fig1, replace)




///Table 2
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
outreg2 using table2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
outreg2 using table2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.clintonfta##i.blk c.ideo01##i.blk c.ptyid01##i.blk if white==1, hc3
outreg2 using table2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append


///Appendix 1.

reg oppmort01 c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using apptable, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using apptable, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 c.trumpfta##i.blk c.clintonfta##i.blk if white==1, hc3
outreg2 using apptable, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix2: Function of racial resentment
reg oppmort01 age income01 gender educ01 unem c.rrscal##i.blk if white==1, hc3
outreg2 using apptable2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.rrscal##i.blk if white==1, hc3
outreg2 using apptable2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.rrscal##i.blk if white==1, hc3
outreg2 using apptable2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix3: Function of ethnocentrism
reg oppmort01 age income01 gender educ01 unem c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix4: Function of white disadvantage
reg oppmort01 age income01 gender educ01 unem c.whtvul##i.blk if white==1, hc3
outreg2 using apptable4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.whtvul##i.blk if white==1, hc3
outreg2 using apptable4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.whtvul##i.blk if white==1, hc3
outreg2 using apptable4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix 5: W2 vote choice as moderator (A2).
reg oppmort01 age income01 gender educ01 unem  i.trump i.blk i.trump#i.blk if white==1, hc3
outreg2 using apptable5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
reg anger01 age income01 gender educ01 unem i.trump i.blk i.trump#i.blk if white==1, hc3
outreg2 using apptable5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem  i.trump i.blk i.trump#i.blk if white==1, hc3
outreg2 using apptable5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix6: Function of racial resentment
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.rrscal##i.blk if white==1, hc3
outreg2 using apptable6, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.trumpfta##i.blk c.rrscal##i.blk if white==1, hc3
outreg2 using apptable6, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.rrscal##i.blk if white==1, hc3
outreg2 using apptable6, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix7: Function of ethnocentrism
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable7, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable7, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtblkftdiffw2##i.blk if white==1, hc3
outreg2 using apptable7, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append

///appendix8: Function of white disadvantage
reg oppmort01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtvul##i.blk if white==1, hc3
outreg2 using apptable8, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word replace
reg anger01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtvul##i.blk if white==1, hc3
outreg2 using apptable8, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append
reg indblame01 age income01 gender educ01 unem c.trumpfta##i.blk c.whtvul##i.blk if white==1, hc3
outreg2 using apptable8, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10, 0.20) addstat(Pseudo R-squared, e(r2_a)) word append





