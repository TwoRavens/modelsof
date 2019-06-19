/** Table 4 Effects of City Size on Variance of Wages
 When Accounting for Demogrphics and Demogrpahics+Industry **/


capture log close
log using table4.log,replace text


clear
set mem 1000m
set matsize 1000
set more off

* All counterfactual are done with respect to rural areas but we can easily change it and make it wirth respect to small msa (put [2] instead of [1]). 
* we have two missing obs, i.e. cells that are empty. these are both in 07 and are Ddem=1 indc=9 size 10 and Ddem=6 indc=7 and size=2. the code is such that if a cell is completely empty
* we cannot create a mean and variance for it. even if we did, not readjusting the shares, which is what we do here, that would have a zero weight so nothing would change. 
* if the main code was con3ter, we should adjust this although 2 cells will not make a difference.


capture program drop doall
program define doall 

clear
use ../censusmicro/census`1'.dta
keep if hoursamp==1
if `1' == 80 {
   	gen perwt = 1
	}
	
drop if indc==0	

replace indc=10 if indc==3 & ind1990<=222
replace indc=11 if indc==8 & ind1990<=810
replace indc=12 if indc==4 & ind1990<=432
	
gen Dage2=0
qui replace Dage2=1 if age>=25 & age<30
qui replace Dage2=2 if age>=30 & age<35
qui replace Dage2=3 if age>=35 & age<40
qui replace Dage2=4 if age>=40 & age<45
qui replace Dage2=5 if age>=45 & age<50
qui replace Dage2=6 if age>=50 & age<55

gen Ddem=0
qui replace Ddem=1 if Dage2==1 & Dedu==1
qui replace Ddem=2 if Dage2==1 & Dedu==2
qui replace Ddem=3 if Dage2==1 & Dedu==3
qui replace Ddem=4 if Dage2==1 & Dedu==4
qui replace Ddem=5 if Dage2==1 & Dedu==5
qui replace Ddem=6 if Dage2==2 & Dedu==1
qui replace Ddem=7 if Dage2==2 & Dedu==2
qui replace Ddem=8 if Dage2==2 & Dedu==3
qui replace Ddem=9 if Dage2==2 & Dedu==4
qui replace Ddem=10 if Dage2==2 & Dedu==5
qui replace Ddem=11 if Dage2==3 & Dedu==1
qui replace Ddem=12 if Dage2==3 & Dedu==2
qui replace Ddem=13 if Dage2==3 & Dedu==3
qui replace Ddem=14 if Dage2==3 & Dedu==4
qui replace Ddem=15 if Dage2==3 & Dedu==5
qui replace Ddem=16 if Dage2==4 & Dedu==1
qui replace Ddem=17 if Dage2==4 & Dedu==2
qui replace Ddem=18 if Dage2==4 & Dedu==3
qui replace Ddem=19 if Dage2==4 & Dedu==4
qui replace Ddem=20 if Dage2==4 & Dedu==5
qui replace Ddem=21 if Dage2==5 & Dedu==1
qui replace Ddem=22 if Dage2==5 & Dedu==2
qui replace Ddem=23 if Dage2==5 & Dedu==3
qui replace Ddem=24 if Dage2==5 & Dedu==4
qui replace Ddem=25 if Dage2==5 & Dedu==5
qui replace Ddem=26 if Dage2==6 & Dedu==1
qui replace Ddem=27 if Dage2==6 & Dedu==2
qui replace Ddem=28 if Dage2==6 & Dedu==3
qui replace Ddem=29 if Dage2==6 & Dedu==4
qui replace Ddem=30 if Dage2==6 & Dedu==5
	
sort size_a Ddem indc
egen totwt = sum(perwt)
gen theta = perwt/totwt

* Weight of each cell (dem x size x ind). this is not predicted. see con3ter for a prediction of this.
by size_a Ddem indc: egen tot`1'=sum(theta)

* Mean of each cell (dem x size x indc)
qui xi:reg lincwgb i.size_a*i.Ddem i.size_a*i.indc  i.Dedu*i.indc  i.Dage2*i.indc [aw=perwt]
predict mu`1'

* Construct the variance of each cell (dem x size x ind)
gen sig`1' = (lincwgb-mu`1')^2
qui xi:reg sig`1' i.size_a*i.Ddem i.size_a*i.indc  i.Dedu*i.indc  i.Dage2*i.indc [aw=perwt]
predict sig2`1'
sum sig2 if sig2<=0
replace sig2=0 if sig2<0

save obs-res`1'2,replace

collapse (mean) sig2`1' mu`1' tot`1' [aw=perwt], by(size_a Ddem indc)

sort Ddem indc size

* size of each demographic/industry cell, all locations
by Ddem indc: egen tots`1'=sum(tot`1')

if `1' == 80 {

	* Construct the gradient wrt size of variances withing dem cell in the 80
   	by Ddem indc: gen changes80=sig280-sig280[1]
	
	* Construct the distribution in each size for each dem cell in the 80
	by Ddem indc: gen ts`1'=tot`1'/tots`1'

	*mean of demographic in 1980
	by Ddem indc: egen mean80=sum(ts80*mu80)
	by Ddem indc: gen changem80=mu80-mean80
	}

if `1' ~= 80 {

	sort size  Ddem indc
	merge size Ddem indc using tempa3bis2
	drop _m
	sort Ddem indc size
	}
	
* Construct what the mean for each cell (dem x size) would be is the gradient was the same as in the 80 and only rural areas are free to move 
by Ddem indc: gen sig2`1'80=sig2`1'[1]+changes80

*mean of demographic with 80 distribution
by Ddem indc: egen mean`1'80=sum(ts80*mu`1')
by Ddem indc: gen mu`1'80=mean`1'80+changem80
	
* Construct weight of each cell if distribution within size of each demographic is the same as 80, although demographic are free to move 
by Ddem indc: gen tot`1'80=tots`1'*ts80	
	
* Construct overall variance (total/res/obs) for each year
egen m`1'=sum(tot`1'*mu`1')
egen var_obs`1'=sum((mu`1'-m`1')^2*tot`1')
egen var_res`1'=sum(sig2`1'*tot`1')
gen var_tot`1'=var_obs`1'+var_res`1'

* Construct variances holding quantities at the same values of the 80 but letting everything else vary
egen m`1'80q=sum(tot80*mu`1')
egen var_obs`1'80q=sum((mu`1'-m`1'80q)^2*tot80)
egen var_res`1'80q=sum(sig2`1'*tot80)
gen var_tot`1'80q=var_obs`1'80q+var_res`1'80q

* Construct variances holding the distribution across locations within group at 1980 level, but allowing other quantities to vary 
egen m`1'80qc=sum(tot`1'80*mu`1')
egen var_obs`1'80qc=sum((mu`1'-m`1'80qc)^2*tot`1'80)
egen var_res`1'80qc=sum(sig2`1'*tot`1'80)
gen var_tot`1'80qc=var_obs`1'80qc+var_res`1'80qc

* Construct variances holding the gradient between location for each demographic at the 80 level but letting the quantities vary. 
egen m`1'80p=sum(tot`1'*mu`1'80)
egen var_obs`1'80p=sum((mu`1'80-m`1'80p)^2*tot`1')
egen var_res`1'80p=sum(sig2`1'80*tot`1')
gen var_tot`1'80p=var_obs`1'80p+var_res`1'80p
	
* Construct variances holding the gradient between location for each demographic at the 80 level and also the distribution within demographic at the 80 level. 
egen m`1'80c=sum(tot`1'80*mu`1'80)
egen var_obs`1'80c=sum((mu`1'80-m`1'80c)^2*tot`1'80)
egen var_res`1'80c=sum(sig2`1'80*tot`1'80)
gen var_tot`1'80c=var_obs`1'80c+var_res`1'80c
	
sort size  Ddem	indc
save tempa3bis2,replace

end

doall 80
doall 90
doall "00"
doall "07"


* in the following program we take the "mu" of the previous program, which separates observed versus unobserved inequality, and see how much of the change in the variance can be projected onto city size

capture program drop city
program define city
use obs-res`1'2,clear

sort size_a
keep perw mu`1' size_a lincwgb theta

* here I create means and variances of residuals (one for obs and one for res) conditional on city size only
by size_a: egen tot`1'=sum(theta)
by size_a: egen mm`1'=sum(mu`1'*theta/tot`1')
gen var_obs`1'=(mu`1'-mm`1')^2
gen var_res`1'=(lincwgb-mu`1')^2
collapse (mean) var_obs`1' var_res`1' tot`1' mm`1' [aw=perwt], by(size_a)

if `1' == 80 {
	*generate the gradient of the 80 (for mean and variances) so we can use it for counterfactuals
	gen change_obs=var_obs`1'-var_obs`1'[1]
	gen change_res=var_res`1'-var_res`1'[1]
	egen means80=sum(tot80*mm80)
	gen change_mu=mm`1'-means80
	
}

if `1' ~= 80 {
	sort size_a 
	merge size_a using temp_city2.dta
	tab _merge
	drop _merge
}
   
* Construct mean and variances assuming the same gradietn of the 80.
egen means`1'80=sum(tot80*mm`1')
gen mm`1'80=means`1'80+change_mu
gen var_obs`1'80=var_obs`1'[1]+change_obs
gen var_res`1'80=var_res`1'[1]+change_res
	
* Construct variances holding quantities and prices at the same values of the 80
egen mmm`1'80c=sum(tot80*mm`1'80)
egen var_Q`1'80c=sum((mm`1'80-mmm`1'80c)^2*tot80)
egen var_obs`1'80c=sum(var_obs`1'80*tot80)
egen var_res`1'80c=sum(var_res`1'80*tot80)
gen var_tot`1'80c=var_obs`1'80c+var_res`1'80c+var_Q`1'80c

* Construct variances holding  prices at the same values of the 80
egen mmm`1'80p=sum(tot`1'*mm`1'80)
egen var_Q`1'80p=sum((mm`1'80-mmm`1'80p)^2*tot`1')
egen var_obs`1'80p=sum(var_obs`1'80*tot`1')
egen var_res`1'80p=sum(var_res`1'80*tot`1')
gen var_tot`1'80p=var_obs`1'80p+var_res`1'80p+var_Q`1'80p

sort size

save temp_city2,replace

end

city 80
city 90 
city "00" 
city "07"

* This program is similar to the previous but we project the changes onto both city size and demographics (schooling and age)

capture program drop citydem
program define citydem
use obs-res`1'2,clear

sort size_a Ddem
keep perw mu`1' size_a lincwgb Ddem theta

* get mean and variances
by size_a Ddem: egen tot`1'=sum(theta)
by size_a Ddem: egen mm`1'=sum(mu`1'*theta/tot`1')
gen var_obs`1'=(mu`1'-mm`1')^2
gen var_res`1'=(lincwgb-mu`1')^2
collapse (mean) var_obs`1' var_res`1' tot`1' mm`1'  [aw=perwt], by(size_a Ddem)

	sort  Ddem size

	* Construct the distribution in each size for each dem cell in the 80
	by Ddem: egen tots`1'=sum(tot`1')
	by Ddem: gen ts`1'=tot`1'/tots`1'

if `1' == 80 {

	* get the gradient with respect to city size only
	by Ddem: gen change_obs=var_obs`1'-var_obs`1'[1]
	by Ddem: gen change_res=var_res`1'-var_res`1'[1]
	by Ddem:egen means80=sum(ts80*mm80)
	by Ddem: gen change_mu=mm`1'-means80
	
}

sort Ddem size_a

if `1' ~= 80 {
	 
	merge Ddem size_a using temp_citydem2.dta
	tab _merge
	drop _merge
	sort Ddem size_a
}


* Construct weight of each cell if distribution within size of each demographic is the same as 80, although demographic are free to move 
by Ddem: gen tot`1'80=tots`1'*ts80	
   
* Construct mean and variances assuming the same gradien of the 80.
by Ddem: egen means`1'80=sum(ts80*mm`1')
by Ddem: gen mm`1'80=means`1'80+change_mu
by Ddem: gen var_obs`1'80=var_obs`1'[1]+change_obs
by Ddem: gen var_res`1'80=var_res`1'[1]+change_res
	
* Construct variances holding quantities and prices at the same values of the 80
egen mmm`1'80c=sum(tot`1'80*mm`1'80)
egen var_Q`1'80c=sum((mm`1'80-mmm`1'80c)^2*tot`1'80)
egen var_obs`1'80c=sum(var_obs`1'80*tot`1'80)
egen var_res`1'80c=sum(var_res`1'80*tot`1'80)
gen var_tot`1'80c=var_obs`1'80c+var_res`1'80c+var_Q`1'80c

* Construct variances holding  prices at the same values of the 80
egen mmm`1'80p=sum(tot`1'*mm`1'80)
egen var_Q`1'80p=sum((mm`1'80-mmm`1'80p)^2*tot`1')
egen var_obs`1'80p=sum(var_obs`1'80*tot`1')
egen var_res`1'80p=sum(var_res`1'80*tot`1')
gen var_tot`1'80p=var_obs`1'80p+var_res`1'80p+var_Q`1'80p

* Construct variances holding quantities wrt city size at the same values of the 80
egen mmm`1'80qc=sum(tot`1'80*mm`1')
egen var_Q`1'80qc=sum((mm`1'-mmm`1'80qc)^2*tot`1'80)
egen var_obs`1'80qc=sum(var_obs`1'*tot`1'80)
egen var_res`1'80qc=sum(var_res`1'*tot`1'80)
gen var_tot`1'80qc=var_obs`1'80qc+var_res`1'80qc+var_Q`1'80qc

* Construct variances holding quantities at the same values of the 80
egen mmm`1'80q=sum(tot80*mm`1')
egen var_Q`1'80q=sum((mm`1'-mmm`1'80q)^2*tot80)
egen var_obs`1'80q=sum(var_obs`1'*tot80)
egen var_res`1'80q=sum(var_res`1'*tot80)
gen var_tot`1'80q=var_obs`1'80q+var_res`1'80q+var_Q`1'80q

sort Ddem size

save temp_citydem2,replace

end

citydem 80
citydem 90 
citydem "00" 
citydem "07"


capture program drop contruct_variances
program define contruct_variances

qui {
if `1' == 2 {
   use temp_city2,clear
}
if `1' == 3 {
   use temp_citydem2,clear
}
if `1' == 4 | `1' == 1 {
   use tempa3bis2,clear
}

if  `1' == 4 {
   gen var_Q8080c=0
   gen var_Q9080c=0
   gen var_Q0080c=0
   gen var_Q0780c=0
   gen var_Q8080p=0
   gen var_Q9080p=0
   gen var_Q0080p=0
   gen var_Q0780p=0
   gen var_Q8080q=0
   gen var_Q9080q=0
   gen var_Q0080q=0
   gen var_Q0780q=0
   gen var_Q8080qc=0
   gen var_Q9080qc=0
   gen var_Q0080qc=0
   gen var_Q0780qc=0
}

if `1' == 1 {
   n display("Actual Variances")
   n sum var_obs80 var_obs90 var_obs00 var_obs07 var_res80 var_res90 var_res00 var_res07 var_tot80 var_tot90 var_tot00 var_tot07 if _n==1, separator(0)
}

if `1' == 2 {
   n display("No Controls")
   n display("Absent City Size Effects on Prices and Quantities")
   n sum var_obs8080c var_obs9080c var_obs0080c var_obs0780c var_res8080c var_res9080c var_res0080c var_res0780c var_Q8080c var_Q9080c var_Q0080c var_Q0780c var_tot8080c var_tot9080c var_tot0080c var_tot0780c if _n==1, separator(0)
}

if `1' > 2 {
   if `1' == 3 {
      n display("Demographic Controls")
   }
   if `1' == 4 {
      n display("Demographic and Industry Controls")
   }

   n display("Absent City Size Effects on Quantities Only")
   n sum var_obs8080qc var_obs9080qc var_obs0080qc var_obs0780qc var_res8080qc var_res9080qc var_res0080qc var_res0780qc var_Q8080qc var_Q9080qc var_Q0080qc var_Q0780qc var_tot8080qc var_tot9080qc var_tot0080qc var_tot0780qc if _n==1, separator(0)

   n display("Absent City Size Effects on Prices and Quantities")
   n sum var_obs8080c var_obs9080c var_obs0080c var_obs0780c var_res8080c var_res9080c var_res0080c var_res0780c var_Q8080c var_Q9080c var_Q0080c var_Q0780c var_tot8080c var_tot9080c var_tot0080c var_tot0780c if _n==1, separator(0)

   n display("Absent City Size Effects on Prices Only (Unreported)")
   n sum var_obs8080p var_obs9080p var_obs0080p var_obs0780p var_res8080p var_res9080p var_res0080p var_res0780p var_Q8080p var_Q9080p var_Q0080p var_Q0780p var_tot8080p var_tot9080p var_tot0080p var_tot0780p if _n==1, separator(0)

   n display("Using 1980 Quantities, No Price Adjustment (Unreported)")
   n sum var_obs8080q var_obs9080q var_obs0080q var_obs0780q var_res8080q var_res9080q var_res0080q var_res0780q var_Q8080q var_Q9080q var_Q0080q var_Q0780q var_tot8080q var_tot9080q var_tot0080q var_tot0780q, separator(0)

}


}
end

contruct_variances 1
contruct_variances 2
contruct_variances 3
contruct_variances 4

log c


erase temp_citydem2.dta
erase temp_city2.dta 
erase tempa3bis2.dta
erase obs-res002.dta
erase obs-res072.dta
erase obs-res802.dta
erase obs-res902.dta

