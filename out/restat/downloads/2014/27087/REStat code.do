

**************************************************************
* This file describes the data and code used in Manova, Wei and Zhang "Firm Exports and Multinational Activity under Credit Constraints"
* The paper has been accepted for publication in the Review of Economics and Statistics
**************************************************************


* data construction: Chinese firm exports, # products & # dest by sector 
**********************************************************************

* The raw Chinese customs data reports exports by firm, HS 8-digit product and destination in 2005, which we collapse to the firm level
* Variable definition:
* fcode: firm identifier
* ftype: firm ownership type
* pcode: product identifier
* dest: destination country identifier
* SumValue: firm exports by product and destination in raw data

use "Chinese_customs_data.dta", clear

* proxy for firm size
egen size=sum(SumValue), by(fcode)
g lsize=ln(size)
la var lsize "proxy for firm size, = log total firm exports"

* aggregating from HS 8-digit products to 36 ISIC sectors, using concordance file from Jon Haveman's webpage
g pcode6=int(pcode/100)
sort pcode6
merge pcode6 using "hs2002_isic2_concordance.dta", keep(isic4)
drop if _m==2
drop _m
g isic36=int(isic4/10)
replace isic36=isic4 if isic4==3211 | isic4==3411 | isic4==3511 | isic4==3513 | isic4==3522 | isic4==3825 | isic4==3832 | isic4==3841 | isic4==3843
* this defines ISIC sectors in same classification as the one used for sector measures of financial vulnerability

preserve
collapse (mean) lsize (sum) SumValue (count) pcode, by(fcode ftype isic36)
rename pcode n_pcode_dest
sort fcode ftype isic36
compress
save "firm_level.dta"

restore, preserve
keep fcode pcode ftype isic36
duplicates drop
collapse (count) pcode, by(fcode ftype isic36)
rename pcode n_pcode
sort fcode ftype isic36
compress
merge fcode ftype isic36 using "firm_level.dta"
drop _m
sort fcode ftype isic36
save "firm_level.dta", replace

restore
keep fcode dest ftype isic36
duplicates drop
collapse (count) dest, by(fcode ftype isic36)
rename dest n_dest
sort fcode ftype isic36
compress
merge fcode ftype isic36 using "firm_level.dta"
drop _m
sort fcode ftype isic36
save "firm_level.dta", replace

order fcode ftype isic36 SumValue n_dest n_pcode n_pcode_dest
la var SumValue "exports by firm-isic36"
la var n_dest "# destinations by firm-isic36"
la var n_pcode "# products by firm-isic36"
la var n_pcode_dest "# destination-product markets by firm-isic36"
save "firm_level.dta", replace


* data construction: firm size and ownership dummies
**********************************************************************

* construct dummies for private domestic firms, joint ventures, and fully foreign-owned multinational affiliates
* the correspondence between ftype and these ownership categories may vary across different providers of the Chinese customs data
g state=(ftype==5)
g private=(ftype==7 | ftype==8 | ftype==4)
g joint=(ftype==2 | ftype==3)
g foreign=(ftype==6)
g anyforeign=(ftype==2 | ftype==3 | ftype==6)
drop if state==1
la var private "=1 if private domestic"
la var joint "=1 if joint venture"
la var foreign "=1 if fully foreign owned"
la var anyforeign "=1 if partially or fully foreign owned"


* data construction: merging in sector variables
**********************************************************************

* financial vulnerability by sector, from Kroszner-Laeven-Klingebiel (2007) and Fisman-Love (2003)
sort isic36
merge isic36 using "fin_vuln_measures.dta", keep(ext_dep_80_99 liq_1980_99 rd_intensity tangibility trcredit_flow pc)
keep if _m==3
drop _m

la var ext_dep_80_99 "external finance dependence"
la var liq_1980_99 "inventory to sales ratio"
la var rd_intensity "R&D intensity"
la var tangibility "asset tangibility"
la var trcredit_flow "trade credit intensity"
la var pc "first principal component of external finance dependence and asset tangibility"

* factor intensity by sector from Braun (2003)
g isic=isic36
replace isic=int(isic36/10) if isic36==3211 | isic36==3411 | isic36==3522 | isic36==3825 | isic36==3832 | isic36==3841 | isic36==3843
sort isic
merge isic using "industry controls.dta", keep(Kint Hint)
drop if _m==2
drop _m
la var Kint "physical capital intensity"
la var Hint "human capital intensity"

* contract intensity by sector from Nunn (2007)
g isic3=isic
replace isic3=351 if isic3==3511 | isic3==3512 | isic3==3513
sort isic3
merge isic3 using "Nunn_data.dta", keep(frac_lib_not_homog)
drop if _m==2
drop _m
la var frac_lib_not_homog "contract intensity"

* interaction variables
foreach x in joint foreign anyforeign lsize {
	g `x'_pc=`x'*pc
	g `x'_findep=`x'*ext_dep_80_99
	g `x'_rd=`x'*rd_intensity
	g `x'_liq=`x'*liq_1980_99
	g `x'_tang=`x'*tangibility
	g `x'_trcredit=`x'*trcredit_flow
	g `x'_kint=`x'*Kint
	g `x'_hint=`x'*Hint
	g `x'_nunn=`x'*frac_lib_not_homog
	}


**********************************************************************
* Table 2
**********************************************************************

* constructing log outcome variables
foreach x in SumValue n_dest n_pcode n_pcode_dest {
	g l`x'=ln(`x')
	}
rename lSumValue lvalue

xi i.isic36
local controls="_Iisic36_313-_Iisic36_3843"
local cluster="cluster(isic36)"
*local cluster="cluster(fcode)"

areg lvalue anyforeign_pc lsize_pc `controls', `cluster' absorb(fcode)
foreach x in lvalue {
	foreach y in pc findep liq tang trcredit {
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		test joint_`y'=foreign_`y'
		}
	}


**********************************************************************
* Online Appendix Table 2
**********************************************************************

local controls2="joint_kint foreign_kint lsize_kint joint_hint foreign_hint lsize_hint _Iisic36_313-_Iisic36_3843"
local controls3="joint_rd foreign_rd lsize_rd _Iisic36_313-_Iisic36_3843"
local controls4="joint_nunn foreign_nunn lsize_nunn _Iisic36_313-_Iisic36_3843"

foreach x in lvalue {
	foreach y in pc {
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		areg `x' joint_`y' foreign_`y' `controls', `cluster' absorb(fcode)
		reg `x' joint foreign joint_`y' foreign_`y' `controls', `cluster'
		areg `x' joint_`y' foreign_`y' state_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls2', `cluster' absorb(fcode)
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls3', `cluster' absorb(fcode)
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls4', `cluster' absorb(fcode)
		}
	}


**********************************************************************
* Table 3: extensive margin (firm # products and destinations by sector)
**********************************************************************

foreach x in ln_dest ln_pcode ln_pcode_dest {
	foreach y in pc {
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		}
	}


**********************************************************
* Table 3: extensive and intensive margin (firm exports & # products by sector and destination)
**********************************************************

* data construction: Chinese firm exports and # products by sector and destination (i.e. bilateral)
**********************************************************************

use "Chinese_customs_data.dta", clear
egen size=sum(SumValue), by(fcode)
g lsize=ln(size)
la var lsize "proxy for firm size, = log total firm exports"

* aggregating from HS 8-digit products to 36 ISIC sectors, using concordance file from Jon Haveman's webpage
g pcode6=int(pcode/100)
sort pcode6
merge pcode6 using "hs2002_isic2_concordance.dta", keep(isic4)
drop if _m==2
drop _m
g isic36=int(isic4/10)
replace isic36=isic4 if isic4==3211 | isic4==3411 | isic4==3511 | isic4==3513 | isic4==3522 | isic4==3825 | isic4==3832 | isic4==3841 | isic4==3843
collapse (sum) SumValue (count) pcode (mean) lsize, by(fcode ftype isic36 dest)
g lvalue=log(SumValue)
g lnproducts=log(pcode)
la var SumValue "exports by firm-isic36-destination"
la var pcode "# products by firm-isic36-destination"

* merge with industry measures, generate ownership & interactions as above

xi i.isic36 i.dest
local controls="_Idest_2-_Idest_968 _Iisic36_313-_Iisic36_3843"
local cluster="cluster(isic36)"

foreach x in lvalue lnproducts {
	foreach y in pc {
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		}
	}


******************************************************
* Table 4
******************************************************

* bilateral distance to destination from CEPII
* cost of exporting to destination from World bank Doing Business Report
sort dest
merge dest using "cepii_distances.dta", keep (ldist)
drop if _m==2
drop _m
sort dest
merge dest using "worldbank_data.dta", keep (doci daysi costi)
drop if _m==2
drop _m
la var ldist "distance from China to export destination"
la var doci "# documents required to export to destination"
la var daysi "# days required to export to destination"
la var costi "cost per shipping container required to export to destination"

* constructing interactions

foreach x in doci daysi costi {
	g l`x'=log(`x')
	}
foreach x in ldist ldoci ldaysi lcosti {
	g `x'_pc=`x'*pc
	foreach y in joint foreign lsize {
		g `y'_`x'_pc=`y'*`x'*pc
		}
	}

foreach x in ldist ldoci ldaysi lcosti {
	foreach y in pc {
		areg lvalue `x'_`y' joint_`x'_`y' foreign_`x'_`y' lsize_`x'_`y' `controls', `cluster' absorb(fcode)
		}
	}


**********************************************************
* Table 3: intensive margin (firm exports by product and destination)
**********************************************************

use "Chinese_customs_data.dta", clear
egen size=sum(SumValue), by(fcode)
g lsize=ln(size)
g lvalue=log(SumValue)
la var lsize "proxy for firm size, = log total firm exports"
la var SumValue "exports by firm-product-destination"

g pcode6=int(pcode/100)
sort pcode6
merge pcode6 using "hs2002_isic2_concordance.dta", keep(isic4)
drop if _m==2
drop _m
g isic36=int(isic4/10)
replace isic36=isic4 if isic4==3211 | isic4==3411 | isic4==3511 | isic4==3513 | isic4==3522 | isic4==3825 | isic4==3832 | isic4==3841 | isic4==3843

* merge with industry measures, generate ownership & interactions as above

xi i.isic36 i.dest
local controls="_Idest_2-_Idest_968 _Iisic36_313-_Iisic36_3843"
local cluster="cluster(isic36)"

foreach x in lvalue {
	foreach y in pc {
		areg `x' joint_`y' foreign_`y' lsize_`y' `controls', `cluster' absorb(fcode)
		}
	}


******************************************************
* Table 1
******************************************************

use "Chinese_customs_data.dta", clear
replace SumValue=SumValue/1000000000

* merge with industry measures and generate ownership as above

preserve
collapse (sum) SumValue, by(state private joint foreign)
egen total=sum(SumValue)
g share=SumValue/total
list
restore

* A_high=1 for sectors with A above median

foreach x in ext_dep_80_99 liq_1980_99 tangibility trcredit_flow {
	preserve
	collapse (sum) SumValue, by(`x'_high state private joint foreign)
	egen total=sum(SumValue), by(`x'_high)
	g share=SumValue/total
	list
	restore
	}
	
