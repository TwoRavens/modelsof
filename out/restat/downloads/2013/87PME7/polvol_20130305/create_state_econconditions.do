#delimit;
clear;

*******http://www.bls.gov/lau/ , takes some figuring out to get it; 
insheet using "$startdir/$inputdata\BLS state unemployment.txt", delimiter(,);
drop if annual1976=="No Data Available";
destring annual1976, replace;

renpfix annual unemp;
drop unemp2010;
gen stat=substr(seriesid, -2,2);
gen fips=substr(seriesid,6,2);
keep if stat=="03";
drop stat seriesid;

reshape long unemp, i(fips) j(year);
destring fips, replace;
label values fips statefiplbl;
sort fips;
replace unemp=unemp/100;
rename unemp stateunemp;
save "$startdir/$outputdata\stateunemployment.dta", replace;


**state personal income;
**this is downloaded "summary" series on BEA website, not altered whatsoever;
insheet using "$startdir/$inputdata\spi_download.csv", clear;
drop areaname;
keep if personalincome=="100";
drop personalincome;
forvalues i=4/83{;
local y=1925+`i';
*di "`y'";
rename v`i' Y`y';
}; 
destring fips, replace;
drop if fips==0 | fips>90;
forvalues y=1929/1949{;
quietly replace Y`y'="" if Y`y'=="(N)";
quietly destring Y`y', replace;
};
tostring fips, replace format(%02.0f);
merge fips using "$startdir/$outputdata\fipscodes.dta", sort;
reshape long Y, i(fips);
drop shortfips state postal bpl censusregion _merge;
rename _j year;
rename Y spi;
destring fips, replace;
sort year fips;
save "$startdir/$outputdata\statepersonalincome_19292008.dta", replace;



clear;
set memory 100m;
use "$startdir/$outputdata\population.dta";
sort fips year;

by fips: gen Np10yr=N[_n+1] if year+10==year[_n+1];
by fips: gen Np5yr=N[_n+1] if year+5==year[_n+1];

gen G=(Np10yr/N)^.1 if Np10yr!=.;
gen Gspecial=(Np5yr/N)^.2 if Np5yr!=.;

local k=9;
forvalues i=0/`k'{;
        gen Np`i'=N*G^`i';
};
drop G;

local k=5;
forvalues i=0/`k'{;
        gen Npspecial`i'=N*Gspecial^`i';
        replace Np`i'=Npspecial`i' if Np`i'==. & year>=2000;
};
drop Gspecial Npspecial*;

replace Np0 = N if Np0==. & N!=.;
drop N;
reshape long Np,i(fips year) j(yearend);
replace Np=0 if year==2005;
rename Np N;

drop if N==0;
drop if year==2000 & yearend>5;

replace year=year+yearend;
collapse (max) N, by(fips year);
sort fips year;
drop if N==.;
save "$startdir/$outputdata\smoothedpopulation.dta", replace;
clear;

*http://www.bea.gov/regional/gsp/default.cfm?series=SIC;
*load separately 1963-1997 and 1997-2008;
*note that this is downloaded.  Only change is a Y insterted before years on first line before insheet;
insheet using  "$startdir/$inputdata\gspall_c_19631997.csv", names;
destring code, replace;
keep if code==0; *note code differs across datasets;
destring y*, replace;
drop component industry id region code;
destring fips, replace;
recast int fips;
reshape long y,i(fips) j(year);
rename y gdp;
gen gdpdef="sic";
sort fips year;
save "$startdir/$outputdata\stateeconconditions_19631997.dta", replace;
clear;


insheet using  "$startdir/$inputdata\gspall_c_19972007.csv", names;
destring code, replace;
keep if code==1;  *note code differs across datasets;
destring y*, replace;
drop component industry id region code;
destring fips, replace;
recast int fips;
reshape long y,i(fips) j(year);
rename y gdp;
gen gdpdef="naics";
sort fips year;
save "$startdir/$outputdata\stateeconconditions_19972007.dta", replace;
clear;
use "$startdir/$outputdata\stateeconconditions_19631997.dta";
append using "$startdir/$outputdata\stateeconconditions_19972007.dta";
sort fips year gdpdef;
save "$startdir/$outputdata\stateeconconditions.dta", replace;

merge fips year using "$startdir/$outputdata\smoothedpopulation.dta";
sort year fips;
drop _merge;
merge year fips using "$startdir/$outputdata\statepersonalincome_19292008.dta";
sort year fips;
save "$startdir/$outputdata\stateeconconditions.dta", replace;



*correct for inflation using data at ftp://ftp.bls.gov/pub/special.requests/cpi/cpiai.txt;
clear;
insheet using "$startdir/$inputdata\cpiai.txt", tab;

rename avg cpi_1984is100;
keep year cpi_1984is100;
destring year, replace;
destring cpi_1984is100, replace;
gen factor=cpi_1984is100 if year==2000;
gsort- factor;
replace factor=factor[_n-1] if factor==.;
gen cpi_2000is100=cpi_1984is100/factor;
*double checked with info at http://oregonstate.edu/cla/polisci/faculty-research/sahr/sahr.htm under DOWNLOAD CONVERSION FACTORS;
rename cpi_2000is100 cpi;
keep year cpi;
drop if year<1929 | year>2005;
sort year;
merge year using "$startdir/$outputdata\stateeconconditions.dta", uniqmaster _merge(cpimerge);

gen nominalgdp=gdp;
gen nominalspi=spi;
replace gdp=gdp/cpi;
replace spi=spi/cpi; 




gen gdppp=gdp/N;
gen spipp=spi/N;
sort fips gdpdef year;
by fips gdpdef: gen dgdp=gdppp/gdppp[_n-1]-1 if year-1==year[_n-1];
by fips gdpdef: gen prob=1 if year-1!=year[_n-1];
sort fips year gdpdef;
replace dgdp=0 if year>=1891 & year<=1963;
drop if dgdp==.;

sort fips year;
by fips: gen dspi=spipp/spipp[_n-1]-1 if year-1==year[_n-1];
replace dspi=0 if year>=1891 & year<=1929;
keep fips year dgdp dspi N;

label values fips statefiplbl;
drop if fips>90 | fips==0;

merge fips year using "$startdir/$outputdata/stateunemployment.dta", sort;
drop if _merge==2;
drop _merge;

save "$startdir/$outputdata\stateeconconditions.dta", replace;
