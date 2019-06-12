
**************************************

*Had issues with dummies for zsecond8
*Dropped in 4 regressions/probits
*Doesn't affect F test, which takes drops into account
*Search for "*ZSECOND ISSUE HERE" in code below to see where this arises


*Reviewing results

use clorin_clean.dta, clear

*Their code to create locals

local health "base_soapfood base_soaptoil base_puratt"
local demos "age school schyear married pregnant children nchild5 hhldsize durables"
local locality "zlocality2 zlocality3 zlocality4 zlocality5"
local prior "base_use base_have"
local all_controls "`prior' `health' `demos' `locality'"

local zmarketers "zmarketer2 zmarketer3 zmarketer4 zmarketer5 zmarketer6"
local first_zmarketers "first_zmarketer2 first_zmarketer3 first_zmarketer4 first_zmarketer5 first_zmarketer6"
local second_zmarketers "second_zmarketer2 second_zmarketer3 second_zmarketer4 second_zmarketer5 second_zmarketer6"
local possec_zmarketers "possec_zmarketer2 possec_zmarketer3 possec_zmarketer4 possec_zmarketer5 possec_zmarketer6"

* LOCALS: WRITTEN BY LOOPS

local std_mkt_control ""
foreach control in `all_controls'{
	local std_mkt_control "`std_mkt_control' std_mkt_`control'"
}

local inter_follow_sunkcost ""
local inter_follow_value ""
local inter_married ""

foreach split in follow_sunkcost follow_value married base_ever{
	foreach var in `all_controls' zfirst2 zfirst3 zfirst4 zfirst5 zfirst6{
		local inter_`split' "`inter_`split'' `var'_`split'"
	}
}

local inter_follow_sunkcost_nofirst ""
local inter_follow_fcon_nofirst ""

foreach split in follow_sunkcost follow_fcon{
	foreach var in `all_controls'{
		local inter_`split'_nofirst "`inter_`split'_nofirst' `var'_`split'"
	}
}

local inter_follow_sunkcost_first ""
foreach var in zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8{
	local inter_follow_sunkcost_first "`inter_follow_sunkcost_first' `var'_follow_sunkcost"
}


*Reproducing tables


*Table 2 - all okay

	reg bought first
	reg bought first `std_mkt_control'
	reg bought first if follow==1

*Table 3 - All okay

	regress follow_use first zsecond2-zsecond8 if bought==1
	regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1
	regress follow_have first zsecond2-zsecond8 if bought==1
	regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1

*Table 4 - All okay
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {
		regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1
		reg `outcome' `transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 `all_controls' `inter_follow_sunkcost' follow_sunkcost if bought==1
		}
	}

*Table 5 - All okay

	regress onemonth_exhausted first zsecond2-zsecond8 if bought==1

*ZSECOND ISSUE HERE

	regress onemonth_use first zsecond2-zsecond7 if bought==1 & onemonth_exhausted~=1
	testparm first zsecond2-zsecond7 

	regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
	testparm first zsecond2-zsecond8

*ZSECOND ISSUE HERE

	regress onemonth_have first zsecond2-zsecond7 if bought==1 & onemonth_exhausted~=1
	testparm first zsecond2-zsecond7 

	regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
	testparm first zsecond2-zsecond8 

*Doesn't vary
sum zsecond8 if bought==1 & onemonth_exhausted~=1 & onemonth_use ~= .
sum zsecond8 if bought==1 & onemonth_exhausted~=1 & onemonth_have ~= .

	regress follow_purpose first zsecond2-zsecond8 if bought==1
	regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

*Table A3 - All okay

	** SPECIFICATION 2: PROBIT MODEL - ALL OKAY
		dprobit bought first
		probit bought first

		foreach outcome in follow_use follow_have {

*ZSECOND ISSUE HERE (two rounds on outcome)

			dprobit `outcome' first zsecond2-zsecond8 if bought==1
			probit `outcome' first zsecond2-zsecond8 if bought==1

			dprobit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
			probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
		}

	** SPECIFICATION 3: MARKETER FIXED EFFECTS - ALL OKAY
		reg bought first `zmarketers'

		foreach outcome in follow_use follow_have {
			regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1

			reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1
			testparm second zfirst2-zfirst6
		}

	** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS
		foreach outcome in follow_use follow_have {
			scalar weighted = 0
			scalar weightsum = 0
			scalar N = 0
			matrix L = J(1,1,0)
			foreach f of numlist 3/8 {
				reg `outcome' second `all_controls' if first==`f' & bought==1
				scalar weighted = weighted + _b[second]/(_se[second]^2)
				scalar weightsum = weightsum + 1/(_se[second]^2)
				scalar N = scalar(N) + e(N)
				matrix L = L[1,1] + colsof(e(V))
				}
			display "average coefficient of `outcome' on second: " weighted/weightsum " (" sqrt(1/weightsum) ")"

			scalar weighted = 0
			scalar weightsum = 0
			scalar N = 0
			matrix L = J(1,1,0)
			* (note: only using transaction prices up to 6 because not enough data at 7 to estimate model)
			foreach s of numlist 0/6 {
				reg `outcome' first if second==`s'&bought==1
				scalar weighted = weighted + _b[first]/(_se[first]^2)
				scalar weightsum = weightsum + 1/(_se[first]^2)
				scalar N = scalar(N) + e(N)
				matrix L = L[1,1] + colsof(e(V))
				}
			display "average coefficient of `outcome' on first: " weighted/weightsum " (" sqrt(1/weightsum) ")"
		}

	** SPECIFICATION 5: CONTROLLING FOR QUALITY ASSESSMENTS - ALL OKAY
		reg bought first follow_puratt
		foreach outcome in follow_use follow_have {
			reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1
			reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1
		}

	** SPECIFICATION 6: ORDERED PROBIT ON FREE CHLORINE - ALL OKAY
		oprobit follow_free first zsecond2-zsecond8 if bought==1
		oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1

	** SPECIFICATION 7: ORDERED PROBIT ON RECENCY OF USE - ALL OKAY
		oprobit follow_recent first zsecond2-zsecond8 if bought==1
		oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1

save DatABS, replace
