#delimit;
clear;
set more off;
set memory 4g;


use statefip ind1950 ind1990 year hhwt using "$startdir/$outputdata\usa_1percent_all.dta";

/*	
http://www.bls.gov/iag/tgs/iag_index_naics.htm
10"	Mining and logging"	
20"	Construction"	
30"	Manufacturing"	???????
31"	Durable Goods"
32"	Nondurable Goods"	
40"	Trade, transportation, and utilities"	???????
41"	Wholesale trade"	
42"	Retail trade"
43"	Transportation and warehousing"	
44"	Utilities"	
50"	Information"	
55"	Financial activities"	
60"	Professional and business services"	
65"	Education and health services	"
70"	Leisure and hospitality"	
80"	Other services"	
90"	Government ";
*****    JUST GONNA HAND MATCH; */
gen industry_name="";
replace industry_name="Mining and logging" if (ind1950>=105 & ind1950<=239) | ind1950==306;
gen ind10=0;
replace ind10=1 if (ind1950>=105 & ind1950<=239) | ind1950==306;

replace industry_name="Construction" if ind1950==246 ;
gen ind20=0;
replace ind20=1 if ind1950==246 ;

replace industry_name="Manufacturing" if ind1950==1000;
replace industry_name="Durable Goods" if(ind1950>=307 & ind1950<=399);
gen ind31=0;
replace ind31=1 if(ind1950>=307 & ind1950<=399);
 
replace industry_name="Nondurable goods" if (ind1950>=406 & ind1950<=499);
gen ind32=0;
replace ind32=1 if (ind1950>=406 & ind1950<=499);
replace industry_name="Trade, transportation, and utilities" if ind1950==1000;

replace industry_name="Wholesale trade" if ind1950>=606 & ind1950<=627;
gen ind41=0;
replace ind41=1 if ind1950>=606 & ind1950<=627;
 
replace industry_name="Retail trade" if (ind1950>=636 & ind1950<=669) | (ind1950>=686 & ind1950<=699); 
gen ind42=0;
replace ind42=1 if (ind1950>=636 & ind1950<=669) | (ind1950>=686 & ind1950<=699);  

replace industry_name="Transportation and warehousing" if ind1950>=506 & ind1950<=568;  
gen ind43=0;
replace ind43=1 if ind1950>=506 & ind1950<=568;  

replace industry_name="Utilities" if ind1950>=578 & ind1950<=598;  
gen ind44=0;
replace ind44=1 if ind1950>=578 & ind1950<=598; 

replace industry_name="Information" if ind1950==856 |  ind1950==857;   
gen ind50=0;
replace ind50=1 if ind1950==856 |  ind1950==857; 

replace industry_name="Financial activities" if ind1950>=716 & ind1950<=756; 
gen ind55=0;
replace ind55=1 if ind1950>=716 & ind1950<=756; 

replace industry_name="Professional and business services" if (ind1950>=806 & ind1950<=808) |  ind1950==879 |  ind1950==898 |  ind1950==899;
gen ind60=0;
replace ind60=1 if (ind1950>=806 & ind1950<=808) |  ind1950==879 |  ind1950==898 |  ind1950==899;

replace industry_name="Education and health services" if ind1950==888 |  ind1950==869 |  ind1950==868; 
gen ind65=0;
replace ind65=1 if ind1950==888 |  ind1950==869 |  ind1950==868;

replace industry_name="Leisure and hospitality" if ind1950==679 |  ind1950==836 |  ind1950==859 |  ind1950==858; 
gen ind70=0;
replace ind70=1 if ind1950==679 | ind1950==836 |  ind1950==859 |  ind1950==858; 

replace industry_name="Other services" if ind1950==816 |  ind1950==817 |  ind1950==826 |  ind1950==897 |  ind1950==896 |  (ind1950>=846 & ind1950<=849);
gen ind80=0;
replace ind80=1 if ind1950==816 | ind1950==817 | ind1950==826 | ind1950==897 | ind1950==896 |  (ind1950>=846 & ind1950<=849);

replace industry_name="Government" if ind1950>=906 & ind1950<=946;
gen ind90=0;
replace ind90=1 if ind1950>=906 & ind1950<=946;
egen indcounter=rowtotal(ind10-ind90);
gen indnone=0;
replace indnone=1 if indcounter==0;


/*
ind1950lbl:
           0 N/A OR NONE REPORTED
10         105 agriculture *** I know these three make no sense, but the page suggests that they go in this supersector, and that the "mining and logging" label is what is wrong.
10         116 forestry ******
10         126 fisheries *****
10         206 metal mining
10         216 coal mining
10         226 crude petroleum and natural gas extraction
10         236 nonmettalic  mining and quarrying, except fuel
10         239 mining, not specified
20         246 construction
10         306 logging
31         307 sawmills, planing mills, and mill work
31         308 misc wood products
31         309 furniture and fixtures
31         316 glass and glass products
31         317 cement, concrete, gypsum and plaster products
31         318 structural clay products
31         319 pottery and related prods
31         326 misc nonmetallic mineral and stone products
31         336 blast furnaces, steel works, and rolling mills
31         337 other primary iron and steel industries
31         338 primary nonferrous industries
31         346 fabricated steel products
31         347 fabricated nonferrous metal products
31         348 not specified metal industries
31         356 agricultural machinery and tractors
31         357 office and store machines
31         358 misc machinery
31         367 electrical machinery, equipment and supplies
31         376 motor vehicles and motor vehicle equipment
31         377 aircraft and parts
31         378 ship and boat building and repairing
31         379 railroad and misc transportation equipment
31         386 professional equipment
31         387 photographic equipment and supplies
31         388 watches, clocks, and clockwork-operated devices
31         399 misc manufacturing industries
32         406 meat products
32         407 dairy products
32         408 canning and preserving fruits, vegetables, and seafoods
32         409 grain-mill products
32         416 bakery products
32         417 confectionary and related products
32         418 beverage industries
32         419 misc food preparations and kindred products
32         426 not specified food industries
32         429 tobacco manufactures
32         436 knitting mills
32         437 dyeing and finishing textiles, except knit goods
32         438 carpets, rugs, and other floor coverings
32         439 yarn, thread, and fabric
32         446 misc textile mill products
32         448 apparel and accessories
32         449 misc fabricated textile products
32         456 pulp, paper, and paper-board mills
32         457 paperboard containers and boxes
32         458 misc paper and pulp products
32         459 printing, publishing, and allied industries
32         466 synthetic fibers
32         467 drugs and medicines
32         468 paints, varnishes, and related products
32         469 misc chemicals and allied products
32         476 petroleum refining
32         477 misc petroleum and coal products
32         478 rubber products
32         487 leather: tanned, curried, and finished
32         488 footwear, except rubber
32         489 leather products, except footwear
32         499 not specified manufacturing industries
43         506 railroads and railway
43         516 street railways and bus lines
43         526 trucking service
43         527 warehousing and storage
43         536 taxicab service
43         546 water transportation
43         556 air transportation
43         567 petroleum and gasoline pipe lines
43         568 services incidental to transportation
44         578 telephone
44         579 telegraph
44         586 electric light and power
44         587 gas and steam supply systems
44         588 electric-gas utilities
44         596 water supply
44         597 sanitary services
44         598 other and not specified utilities
41         606 motor vehicles and equipment
41         607 drugs, chemicals, and allied products
41         608 dry goods apparel
41         609 food and related products
41         616 electrical goods, hardware, and plumbing equipment
41         617 machinery, equipment, and supplies
41         618 petroleum products
41         619 farm prods--raw materials
41         626 misc wholesale trade
41         627 not specified wholesale trade
42         636 food stores, except dairy
42         637 dairy prods stores and milk retailing
42         646 general merchandise
42         647 five and ten cent stores
42         656 apparel and accessories stores, except shoe
42         657 shoe stores
42         658 furniture and house furnishings stores
42         659 household appliance and radio stores
42         667 motor vehicles and accessories retailing
42         668 gasoline service stations
42         669 drug stores
70         679 eating and drinking  places
42         686 hardware and farm implement stores
42         687 lumber and building material retailing
42         688 liquor stores
42         689 retail florists
42         696 jewelry stores
42         697 fuel and ice retailing
42         698 misc retail stores
42         699 not specified retail trade
55         716 banking and credit
55         726 security and commodity brokerage and invest companies
55         736 insurance
55         746 real estate
55         756 real estate-insurance-law  offices
60         806 advertising
60         807 accounting, auditing, and bookkeeping services
60         808 misc business services
80         816 auto repair services and garages
80         817 misc repair services
80         826 private households
70         836 hotels and lodging places
80         846 laundering, cleaning, and dyeing
80         847 dressmaking shops
80         848 shoe repair shops
80         849 misc personal services
50         856 radio broadcasting and television
50         857 theaters and motion pictures
70         858 bowling alleys, and billiard and pool parlors
70         859 misc entertainment and recreation services
65         868 medical and other health services, except hospitals
65         869 hospitals
60         879 legal services
65         888 educational services
80         896 welfare and religious services
80         897 nonprofit membership organizs.
60         898 engineering and architectural services
60         899 misc professional and related
90         906 postal service
90         916 federal public administration
90         926 state public administration
90         936 local public administration
90         946 public administration, level not specified 
         976 COMMON OR GENERAL LABORER
         982 HOUSEWORK AT HOME
         983 SCHOOL RESPONSE (STUDENTS, ETC.)
         984 RETIRED
         987 INSTITUTION RESPONSE
         991 LADY/MAN OF LEISURE
         995 NON-INDUSTRIAL RESPONSE
         997 NONCLASSIFIABLE
         998 INDUSTRY NOT REPORTED
*/;
gen roundhhwt=round(hhwt/10);
expand roundhhwt;
collapse ind10-ind90 indnone (count) Ninc=indnone, by(statefip year);



drop if statefip==2| statefip==11| statefip==15| statefip>56;
sort statefip year;
foreach x in 10 20 31 32 41 42 43 44 50 55 60 65 70 80 90 none{;
replace ind`x'=0 if ind`x'==.;
by statefip: gen periodgrowth`x'=(ind`x'-ind`x'[_n-1])/ind`x'[_n-1] if ind`x'[_n-1]<.;
by statefip: gen yeargrowth`x'=(1+periodgrowth`x'[_n+1])^(1/10) if year<2000;
by statefip: replace yeargrowth`x'=(1+periodgrowth`x'[_n+1])^(1/5) if year==2000;
by statefip: gen linyeargrowth`x'=(ind`x'[_n+1]-ind`x')/(year[_n+1]-year) if ind`x'==0;
drop periodgrowth`x';
};


expand 10 if year<2000;
expand 5 if year==2000;
bysort statefip year: gen newyear=year+_n-1;
replace year=2000 if newyear==2005;
*gen testind32=ind32*yeargrowth32^(newyear-year);
*replace testind32=ind32+linyeargrowth32*(newyear-year) if linyeargrowth32<.;
*list testind32 ind32 if year==newyear;
foreach x in 10 20 31 32 41 42 43 44 50 55 60 65 70 80 90 none{;
replace ind`x'=ind`x'*yeargrowth`x'^(newyear-year) if yeargrowth`x'<.;
replace ind`x'=ind`x'+linyeargrowth`x'*(newyear-year) if linyeargrowth`x'<.;
};
drop yeargrowth* linyeargrowth*;
rename statefip fips;
drop year;
rename newyear year;
save "$startdir/$outputdata\ipumsindbasestateFORIND.dta", replace; 


*/;





insheet using "$startdir/$inputdata\industrycodesBLS.txt", tab clear;
drop v8;
rename naics_code naics;
tostring industry_code, replace format(%08.0f);
save "$startdir/$outputdata\industrycodesBLS.dta", replace;

insheet using "$startdir/$inputdata\BLS industry employment.txt", delimiter(,) clear;
gen prefix=substr(seriesid,1,2);
gen seasonaladjustmentcode=substr(seriesid,3,1);
gen supersectorcode=substr(seriesid,4,2);
gen industry_code=substr(seriesid,4,8);
gen datatypecode=substr(seriesid,12,2);
destring annual*, replace;
destring supersectorcode, replace;
drop if supersectorcode==0 | supersectorcode==5;
label define supersectorlbl 
0	"Total nonfarm"	
5"	Total private"	
6"	Goods-producing"	
7"	Service-providing"	
8"	Private service-providing"	
10"	Mining and logging"	
20"	Construction"	
30"	Manufacturing"	
31"	Durable Goods"	
32"	Nondurable Goods"	
40"	Trade, transportation, and utilities"	
41"	Wholesale trade"	
42"	Retail trade"	
43"	Transportation and warehousing"	
44"	Utilities"	
50"	Information"	
55"	Financial activities"	
60"	Professional and business services"	
65"	Education and health services	"
70"	Leisure and hospitality"	
80"	Other services"	
90"	Government ";
label values supersectorcode supersectorlbl;

merge industry_code using "$startdir/$outputdata\industrycodesBLS.dta", sort unique;
drop if _merge<3;
drop _merge;




sum annual*; 
keep if  seriesid=="CEU1000000001" | seriesid=="CEU2000000001" | seriesid=="CEU4000000001" | seriesid=="CEU3100000001" | seriesid=="CEU3200000001" 
    | seriesid=="CEU4142000001" | seriesid=="CEU4200000001" | seriesid=="CEU4300000001" | seriesid=="CEU4422000001" | seriesid=="CEU5000000001" | seriesid=="CEU5500000001"
    | seriesid=="CEU6000000001" | seriesid=="CEU6500000001" | seriesid=="CEU7000000001" | seriesid=="CEU8000000001" | seriesid=="CEU9000000001";
list naics supersector industry_name industry_code;
keep annual* supersector ;
reshape long annual, i(supersectorcode);
rename supersectorcode ind;
rename _j year;
rename annual emp;
sort ind year;
reshape wide emp, i(year) j(ind);
save "$startdir/$outputdata/BLSindemp.dta", replace;
*/;

use "$startdir/$outputdata/BLSindemp.dta", clear;
merge year using "$startdir/$outputdata/ipumsindbasestateFORIND.dta", sort uniqmaster;
drop _merge;

merge fips year using "$startdir/$outputdata/smoothedpopulation.dta", sort unique; *this is the same N used to make GDP per person, is this right?;
drop if _merge<3;
drop _merge;

bysort year: egen Ntotal=total(N);
foreach x of numlist 10 20 31 32 40 41 42 43 44 50 55 60 65 70 80 90{;
replace emp`x'=emp`x'/Ntotal;
sort fips year;
by fips: gen demp`x'=(emp`x'-emp`x'[_n-1])/emp`x'[_n-1] if emp`x'[_n-1]<.;
};
drop if year<1940;
drop if year>2005;

*43 and 44 are missing til 1972 and 1964 respectively, so i fill them in with 40.;
replace demp43=demp40 if demp43==. & year<1973;
replace demp44=demp40 if demp44==. & year<1965;
foreach x of numlist 10 20 31 32 41 42 43 44 50 55 60 65 70 80 90{;
gen shock`x'=demp`x'*ind`x';

};
egen empshare=rowtotal(shock*);
collapse empshare, by(fips year);

save "$startdir/$outputdata\empshare.dta", replace;

