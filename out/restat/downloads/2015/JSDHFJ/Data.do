*******************************************************************************
***
*** Code for creating the dataset from original data for the paper
***
*** SALES, QUANTITY SURCHARGE AND CONSUMER INATTENTION 
***
*** Review of Economics and Statistics
***
*******************************************************************************

clear
version 13.1
set matsize 500
set more off

***************************************************************
*** Basic manipulations - data in long (product-level) form ***
***************************************************************

use NL-pq, clear
rename week tper
rename chain1 chain
keep if chain == 1
gen int week = real(substr(tper,2,.))
drop tper herf h1 h2 c1 c3 c4
rename prod product

/* Replace 0's with missing values */

recode price* sales* (0=.) 

*** Merge in product names ***

sort product 
merge m:1 product using ProductDesc
tab _merge
drop _merge 
rename prodcode prodid

*** Merge in pack sizes ***

sort product 
merge m:1 product using PackSizes
tab _merge
drop _merge prodnamefull

*** Create numeric manucode variable ***
*** Keep big 3 manufacturers plus private label ***

label define manulbl 1 "HENKEL" 2 "P&G" 3 "UNILEVER" 4 "PRIVATE" 5 "SARA LEE" 6 "RECKITT" 7 "DALLI" 8 "AO"
encode manuname, gen(manucode) label(manulbl)
keep if manucode < 5
drop manuname manunm
label drop manulbl

order product week brand sales* price* 
sort manucode chain week prodid

******************************************************************************
******************************************************************************
******************************************************************************
*** IMPORTANT!!!                                                           ***
*** Procedure that identifies promotions                                   ***

global TOTPACKS = 8   /* Max number of packs in a product */
global WINDOW = 3     /* Length (one side) of window for defining promotion */
scalar PROMDISC = 10  /* Discount threshold to identify promotions */ 

tsset prodid week

quietly forvalues i = 1/$TOTPACKS {
	forvalues j = 1/$WINDOW {
		gen lag`j'price = L`j'.price`i'
		gen lead`j'price = F`j'.price`i'
		}
	gen byte complete = 1 - missing(price`i', lag3price, lag2price, lag1price, lead3price, lead2price, lead1price)
	egen RegPrice`i' = rmedf(lag3price lag2price lag1price lead3price lead2price lead1price) if complete
	gen PercDisc = (RegPrice`i' - price`i') / RegPrice`i' * 100
	gen byte PackProm`i' = inrange(PercDisc, PROMDISC, .) if PercDisc!=.
	gen byte ConsecProm`i' = (L.PackProm`i' * PackProm`i')   /* ConsecProm=1 if consecutive promotions flagged */
	
	gen NextWkPercDisc = (RegPrice`i' - F.price`i') / RegPrice`i' * 100
	gen byte PromSpills`i' = (PackProm`i' == 1) * inrange(NextWkPercDisc, PROMDISC, .) if NextWkPercDisc!=.   /* 1 if promotion spills into second week */
	replace PackProm`i' = 0 if L.PackProm`i' == 1            /* Second promotion period NOT flagged as promotion */
	replace PackProm`i' = 0 if price`i' > F.price`i'         /* If price in next period is lower, it is not a promotion */
	replace PackProm`i' = . if PercDisc == .
	gen PromDisc`i' = PercDisc if PackProm`i'                /* Promotion discount */

	drop lead* lag* *PercDisc complete 
	}

drop ConsecProm* PromSpills*

******************************************************************************
******************************************************************************
******************************************************************************


*** Reshape the data to long form so that an observation is a pack 
*** This will enable creation of product-level variables

compress *
sort prodid week
reshape long sales price size PackProm RegPrice PromDisc, i(week product) j(pack)
drop if missing(price,sales)
order product pack chain week price sales PackProm  
sort product pack chain week 

*** Create ID variable
gen int packid = 10 * prodid + pack 
xtset packid week
sort packid week 
gen DQ = sales / L.sales

* Label new variables
label var product  "Original alphanumeric product code"
label var prodid "Numeric product code"
label var manucode "Manufacturer code"
label var chain    "Chain code"
label var week     "Week 1-120"
label var price "Price per unit"
label var sales "Sales"
label var size "Pack size"
label var packid "Pack identification code"
label var DQ "sales divided by lagged sales"

******************************************************************************
*** Drop problematic observations 
*** (mostly observations on packs that appear infrequently)
*** identified by manual inspection

quietly do ProblemObs
drop if ToBeDropped == 1
drop ToBeDropped 

******************************************************************************
******************************************************************************
******************************************************************************


drop if missing(PackProm)


*** Calculate some variables

egen byte NumSizes = count(pack), by(chain week prodid)
tab prodid if NumSizes>2

xtset packid week
sort packid week 

egen SizeRank = rank(size), by(prodid chain week) field
replace SizeRank = . if NumSizes == 1
gen InvSizeRank = 3 - SizeRank

label define sizes 1 "Large" 2 "Small"
label values SizeRank sizes
label define invsizes 2 "Large" 1 "Small"
label values InvSizeRank invsizes
label var SizeRank "Size rank (large=1)"
label var InvSizeRank "Inverse size rank (small=1)"

******************************************************************************
*** Calculate quantity discounts, QS and size ratio 
*** (Important to first xtset and sort by WeekProdID InvSizeRank)

gen WeekProdID = 10000 * week + prodid
xtset WeekProdID InvSizeRank
sort WeekProdID InvSizeRank
gen QuantDisc1  = (L.price - price)  / L.price if NumSizes > 1
gen QS = (QuantDisc1 < 0) if QuantDisc1 != .
replace QS = F.QS if F.QS==1 | F.QS==0

gen SizeRatio = size / F.size

xtset packid week
sort packid week

******************************************************************************
******************************************************************************
******************************************************************************

*** Define promotion variables

egen TotPackProms = sum(PackProm), by(chain packid)
label var TotPackProms "Total number of promotions for pack in sample" 

egen WeekProdProms = sum(PackProm), by(chain week prodid)
label var WeekProdProms "Number of promotions for product-week, any pack"

gen AtLeastOneProm = (WeekProdProms > 0)
label var AtLeastOneProm "At least one product promotion (any pack) in week"

egen WeeksAvailable = count(week) if ~missing(PackProm), by(prodid size)
label var WeeksAvailable "Number or weeks pack on sale"

gen TimeOnProm = TotPackProms / WeeksAvailable * 100
label var TimeOnProm "Fraction of time pack on sale"

gen OtherPackProm = (WeekProdProms > PackProm) 
label var OtherPackProm "1 if other pack of this product is promoted in chain-week"

gen SimProms = WeekProdProms > 1
label var SimProms "1 if BOTH packs of this product are promoted in chain-week"

gen OwnProm = PackProm * (1-SimProms)             /* 1 if ONLY this pack is promoted */
label var OwnProm "this pack is promoted and no sim prom of other pack of same product"

gen OtherOwnProm = OtherPackProm * (1-SimProms)   /* 1 if ONLY the other pack is promoted */
label var OtherOwnProm "other pack of same product is promoted in chain-week"

gen OwnPromSolo = PackProm * (NumSizes == 1)      /* 1 when pack is promoted in the presence of no alternative */
label var OwnPromSolo "this pack is promoted and it's a single-pack product line"


******************************************************************************
******************************************************************************
******************************************************************************

*** Create QUALITY variable

sort packid week
gen premium = manucode < 4  /* Big 3 are premium */
replace premium = 0 if inlist(brand,"SUNIL","WITTE REUS") /* exceptions */
gen str8 quality = "PREMIUM" 
replace quality = "VALUE" if premium==0

sort product week pack

save FinalData, replace

******************************************************************************
*** Incorporate data on distribution                                          
******************************************************************************


use RawDistribution, clear
ren var242 itemname
gen product = ""

replace product = "N14" if regexm(itemname,"ARIEL PDR COLOR COL NV")
replace product = "N14"  if regexm(itemname,"ARIEL PDR COLOR COL NV")         
replace product = "N15"  if regexm(itemname,"ARIEL PDR ESSENTIAL NCOL NV")       
replace product = "N16"  if regexm(itemname,"ARIEL TABLET TABLETS NCOL ST")      
replace product = "N18"  if regexm(itemname,"DASH TABLET TABLETS NCOL ST")       
replace product = "N29"  if regexm(itemname,"DIXAN PDR MEGAPERLS NCOL NV")       
replace product = "N19"  if regexm(itemname,"DREFT PDR FIJNW._ULT NCOL NV")      
replace product = "N20"  if regexm(itemname,"DREFT VLB DARK NCOL ST")            
replace product = "N21"  if regexm(itemname,"DREFT VLB FIJNW._ULT NCOL NV")      
replace product = "N22"  if regexm(itemname,"DREFT VLB FIJNW._ULT NCOL ST")      
replace product = "N42"  if regexm(itemname,"E.M. PDR HOOFDWAS COL NV")          
replace product = "N43"  if regexm(itemname,"E.M. PDR HOOFDWAS NCOL NV")         
replace product = "N44"  if regexm(itemname,"E.M. VLB FIJNWAS NCOL ST")          
replace product = "N37"  if regexm(itemname,"FLEURIL PDR COL.MAGIC NCOL ST")     
replace product = "N38"  if regexm(itemname,"FLEURIL VLB BL.MAGIC NCOL ST")      
replace product = "N39"  if regexm(itemname,"FLEURIL VLB COL.MAGIC NCOL ST")     
replace product = "N1"   if regexm(itemname,"OMO PDR COLOR COL NV")               
replace product = "N2"   if regexm(itemname,"OMO PDR HOOFDWAS NCOL NV")           
replace product = "N4"   if regexm(itemname,"OMO TABLET TABLETS NCOL ST")         
replace product = "N5"   if regexm(itemname,"OMO VLB VLB COL ST")                 
replace product = "N23"  if regexm(itemname,"PERSIL PDR MEGAPERLS COL NV")       
replace product = "N24"  if regexm(itemname,"PERSIL PDR MEGAPERLS NCOL NV")      
replace product = "N25"  if regexm(itemname,"PERSIL TABLET TABS COL ST")         
replace product = "N27"  if regexm(itemname,"PERSIL VLB COLOR COL ST")           
replace product = "N28"  if regexm(itemname,"PERSIL VLB NATURAL NCOL ST")        
replace product = "N10"  if regexm(itemname,"ROBIJN PDR COLOR NCOL NV")          
replace product = "N11"  if regexm(itemname,"ROBIJN PDR F&F NCOL ST")            
replace product = "N12"  if regexm(itemname,"ROBIJN VLB BL.VELVET NCOL ST")      
replace product = "N13"  if regexm(itemname,"ROBIJN VLB COLOR NCOL ST")          
replace product = "N6"   if regexm(itemname,"SUNIL PDR COLOR COL NV")             
replace product = "N7"   if regexm(itemname,"SUNIL PDR HOOFDWAS NCOL NV")         
replace product = "N8"   if regexm(itemname,"SUNIL TABLET TABLETS COL ST")        
replace product = "N9"   if regexm(itemname,"SUNIL TABLET TABLETS NCOL ST")       
replace product = "N30"  if regexm(itemname,"WIT.COL.REUS PDR COLOR COL NV")     
replace product = "N31"  if regexm(itemname,"WIT.COL.REUS PDR COLOR COL ST")     
replace product = "N32"  if regexm(itemname,"WIT.COL.REUS PDR WIT_COMP. NCOL NV")
replace product = "N33"  if regexm(itemname,"WIT.COL.REUS PDR WIT_COMP. NCOL ST")
replace product = "N34"  if regexm(itemname,"WIT.COL.REUS TABLET TABS NCOL ST")  
replace product = "N35"  if regexm(itemname,"WIT.COL.REUS VLB COLOR COL ST")     
replace product = "N36"  if regexm(itemname,"WIT.COL.REUS VLB WIT_COMP. NCOL ST")
replace product = "N17"  if regexm(itemname,"ARIEL VLB HYDRACTIVE NCOL ST")      
replace product = "N40"  if regexm(itemname,"DATO PDR COMPACT NCOL ST")          
replace product = "N3"   if regexm(itemname,"OMO TABLET TABLETS COL ST")          
replace product = "N26"  if regexm(itemname,"PERSIL TABLET TABS NCOL ST")        

drop if product == ""
gen size = real(word(itemname,-1))

duplicates tag itemname, gen(dups)
drop if dups > 0
drop dups

renpfix nd0 nd
renpfix wd0 wd
reshape long nd wd, i(itemname) j(yrwk)

label var nd "Simple % coverage"
label var wd "Sales-weighted coverage"

sort yrwk
save temp, replace

keep yrwk
duplicates drop
sort yrwk
egen week = seq()
merge 1:m yrwk using temp
drop _merge
erase temp.dta

recode size .= 9999 /* 9999 denotes observation containing product distribution */

egen meannd = mean(nd), by(product size)
drop if meannd == 0 
egen meanwd = mean(wd), by(product size)
drop if meanwd == 0 
*egen SizeRank = rank(size), by(product week)
*table product SizeRank, c(m nd)


egen prodnd = max(nd), by(product week)
egen prodwd = max(wd), by(product week)
gen frac_prodnd = nd / prodnd
gen frac_prodwd = wd / prodwd
egen minwd = min(wd), by(product week)
egen minnd = min(nd), by(product week)
label var prodnd "Numeric distribution of the PRODUCT"
label var prodwd "Weighted distribution of the PRODUCT"
label var frac_prodnd "Fraction of stores item is in if product is in"
label var frac_prodwd "Weighted fraction of stores item is in if product is in"
label var minnd "Minimum numeric distribution for items of given product"
label var minwd "Minimum weighted distribution for items of given product"

save Distribution, replace

use Distribution, clear
merge 1:1 product size week using FinalData, keepusing(SizeRank sales)
drop _merge
drop if missing(sales) & size~=9999 	/* drop products that are not in the dsitribution dataset but not in the main dataset */

su *nd*

keep product week size SizeRank nd wd
replace SizeRank = 0 if size==9999
recode SizeRank .=1
drop size
reshape wide nd wd, i(product week) j(SizeRank)
rename nd0 nd_sorl
rename nd1 nd_l
rename nd2 nd_s
rename wd0 wd_sorl
rename wd1 wd_l
rename wd2 wd_s
merge 1:m product week using FinalData
keep if _merge == 3
drop _merge

table product SizeRank, c(m wd_s m wd_l)


gen lam_scondonl = 1 - (nd_sorl - nd_s) / nd_l


xtset packid week
sort packid week


keep week product prodid pack packid manucode premium quality size price sales PackProm QS PromDisc NumSizes DQ SizeRank InvSizeRank TotPackProms TimeOnProm AtLeastOneProm WeekProdProms SizeRatio lam_scondonl 

save FinalData, replace

