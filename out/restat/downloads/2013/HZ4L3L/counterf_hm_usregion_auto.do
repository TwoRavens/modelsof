
version 9.2

clear
set more off
set mem 1000m
set matsize 11000
set maxvar 10000


scalar theta=1             /* IHS parameter */

* Path
* global foldp "C:/work/Integration/"
do "c:/foldp/foldp.do"
global foldp "${foldp}/Wealth Counterfactuals/Verification/"
global foldp1 ${foldp}

* Asset
global asset House
*Asset abbreviation
global abv hm

* US Region # (US Region base is US: 2.Midwest)
* 1.Northeast, 3.South, 4.West
 
foreach cntr of numlist 1 3 4 {

*use "${foldp}Data/HRS_final_DG.dta", clear
use "${foldp1}Data/HRS/HRS_DG.dta", clear

keep if head==1

keep if r7cenreg==2 | r7cenreg==`cntr'

ge byte ind = (r7cenreg==`cntr')


*** Regressors *** 

*Age squared
qui gen long agesq=age^2

*Age group
qui recode age (min/59=1) (60/69=2) (70/79=3) (80/max=4),g(agegroup)
qui ta agegroup,g(dage)

*Female dummy
qui gen byte fem=(gender==2) if gender~=.

*Education dummies
qui gen byte nohigh=(edu==1) if edu~=.
qui gen byte highs=(edu==2) if edu~=.
qui gen byte college=(edu==3) if edu~=.

*Health status
qui gen byte badhs=(srhealtha==4 | srhealtha==5) if srhealtha~=.

*Marital Status
qui gen byte couple=(mstat==1) if mstat~=.
qui gen byte divorced=(mstat==2) if mstat~=.
qui gen byte widow=(mstat==3) if mstat~=.
qui gen byte nevmar=(mstat==4) if mstat~=.

*Number of rooms (range)
*qui ta ordhrooms,g(dnroom)


*Both spouses retired

*Non working and retirement dummy (combined)
qui gen byte dnw=(retire==1 | nonwork==1)
qui egen byte sdnw=sum(dnw),by(implicat hhid)
*Actual hhd size in the sample
qui gen byte d1=1
qui egen byte sd1=sum(d1),by(implicat hhid)
*Dummy for households where the single head or the head and the spouse are not employed
qui gen byte dnonempl=(sdnw==sd1)
drop d1 sd1


*Wealth regressors. 

*Wealth covariate for the regression of risky financial assets. Equal to net worth minus risky financial assets
qui gen double inrw=hnetwv-hrfinv
*IHS of wealth
qui replace inrw=log(theta*(inrw)+sqrt((theta*(inrw))^2+1))/theta


*Wealth covariate for the regression of risky real assets. Equal to net worth minus risky real assets
qui gen double ibow=hnetwv-horlav
*IHS of wealth
qui replace ibow=log(theta*(ibow)+sqrt((theta*(ibow))^2+1))/theta

*Wealth covariate for the regression of own business. Equal to net worth minus own business
qui gen double ienw=hnetwv-hownbv
*IHS of wealth
qui replace ienw=log(theta*(ienw)+sqrt((theta*(ienw))^2+1))/theta

*Wealth covariate for the regression of other real estate. Equal to net worth minus other real estate
qui gen double istw=hnetwv-horesv
*IHS of wealth 
qui replace istw=log(theta*(istw)+sqrt((theta*(istw))^2+1))/theta

*Wealth covariate for the regression of home. Equal to net worth minus home value
qui gen double imhw=hnetwv-(hhomev-hmortv)
*IHS of wealth
qui replace imhw=log(theta*(imhw)+sqrt((theta*(imhw))^2+1))/theta

*Income. Equal to total minus capital
*ATTENTION. Look at disaggregation of capital income
qui gen double iinc=hgtincv-hcpincv
*IHS of non-capital income
qui replace iinc=log(theta*(iinc)+sqrt((theta*(iinc))^2+1))/theta


*IHS of total income
qui gen double igtinc=log(theta*(hgtinc)+sqrt((theta*(hgtinc))^2+1))/theta


*IHS of dependent variables.

*IHS of gross total wealth
qui gen double itgw=log(theta*hgtwv+sqrt((theta*hgtwv)^2+1))/theta

*IHS of net total wealth
qui gen double itnw=log(theta*hnetwv+sqrt((theta*hnetwv)^2+1))/theta

* IHS of risky financial assets *
qui gen double irf=log(theta*hrfinv+sqrt((theta*hrfinv)^2+1))/theta

*IHS of risky real assets
qui gen double irr=log(theta*horlav+sqrt((theta*horlav)^2+1))/theta

*IHS of own business
qui gen double ibus=log(theta*hownbv+sqrt((theta*hownbv)^2+1))/theta

*IHS of other real estate
qui gen double iest=log(theta*horesv+sqrt((theta*horesv)^2+1))/theta

*IHS of the value of the home equity
qui gen double ihm=log(theta*hhomev+sqrt((theta*hhomev)^2+1))/theta


*exit

drop if wgtach==0

*************
su imhw [aw=wgtach] if ind==0, d

scalar pw25 = r(p25)
scalar pw50 = r(p50)
scalar pw75 = r(p75)

ge byte qw2_0 = (pw25<imhw & imhw<=pw50) 
ge byte qw3_0 = (pw50<imhw & imhw<=pw75) 
ge byte qw4_0 = (pw75<imhw) if imhw!=.


*************

su iinc [aw=wgtach] if ind==0, d

scalar pi25 = r(p25)
scalar pi50 = r(p50)
scalar pi75 = r(p75)

ge byte qi2_0 = (pi25<iinc & iinc<=pi50) 
ge byte qi3_0 = (pi50<iinc & iinc<=pi75) 
ge byte qi4_0 = (pi75<iinc) if iinc!=.


*************

keep if  hhomeo==1

ge double loghm = log(hhomev)

ge double lognhm = log(hhomev-hmortv) if (hhomev-hmortv)>1
replace lognhm = 0 if (hhomev-hmortv)>=-1 & (hhomev-hmortv)<=1 
replace lognhm = -1*log(abs(hhomev-hmortv)) if (hhomev-hmortv)<-1

*exit

noisily ta ind


**** Commands  ****
global depvar loghm
global indepvars age agesq hsize highs college recall badhs retire working couple widow nevmar beqex00 provhelp voluntary adlno qi2_0 qi3_0 qi4_0 qw2_0 qw3_0 qw4_0

 
noisily mmdeco ${depvar} ${indepvars}, p(100) se(100) w(wgtach) by(ind)
keep if p!=.
 
* Collect results 

sort p

 if `cntr' ==1 {
mat ${abv}_bMWxi = `cntr', dif[10], ref[10], ref[10]/SE_ref[10], cvef[10], cvef[10]/SE_cvef[10], dif[25], ref[25] , ref[25]/SE_ref[25], cvef[25], cvef[25]/SE_cvef[25], dif[50], ref[50], ref[50]/SE_ref[50], cvef[50], cvef[50]/SE_cvef[50], dif[75], ref[75], ref[75]/SE_ref[75], cvef[75], cvef[75]/SE_cvef[75], dif[90], ref[90] , ref[90]/SE_ref[90], cvef[90], cvef[90]/SE_cvef[90] 
}

 if `cntr' !=1 {
mat ${abv}_bMWxih= `cntr', dif[10], ref[10], ref[10]/SE_ref[10], cvef[10], cvef[10]/SE_cvef[10], dif[25], ref[25], ref[25]/SE_ref[25], cvef[25], cvef[25]/SE_cvef[25], dif[50], ref[50], ref[50]/SE_ref[50], cvef[50], cvef[50]/SE_cvef[50], dif[75], ref[75], ref[75]/SE_ref[75], cvef[75], cvef[75]/SE_cvef[75], dif[90], ref[90] , ref[90]/SE_ref[90], cvef[90], cvef[90]/SE_cvef[90]
mat  ${abv}_bMWxi = ${abv}_bMWxi\ ${abv}_bMWxih
}

 
save "${foldp1}Results/DG/${asset}/US/${abv}_MW_`cntr'.dta", replace

}

matrix coln ${abv}_bMWxi = Country Diff_10 Coeff_10 tcf_10 Cov_10 tcv_10 Diff_25 Coeff_25 tcf_25 Cov_25 tcv_25 Diff_50 Coeff_50 tcf_50 Cov_50 tcv_50 Diff_75 Coeff_75 tcf_75 Cov_75 tcv_75 Diff_90 Coeff_90 tcf_90 Cov_90 tcv_90 
mat2txt, matrix(${abv}_bMWxi) saving("${foldp1}/Results/DG/${asset}/US/Table_${abv}_bMWxi") title(Decomp of House dstrb within US) format(%9.4f) replace


exit



noisily {
sort p
di as text "Act Diff:"  "  " as result diff[25] "  " diff[50] "  " diff[75]

sort p
di as text "Coeff Eff:"  "  " as result ref[25] " " ref[25]/SE_ref[25] "    " ref[50] " " ref[50]/SE_ref[50] "    " ref[75] " " ref[75]/SE_ref[75]

sort p
di as text "Covar Eff:"  "  " as result cvef[25] " " cvef[25]/SE_cvef[25] "    " cvef[50] " " cvef[50]/SE_cvef[50] "    " cvef[75] " " cvef[75]/SE_cvef[75]
}

exit

