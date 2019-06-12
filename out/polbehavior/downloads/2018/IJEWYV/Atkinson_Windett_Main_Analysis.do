use Cong88-110_Amended.dta 



*******summary statistic plots of DV


vioplot femcount2 malecount2, over(Cong) yscale(range(0 200) noextend) nofill  legend(pos(6)) title("") ytitle("Total Bills Sponsored", size(medium) margin(medsmall)) xtitle("Congress", size(medium) margin(medsmall)) xlabel(, angle(vertical))
graph export "VioCount.pdf", as(pdf) replace

 
vioplot HHIfem HHImale, over(Cong)  nofill  legend(pos(6))   title("") ytitle("Agenda Diversity (HHI)", size(medium) margin(medsmall)) xtitle("Congress", size(medium) margin(medsmall)) xlabel(, angle(vertical)) 
graph export "VioHHI.pdf", as(pdf) replace

vioplot femchallenger malechallenger, over(eleccount2)  nofill  legend(pos(6)) scheme(s2mono) graphregion(color(white))   title("") ytitle("Number of Challengers", size(medium) margin(medsmall)) xtitle("Election Cycle", size(medium) margin(medsmall)) xscale(range(5(1)24)) xlabel(, angle(vertical)) 
graph export "VioChall.pdf", as(pdf) replace



*Model pooling eras

*Sponsorship count

xtnbreg count lcount i.gender spread widow racdum  ComChr leadership districtmchar majorityparty dwnom1  c.Cong 
estimates store counttot

estout counttot , cells(b(star fmt(3)) se(par fmt(2))) stats(rsquared N) starlevels(+ 0.10 * 0.05) style(tex) label legend varlabels(_cons Constant)

margins gender, at(Cong=(88(1)110)) expression(predict(nu0)) 

marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea) scheme(s2mono) graphregion(color(white)) ylabel(10(10)50, labs(medium))  title("") ytitle("Total Bills Sponsored", size(medium) margin(medsmall)) xtitle("Congress", size(large) margin(medsmall))  xlabel(, angle(vertical)) legend()
graph export "CountTotal.pdf", as(pdf) replace

**DIversity 

xtreg HHI lHHI  i.gender spread widow racdum  ComChr leadership districtmchar majorityparty dwnom1  c.Cong 
estimates store HHItot
estout HHItot , cells(b(star fmt(3)) se(par fmt(2))) stats(rsquared N) starlevels(+ 0.10 * 0.05) style(tex) label legend varlabels(_cons Constant)



margins gender, at(Cong=(88(1)110)) 
marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea) scheme(s2mono) graphregion(color(white)) ylabel(1800(250)2800, labs(medium))  title("") ytitle("Agenda Diversity", size(medium) margin(medsmall)) xtitle("Congress", size(large) margin(medsmall))  xlabel(, angle(vertical)) legend()
  
graph export "DiversityTotal.pdf", as(pdf) replace


*Issue Concentration

sureg (macroeconper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong)(civilrightsper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(healthper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(agricultureper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(laborper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(educationper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(environmentper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(energyoper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(transportationper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(lawcrimefamilyper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(socialwelfareper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(communitydevelper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(bankingper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(defenseper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(spaceper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(foreigntradeper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(internationalaffairsper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(governmentopper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(publiclandsper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong )(otherper i.gender c.spread widow servicetime racdum ComChr leadership   districtmchar  i.Cong ) 

*At this point, the point estimates should be exported to a csv or excel file to make the graphic in R

** Total Challengers:
ologit totfin i.gender##c.mensissues i.gender##c.count i.gender##c.HHI i.party  spread widow racdum  ComChr leadership districtmchar  dwnom1 south c.eleccount, vce(cluster eleccount)
estimates store electot

estout electot , cells(b(star fmt(3)) se(par fmt(2))) stats(rsquared N) starlevels(+ 0.10 * 0.05) style(tex) label legend varlabels(_cons Constant)

margins, predict(outcome(4)) at(gender=(1) count=(48) eleccount=(5(1)24))
marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea)scheme(s2mono) graphregion(color(white)) xdimension(eleccount) title("") xlabel(, angle(vertical))  ylabel(0(.2).8) xtitle("Election Year") ytitle("Probabilty of 3+ Challengers", size(medium)) caption("Women +1 Standard Deviation Above Mean Total Bill Sponsorship", size(small)) 
graph export fem48.pdf, replace
margins, predict(outcome(4)) at(gender=(0) count=(22) eleccount=(5(1)24))  vce(unconditional)
marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea) scheme(s2mono) graphregion(color(white)) xdimension(eleccount) title("") xlabel(, angle(vertical))   ylabel(0(.2).8) xtitle("Election Year") ytitle("Probabilty of 3+  Challengers", size(medium)) caption("Men at Mean Level of Total Bill Sponsorship", size(small)) 
graph export men22.pdf, replace



margins, predict(outcome(1)) at(gender=(1) count=(48) eleccount=(5(1)24))vce(unconditional)
marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea)scheme(s2mono) graphregion(color(white)) xdimension(eleccount) title("") xlabel(, angle(vertical))ylabel(0(.2).8) xtitle("Election Year") ytitle("Probabilty of Unopposed Re-election") caption("Women +1 Standard Deviation Above Mean Total Bill Sponsorship",size(small))
graph export fem148.pdf, replace
margins, predict(outcome(1)) at(gender=(0) count=(22) eleccount=(5(1)24))vce(unconditional)
marginsplot, recast(line) plot1opts(lpattern(dash)) recastci(rarea)scheme(s2mono) graphregion(color(white)) xdimension(eleccount) title("") xlabel(, angle(vertical))ylabel(0(.2).8) xtitle("Election Year") ytitle("Probabilty of Unopposed Re-election") caption("Men at Mean Level of Total Bill Sponsorship", size(small)) 
graph export men122.pdf, replace

graph combine fem48.gph men22.gph fem148.gph  men122.gph









