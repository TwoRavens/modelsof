# delimit;

********************************************************************

makes pictures of streetcar ridership figures 

september 13, 2012
september 14, 2012
september 17, 2012
october 5, 2012     ** add part that makes table of population and ridership
march 1, 2013       ** adding new years of data that jack found and put in
march 2, 2013       ** more of same
march 4, 2013       ** more of same
june 17, 2014	    ** making assumptions to get a consistent PE series
august 2, 2017	    ** save dataset to make figures all in one program 

ridershipfigsv09.do

********************************************************************


****** A. set up **************************************************;

*** A.1. start up things ***;

clear all;
pause on;
set more off;
set linesize 140;

* set todays date;
adopath ++ /home/lfbrooks/ado;
dateo;

* make temporary directory *;
global temp "/scratch/streetcars";

*** A.2. load data ***;

* these data are typed in by ras jack & jessica hayes *;
* they are in a google xls *;
insheet using "/groups/brooksgrp/zoning/streetcar_stops/streetcar_ridership_data/2013-03-01_Streetcar_Ridership_Figures_nofirst.txt", tab;


****** B. clean up data ************************************************;

*** B.1. clean up year variable ***;

gen year=year_char;
tab year;


*** B.2. keep only relevant firms and totals ***;

* make names consistent *;
replace firm = "Angels Flight Railway Company"
  if firm == "Angel" | firm == "Angel Flight Railway Company";
replace firm = "Glendale and Montrose Railway"
  if firm == "Glendale and montrose Railway" | firm == "Glendale Montrose Railway";
replace firm = "Pacific Electric Railway Company"
  if firm == "Pacific Railway Electric Company";
replace firm = "Pacific Electric - Local Lines Rail" if firm == ")";

* keep only the relevant firms *;
keep if firm == "Angels Flight Railway Company" |
        firm == "Glendale and Montrose Railway" |
        firm == "Los Angeles Inter-urban Railway Company" |
        firm == "Los Angeles Pacific Company" |
        firm == "Los Angeles Railway Corporation" |
        firm == "Los Angeles Railway" |
        substr(firm,1,24) == "Los Angeles and Mt. Wash" |
        firm == "Los Angeles and Redondo Railway Company" |
        firm == "Pacific Electric" |
        firm == "Pacific Electric - Local Lines Rail";

* give firms numeric codes for easier use later *;
rename firm firm_name;

gen firm = 0;
replace firm = 1 if firm_name == "Angels Flight Railway Company";
replace firm = 2 if firm_name == "Glendale and Montrose Railway" ;
replace firm = 3 if firm_name == "Los Angeles Inter-urban Railway Company" ;
replace firm = 4 if firm_name == "Los Angeles Pacific Company" ;
replace firm = 5 if firm_name == "Los Angeles Railway Corporation";
replace firm = 6 if substr(firm_name,1,24) == "Los Angeles and Mt. Wash";
replace firm = 7 if firm_name == "Los Angeles and Redondo Railway Company" ;
replace firm = 8 if firm_name == "Pacific Electric";
replace firm = 10 if firm_name == "Los Angeles Railway";
replace firm = 11 if firm_name == "Pacific Electric - Local Lines Rail";

* drop multiple observations for the same firm in the same year *;
** la railway **;
* get rid of rr commission obs for LA Railway, since we always have info from another source *;
drop if firm == 5 & source == "Railroad Commission";
* these sources dont agree in early years, but do in later years *;
drop if firm == 10 & source == "Jenkins, 1940" & year >= 1920 & year <= 1924;

** pe (more tricky) **;
* the sources vary so much in ridership that ill just keep both and show both *;
*sort year firm;
*format rev_passengers %15.0gc;
*format transfer_passengers %15.0gc;
*format total_passengers %15.0gc;
*list firm firm_name year source rev_passengers transfer_passengers total_passengers if firm == 8 | firm == 11;

* save for next merge *;
sort year;
save ${temp}/stfirms, replace;

*** B.3. bring in county population *************;

* source notes for this are in excel file by same name *;
clear;
use /groups/brooksgrp/zoning/streetcar_stops/los_angeles_population_over_long_time/assembled_data/2012-09-14_la_cnty_and_c3ities_pop_1850_2000.dta;

* keep only la county and city population figures *;
keep year county_losangeles city_losangeles;
keep if year >= 1890 & year <= 1950;

* find decade differences *;
summ county_losangeles if year == 1910;
local m1910 = r(mean);
summ city_losangeles if year == 1910;
local m1910i = r(mean);
summ county_losangeles if year == 1920;
local m1920 = r(mean);
summ city_losangeles if year == 1920;
local m1920i = r(mean);
summ county_losangeles if year == 1930;
local m1930 = r(mean);
summ city_losangeles if year == 1930;
local m1930i = r(mean);
summ county_losangeles if year == 1940;
local m1940 = r(mean);
summ city_losangeles if year == 1940;
local m1940i = r(mean);
local diff12 = (`m1920' - `m1910')/10;
local diff23 = (`m1930' - `m1920')/10;
local diff34 = (`m1940' - `m1930')/10;
local diff12i = (`m1920i' - `m1910i')/10;
local diff23i = (`m1930i' - `m1920i')/10;
local diff34i = (`m1940i' - `m1930i')/10;


* make linear interpolation for population between census years *;
forvalues j=1/9
  {;
  * 1910 to 1920 *;
  local new = _N+1;
  set obs `new';
  gen obso = _n;
  replace year = 1910 + `j' if obso == `new';
  replace county_losangeles = `m1910' + `j'*`diff12' if obso == `new';
  replace city_losangeles = `m1910i' + `j'*`diff12i' if obso == `new';
  drop obso;
  * 1920 to 1930 *;
  local new = _N+1;
  set obs `new';
  gen obso = _n;
  replace year = 1920 + `j' if obso == `new';
  replace county_losangeles = `m1920' + `j'*`diff23' if obso == `new';
  replace city_losangeles = `m1920i' + `j'*`diff23i' if obso == `new';
  drop obso;
  * 1930 to 1940 *;
  local new = _N+1;
  set obs `new';
  gen obso = _n;
  replace year = 1930 + `j' if obso == `new';
  replace county_losangeles = `m1930' + `j'*`diff34' if obso == `new';
  replace city_losangeles = `m1930i' + `j'*`diff34i' if obso == `new';
  drop obso;
  };


* make half-year populations *;
capture program drop halfyr;
program define halfyr;

  syntax, inyr(string);

  * calculate second yr *;
  local outyr = `inyr' + 1;

  * first year *;
  summ county_losangeles if year == `inyr';
  local m`inyr' = r(mean);
  summ city_losangeles if year == `inyr';
  local m`inyr'i = r(mean);

  * second year *;
  summ county_losangeles if year == `outyr';
  local m`outyr' = r(mean);
  summ city_losangeles if year == `outyr';
  local m`outyr'i = r(mean);

  * make new obs and calculate *;
  local new = _N+1;
  set obs `new';
  gen obso = _n;
  replace year = `inyr' + 0.5 if obso == `new';
  replace county_losangeles = (`m`inyr'' + `m`outyr'')/2 if obso == `new';
  replace city_losangeles = (`m`inyr'i' + `m`outyr'i')/2 if obso == `new';
  drop obso;

end;

* call the program *;
halfyr, inyr(1912);
halfyr, inyr(1913);
halfyr, inyr(1914);
halfyr, inyr(1915);
halfyr, inyr(1916);

* rename *;
rename county_losangeles population;
label variable population "los angeles county population from census";
rename city_losangeles lacity_pop;
label variable lacity_pop "city of los angeles population from census";

* save for later merging (so we dont transpose it in the next step) *;
sort year;
save ${temp}/pops, replace;

* merge with passengers *;
sort year;
merge 1:m year using ${temp}/stfirms;
drop if _merge == 1;
drop _merge;

*** B.4. make consistent variables of interest ****;

* make consistent-ish passengers variable *;
gen passengers = total_passengers;
replace passengers = rev_passengers + transfer_passengers if total_passengers == .;

drop junk1 junk2;

* get rid of characters for average fare *;
destring average_fare, generate(average_fare_num) force;

* make some per capita things *;
gen pass_pc = passengers / population;
gen pass_rev_pc = pass_rev / population;

*** B.5. transpose for graphing ***;

keep firm year passengers average_fare_num pass_rev pass_pc pass_rev_pc;
replace passengers = passengers / 1000000;
label variable passengers "passengers in millions";
replace average_fare_num = average_fare_num * 100;
replace pass_rev = pass_rev / 1000000;
format passengers %18.0gc;
reshape wide passengers average_fare_num pass_rev pass_pc pass_rev_pc, i(year) j(firm);

* ado to label variables *;
capture program drop labo;
program define labo;

  syntax, varin(string) varind(string);

  * note that we dropped #5 above b/c it was a duplicate *;
  * #9 was state total that we dont have any more *;
  label variable `varin'1 "Angels Flight";
  label variable `varin'2 "Glendale & Montrose";
  label variable `varin'3 "LA Inter-urban RR";
  label variable `varin'4 "LA Pacific Co";
  label variable `varin'6 "LA & Mt. Washington RR";
  label variable `varin'7 "LA & Redondo RR Co";
  label variable `varin'8 "Pacific Electric";
  label variable `varin'10 "LA Railway";
  label variable `varin'11 "Pacific Electric - 1940 source";

end;

labo, varin(passengers)       varind(passengers);
labo, varin(average_fare_num) varind(av. fare);
labo, varin(pass_rev)         varind(passenger rev.);
labo, varin(pass_pc)          varind(passengers per capita);
labo, varin(pass_rev_pc)      varind(passenger rev. per capita);

* drop a few that have no data *;
* la inter-urban rr (3) angels flight (1) and la & mt wash (6) never have passenger #s *;
drop passengers3 passengers1 passengers6;
* never info for fares: *;
drop average_fare_num4 average_fare_num6 average_fare_num3 average_fare_num7;
* never info for passenger revenue *;
drop pass_rev6 pass_rev3;

*** B.6. merge back in the population by year now ****;

merge year using ${temp}/pops;
tab _merge;
drop _merge;

*** B.7 fix too-low PE numbers ***;

* there is a problem that the PE numbers from 1920 to 1940 are a lot lower
  than the PE numbers from 1910 to 1915.  it seems that this is due to 
  the fact that our source for 1920-1939 has only Pacific Electric -local lines- 
  and the source before has all lines. This was the only source we found (when we 
  looked into this before) for ridership on the Pacific Electric. *;
* we decide (see email to Byron dated 5/8/2014) to rescale-the later numbers to match
  the earlier numbers using the years of overlap *;
* looking at the data, the sources overlap in 1922, 1923 and 1924 *;

* calculate later numbers share of earlier number for those three years *;
gen latershr = pass_pc11 / pass_pc8;
* find average share for three years of overlapping data *;
summ latershr if year == 1922 | year == 1923 | year == 1924, detail;
local shr = r(mean);
* revise later data by this share (39 percent) *;
gen pass_pc11rev = pass_pc11 / `shr';

* make one series for both data *;
gen pass_pc12 = pass_pc8 if year < 1925;
replace pass_pc12 = pass_pc11rev if year >= 1925;
label variable pass_pc12 "Pacific Electric, two sources, adjusted";

* save this for use elsewhere *;
save /groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/data/${date}_ridership_data, replace;

* get rid of temporary data *;
shell rm ${temp}/*;

BREAK;

****** C. make some pictures *******************************************;

*** C.1. basic set up things ***;

graph set eps orientation landscape;

*** C.2. ado for stuff over time ***;

** this may behave differently now that (10/4) i added population for years that
   do not have ridership info **;

capture program drop stuffyr;
program define stuffyr;

  syntax, varin1(string) varin2(string) ytitl(string) grapht(string) subtitl(string);

  * without state totals *;
  graph twoway
    connected `varin1' year,
    ytitle("`ytitl'")
    subtitle(`subtitl')
    legend(size(medium))
    xsize(11) ysize(8.5);
  graph export "/href/brooks/home/bleah/zoning/streetcars/statafig/streetcar_ridership_over_time/${date}_`grapht'.eps",
    replace;

  * with state totals *;
  graph twoway
    connected `varin1' `varin2' year,
    ytitle("`ytitl'")
    subtitle(`subtitl')
    legend(size(medium))
    xsize(11) ysize(8.5);
  graph export "/href/brooks/home/bleah/zoning/streetcars/statafig/streetcar_ridership_over_time/${date}_`grapht'_wstate.eps",
    replace;

end;

*** C.3. run the ado ***;

* passengers *;
*stuffyr, varin1(passengers2 passengers4 passengers5 passengers7 passengers8)
         varin2(passengers9) ytitl(passengers, millions) grapht(passengers)
         subtitl(Annual Passengers);
* fares *;
*stuffyr, varin1(average_fare_num1 average_fare_num2 average_fare_num5 average_fare_num8)
         varin2(average_fare_num9) ytitl(average fare, cents) grapht(fare)
         subtitl(Average Fare);
* passenger revenue *;
*stuffyr, varin1(pass_rev1 pass_rev2 pass_rev4 pass_rev5 pass_rev7 pass_rev8)
         varin2(pass_rev9) ytitl(passenger revenues, millions) grapht(pass_rev)
         subtitl(Passenger Revenue);
* passengers per capita *;
*stuffyr, varin1(pass_pc2 pass_pc4 pass_pc5 pass_pc7 pass_pc8)
         varin2(pass_pc9) ytitl(passengers per capita) grapht(pass_pc)
         subtitl(Annual Passengers per capita);
* passenger revenue per capita *;
*stuffyr, varin1(pass_rev_pc1 pass_rev_pc2 pass_rev_pc4 pass_rev_pc5 pass_rev_pc7 pass_rev_pc8)
         varin2(pass_rev_pc9) ytitl(passenger revenues per capita) grapht(pass_rev_pc)
         subtitl(Passenger Revenue per capita);

*** C.4. passengers per capita ***;

** passengers per capita, pacific electric (two types) left axis, la ry right axis **;

* without state totals *;
graph twoway
  (connected pass_pc11 year if year >= 1910 & year <= 1939, yaxis(1) mcolor(cranberry) lcolor(cranberry))
  (connected pass_pc10 year if year >= 1910 & year <= 1939, yaxis(2) mcolor(gold) lcolor(gold))
  (connected pass_pc8 year if year >= 1910 & year <= 1939, yaxis(1) mcolor(maroon) lcolor(maroon)),
  xscale(range(1910 1940))
  yscale(range(0 300) axis(2))
  ylabel(0(100)300, axis(2))
  ytitle("Pacific Electric rides per capita", axis(1))
  ytitle("LA Railway rides per capita", axis(2))
  text(44 1934 "LA Railway")
  text(110 1922 "Pacific Electric, 1925 source")
  text(20  1918 "Pacific Electric, 1940 source")
  xtitle("")
  legend(off)
  xsize(11) ysize(8.5);

*graph export "/groups/brooksgrp/zoning/streetcar_stops/stata_figures/streetcar_ridership_figures/${date}_percapita_ridership_pe_and_lary.eps",
    replace;

*** C.5. passengers per capita, fixed data ***;

** passengers per capita, pacific electric left axis, la ry right axis **;

* without state totals *;
graph twoway
  (connected pass_pc12 year if year >= 1910 & year <= 1939, yaxis(1) mcolor(cranberry) lcolor(cranberry))
  (connected pass_pc10 year if year >= 1910 & year <= 1939, yaxis(2) mcolor(gold) lcolor(gold)),
  xscale(range(1910 1940))
  yscale(range(0 300) axis(2))
  ylabel(0(100)300, axis(2))
  ytitle("Pacific Electric rides per capita", axis(1))
  ytitle("LA Railway rides per capita", axis(2))
  text(60 1936 "LA Railway")
  text(40 1925 "Pacific Electric")
  xtitle("")
  legend(off)
  xsize(11) ysize(8.5);

graph export "/groups/brooksgrp/zoning/streetcar_stops/stata_figures/streetcar_ridership_figures/${date}_percapita_ridership_pe_adj_and_lary.eps",
    replace;



****** D. make output of population and ridership for paper **************;

sort year;
keep if (year == 1880 | year == 1890 | year == 1900 | year == 1910 | year == 1920 | year == 1930) | (passengers10 != . | passengers11 != . | passengers8 != .);
set linesize 180;
format population %10,0fc;
format lacity_pop %10,0fc;
format passengers10 %5.0f;
format passengers8 %5.0f;
format passengers11 %5.0f;
format pass_pc8 %5.0f;
format pass_pc10 %5.0f;
format pass_pc11 %5.0f;
gen apos = "'";
gen str13 population_s = apos + string(population, "%10.0fc");
gen str13 lacity_pop_s = apos + string(lacity_pop, "%10.0fc");
list year population population_s lacity_pop_s passengers10 pass_pc10 passengers8 pass_pc8 passengers11 pass_pc11;

* output the file *;
*outsheet year population_s lacity_pop_s passengers5 pass_pc5 passengers8 pass_pc8;
*outsheet year passengers10 pass_pc10 passengers8 pass_pc8 passengers11 pass_pc11 pass_pc12
  using "/href/brooks/home/bleah/zoning/streetcars/stataout/population_ridership_stats/${date}_rider_stats_by_year.txt", replace;
