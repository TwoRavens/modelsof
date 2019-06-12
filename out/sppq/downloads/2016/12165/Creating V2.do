* NOTE: Replace the file path before each .dta file in every "use," "save," and "merge" command with the local directory where these replication files are stored.  
*Start with the data from Gentzkow, Shapiro, and Sinkinson's replication file for their AER article.
use "Gentzkow, Shapiro, and Sinkinson Replication Files.dta"
keep if state=="PA"
keep if year<=1948
keep if year>=1876
keep year cnty90 preseligible prestout
save "Turnout and Eligible.dta"
clear
*Now add circulation figures from Gentzkow and Shapiro's newspaper data (ICPSR Study Number 30261).
*You must download these data from ICPSR first and save them to the same file where the other data from this study are located. 
use "30261-0007-Data.dta"
merge m:1 CITYPERMID using "30261-0006-Data.dta"
keep if STATE=="PENNSYLVANIA"
keep if YEAR<=1948
keep if YEAR>=1876
replace CIRC_POLAFF_R=0 if CIRC_POLAFF_R==.
replace CIRC_POLAFF_D=0 if CIRC_POLAFF_D==.
collapse (sum) CIRC_POLAFF_R CIRC_POLAFF_D, by(CNTY90 YEAR)
gen TotalPartyCirc= CIRC_POLAFF_R + CIRC_POLAFF_D
*Logged total circulation of party-affiliated newspapers within a county. 
gen lnTotPartyCirc=ln(TotalPartyCirc + 1)
keep YEAR CNTY90 lnTotPartyCirc
rename YEAR year 
rename CNTY90 cnty90
save "Party Newspaper Circulation.dta"
merge 1:1 cnty90 year using "Turnout and Eligible.dta"
replace lnTotPartyCirc=0 if lnTotPartyCirc==.
drop _merge
*Add the variable gauging the coverage of voter registration within each county. This measure was collected from various editions of Smull's Legislative Handbook and Manual of the State of Pennsylvania. 
merge 1:1 cnty90 year using "Voter Registration Variable.dta" 
drop _merge
*Creating the interaction term. 
gen LnPartyCircXReg=lnTotPartyCirc*reg
*Logging the number of eligible voters within each county.
gen LnPresEligible=ln(preseligible)
*Creating the lagged presidential turnout variable. 
by cnty90: gen lagprestout=prestout[_n-1]
*Creating the time trend variable.
gen timetrend=1 if year==1876
replace timetrend=2 if year==1880
replace timetrend=3 if year==1884
replace timetrend=4 if year==1888
replace timetrend=5 if year==1892
replace timetrend=6 if year==1896
replace timetrend=7 if year==1900
replace timetrend=8 if year==1904
replace timetrend=9 if year==1908
replace timetrend=10 if year==1912
replace timetrend=11 if year==1916
replace timetrend=12 if year==1920
replace timetrend=13 if year==1924
replace timetrend=14 if year==1928
replace timetrend=15 if year==1932
replace timetrend=16 if year==1936
replace timetrend=17 if year==1940
replace timetrend=18 if year==1944
replace timetrend=19 if year==1948

*Australian ballot dummy.
gen AustralianBallot=1 if timetrend>4
replace AustralianBallot=0 if AustralianBallot==.
*Party column dummy.
gen PartyColumn=1 if timetrend>5 & timetrend<8
replace PartyColumn=0 if PartyColumn==.
*Office block dummy.
gen OfficeBlock=1 if timetrend>7
replace OfficeBlock=0 if OfficeBlock==.
*Direct primary dummy.
gen DirectPrimary=1 if timetrend>8
replace DirectPrimary=0 if DirectPrimary==.
*Dunn Act dummy.
gen DunnAct=1 if timetrend>12
replace DunnAct=0 if DunnAct==.
*19th Amendment dummy.
gen Women=1 if timetrend>11
replace Women=0 if Women==.
*Taxpaying requrement dummy.
gen NoTax=1 if timetrend>15
replace NoTax=0 if NoTax==.
*Senate election year dummy.
gen SenateElection=1 if year==1916|year==1928|year==1940
replace SenateElection=0 if SenateElection==.
save "No Demographics.dta"
clear
*Now dealing with the census demographics. 
*You must download these data from ICPSR first and save them to the same file where the other data from this study are located. 
use "02896-0011-Data.dta"
keep if state==14
*1870 Numerators and Denominators.
gen ManuOutput1870=mfgout
gen White1870=whtot
gen Male1870=m21tot
gen PopCity25k1870=urb25
gen TotPop1870=totpop
gen PopTown1870=urb870
keep county name fips ManuOutput1870 White1870 Male1870 PopCity25k1870 TotPop1870 PopTown1870
save "Census1870.dta"
clear
use "02896-0015-Data.dta" 
keep if state==14
*1880 Numerators and Denominator.
gen PopTown1880=urb880
gen Male1880=m21tot
gen PopCity25k1880=urb25
gen White1880=whtot
gen TotPop1880=totpop
gen ManuOutput1880=mfgout
keep county name fips ManuOutput1880 White1880 Male1880 PopCity25k1880 TotPop1880 PopTown1880
save "Census1880.dta"
clear
use "02896-0018-Data.dta"
keep if state==14
*1890 Numerators and Denominator.
gen PopTown1890=urb890
gen Male1890= nbwm21 + fbwm21 + colm21
gen PopCity25k1890=urb25
gen White1890=whtot
gen TotPop1890=totpop
gen ManuOutput1890=mfgout
keep county name fips ManuOutput1890 White1890 Male1890 PopCity25k1890 TotPop1890 PopTown1890
save "Census1890.dta"
clear
use "02896-0020-Data.dta"
keep if state==14
*1900 Numerators and Denominator.
gen PopTown1900=urb900
gen Male1900=m21
gen PopCity25k1900=urb25
gen White1900=whtot
gen TotPop1900=totpop
gen ManuOutput1900=mfgout
keep county name fips ManuOutput1900 White1900 Male1900 PopCity25k1900 TotPop1900 PopTown1900
save "Census1900.dta"
clear
use "02896-0022-Data.dta"
keep if state==14
*1910 Numerators and Denominator.
gen PopTown1910=urb1910
gen Male1910=mvote
gen PopCity25k1910=urb25
gen White1910=whtot
gen TotPop1910=totpop
gen ManuOutput1910=-1
keep county name fips ManuOutput1910 White1910 Male1910 PopCity25k1910 TotPop1910 PopTown1910
save "Census1910.dta"
clear
use "02896-0024-Data.dta"
keep if state==14
*1920 Numerators and Denominator.
gen PopTown1920=urb920
gen Male1920=m21
gen PopCity25k1920=urb25
gen White1920=whtot
gen TotPop1920=totpop
gen ManuOutput1920=mfgout
keep county name fips ManuOutput1920 White1920 Male1920 PopCity25k1920 TotPop1920 PopTown1920
save "Census1920.dta"
clear
use "02896-0026-Data.dta" 
keep if state==14
*1930 Numerators and Denominator.
gen PopTown1930=urb930
gen Male1930=m21
gen PopCity25k1930=urb25
gen White1930=whtot
gen TotPop1930=totpop
gen ManuOutput1930=mfgout
keep county name fips ManuOutput1930 White1930 Male1930 PopCity25k1930 TotPop1930 PopTown1930
save "Census1930.dta"
clear
use "02896-0032-Data.dta"
keep if state==14
*1940 Numerators and Denominator.
gen PopTown1940=urb940
gen Male1940=m21
gen PopCity25k1940=urb25
gen White1940=whtot
gen TotPop1940=totpop
gen ManuOutput1940=mfgout
keep county name fips ManuOutput1940 White1940 Male1940 PopCity25k1940 TotPop1940 PopTown1940
save "Census1940.dta"
clear
use "02896-0035-Data.dta"
keep if state==14
*1950 Numerators and Denominator.
gen PopTown1950=urb950
gen Male1950=m25
gen PopCity25k1950=urb25
gen White1950= nwmtot + fbwmtot + nwftot + fbwftot
gen TotPop1950=totpop
gen ManuOutput1950=-1
keep county name fips ManuOutput1950 White1950 Male1950 PopCity25k1950 TotPop1950 PopTown1950
save "Census1950.dta"
clear
*Merging the census files.
use "Census1870.dta"
merge 1:1 fips using "Census1880.dta"
drop _merge
merge 1:1 fips using "Census1890.dta"
drop _merge
merge 1:1 fips using "Census1900.dta"
drop _merge
merge 1:1 fips using "Census1910.dta"
drop _merge
merge 1:1 fips using "Census1920.dta"
drop _merge
merge 1:1 fips using "Census1930.dta"
drop _merge
merge 1:1 fips using "Census1940.dta"
drop _merge
merge 1:1 fips using "Census1950.dta"
drop _merge
*Linear Interpolation.
gen PopTown1876=[(PopTown1880-PopTown1870)/10]*6 + PopTown1870
gen PopTown1884=[(PopTown1890-PopTown1880)/10]*4 + PopTown1880
gen PopTown1888=[(PopTown1890-PopTown1880)/10]*8 + PopTown1880
gen PopTown1892=[(PopTown1900-PopTown1890)/10]*2 + PopTown1890
gen PopTown1896=[(PopTown1900-PopTown1890)/10]*6 + PopTown1890
gen PopTown1904=[(PopTown1910-PopTown1900)/10]*4 + PopTown1900
gen PopTown1908=[(PopTown1910-PopTown1900)/10]*8 + PopTown1900
gen PopTown1912=[(PopTown1920-PopTown1910)/10]*2 + PopTown1910
gen PopTown1916=[(PopTown1920-PopTown1910)/10]*6 + PopTown1910
gen PopTown1924=[(PopTown1930-PopTown1920)/10]*4 + PopTown1920
gen PopTown1928=[(PopTown1930-PopTown1920)/10]*8 + PopTown1920
gen PopTown1932=[(PopTown1940-PopTown1930)/10]*2 + PopTown1930
gen PopTown1936=[(PopTown1940-PopTown1930)/10]*6 + PopTown1930
gen PopTown1944=[(PopTown1950-PopTown1940)/10]*4 + PopTown1940
gen PopTown1948=[(PopTown1950-PopTown1940)/10]*8 + PopTown1940

gen TotPop1876=[(TotPop1880-TotPop1870)/10]*6 + TotPop1870 
gen TotPop1884=[(TotPop1890-TotPop1880)/10]*4 + TotPop1880
gen TotPop1888=[(TotPop1890-TotPop1880)/10]*8 + TotPop1880
gen TotPop1892=[(TotPop1900-TotPop1890)/10]*2 + TotPop1890
gen TotPop1896=[(TotPop1900-TotPop1890)/10]*6 + TotPop1890
gen TotPop1904=[(TotPop1910-TotPop1900)/10]*4 + TotPop1900
gen TotPop1908=[(TotPop1910-TotPop1900)/10]*8 + TotPop1900
gen TotPop1912=[(TotPop1920-TotPop1910)/10]*2 + TotPop1910
gen TotPop1916=[(TotPop1920-TotPop1910)/10]*6 + TotPop1910
gen TotPop1924=[(TotPop1930-TotPop1920)/10]*4 + TotPop1920
gen TotPop1928=[(TotPop1930-TotPop1920)/10]*8 + TotPop1920
gen TotPop1932=[(TotPop1940-TotPop1930)/10]*2 + TotPop1930
gen TotPop1936=[(TotPop1940-TotPop1930)/10]*6 + TotPop1930
gen TotPop1944=[(TotPop1950-TotPop1940)/10]*4 + TotPop1940
gen TotPop1948=[(TotPop1950-TotPop1940)/10]*8 + TotPop1940

gen PopCity25k1876=[(PopCity25k1880-PopCity25k1870)/10]*6 + PopCity25k1870
gen PopCity25k1884=[(PopCity25k1890-PopCity25k1880)/10]*4 + PopCity25k1880
gen PopCity25k1888=[(PopCity25k1890-PopCity25k1880)/10]*8 + PopCity25k1880
gen PopCity25k1892=[(PopCity25k1900-PopCity25k1890)/10]*2 + PopCity25k1890
gen PopCity25k1896=[(PopCity25k1900-PopCity25k1890)/10]*6 + PopCity25k1890
gen PopCity25k1904=[(PopCity25k1910-PopCity25k1900)/10]*4 + PopCity25k1900
gen PopCity25k1908=[(PopCity25k1910-PopCity25k1900)/10]*8 + PopCity25k1900
gen PopCity25k1912=[(PopCity25k1920-PopCity25k1910)/10]*2 + PopCity25k1910
gen PopCity25k1916=[(PopCity25k1920-PopCity25k1910)/10]*6 + PopCity25k1910
gen PopCity25k1924=[(PopCity25k1930-PopCity25k1920)/10]*4 + PopCity25k1920
gen PopCity25k1928=[(PopCity25k1930-PopCity25k1920)/10]*8 + PopCity25k1920
gen PopCity25k1932=[(PopCity25k1940-PopCity25k1930)/10]*2 + PopCity25k1930
gen PopCity25k1936=[(PopCity25k1940-PopCity25k1930)/10]*6 + PopCity25k1930
gen PopCity25k1944=[(PopCity25k1950-PopCity25k1940)/10]*4 + PopCity25k1940
gen PopCity25k1948=[(PopCity25k1950-PopCity25k1940)/10]*8 + PopCity25k1940

gen Male1876=[(Male1880-Male1870)/10]*6 + Male1870
gen Male1884=[(Male1890-Male1880)/10]*4 + Male1880
gen Male1888=[(Male1890-Male1880)/10]*8 + Male1880
gen Male1892=[(Male1900-Male1890)/10]*2 + Male1890
gen Male1896=[(Male1900-Male1890)/10]*6 + Male1890
gen Male1904=[(Male1910-Male1900)/10]*4 + Male1900
gen Male1908=[(Male1910-Male1900)/10]*8 + Male1900
gen Male1912=[(Male1920-Male1910)/10]*2 + Male1910
gen Male1916=[(Male1920-Male1910)/10]*6 + Male1910
gen Male1924=[(Male1930-Male1920)/10]*4 + Male1920
gen Male1928=[(Male1930-Male1920)/10]*8 + Male1920
gen Male1932=[(Male1940-Male1930)/10]*2 + Male1930
gen Male1936=[(Male1940-Male1930)/10]*6 + Male1930
gen Male1944=[(Male1950-Male1940)/10]*4 + Male1940
gen Male1948=[(Male1950-Male1940)/10]*8 + Male1940

gen White1876=[(White1880-White1870)/10]*6 + White1870
gen White1884=[(White1890-White1880)/10]*4 + White1880
gen White1888=[(White1890-White1880)/10]*8 + White1880
gen White1892=[(White1900-White1890)/10]*2 + White1890
gen White1896=[(White1900-White1890)/10]*6 + White1890
gen White1904=[(White1910-White1900)/10]*4 + White1900
gen White1908=[(White1910-White1900)/10]*8 + White1900
gen White1912=[(White1920-White1910)/10]*2 + White1910
gen White1916=[(White1920-White1910)/10]*6 + White1910
gen White1924=[(White1930-White1920)/10]*4 + White1920
gen White1928=[(White1930-White1920)/10]*8 + White1920
gen White1932=[(White1940-White1930)/10]*2 + White1930
gen White1936=[(White1940-White1930)/10]*6 + White1930
gen White1944=[(White1950-White1940)/10]*4 + White1940
gen White1948=[(White1950-White1940)/10]*8 + White1940

gen ManuOutput1876=[(ManuOutput1880-ManuOutput1870)/10]*6 + ManuOutput1870
gen ManuOutput1884=[(ManuOutput1890-ManuOutput1880)/10]*4 + ManuOutput1880
gen ManuOutput1888=[(ManuOutput1890-ManuOutput1880)/10]*8 + ManuOutput1880
gen ManuOutput1892=[(ManuOutput1900-ManuOutput1890)/10]*2 + ManuOutput1890
gen ManuOutput1896=[(ManuOutput1900-ManuOutput1890)/10]*6 + ManuOutput1890
gen ManuOutput1904=[(ManuOutput1920-ManuOutput1900)/20]*4 + ManuOutput1900
gen ManuOutput1908=[(ManuOutput1920-ManuOutput1900)/20]*8 + ManuOutput1900
gen ManuOutput1912=[(ManuOutput1920-ManuOutput1900)/20]*12 + ManuOutput1900
gen ManuOutput1916=[(ManuOutput1920-ManuOutput1900)/20]*16 + ManuOutput1900
gen ManuOutput1924=[(ManuOutput1930-ManuOutput1920)/20]*4 + ManuOutput1920
gen ManuOutput1928=[(ManuOutput1930-ManuOutput1920)/20]*8 + ManuOutput1920
gen ManuOutput1932=[(ManuOutput1940-ManuOutput1930)/20]*2 + ManuOutput1930
gen ManuOutput1936=[(ManuOutput1940-ManuOutput1930)/20]*6 + ManuOutput1930
gen ManuOutput1944=-1
gen ManuOutput1948=-1

reshape long PopTown TotPop PopCity25k Male White ManuOutput, i(fips) j(year)

drop if county==0
drop if year==1870|year==1890|year==1910|year==1930|year==1950
replace ManuOutput=-1 if ManuOutput==.
*Leave out Lackawanna as it was not a county yet in 1876.
replace ManuOutput=. if name=="LACKAWANNA" & year==1876
gen MisManuOutput=1 if ManuOutput==-1
replace MisManuOutput=0 if MisManuOutput==.
gen PerCapitaManu=ManuOutput/TotPop
replace PerCapitaManu=-1 if MisManuOutput==1
gen SharePopWhite=White/TotPop
gen ShareMale=Male/TotPop
gen ShareTowns=PopTown/TotPop
gen ShareCity=PopCity25k/TotPop
gen LogPerCapitaManu=ln(PerCapitaManu) if PerCapitaManu>-1
replace LogPerCapitaManu=-1 if PerCapitaManu==-1
gen LnPCMMissing=LogPerCapitaManu
replace LnPCMMissing=. if LnPCMMissing==-1
keep fips year  MisManuOutput SharePopWhite ShareMale ShareTowns ShareCity LogPerCapitaManu LnPCMMissing
rename fips cnty90
save "Demographics.dta"
clear
use "No Demographics.dta"
merge 1:1 cnty90 year using "Demographics.dta"
drop _merge
save "Analysis File.dta"
