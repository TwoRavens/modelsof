* SURVEY EXPERIMENT 
* Replication code for: "Pass the Buck If You Can: How Partisan Competition Triggers Attribution Bias in Multilevel Democracies"



* Dataset
use experiment_data.dta


* Data preparation

// Respondents from the Canary Islands and Navarre are excluded from the analysis (see main text)

** Original variables
// treat: treatment (0=Negative, 1=Control, 2=Positive)
// resp_reg: regional government attribution (0-10)
// resp_nat: national government attribution (0-10)
// proxpp: proximity to PP (1=Very close, 5=Very distant)
// proxpsoe: proximity to PSOE (1=Very close, 5=Very distant)
// proxciu: proximity to CiU (1=Very close, 5=Very distant)
// proxpnv: proximity to PNV (1=Very close, 5=Very distant)
// placeid: territorial identity (1=Only Spanish, 5=Only region)
// ccaa: region

** New variables
// compresp: net regional attribution (-10 to 10)
// proxinc: proximity to regional incumbent (recoded to 0=Very distant, 1=Very close)
// d_proxinc: binary version of proximity to regional incumbent
// d_placeid: binary version of territorial identity
// regincumb: in-/out-party regional incumbent
// natrinc: nationalist/non-nationalist regional incumbent 

drop if ccaa==5 | ccaa==15

gen compresp=resp_reg-resp_nat

recode proxpp proxpsoe proxciu proxpnv (1=1)(2=.75)(3=.5)(4=.25)(5=0)
gen proxinc=proxpp
replace proxinc=proxpsoe if ccaa==1 | ccaa==3 | ccaa==5
replace proxinc=proxciu if ccaa==9
replace proxinc=proxpnv if ccaa==16

recode proxinc (0/.24=0 "Distant")(.25/1=1 "Close"), gen(d_proxinc) 

replace placeid=(placeid-1)/4

recode placeid (0/.49=0 "More Spanish")(.5/1=1 "More/equally region"), gen(d_placeid)

recode ccaa (1 3 9 16=1 "Out-party")(*=0 "In-party"), gen(regincumb)

recode ccaa (9 16=1 "Nationalist")(*=0 "Non-nationalist"), gen(natrinc)


* Table 2
reg compresp b1.treat##c.proxinc##regincumb


* Table 3
reg compresp b1.treat##c.placeid##natrinc


* Figure 1
qui reg compresp b1.treat##c.proxinc##regincumb
margins treat, at(proxinc=(0 1) regincumb=(0 1))
marginsplot, by(regincumb) x(treat) ytitle("Net regional attribution") xtitle("Condition") ///
 plot(proxinc, lab("Very distant" "Very close")) xscale(range(-.1 2.1)) ylabel(-3(1)3) byopt(title("") imargin(medium) legend(on)) ///
 legend(subtitle("Proximity to regional incumbent", size(small)) size(small))


* Figure 2
qui reg compresp b1.treat##c.placeid##natrinc
margins treat, at(placeid=(0 1) natrinc=(0 1))
marginsplot, by(natrinc) x(treat) ytitle("Net regional attribution") xtitle("Condition") ylabel(-5(2.5)5) ///
 plot(placeid, lab("Only Spanish" "Only region")) xscale(range(-.1 2.1)) byopt(title("") imargin(medium) legend(on)) ///
 legend(subtitle("Territorial identity", size(small)) size(small))


* Table A1
reg compresp b1.treat##c.proxpp##regincumb


* Figure A1
qui reg compresp b1.treat##c.proxpp##regincumb
margins treat, at(proxpp=(0 1) regincumb=(0 1))
marginsplot, by(regincumb) x(treat) ytitle("Net regional attribution") xtitle("Condition") ///
 plot(proxpp, lab("Very distant" "Very close")) xscale(range(-.1 2.1)) byopt(title("") imargin(medium) legend(on)) ///
 legend(subtitle("Proximity to national incumbent", size(small)) size(small))


* Table B1
reg compresp b1.treat##d_proxinc##regincumb 


* Table B2
reg compresp b1.treat##d_placeid##natrinc


* Figure B1
qui reg compresp b1.treat##d_proxinc##regincumb 
margins treat, at(d_proxinc=(0 1) regincumb=(0 1))
marginsplot, by(regincumb) x(treat) ytitle("Net regional attribution") xtitle("Condition") ///
 plot(d_proxinc, lab("Distant" "Close")) xscale(range(-.1 2.1)) ylabel(-3(1)3) byopt(title("") imargin(medium) legend(on)) ///
 legend(subtitle("Proximity to regional incumbent", size(small)) size(small))


* Figure B2
qui reg compresp b1.treat##d_placeid##natrinc
margins treat, at(d_placeid=(0 1) natrinc=(0 1))
marginsplot, by(natrinc) x(treat) ytitle("Net regional attribution") xtitle("Condition") ///
 plot(d_placeid, lab("More Spanish" "More/equally region")) xscale(range(-.1 2.1)) byopt(title("") imargin(medium) legend(on)) ///
 legend(subtitle("Territorial identity", size(small)) size(small))





