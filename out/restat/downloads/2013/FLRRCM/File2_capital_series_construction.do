# delimit;
cd c:\chile\datafiles;
clear;
use all79_85; /** This is an aggregation of data for 1979 to 1985 **/
keep id year GKB GKM GKV GKO GKB1 GKM1 GKV1 GKO1 NKB NKM NKV NKO
NKB1 NKM1 NKV1 NKO1 CUMDB CUMDM CUMDV CUMDO;

sort id year;
label var GKB "Gross stock: Buildings (base=1980)";
label var GKM "Gross stock: Machinery (base=1980)";
label var GKV "Gross stock: Vehicles (base=1980)";
label var GKO "Gross stock: Other assets (base=1980)";

label var GKB1 "Gross stock: Buildings (base=1981)";
label var GKM1 "Gross stock: Machinery (base=1981)";
label var GKV1 "Gross stock: Vehicles (base=1981)";
label var GKO1 "Gross stock: Other assets (base=1981)";

label var NKB "Net stock: Buildings (base=1980)";
label var NKM "Net stock: Machinery (base=1980)";
label var NKV "Net stock: Vehicles (base=1980)";
label var NKO "Net stock: Other assets (base=1980)";

label var NKB1 "Net stock: Buildings (base=1981)";
label var NKM1 "Net stock: Machinery (base=1981)";
label var NKV1 "Net stock: Vehicles (base=1981)";
label var NKO1 "Net stock: Other assets (base=1981)";

label var CUMDB "Accumulated depreciation: Buildings";
label var CUMDM "Accumulated depreciation: Machinery";
label var CUMDV "Accumulated depreciation: Vehicles";
label var CUMDO "Accumulated depreciation: Other assets";

save liu_cap, replace;


*****************************************************************;
clear;
use merged3;

keep id year stassets fabldg famach faveh faland XX141 XX142 XX143 
XX144 XX145 totasset fxdasset gafxcapb gafxcapm gafxcapv gaddland 
corrland corrbldg corrmach corrveh defmach defcons defmach_ye 
defcons_ye enter exit;

label var XX141 "Furniture";
label var XX142 "Other fixed assets";
label var XX143 "Accumulated depreciation";
label var XX144 "Current period depreciation";
label var XX145 "Other assets";

sort id year;
merge id year using liu_cap;
drop _merge;

egen enteryr=sum(enter*year), by(id);
egen exityr=sum(exit*year), by(id);

save capdata, replace;

program drop _all;

sort id year;

/**
*In the following, we follow Lili Liu (1990), who constructed capital for the 1979-1986 dataset, for 
constructing capital series with base 1980 or 1981.  We follow Hseih and Parker(2001) in 
constructing capital series using base year after 1986 (using reported book values
for years 1992--1996.  What we do here is the following:
* We construct three different capital series based on seven different
base years: 1980, 1981 and 1992 to 1996.
* For the 1980 and 1981 base figures we work off Liu's NK* and NK*1 
net stock figures.  We add NKO to "buildings".  This means we'll be running down "Other 
assets" at the same depreciation rate as buildings (5%), whereas 
Liu had carried them forward without depreciation. We add "land" (investment in land) reported in post 1986 dataset 
to the "buildings" (investment in buildings). This avoids having an 
asset variable with positive values only post 1986. We don't do anything about "furniture" 
in reported in the 1979-86  dataset, as we assume Liu has factored this in while forming the 
NK* and NK*1 variables. 
* When a company is missing from the dataset for a some years, we treat 
investment as zero in those years. 
* To construct series using post-1991 data, we assume the reported data
is the net block at the current prices.
* Our tests in this program indicate a that our capital series very 
closely matches Liu's series (for base years 1980 and 1981).  These
don't match well with the 1992-96 base capital series.
**/


gen fabldg_old=fabldg;
gen gafxcapb_old=gafxcapb;

/** Since Liu constructs NK* in mid year 1980 pesos, we reflate 
here to get it to nominal values, so that the later deflation 
puts the data at constant 1979 pesos.  We use the price indices 
(assume mid year) given at the back of her appendix. **/ 

replace fabldg=NKB*sqrt(100*120.02)/100 + NKO*sqrt(112.70*100)/100 
if year==1980;
replace fabldg=NKB1*sqrt(120.02*128.25)/100 
	+ NKO1*sqrt(112.70*123.06)/100 if year==1981;

replace famach=NKM*sqrt(105.53*100)/100 if year==1980;
replace famach=NKM1*sqrt(105.53*116.61)/100 if year==1981;

replace faveh=NKV*sqrt(105.12*100)/100 if year==1980;
replace faveh=NKV1*sqrt(105.12*117.16)/100 if year==1981;

replace fabldg=fabldg+faland if year>1985 & faland~=.;
replace gafxcapb=gafxcapb+gaddland if year>1991 & gaddland~=.;

/** There is no investment in the "Others" category, so we don't 
have to make any adjustments there**/
** These are year-end real capital stock values (1979 pesos);
/* We ignore missing year investments */

********* BUILDING **************
program drop _all;

program define bldgstock
;
syntax =/exp;
gen rbldg_`exp'=(fabldg/defcons_ye) if year==`exp';
sort id year;
by id: replace rbldg_`exp'=rbldg_`exp'[_n-1]*(.95^(year[_n]-year[_n-1]))
            + (gafxcapb/defcons) if year >`exp';
gsort id -year;
by id: replace rbldg_`exp'=(rbldg_`exp'[_n-1]-(gafxcapb[_n-1]
    /defcons[_n-1]))*(.95^(year[_n]-year[_n-1])) if year[_n] <`exp';
sort id year;
replace rbldg_`exp'=0 if rbldg_`exp'==.;
label var rbldg_`exp' "Real building stock (Net, base `exp')";
end;

bldgstock =1980;
bldgstock =1981;
bldgstock =1992;
bldgstock =1993;
bldgstock =1994;
bldgstock =1995;
bldgstock =1996;

********* MACHINERY **************
program drop _all;
program define machstock;
syntax =/exp;
gen rmach_`exp'=(famach/defmach_ye) if year==`exp';
sort id year;
by id: replace rmach_`exp'=rmach_`exp'[_n-1]*(0.9^(year[_n]-year[_n-1]))
            + (gafxcapm/defmach) if year >`exp';
gsort id -year;
by id: replace rmach_`exp'=(rmach_`exp'[_n-1]-(gafxcapm[_n-1]
    /defmach[_n-1]))*(.9^(year[_n]-year[_n-1])) if year[_n] <`exp';
sort id year;
replace rmach_`exp'=0 if rmach_`exp'==.;
label var rmach_`exp' "Real machinery stock (Net, base `exp')";
end;

machstock =1980;
machstock =1981;
machstock =1992;
machstock =1993;
machstock =1994;
machstock =1995;
machstock =1996;

********* VEHICLES **************
program drop _all;
program define vehstock;
syntax =/exp;
gen rveh_`exp'=(faveh/defmach_ye) if year==`exp';
sort id year;
by id: replace rveh_`exp'=rveh_`exp'[_n-1]*(0.8^(year[_n]-year[_n-1]))
            + (gafxcapv/defmach) if year >`exp';
gsort id -year;
by id: replace rveh_`exp'=(rveh_`exp'[_n-1]-(gafxcapv[_n-1]
    /defmach[_n-1]))*(.8^(year[_n]-year[_n-1])) if year[_n] <`exp';
sort id year;
replace rveh_`exp'=0 if rveh_`exp'==.;
label var rveh_`exp' "Real vehicle stock (Net, base `exp')";
end;

vehstock =1980;
vehstock =1981;
vehstock =1992;
vehstock =1993;
vehstock =1994;
vehstock =1995;
vehstock =1996;


drop stassets fabldg famach faveh faland XX141 XX142 XX143 /*
 */ XX144 XX145 totasset fxdasset gafxcapb gafxcapm gafxcapv gaddland /*
 */ corrland corrbldg corrmach corrveh defmach defcons defmach_ye /*
 */ defcons_ye enter exit;


save capdata, replace;

pwcorr rbldg_1980 rbldg_1981 rbldg_1992 rbldg_1993 rbldg_1994 
	rbldg_1995 rbldg_1996 NKB NKB1, obs;
pwcorr rmach_1980 rmach_1981 rmach_1992 rmach_1993 rmach_1994 
	rmach_1995 rmach_1996 NKM NKM1, obs;
pwcorr rveh_1980 rveh_1981 rveh_1992 rveh_1993 rveh_1994 
	rveh_1995 rveh_1996 NKV NKV1, obs;


#delimit;
*** Setting up year-end capital stock variables
gen rcap80=rbldg_1980+rmach_1980+rveh_1980;
gen rcap81=rbldg_1981+rmach_1981+rveh_1981;
gen rcap92=rbldg_1992+rmach_1992+rveh_1992;
gen rcap93=rbldg_1993+rmach_1993+rveh_1993;
gen rcap94=rbldg_1994+rmach_1994+rveh_1994;
gen rcap95=rbldg_1995+rmach_1995+rveh_1995;
gen rcap96=rbldg_1996+rmach_1996+rveh_1996;

label var rcap80 "Real capital stock (net, base 1980)"; 
label var rcap81 "Real capital stock (net, base 1981)"; 
label var rcap92 "Real capital stock (net, base 1992)"; 
label var rcap93 "Real capital stock (net, base 1993)"; 
label var rcap94 "Real capital stock (net, base 1994)"; 
label var rcap95 "Real capital stock (net, base 1995)"; 
label var rcap96 "Real capital stock (net, base 1996)"; 

replace rcap80=. if rcap80<=0;
replace rcap81=. if rcap81<=0;
replace rcap92=. if rcap92<=0;
replace rcap93=. if rcap93<=0;
replace rcap94=. if rcap94<=0;
replace rcap95=. if rcap95<=0;
replace rcap96=. if rcap96<=0;

sort id year;
save capdata, replace;

#delimit;
use merged3;
sort id year;
merge id year using capdata;
drop _merge;

tabstat rcap80, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap81, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap92, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap93, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap94, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap95, stats (n mean sd min p5 median p95 max) by(year);
tabstat rcap96, stats (n mean sd min p5 median p95 max) by(year);

gen tnk80=rcap80;
replace tnk80=rcap81 if rcap80==.;
replace tnk80=. if tnk80<=0;

tabstat tnk80, stats (n mean sd min p5 median p95 max) by(year);
label var tnk80 "Real capital stock (net, base 1980,1981 if
1980 value missing)"; 

gen tnk809=rcap80;
replace tnk809=rcap81 if rcap80==.;
replace tnk809=rcap92 if rcap80==. & rcap81==.;
replace tnk809=. if tnk809<0;

tabstat tnk809, stats (n mean sd min p5 median p95 max) by(year);
label var tnk809 "Real capital stock (net, base 1980,1981
or 1992)";  

gen tnkall=rcap80;
replace tnkall=rcap81 if rcap80==.;
replace tnkall=rcap92 if rcap80==. & rcap81==.;
replace tnkall=rcap93 if rcap80==. & rcap81==. & rcap92==.;
replace tnkall=rcap94 if rcap80==. & rcap81==. & rcap92==. & rcap93==.;
replace tnkall=rcap95 if rcap80==. & rcap81==. & rcap92==. & rcap93==. & rcap94==.;
replace tnkall=rcap96 if rcap80==. & rcap81==. & rcap92==.& rcap93==. & rcap94==. & rcap95==.;

replace tnkall=. if tnkall<=0;
tabstat tnkall, stats (n mean sd min p5 median p95 max) by(year);

gen rinvcapb=gafxcapb/defcons;
gen rinvcapm=gafxcapm/defmach;
gen rinvcapv=gafxcapv/defmach;
label var rinvcapb "Real gross capital investment in building"; 
label var rinvcapm "Real gross capital investment in machinery"; 
label var rinvcapv "Real gross capital investment in vehicles"; 

save mergecap_3, replace;

