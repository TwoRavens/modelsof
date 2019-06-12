/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

AUTHOR: David Chan

PURPOSE: Generate SOR data and price predictions based on SOR data

INPUTS:
- Raw SOR data saved as `file'-ALL.xlsx
- rucdate_mtg_xwalk.dta

OUTPUTS:
- sor_predictions.dta
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Programs *****************************************************************************
capture program drop label_missing
program label_missing
syntax , tokens(string) [miss_name(string) miss_pos(string)]
qui {
	if "`miss_name'"=="" local miss_name miss_name
	if "`miss_pos'"=="" local miss_pos miss_pos
	capture drop miss_name
	capture drop miss_pos
	gen miss_name=""
	gen miss_pos=""
	tokenize `tokens'
	foreach val1 in 0 1 {
		local miss_name1 `val1'
		local miss_cond1 missing(`1')==`val1'
		foreach val2 in 0 1 {
			local miss_name2 `miss_name1'`val2'
			local miss_cond2 `miss_cond1'&missing(`2')==`val2'
			foreach val3 in 0 1 {
				local miss_name3 `miss_name2'`val3'
				local miss_cond3 `miss_cond2'&missing(`3')==`val3'
				foreach val4 in 0 1 {
					local miss_name4 `miss_name3'`val4'
					local miss_cond4 `miss_cond3'&missing(`4')==`val4'
					foreach val5 in 0 1 {
						local miss_name `miss_name4'`val5'
						local miss_cond `miss_cond4'&missing(`5')==`val5'
						disp as text "`miss_name': `miss_cond'"
						replace miss_name="`miss_name'" if `miss_cond'
					}
				}
			}
		}
	}
	foreach num of numlist 1/5 {
		replace miss_pos=miss_pos+"`num'" if substr(miss_name,`num',1)=="1"
	}
}
end

capture program drop label_combo
program label_combo
syntax if, combo(string) tokens(string) [disponly comboname(string)]
qui {
	tokenize `tokens'
	if "`comboname'"=="" local comboname comboname
	local combonameval
	local combocond
	foreach num of numlist `combo' {
		local combonameval `combonameval'`num'
		if strlen("`combonameval'")>=2 {
			if "`combocond'"=="" local combocond ``lastnum''<``num''
			else local combocond `combocond'&``lastnum''<``num''
		}
		local lastnum `num'
	}
	noi disp as text "`combonameval': `combocond'"	
	if "`disponly'"=="" {
		if "`combocond'"!="" local if `if'&`combocond'
		replace `comboname'="`combonameval'" `if'
	}
}
end

capture program drop label_combo_loop
program label_combo_loop
syntax, tokens(string) [miss_pos(string) comboname(string) disponly]
qui {
	if "`comboname'"=="" local comboname comboname
	if "`miss_pos'"=="" local miss_pos miss_pos
	local cmdline tokens(`tokens') comboname(`comboname') `disponly'
	capture drop `comboname'
	gen `comboname'=""
	levelsof `miss_pos', local(levels)
	foreach l in `levels' `""' {
		local missing 
		foreach num of numlist 1/`=strlen("`l'")' {
			local missing `missing' `=substr("`l'",`num',1)'
		}
		local nums 1 2 3 4 5
		local ingroup : list nums - missing
		local size_in : list sizeof ingroup
		if `size_in'>0 foreach num1 of numlist `ingroup' {
			local combo1 `num1'
			local comp : list ingroup - combo1
			if !regexm("`missing'","`num1'")&`size_in'>=2 ///
			foreach num2 of numlist `comp' {
				local combo2 `combo1' `num2'
				local comp : list ingroup - combo2
				if !regexm("`missing'","`num2'")&`size_in'>=3 ///
				foreach num3 of numlist `comp' {
					local combo3 `combo2' `num3'
					local comp : list ingroup - combo3
					if !regexm("`missing'","`num3'")&`size_in'>=4 ///
					foreach num4 of numlist `comp' {
						local combo4 `combo3' `num4'
						local num5 : list ingroup - combo4
						if !regexm("`missing'","`num4'")&`size_in'==5 ///
							label_combo if `miss_pos'=="`l'", ///
								combo(`combo4' `num5') `cmdline'
						else label_combo if `miss_pos'=="`l'", ///
							combo(`combo4') `cmdline'
					}
					else label_combo if `miss_pos'=="`l'", ///
						combo(`combo3') `cmdline'
				}
				else label_combo if `miss_pos'=="`l'", combo(`combo2') `cmdline'
			}
			else label_combo if `miss_pos'=="`l'", combo(`combo1') `cmdline'
		}
	}
}
end


*** Join SOR data ************************************************************************
*Import excel files from the directory
local files 2006 2007 2008fiveyrv 2009 2010 2011 2012fiveyrv 2013 2014 2015
clear
tempfile append_file
qui	foreach file in `files' {
	import excel using "data/raw/SOR/`file'-ALL.xlsx", clear firstrow allstring		
	capture append using `append_file'
	save `append_file', replace
}
rename code cpt_code
replace rucdate = subinstr(rucdate, "-", "", .)
drop if code == "code" | missing(rucdate)
duplicates drop

replace num_times1yr="22,500" if num_times1yr=="20,000-25,000"
replace mpcrvu_key2=".45" if mpcrvu_key2=="..45"
replace rvw=".14" if rvw=="0..14"

// Change to numeric
qui foreach var of varlist * {
	if !inlist("`var'","cpt_code","rucdate","tn","code_key","mpccode_key1", ///
	"mpccode_key2") {
		destring `var', replace force float
		// unfixable non-numeric values for num_times1yr judgea judgeb skillsa 
		// officecode11 officecode15 rvw rvu2 medicare_1yr (fixed others above)
		replace `var'=round(`var',.000001)
		// Get rid of rounding errors
	}
}

// Drop duplicates (missing CPT components, incorrectly ordered times (2), or 
// incorrect rvu2 or rvw (2))
sort cpt_code rucdate critcode91
by cpt_code rucdate: drop if critcode91[1]!=.&critcode91[2]==.&_N==2
drop if cpt_code=="29826"&rucdate=="Apr11"&rvwlow==300
drop if cpt_code=="33548"&rucdate=="Apr05"&evalmed==60
drop if cpt_code=="52332"&rvw==0
drop if cpt_code=="52353"&rvu2==7.5

foreach var of varlist rvwlow-rvwhigh intralow-intrahigh {
	capture replace `var'=`var'_orig
	capture drop `var'_orig
	gen `var'_orig=`var'
}

foreach meas in rvw intra {
	global tokens `meas'low `meas'25 `meas'med `meas'75 `meas'high
	tokenize ${tokens}

	// Multiplying or dividing by 10
	capture drop changed_`meas'
	gen byte changed_`meas'=0
	foreach num of numlist 1/5 {
		local exp1 floor(log10(``num''/``=`num'-1''))
		local exp2 ceil(log10(``num''/``=`num'+1''))
		local exp3 ceil(log10(``num''/``=`num'-1''))
		if `num'==1 {
			local toreplace ``num''/10^(`exp2')
			local cond `exp2'>0&`exp2'!=.
		}	
		else if `num'<5 {
			local toreplace ``num''/10^(`exp1')
			local cond `exp1'==`exp2'&`exp1'!=0&`exp1'!=.
		}
		else {
			egen temprowtotal=rowtotal(${tokens})
			gen comprowtotal=temprowtotal-``num''
			local toreplace ``num''/10^(`exp1')
			local cond `exp1'<0&`exp1'!=.&`toreplace'/comprowtotal*4<10
		}
		replace changed_`meas'=1 if `cond'
		replace ``num''=`toreplace' if `cond'	
		capture drop comprowtotal temprowtotal
	}

	label_missing, tokens(${tokens}) 
	label_combo_loop, tokens(${tokens})
	tab comboname

*** Fixes for rvw* ***********************************************************************
if regexm("${tokens}","rvw") {
	// Transposing
	tokenize ${tokens}
	replace `2'=`3'_orig if comboname=="13245"
	replace `3'=`2'_orig if comboname=="13245"
	replace `3'=`4'_orig if comboname=="12435"
	replace `4'=`3'_orig if comboname=="12435"
	replace `4'=`5'_orig if comboname=="12354"
	replace `5'=`4'_orig if comboname=="12354"

	// Drop or interpolate observations that are out of order
	replace `2'=(`1'+`3')/2 if comboname=="13425"
	replace `3'=(`2'+`4')/2 if comboname=="31245"
	replace `4'=(`3'+`5')/2 if comboname=="41235"
	replace `5'=. if comboname=="51234"
}

*** Fixes for intra* *********************************************************************
else if regexm("${tokens}","intra") {
	// Transposing
	tokenize ${tokens}
	replace `3'=`4'_orig if comboname=="12435"
	replace `4'=`3'_orig if comboname=="12435"

	// Drop or interpolate observations that are out of order
	replace `3'=(`2'+`4')/2 if comboname=="12453"|comboname=="13245"|comboname=="31245"
	replace `5'=. if comboname=="51234"
}
}

*** Save data on predictions *************************************************************
global sorvars rvwlow rvw25 rvwmed rvw75 rvwhigh evalmed posmed dressmed ///
	intralow intra25 intramed intra75 intrahigh immedposttime ///
	critcode91-officecode15_2 rvu_key mpcrvu_key1 mpcrvu_key2 ///
	respondentskey prctrespon_keyref num_times1yr medicare_1yr	

rename rvw ss_rec
rename rvu2 ruc_rec
gen lnss_rec=ln(ss_rec)
gen lnruc_rec=ln(ruc_rec)
keep cpt_code rucdate ruc_rec ss_rec lnruc_rec lnss_rec $sorvars diga-postintenseb
drop if cpt_code=="code"
merge m:1 rucdate using data/crosswalks/rucdate_mtg_xwalk, keep(match) ///
	assert(match using) nogen
drop ruc_yr mtg_num ruc_cycle str_mtgid rucdate

// Process variables
gen rvw25_75=(rvw75-rvw25)/rvwmed
gen rvwlow_high=(rvwhigh-rvwlow)/rvwmed
gen intra25_75=(intra75-intra25)/rvwmed
gen intralow_high=(rvwhigh-rvwlow)/rvwmed
global sorvars ${sorvars} rvw25_75 rvwlow_high intra25_75 intralow_high
foreach var of varlist $sorvars {
	count if `var'==. 
	if r(N)>0 {
		gen byte m_`var'=`var'==.
		replace `var'=0 if `var'==.
		global sorvars ${sorvars} m_`var'		
	}
}
global sorchars ${sorvars} c.prctrespon_keyref#c.rvu_key
rename risk_mean risk_meana
rename risk_mean_cd risk_meanb
qui foreach sorchar in dig rec descion skills eff risk_mean judge risk ///
	preintense intraintense postintense {
	count if `sorchar'a==.|`sorchar'b==.
	if r(N)>0 {
		gen byte m_`sorchar'=(`sorchar'a==.|`sorchar'b==.)
		global sorvars ${sorvars} m_`sorchar'
	}
	gen byte `sorchar'_hi=cond(`sorchar'a!=.&`sorchar'b!=.,`sorchar'a>`sorchar'b,0)
	gen `sorchar'_prop=cond(`sorchar'a!=.&`sorchar'b!=.&`sorchar'b!=0, ///
		(`sorchar'a-`sorchar'b)/`sorchar'b,0)
	gen byte m_`sorchar'_prop=cond(`sorchar'b==.,0,`sorchar'b==0)
	gen `sorchar'_diff=cond(`sorchar'a!=.&`sorchar'b!=., ///
		`sorchar'a-`sorchar'b,0)
	global sorvars ${sorvars} `sorchar'_hi m_`sorchar'_prop `sorchar'_prop `sorchar'_diff
	global sorchars ${sorvars} ///
		c.`sorchar'_hi#c.rvu_key c.`sorchar'_prop#c.rvu_key c.`sorchar'_diff#c.rvu_key
	drop `sorchar'a `sorchar'b
}

// Form predictions
qui foreach outcome of varlist lnruc_rec lnss_rec ruc_rec ss_rec {
	noi disp as text "Standard SOR prediction of `outcome'"
	qui reg `outcome' ${sorchars}
	predict `outcome'_xb_sor, xb
	noi disp as text "Jack-knifing SOR predictions of `outcome' by mtgid: " _c
	gen `outcome'_xb_sor_jk=.
	levelsof mtgid, local(levels)
	foreach num of local levels {
		noi disp as result `num' " " _c
		qui reg `outcome' ${sorchars} if mtgid!=`num'
		predict temp if mtgid==`num', xb	
		replace `outcome'_xb_sor_jk=temp if mtgid==`num'
		drop temp
	}
	noi disp _n
}		
drop ${sorvars}

save data/intermediate/sor_predictions, replace
