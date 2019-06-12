*
global mypath "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS"


***Combine data (2005-2008)
forvalues year=5/8 {
	fdause ${mypath}\CDBRFS0`year'.XPT
	save ${mypath}\brfss_200`year'.dta, replace
}
forvalues year=5/8 {
	clear *
	append using ${mypath}\brfss_200`year'.dta
	erase ${mypath}\brfss_200`year'.dta
}
save "${mypath}\data\brfss_combined0508.dta", replace

use "${mypath}\data\brfss_combined0508.dta", clear


***Clean and format data
g quartile_1=nattmpts<=1
g quartile_2=(nattmpts>=2 & nattmpts<=3)
g quartile_3=(nattmpts>3& nattmpts<=7)
g quartile_4=(nattmpts>=7)

label variable quartile_1 "1 call"
label variable quartile_2 "2-3 calls"
label variable quartile_3 "3-7 calls"
label variable quartile_4 ">7 calls"

g inc1=(income2>=1 & income2<=4)
	label variable inc1 "<=$25k"
g inc2=(income>=5 & income2<=6)
	label variable inc2 "$25-$50k"
g inc3=(income2==7)
	label variable inc3 "50-75k"
g inc4=income2==8
	label variable inc4 ">$75K"
g inc5=(income2==77 | income2==99 | income2==.)
	label variable inc5 "Missing income"

g female=sex==2
	label variable female "Female"

*One missing age, dropped
drop if age<18 | age==. 
g age1=(age>=18 & age<=39)
	label variable age1 "18-39"
g age2=(age>=40 & age<=49)
	label variable age2 "40-49"
g age3=(age>=50 & age<=59)
	label variable age3 "50-59"
g age4=(age>=60 & age<=69)
	label variable age4 "60-69"
g age5=(age>=70)
	label variable age5 "70+"

***Drop those with missing life satisfaction
drop if lsatisfy==. | lsatisfy==7 | lsatisfy==9 

g child1=(children>=1 & children<=87)
	label variable child1 "Child under 18 in house"
g child2=(children==88)
	label variable child2 "No child under 18 in house"
g child3=(children==99 | children==.)
	label variable child3 "Missing child data"

g agenchild1=1 if (age1==1 | age2==1) & child1==1
	label variable agenchild1 "<=49 & child"
replace agenchild1=0 if agenchild1==.
	g agenchild2=1 if (age1==1 | age2==1) & child1==0
replace agenchild2=0 if agenchild2==.
	label variable agenchild2 "<=49 & no child"
g agenchild3=1 if (age3==1 | age4==1 | age5==1)
	label variable agenchild3 ">=50"
replace agenchild3=0 if agenchild3==.
g agenchild4=child3==1
	label variable agenchild4 "Missing child"
g lsatisfy_r=5-lsatisfy

g education=educa
	replace education=99 if educa==. | educa==9

g marriage=marital 
	replace marriage=99 if marital==9 | marital==.

g race=_racegr2
	replace race=99 if race==9 | race==.

g state=_state

g urban_rural=mscode
replace urban_rural=99 if mscode==.


keep child* age* lsatis* female inc* quartile* marriage education race state urban_rural
save "${mypath}\data\brfss_hefrab.dta", replace
*/


***Perform analysis
use "${mypath}\data\brfss_hefrab.dta", clear


***Regressions performed one variable and difficulty quartile at a time (left panels of A.23
forvalues x=1/4 {

	di "reg lsatisfy_r inc1 inc2 inc4 inc5 if quartile_`x'==1"
		reg lsatisfy_r inc1 inc2 inc4 inc5 if quartile_`x'==1
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r female if quartile_`x'==1"
		reg lsatisfy_r female if quartile_`x'==1
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r age1 age2 age4 age5 if quartile_`x'==1"
		reg lsatisfy_r age1 age2 age4 age5 if quartile_`x'==1
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r agenchild1 agenchild3 agenchild4  if quartile_`x'==1"
		reg lsatisfy_r agenchild1 agenchild3 agenchild4  if quartile_`x'==1
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23", bdec(3) tex(frag) label(insert)
}
*/

***Regression for all variables for one difficulty at a time (left panel of A.24)
forvalues x=1/4 {
	di "quartile=`x'"
	reg lsatisfy_r inc1 inc2 inc4 inc5 female age1 age2 age4 age5 agenchild1  agenchild4   i.education i.marriage i.race i.state i.urban_rural if quartile_`x'==1
		outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a24", bdec(3) tex(frag) label(insert)

}
*/

g quartile=1 if quartile_1==1
	replace quartile=2 if quartile_2==1
	replace quartile=3 if quartile_3==1
	replace quartile=4 if quartile_4==1

***Cumulative regressions, one variable at a time (right panel of A.23
forvalues x=1/4 {

	di "reg lsatisfy_r inc1 inc2 inc4 inc5 if quartile<=`x'"
		reg lsatisfy_r inc1 inc2 inc4 inc5 if quartile<=`x'
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23r", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r female if quartile<=`x'"
		reg lsatisfy_r female if quartile<=`x'
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23r", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r age1 age2 age4 age5 if quartile<=`x'"
		reg lsatisfy_r age1 age2 age4 age5 if quartile<=`x'
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23r", bdec(3) tex(frag) label(insert)

	di "reg lsatisfy_r agenchild1 agenchild3 agenchild4  if quartile<=`x'"
		reg lsatisfy_r agenchild1 agenchild3 agenchild4  if quartile<=`x'
				outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a23r", bdec(3) tex(frag) label(insert)
}
*/
***Regression for all variables at a time, cumulative (Right panel of A.24)
forvalues x=1/4 {
	di "quartile=`x'"
		reg lsatisfy_r inc1 inc2 inc4 inc5 female age1 age2 age4 age5 agenchild1  agenchild4   i.education i.marriage i.race i.state i.urban_rural if quartile<=`x'
			outreg2 using "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\outreg\a24r", bdec(3) tex(frag) label(insert)

}
