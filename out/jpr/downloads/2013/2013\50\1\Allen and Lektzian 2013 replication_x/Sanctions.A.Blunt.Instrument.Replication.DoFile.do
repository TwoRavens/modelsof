* Replication do file for Allen and Lektzian "Economic sanctions: A blunt instrument?"
* The models all run using the dataset PHES.dta, which is included in the archive.

* Description of Dependent Variable Data Availability in text and in footnotes 3, 6, and 7.
bysort year: sum WHOGovHealExpPerGovExp
bysort year: sum FAOFoodSupply
bysort year: sum immindex
bysort year: sum WDILifeExpBirth
bysort year: sum hale

* Reproducing Tables from Paper
* Reproduce Table I
	sum WHOGovHealExpPerGovExp FAOFoodSupply immindex WDILifeExpBirth hale ///
	HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1  UCDPMinor25_999D1 ///
	HSESanYr UCDPConfYr sanconflict ///
	dem6 COWMajPow WDIPOPlog PWTopenklog WDIGDPPCConUSDlog  

* Reproduce Table II
* Model II.1
	xtgee lnFAOFoodSupply HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1  UCDPMinor25_999D1 ///
	dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog ,  corr(ar1) vce(robust) force

* Model II.2
	heckman lnFAOFoodSupply UCDPMaj_1000D UCDPMinor25_999D1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if FAOFoodSupply~=., ///
	select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
	SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Model II.3
	heckman lnFAOFoodSupply  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if FAOFoodSupply~=., ///
	select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
	ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Table III
* Model III.1
	xtgee lnimmindex HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1 UCDPMinor25_999D1 ///
	dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog ,  corr(ar1) vce(robust) force

* Model III.2
	heckman lnimmindex  UCDPMaj_1000D UCDPMinor25_999D1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if immindex~=., ///
	select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
	SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Model III.3
	heckman lnimmindex  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if immindex~=., ///
	select(UCDPConfYr= COWMajPow  dem6  WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
	ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Table IV
* Model IV.1
	xtgee lnWHOGovHealExpPerGovExp lHSEMajCostSanYr1 lUCDPMaj_1000D lHSEMinCostSanYr1 lUCDPMinor25_999D1 ///
	dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Model IV.2
	heckman lnWHOGovHealExpPerGovExp lUCDPMaj_1000D lUCDPMinor25_999D1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if WHOGovHealExpPerGovExp~=. , ///
	select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
	SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Model IV.3
	heckman lnWHOGovHealExpPerGovExp  lHSEMajCostSanYr1 lHSEMinCostSanYr1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if WHOGovHealExpPPP~=. , ///
	select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
	ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Table V
* Model V.1
	xtgee lnfWDILifeExpBirth HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1 UCDPMinor25_999D1 ///
	dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Model V.2
	heckman lnfWDILifeExpBirth  UCDPMaj_1000D UCDPMinor25_999D1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fWDILifeExpBirth~=., ///
	select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
	SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Model V.3
	heckman lnfWDILifeExpBirth  HSEMajCostSanYr1 HSEMinCostSanYr1  ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fWDILifeExpBirth~=., ///
	select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
	ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Table VI
* Model VI.1
	xtgee lnfhale HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1  UCDPMinor25_999D1 ///
	dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Model VI.2
	heckman lnfhale  UCDPMaj_1000D UCDPMinor25_999D1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fhale~=., ///
	select(HSESanYr = COWMajPow  dem6 WDIGDPPCConUSDlog PWTopenklog  UCDPConfYr ///
	SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Model VI.3
	heckman lnfhale  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
	dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fhale~=., ///
	select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
	ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Additional Tables from Online Appendix
* Reproduce Table 2: Model 1:
xtgee FAOFoodSupply HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1  UCDPMinor25_999D1 ///
dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog ,  corr(ar1) vce(robust) force

* Reproduce Table 2: Model 2:
heckman FAOFoodSupply UCDPMaj_1000D UCDPMinor25_999D1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if FAOFoodSupply~=., ///
select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Reproduce Table 2: Model 3:
heckman FAOFoodSupply  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if FAOFoodSupply~=., ///
select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 

* Reproduce Table 3: Model 1:
xtgee immindex HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1 UCDPMinor25_999D1 ///
dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog ,  corr(ar1) vce(robust) force

* Reproduce Table 3: Model 2:
heckman immindex  UCDPMaj_1000D UCDPMinor25_999D1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if immindex~=., ///
select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Reproduce Table 3: Model 3:
heckman immindex  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if immindex~=., ///
select(UCDPConfYr= COWMajPow  dem6  WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 


* Reproduce Table 4: Model 1:
xtgee WHOGovHealExpPerGovExp lHSEMajCostSanYr1 lUCDPMaj_1000D lHSEMinCostSanYr1 lUCDPMinor25_999D1 ///
dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Reproduce Table 4: Model 2:
heckman WHOGovHealExpPerGovExp lUCDPMaj_1000D lUCDPMinor25_999D1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if WHOGovHealExpPerGovExp~=. , ///
select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Reproduce Table 4: Model 3:
heckman WHOGovHealExpPerGovExp  lHSEMajCostSanYr1 lHSEMinCostSanYr1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if WHOGovHealExpPPP~=. , ///
select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 


* Reproduce Table 5: Model 1:
xtgee fWDILifeExpBirth HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1 UCDPMinor25_999D1 ///
dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Reproduce Table 5: Model 2:
heckman fWDILifeExpBirth  UCDPMaj_1000D UCDPMinor25_999D1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fWDILifeExpBirth~=., ///
select(HSESanYr = COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog UCDPConfYr ///
SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Reproduce Table 5: Model 3:
heckman fWDILifeExpBirth  HSEMajCostSanYr1 HSEMinCostSanYr1  ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fWDILifeExpBirth~=., ///
select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 


* Reproduce Table 6: Model 1:
xtgee fhale HSEMajCostSanYr1 UCDPMaj_1000D HSEMinCostSanYr1  UCDPMinor25_999D1 ///
dem6 WDIPOPlog PWTopenklog WDIGDPPCConUSDlog,  corr(ar1) vce(robust) force

* Reproduce Table 6: Model 2:
heckman fhale  UCDPMaj_1000D UCDPMinor25_999D1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fhale~=., ///
select(HSESanYr = COWMajPow  dem6 WDIGDPPCConUSDlog PWTopenklog  UCDPConfYr ///
SanYrpeaceyr SanYrSp1 SanYrSp2 SanYrSp3) vce(robust) 

* Reproduce Table 6: Model 3:
heckman fhale  HSEMajCostSanYr1 HSEMinCostSanYr1 ///
dem6  WDIPOPlog PWTopenklog WDIGDPPCConUSDlog if fhale~=., ///
select(UCDPConfYr= COWMajPow dem6 WDIGDPPCConUSDlog PWTopenklog HSESanYr ///
ConfYrpeaceyr ConfYrSp1 ConfYrSp2 ConfYrSp3) vce(robust) 













