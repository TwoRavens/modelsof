
// Fig 1: Mortgage Bankers Association data

cd [DIRECTORY] // set your working directory

set haverdir "K:\DLX\DATA\", permanently // wherever your Haver data is saved.

// Import data from Haver:
import haver mbamr@surveyw mba30y@surveyw, clear // refi index and MBA 30yFRM "effective rate"
// timing: "time" is the Friday of the week it applies to
g dow=dow(time)
tab dow
drop dow
  
sort time

g datem = mofd(time)
format datem %tm

collapse  mbamr_surveyw mba30y_surveyw, by(datem)
 
tsset datem

cap drop frm_ma
cap drop frm_min_ma
tssmooth ma frm_ma = mba30y_surveyw, window(60 0 0)
g frm_min_ma = mba30y_surveyw - frm_ma

keep if datem>=m(2000m1) & datem<=m(2012m12)

format datem %tmMonYY
 line mbamr_surveyw  datem   || line frm_min_ma datem , yaxis(2) lpattern(dash) tline(2008m11) xtitle("") xlabel(#14, angle(45)) ///
 ytitle("MBA Refi Application Index", axis(1)) ytitle("FRM rate relative to 5-yr moving average", axis(2)) legend(order(1 "MBA Refi Application Index (left scale)" 2 "FRM rate relative to 5-year moving average (right scale)") r(2) rowg(0.7))

pwcorr mbamr_surveyw frm_min_ma 
