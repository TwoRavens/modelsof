*Creates basic ELI-level dataset-- run this first
*Set current directory (change to correct path)
*cd "Replication\Paper_statistics\"

***This code reads in the CSV's containing the different ELI-month statistics, merges
*them all into one data set, cleans it, and implements the procedure to incorporate
*the pre-1998 ELI's that do not have a direct correspondence in the post-1998 
*classification. End result is "ELImonthstats.dta"


*Read in data (first 1977-1986)
*Observation and price change counts, average size, price dispersion statistics
*(all based only on observations for which price is available in current and previous
*month; we refer to these as one month changes) 
insheet using "BLS_datafiles\Freq77.csv", comma clear
sort elinew month
tempfile f77
save "`f77'"
*Average of price change squared and cubed
insheet using "BLS_datafiles\Size77.csv", comma clear
sort elinew month
tempfile s77
save "`s77'"
*Same as "Freq77", but all based on observations for which price is available for
*current month and two months before (two month changes)
insheet using "BLS_datafiles\Freqbi77.csv", comma clear
foreach x of varlist freqns fracupns obsns absns changesns changesupns freq obs abs changes absupns absdwns {
rename `x' `x'bi
}
sort elinew month
merge 1:1 elinew month using "`f77'"
drop _merge
merge 1:1 elinew month using "`s77'"
drop _merge
drop _type_ _freq_ fracsmallns smallchangesns dispns fracsmall smallchanges dispupns dispdwns
*Match previously unmatched old ELI's to new classification
replace elinew = "FV001" if elinew == "19011"
replace elinew = "FV002" if elinew == "19021"
replace elinew = "FV003" if elinew == "19031"
replace elinew = "FV004" if elinew == "19032"
replace elinew = "MA011" if elinew == "54053"
destring elinew, force generate(eliold)
drop if eliold ~= .
drop if substr(elinew,1,3) == "ELI"
drop eliold
sort elinew
*Keep only observations starting in 1977, and create month and year variables
drop if elinew == "" | month == . | month < 7701
rename elinew eli
tostring month, replace
gen m = substr(month,3,2)
gen year = substr(month,1,2)
destring m year, replace
replace year = year + 1900
drop month
rename m month
destring month, replace
sort eli year month
tempfile stats77
save "`stats77'"


*Files correspond to same statistics as above, but all for modern sample of the data set
insheet using "BLS_datafiles\Freq88.csv", comma clear
sort eli year month
tempfile f88
save "`f88'"
insheet using "BLS_datafiles\Size88.csv", comma clear
sort eli year month
tempfile s88
save "`s88'"
insheet using "BLS_datafiles\Freqbi88.csv", comma clear
foreach x of varlist freqns fracupns obsns absns changesns changesupns freq obs abs changes absupns absdwns {
rename `x' `x'bi
}
sort eli year month
merge 1:1 eli year month using "`f88'"
drop _merge
merge 1:1 eli year month using "`s88'"
drop _merge _type_ _freq_ fracsmallns smallchangesns dispns fracsmall smallchanges dispupns dispdwns

*Match previously unmatched old ELI's to new classification
replace eli = "FV001" if eli == "19011"
replace eli = "FV002" if eli == "19021"
replace eli = "FV003" if eli == "19031"
replace eli = "FV004" if eli == "19032"
replace eli = "HM022" if eli == "24043"
replace eli = "HK023" if eli == "30033"
replace eli = "TB022" if eli == "47018"
replace eli = "TA041" if eli == "52056"
replace eli = "HZ011" if eli == "72601"
sort eli
drop if eli == "" | month == .
sort eli year month
append using "`stats77'"
sort eli year month
merge m:1 eli using "working\weight98.dta"
drop if _merge ~= 3
drop _merge 
gen frequpns = fracupns*freqns
gen freqdwns = (1-fracupns)*freqns
gen frequpnsbi = fracupnsbi*freqnsbi
gen freqdwnsbi = (1-fracupnsbi)*freqnsbi
replace frequpns = 0 if freqns == 0
replace freqdwns = 0 if freqns == 0
replace frequpnsbi = 0 if freqnsbi == 0
replace freqdwnsbi = 0 if freqnsbi == 0

*Some ELI's under the new classification correspond to more than one ELI under the 
*new classification. To obtain ELI-month statistics under the new classification,
*we express each variable as a sum (when it's an observation count), or as an
*average across the ELI's (old classification) that correspond to each new classification ELI.
*The following steps accomplish this by first summing across ELI's, and then 
*dividing by the total number of observations.
*Different variables have different observation counts pertaining to them; and 
*most are named accordingly. The main exception is obs, which is the number of 
*cases for which the price in the current and previous month are non-missing (and 
*it can therefore be determined whether there was a price change between those two
*months). Obsns is the same, but in addition neither the current nor past month's
*prices are temporary sales.
by eli year month, sort: egen sales = sum((pobsall-pobsnsall))
by eli year month, sort: egen obs2 = sum(obs)
by eli year month, sort: egen pobsall2 = sum(pobsall)
by eli year month, sort: egen pobs2 = sum(pobs)
by eli year month, sort: egen pobsns2 = sum(pobsns)
by eli year month, sort: egen sobsns = sum(obsns)
by eli year month, sort: egen fss = sum(freqs*obs)
by eli year month, sort: egen fs = sum(freqns*obsns)
by eli year month, sort: egen fus = sum(frequpns*obsns)
by eli year month, sort: egen fds = sum(freqdwns*obsns)
by eli year month, sort: egen schanges = sum(changes)
by eli year month, sort: egen schangesns = sum(changesns)
by eli year month, sort: egen schangesupns = sum(changesupns)
by eli year month, sort: egen sabsns = sum(absns*changesns)
by eli year month, sort: egen sabsupns = sum(absupns*changesupns)
by eli year month, sort: egen sabsdwns = sum(absdwns*(changesns-changesupns))
by eli year month, sort: egen sobs = sum(sizeobs)
by eli year month, sort: egen s1s = sum(size1*sizeobs)
by eli year month, sort: egen s2s = sum(size2*sizeobs)
by eli year month, sort: egen s3s = sum(size3*sizeobs)
by eli year month, sort: egen sobsn = sum(sizeobsnobim)
by eli year month, sort: egen s1ns = sum(size1nobim*sizeobsnobim)
by eli year month, sort: egen s2ns = sum(size2nobim*sizeobsnobim)
by eli year month, sort: egen s3ns = sum(size3nobim*sizeobsnobim)
by eli year month, sort: egen dispnss = sum(pricedispns*pobsns)
by eli year month, sort: egen disps = sum(pricedisp*pobs)
by eli year month, sort: egen dispalls = sum(pricedispall*pobsall)
by eli year month, sort: egen iqrnss = sum(priceiqrns*pobsns)
by eli year month, sort: egen iqrs = sum(priceiqr*pobs)
by eli year month, sort: egen iqralls = sum(priceiqrall*pobsall)
by eli year month, sort: egen sobsnsbi = sum(obsnsbi)
by eli year month, sort: egen fsbi = sum(freqnsbi*obsnsbi)
by eli year month, sort: egen fusbi = sum(frequpnsbi*obsnsbi)
by eli year month, sort: egen fdsbi = sum(freqdwnsbi*obsnsbi)

gen freqsale = sales/pobsall2
gen freqs2 = fss/obs2
gen freqns2 = fs/sobsns
gen frequpns2 = fus/sobsns
gen freqdwns2 = fds/sobsns
gen absns2 = sabsns/schangesns
gen absupns2 = sabsupns/schangesupns
gen absdwns2 = sabsdwns/(schangesns-schangesupns)
gen size1t = s1s/sobs
gen size2t = s2s/sobs
gen size3t = s3s/sobs
gen size1nobimt = s1ns/sobsn
gen size2nobimt = s2ns/sobsn
gen size3nobimt = s3ns/sobsn
gen pricedispns2 = dispnss/pobsns2
gen pricedisp2 = disps/pobs2
gen pricedispall2 = dispalls/pobsall2
gen priceiqrns2 = iqrnss/pobsns2
gen priceiqr2 = iqrs/pobs2
gen priceiqrall2 = iqralls/pobsall2
gen freqnsbi2 = fsbi/sobsnsbi
gen frequpnsbi2 = fusbi/sobsnsbi
gen freqdwnsbi2 = fdsbi/sobsnsbi
by eli year month: keep if _n ==1
drop freqs freqns frequpns freqdwns absns absupns absdwns obsns changesns changes changesupns fs ///
	fus fds sabsns sabsupns sabsdwns size1 size2 size3 size1nobim size2nobim ///
	size3nobim  freqnsbi frequpnsbi freqdwnsbi s1s s2s s3s sizeobs s1ns s2ns s3ns sizeobsnobim  ///
	fsbi fusbi fdsbi obsnsbi obs pobsall pricedispns pricedisp pricedispall priceiqrns ///
	priceiqr priceiqrall pobs pobsns dispnss disps dispalls iqrnss iqrs iqralls 
rename freqs2 freqs
rename freqns2 freqns
rename frequpns2 frequpns
rename freqdwns2 freqdwns
rename absns2 absns
rename absupns2 absupns
rename absdwns2 absdwns
rename sobsns obsns
rename schanges changes
rename schangesns changesns
rename schangesupns changesupns
rename size1t size1
rename size2t size2
rename size3t  size3
rename size1nobimt size1nobim
rename size2nobimt  size2nobim
rename size3nobimt  size3nobim
rename sobs sizeobs 
rename sobsn sizeobsnobim
rename freqnsbi2 freqnsbi
rename frequpnsbi2 frequpnsbi
rename freqdwnsbi2 freqdwnsbi
rename sobsnsbi obsnsbi
rename obs2 obs
rename pobsall2 pobsall 
rename pobs2 pobs
rename pobsns2 pobsns
rename pricedispns2 pricedispns
rename pricedisp2 pricedisp 
rename pricedispall2 pricedispall
rename priceiqrall2 priceiqrall
rename priceiqrns2 priceiqrns
rename priceiqr2 priceiqr
gen SDabsns = sqrt(size2nobim - (absns^2))

gen date = ym(year,month)
format %tm date
sort eli
gen x = (eli ~= eli[_n-1])
gen elino = sum(x)
drop x
xtset elino date
gen totobs = obsns + obsnsbi
global freqs freqns frequpns freqdwns
*Adjusting bi-monthly frequenices to make them comparable with monthly
foreach x of global freqs {
gen `x'biadj = 1 - ((1-`x'bi)^(0.5))
gen `x'comb = (obsns/totobs)*`x' + (obsnsbi/totobs)*`x'biadj
replace `x'comb = `x' if `x'biadj == . & `x' ~= .
replace `x'comb = `x'biadj if `x' == . & `x'biadj ~= .
}
save "working\ELImonthstats.dta", replace

*Create Major group variable
  gen begeli = substr(eli,1,2)
  drop if begeli=="MX" | begeli=="HZ"

  gen eli1 = substr(eli,1,1)
  gen eli2 = substr(eli,1,2)
  gen eli4 = substr(eli,1,4)
  
  gen majgroup= .
  replace majgroup =0 if eli2 =="FA" | eli2== "FB" | eli4== "FG02" | eli4== "FJ02" | eli4 == "FJ03" | eli4 =="FJ04" | eli2== "FM" | eli4 == "FN01" | eli2== "FP" |      eli2 == "FR" | eli2 == "FS"| eli2 == "FT" | eli2 == "FW"  
  replace majgroup =1 if eli2 == "FC" | eli2 == "FD" | eli2 == "FE" | eli2 == "FF" |eli4 == "FG01" | eli2 == "FH" | eli4 == "FJ01" | eli2 == "FK" | eli2 == "FL" | eli4 == "FN02" | eli4 == "FN03"  
      
  replace majgroup =2 if eli1 == "H" & eli2 ~= "HB" & eli2 ~="HD" & eli2 ~="HG" & eli2 ~="HP" & eli2~="HE" & eli2 ~="HF" & eli2 ~="HZ"   
  replace majgroup=3 if eli1 == "A"  
  replace majgroup = 4 if eli1 == "T" & eli2 ~="TB" & eli2~="TD" & eli2 ~="TE" & eli2~="TF" & eli2~="TG" & eli~="TA041" & eli~="TA021" 
  replace majgroup = 5 if eli2 == "MA" | eli2 =="MB"
  replace majgroup = 6 if eli1 == "R" & eli2 ~="RF" & eli4 ~="RBO2" & eli4 ~="RD02" & eli4~="RD09" & eli4~="RE09"& eli~="RA021" & eli~="RA042" & eli4 ~="RB02"
  replace majgroup = 7 if eli1 == "E" & eli2 ~="EB" & eli2 ~="EC" & eli2 ~="ED"  
  replace majgroup = 8 if eli1 == "G" & eli2 ~="GC" & eli2 ~="GD"  
  replace majgroup = 9 if (eli2 == "FV" | eli2 =="FX" | eli2 =="HD" | eli2 =="HG" | eli2 =="HP" | eli2=="TD" | eli2 =="TE" | eli2=="TF" | eli2=="TG" | eli2 =="RF"  | eli4 =="RBO2" | eli4 =="RD02" | eli4=="RD09" | eli4=="RE09" | eli2 =="EB" | eli2 =="EC" | eli2 =="ED" | eli2 =="GC" | eli2 =="GD" | eli2 == "MC" | eli2 == "MD" | eli2 == "ME" | eli=="RA021" | eli=="RA042" | eli4=="RB02") & eli4 ~= "TG01" & eli4~="TG02"  
  replace majgroup = 10 if eli2 == "HE" | eli2 == "HF" | eli2 == "HZ"
  replace majgroup= 11 if eli2 == "TB"   
  replace majgroup = 12 if eli2 =="HB" | eli4 =="TG01" | eli4 =="TG02" | eli4 =="TA04" | (eli4 =="TA03" & eli~="TA031")
  drop begeli eli1 eli2 eli4
 by year month majgroup (eli), sort: egen obsnsmg = sum(totobs)
save "working\ELImonthstats.dta", replace

