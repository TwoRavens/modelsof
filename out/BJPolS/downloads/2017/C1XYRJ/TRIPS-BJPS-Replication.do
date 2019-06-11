cd "C:\Users\dtingley\Dropbox\TingleyMildenberger\ContactCongress\Data\BJPSReplication\scripts"
use "../data/TRIPS-Replication-BJPS.dta", replace

summ USComply
local mn=100*r(mean)
di `mn'
local mn2=64
ciplot USNumberComply, note("") subtitle("US Will Comply with Treaty") ytitle("") xtitle("Estimate % America Agrees")  horiz xsc(range(35(5)65)) xline(`mn' )  xline(`mn2', lpattern( dash)) by(USComply) saving(USUSComply.gph, replace)
summ ChinaComply
local mn=100*r(mean)
local mn2=47
ciplot ChinaNumberComply, note("")  subtitle("China Will Comply with Treaty")  ytitle("") xtitle("Estimate % America Agrees") horiz xline(`mn' )  xline(`mn2', lpattern( dash)) by(ChinaComply)  saving(ChinaChinaComply.gph, replace)
graph combine  USUSComply.gph ChinaChinaComply.gph, title("IR Scholars on Climate Accord Compliance") xcomm note("Respondent's own position on vertical axis." "Solid vertical line represents % IR scholars believing that country will comply." "Dashed line represents % of Americans agreeing country will comply.")
*graph export ComplyTRIPS.pdf, replace
