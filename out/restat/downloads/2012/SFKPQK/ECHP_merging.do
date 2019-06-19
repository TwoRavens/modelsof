*******************************************************************************
****** Do file for merging ECHP Personal, household & link files***************
*******************************************************************************

clear
set mem 900m 
set more off 

*************************************************************
***** Merging personal and household files ******************
*************************************************************

* Tranfer personal and household csv-files to dta-format and prepare to merge
forvalues x = 1(1)8 {
	insheet using "c:\data\a_w`x'p.csv", clear
		gen double pidcw=pid + country/100 + wave/1000 
		gen double hidcw=hid + country/100 + wave/1000 
		sort pidcw 
		keep wave country hid pid pg001 pg002 pg003 pg004 pg005 pg006 pg007 pg008 pd001 pd002 /*
		*/ pd003 pd004 pd005 pd006 pd007 pd008 pe001 pe001a pe002 pe002a pe003 pe004 pe005 pe005a /*
		*/ pe005b pe005c pe006a pe006b pe006c pe007a pe007b pe007c pe008 pe009 pe010 pe011 pe012 /*
		*/ pe014 pe015 pe021 pe024 pe025 pe026 pe027 pe038 pe039 pu001 pu002 pu002a pu003 pu003a /*
		*/ pu004 pu004a pi001 pi100 pi110 pi111 pi1111 pi1112 pi112 pi120 pi121 pi122a pi123 pi130 /*
		*/ pi131 pi132 pi1321 pi1322 pi133 pi134 pi135 pi136 pi137a pi138a pi211m pi211mg pt022 pt023 /*
		*/ pt024 ph001 ph002 ph003 ph003a ph004 ph005 ph006 ph007 ph008 ph009 ph010 ph012  ph013 /*
		*/ ph014 ph015 ph016 ph017 ph018 ph019 ph020 ph021 ph022 pr006 pr008 pr008a pr010 /*
		*/ pidcw hidcw
	save "c:\data\a_w`x'p.dta", replace
	insheet using "c:\data\a_w`x'h.csv", clear
		gen double hidcw=hid + country/100 + wave/1000 
		sort hidcw 
		keep wave country hid hg001 hg002 hg003 hg004 hg005 hg006 hg007 hg010 hg011 hg012 hg013 /*
		*/ hg014 hg015 hg016 hg017 hd001 hd002 hd002a hd003 hd004 hd005 hd006 hd006a hd006b hi001 /*
		*/ hi020 hi100 hi100x hi110 hi111 hi111x hi1111 hi1112 hi112 hi112x hi120 hi121 hi121x hi122 /*
		*/ hi122x hi122g hi123 hi123x hi130 hi131 hi131x hi132 hi132x hi133 hi133x hi134 hi134x hi135 /*
		*/ hi135x hi136 hi136x hi137 hi137x hi138 hi138x hi140 hi200 hi211m hi211x hi211mg hi211xg /*
		*/ hf002 hf013 hf014 hf015 hf021 ha005 ha007 ha023 hb001 hb001a hb002 hb003 hb004 hb005 hb006 /*
		*/ hb007 hb008 hl001 hl002 hl003 hl004 hl005 hidcw	
	save "c:\data\a_w`x'h.dta", replace
} 

* Merge personal files
copy "c:\data\a_w1p.dta" "c:\data\masterfilep.dta", replace 
use "c:\data\masterfilep.dta", clear 
forvalues x = 2(1)8 {
	append using "c:\data\a_w`x'p.dta" 
}
sort hidcw 
save "c:\data\masterfilep.dta", replace 


* Merge household files
copy "c:\data\a_w1h.dta" "c:\data\masterfileh.dta", replace
use "c:\data\masterfileh.dta", clear 
forvalues x = 2(1)8 {
	append using "c:\data\a_w`x'h.dta"
}
sort hidcw 
save "c:\data\masterfileh.dta", replace 


* Merge merged personal and household files
use "c:\data\masterfilep.dta", clear 
	joinby hidcw using "c:\data\masterfileh.dta", unmatched(both) update
	drop _merge
	recode country (51=16) (55=17) (57=18), gen(countries)
	sort pidcw
save "c:\data\masterfile.dta", replace


*************************************************************
****************** Merging link file ******************************
*************************************************************

* Transform link csv-file into long coded dta-format and prepare to merge
insheet using "c:\data\a_ulink.csv", clear
save "c:\data\a_ulink.dta", replace
use "c:\data\a_ulink.dta", clear
compress
	gen double pidc = pid + country/100
	sort pidc
	keep country sampers firstint hstatus* hresid* hregion* htrace* hfnres* hsize* hmout* hmin* /*
	*/ hborn* hdied* presid* ptemp* plastw* pio_yy* pio_mm* ptrace* pwstat* psamsta* pelig* /* 
	*/ pintid* pfnres* pidc
	reshape long hstatus@ hresid@ hregion@ htrace@ hfnres@ hsize@ hmout@ hmin@ hborn@ hdied@ presid@ /*
	*/ ptemp@ plastw@ pio_yy@ pio_mm@ ptrace@ pwstat@ psamsta@ pelig@ pintid@ pfnres@, i(pidc) /* 
	*/ j(wave 1 2 3 4 5 6 7 8) 
	gen double pidcw = pidc + wave/1000
	recode country (51=16) (55=17) (57=18), gen(countries)
	sort pidcw
save "c:\data\masterfilel.dta", replace



* Merge link file with masterfile (Sweden has no link file)
forvalues c = 1(1)18 {
	cap use if countries ==`c' using "c:\data\masterfilel.dta"
	cap save "c:\data\masterfilel`c'.dta", replace
	use if countries==`c' using "c:\data\masterfile.dta", clear
		cap joinby pidcw using "c:\data\masterfilel`c'.dta", unmatched(both) update
		cap drop _merge
		sort pidcw
	save "c:\data\masterfile`c'.dta", replace
}

*************************************************************
****************** Merging Register File *************************
*************************************************************
* Transform register csv-files into dta-format
forvalues x = 1(1)8 {
	insheet using "c:\data\a_w`x'r.csv", clear
		gen double pidcw=pid + country/100 + wave/1000 
		gen double hidcw=hid + country/100 + wave/1000 
		sort pidcw 
		keep wave country hid pid hidcw pidcw rd003 
	save "c:\data\a_w`x'r.dta", replace
} 

* Merge register files
copy "c:\data\a_w1r.dta" "c:\data\masterfiler.dta", replace 
use "c:\data\masterfiler.dta", clear 
forvalues x = 2(1)8 {
	append using "c:\data\a_w`x'r.dta" 
}
sort pidcw 
save "c:\data\masterfiler.dta", replace 


* Create variables for number of children
use "c:\data\masterfiler.dta", clear
	sort hidcw	
	gen nch04_ = 0 
	recode nch04_ 0 = 1 if rd003>=0 & rd003 <= 4
	gen nch511_ = 0
	recode nch511_ 0 = 1 if rd003>=5 & rd003 <= 11
	gen nch1218_ = 0
	recode nch1218_ 0 = 1 if rd003>=12 & rd003<=18
	by hidcw: egen nch04 = sum(nch04_)
	by hidcw: egen nch511 = sum(nch511_)
	by hidcw: egen nch1218 = sum(nch1218_)
	recode country (51=16) (55=17) (57=18), gen(countries)
	drop nch04_ nch511_ nch1218_
sort pidcw
save "c:\data\masterfiler.dta", replace


* Merge register files with personal and household files
***** changed into joinby on pidcw instead of hidcw  ********
forvalues c = 1(1)18 {
	use if countries ==`c' using "c:\data\masterfiler.dta"
	save "c:\data\masterfiler`c'.dta", replace
	use "c:\data\masterfile`c'.dta", clear 
		joinby pidcw using "c:\data\masterfiler`c'.dta", unmatched(both) update
		drop _merge
		sort pidcw
	save "c:\data\masterfile`c'.dta", replace
}

*************************************************************
******************* appending files ****************************
*************************************************************
use "c:\data\masterfile1.dta", clear
forvalues c = 2(1)9 {
	append using c:\data\masterfile`c'
}
sort pidcw
save "c:\data\masterfile1_9.dta", replace

use "c:\data\masterfile10.dta", clear
forvalues c = 11(1)18 {
	append using c:\data\masterfile`c'
}
sort pidcw
save "c:\data\masterfile10_57.dta", replace