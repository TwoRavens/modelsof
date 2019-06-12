*12-06-19_mimputation.do

clear

cd "$filetree"

set more off

use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

*merge pruned beck and webb data


rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "country_year_mimpute.dta"


keep if _merge==3
drop abbrev _merge majpow

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}


rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "country_year_mimpute.dta"


keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=0

sort ccode1 ccode2 year


*Analyses for claim: "In fact, 98% of the dyad-year observations in Mousseau’s final dataset are (singly) imputed, 90% of which involve extrapolation; in addition Mousseau deletes 7% of the original sample (the years from 1950-1960) due to this missing data."
*For all years 1950-2001
count if lnlifedeerl~=.
*38057
local interpolated=r(N)
*divide by 5 since technically Beck and Webb only coded every five years. 
di `interpolated'/5
local original=`interpolated'/5
*7611

count
local all=r(N)
*436541

*Proportion of dyad-years originally coded:
di `original'/`all'
*.0174357

*Proportion of dyad-years originally coded or interpolated:
di `interpolated'/`all'
*.08717852

*Restricting to 1960-2000
count if lnlifedeerl~=. & year>=1960 & year<2001
local interpolated=r(N)
local original=`interpolated'/5

count if year>=1960 & year<2001
local all=r(N)

*Proportion of dyad-years originally coded:
di `original'/`all'
*.0193802

*Proportion of dyad-years originally coded or interpolated:
di `interpolated'/`all'
*.09690101


*Need to drop:
count if year<1960
local drop=r(N)
count
local all=r(N)

di `drop'/`all'

*gen _mi_id=_n

sort ccode1 ccode2 year
save "mi_0.dta", replace



clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001


*imputation 1
rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211171.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211171.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.


*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh


count

gen m=1
sort ccode1 ccode2 year
save "mi_1.dta", replace


***



*imputation 2
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211172.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211172.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=2

sort ccode1 ccode2 year
save "mi_2.dta", replace


*imputation 3
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211173.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211173.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=3

sort ccode1 ccode2 year
save "mi_3.dta", replace






*imputation 4
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211174.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211174.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=4

sort ccode1 ccode2 year
save "mi_4.dta", replace



*imputation 5
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211175.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211175.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=5

sort ccode1 ccode2 year
save "mi_5.dta", replace




*imputation 6
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211176.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211176.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=6

sort ccode1 ccode2 year
save "mi_6.dta", replace




*imputation 7
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211177.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211177.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=7

sort ccode1 ccode2 year
save "mi_7.dta", replace




*imputation 8
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211178.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211178.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=8

sort ccode1 ccode2 year
save "mi_8.dta", replace



*imputation 9
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal1211179.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal1211179.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=9

sort ccode1 ccode2 year
save "mi_9.dta", replace





*imputation 10
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111710.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111710.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=10

sort ccode1 ccode2 year
save "mi_10.dta", replace








*imputation 11
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111711.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111711.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=11

sort ccode1 ccode2 year
save "mi_11.dta", replace


*imputation 12
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111712.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111712.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=12

sort ccode1 ccode2 year
save "mi_12.dta", replace


*imputation 13
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111713.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111713.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=13

sort ccode1 ccode2 year
save "mi_13.dta", replace






*imputation 4
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111714.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111714.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=14

sort ccode1 ccode2 year
save "mi_14.dta", replace



*imputation 15
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111715.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111715.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=15

sort ccode1 ccode2 year
save "mi_15.dta", replace




*imputation 6
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111716.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111716.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=16

sort ccode1 ccode2 year
save "mi_16.dta", replace




*imputation 17
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111717.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111717.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=17

sort ccode1 ccode2 year
save "mi_17.dta", replace




*imputation 18
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111718.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111718.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=18

sort ccode1 ccode2 year
save "mi_18.dta", replace



*imputation 19
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111719.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111719.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=19

sort ccode1 ccode2 year
save "mi_19.dta", replace





*imputation 20
clear
use "12-05-28_dem_CIE_analysis.dta"

drop if year<1950
drop if year>2001

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using "outdatatotal12111720.dta"

tab country_name1 if _merge==1, sort
*small countries not matched

keep if _merge==3
drop abbrev _merge majpow


foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'1
}

rename ccode ccode1
rename ccode2 ccode
sort ccode year

merge m:1 ccode year using "outdatatotal12111720.dta"

keep if _merge==3
drop abbrev _merge majpow

rename ccode ccode2

foreach x of varlist mid fmid war region lngdppc lnlifedeer lncap lnmilper lnmilex lnirst lnenergy lnupop lntpop lntottr lnlifepen lnacli {
rename `x' `x'2
}

gen lnlifedeerl=min(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppcl=min(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncapl=min(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperl=min(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexl=min(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirstl=min(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyl=min(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupopl=min(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpopl=min(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrl=min(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenl=min(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclil=min(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

gen lnlifedeerh=max(lnlifedeer1, lnlifedeer2) if lnlifedeer1~=. & lnlifedeer2~=.
gen lngdppch=max(lngdppc1, lngdppc2) if lngdppc1~=. & lngdppc2~=.
gen lncaph=max(lncap1, lncap2) if lncap1~=. & lncap2~=.
gen lnmilperh=max(lnmilper1, lnmilper2) if lnmilper1~=. & lnmilper2~=.
gen lnmilexh=max(lnmilex1, lnmilex2) if lnmilex1~=. & lnmilex2~=.
gen lnirsth=max(lnirst1, lnirst2) if lnirst1~=. & lnirst2~=.
gen lnenergyh=max(lnenergy1, lnenergy2) if lnenergy1~=. & lnenergy2~=.
gen lnupoph=max(lnupop1, lnupop2) if lnupop1~=. & lnupop2~=.
gen lntpoph=max(lntpop1, lntpop2) if lntpop1~=. & lntpop2~=.
gen lntottrh=max(lntottr1, lntottr2) if lntottr1~=. & lntottr2~=.
gen lnlifepenh=max(lnlifepen1, lnlifepen2) if lnlifepen1~=. & lnlifepen2~=.
gen lnaclih=max(lnacli1, lnacli2) if lnacli1~=. & lnacli2~=.

*simplify dataset:
keep country_name1 country_name2 ccode1 ccode2 year abbrev1 abbrev2 cwmid cwongo cwfatald dyadid lncprt mjpw dml dmh contigl lndist polity22 contig distance numstate numGPs cwongonm cwmidnm cwpceyrs midonsl midongl fmidonsl fmidongl warl midyears midyears2 midyears3 fmidyears fmidyears2 fmidyears3 waryears waryears2 waryears3 tpop MMCIE lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh

count

gen m=20

sort ccode1 ccode2 year
save "mi_20.dta", replace






**Code from: https://lists.gking.harvard.edu/pipermail/amelia/2012-February/000841.html
* 2) Appending files together
clear
use "mi_0.dta"
append using "mi_1.dta"
append using "mi_2.dta"
append using "mi_3.dta"
append using "mi_4.dta"
append using "mi_5.dta"
append using "mi_6.dta"
append using "mi_7.dta"
append using "mi_8.dta"
append using "mi_9.dta"
append using "mi_10.dta"
append using "mi_11.dta"
append using "mi_12.dta"
append using "mi_13.dta"
append using "mi_14.dta"
append using "mi_15.dta"
append using "mi_16.dta"
append using "mi_17.dta"
append using "mi_18.dta"
append using "mi_19.dta"
append using "mi_20.dta"

*Check
tab m

*order lnlifedeerl
*browse if m==0
*browse if m==1

 
*Sorting
sort m ccode1 ccode2 year

gen CIEl=lnlifedeerl
sum CIEl if m==1, d
gen CIElc=CIEl-r(p75)
gen dmlCIElc=dml*CIElc

* 3) Saving data (NOTE: Stata requires this step -- data must be saved before importing)
save "midata", replace
 
 
forvalues j=0(1)20 { 
erase "mi_`j'.dta"
}

* 4) Importing into STATA as MI
clear 
use "midata" 
mi import flong,  m(m) id(ccode1 ccode2 year) imputed(CIEl CIElc dmlCIElc lnlifedeerl lngdppcl lnlifepenl lnlifedeerh lngdppch lnlifepenh)
*NOTE: Use the "imputed" to note which variables had missing data.  All imputed vars should be declared.

save "midata", replace

mi convert wide
save "midata", replace

mi describe

mi varying
*See STATA help on the import command re: what these commands should produce if data are properly identified










