#delimit;
clear;
set more off;
capture log close;
set mem 500m;
cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";


/*-------------------------------------------------------*/

/*	This program starts prepping the NPD sales data. I turn
the Excel spreadsheet in CSV files and then insheet them, combine them
and reshape them	*/

/*	Written by Mara, May 6/08	*/

/*-------------------------------------------------------*/


/*	Prep the ITEM level data	- 6 differnet spreadsheets to bring in
and work with	*/

tempfile units ushare dollars dshare transactions price;

/*	UNIT VOLUME	*/
#delimit;
clear;
insheet using ..\data\npd-csv-files\unitvolume_by_toy.csv;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 total_units;
rename v9 total_units2;
rename v10 units1;
rename v11 units2;
rename v12 units3;
rename v13 units4;
rename v14 units5;
rename v15 units6;
rename v16 units7;
rename v17 units8;
rename v18 units9;
rename v19 units10;
rename v20 units11;
rename v21 units12;
rename v22 units13;
rename v23 units14;
rename v24 units15;
rename v25 units16;
rename v26 units17;
rename v27 units18;
rename v28 units19;
rename v29 units20;
rename v30 units21;
rename v31 units22;
rename v32 units23;
rename v33 units24;
rename v34 units25;
rename v35 units26;
rename v36 units27;
rename v37 units28;
rename v38 units29;
rename v39 units30;
rename v40 units31;
rename v41 units32;
rename v42 units33;
rename v43 units34;
rename v44 units35;
rename v45 units36;
/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

/*	Now item-manufacturer-model# should uniquely identify entries in our data	*/
bysort item man model: gen N=_N;
tab N;

/*	Not quite.  We need to include the license b/c some of the toys at the end in
the "all other" category will otherwise get grouped together - we still have to figure out what's
up with those	*/
drop N;
bysort item man model license: gen N=_N;
tab N;
drop  in 1/2;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/

reshape long units, i(item man model license brand) j(date);
sort item man model license brand date;
save `units';



/*----------------------------------------------------*/

/*	UNIT SHARE	*/

#delimit;
clear;
insheet using ..\data\npd-csv-files\unitshare_by_toy.csv;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 total_ushare;
rename v9 ushare1;
rename v10 ushare2;
rename v11 ushare3;
rename v12 ushare4;
rename v13 ushare5;
rename v14 ushare6;
rename v15 ushare7;
rename v16 ushare8;
rename v17 ushare9;
rename v18 ushare10;
rename v19 ushare11;
rename v20 ushare12;
rename v21 ushare13;
rename v22 ushare14;
rename v23 ushare15;
rename v24 ushare16;
rename v25 ushare17;
rename v26 ushare18;
rename v27 ushare19;
rename v28 ushare20;
rename v29 ushare21;
rename v30 ushare22;
rename v31 ushare23;
rename v32 ushare24;
rename v33 ushare25;
rename v34 ushare26;
rename v35 ushare27;
rename v36 ushare28;
rename v37 ushare29;
rename v38 ushare30;
rename v39 ushare31;
rename v40 ushare32;
rename v41 ushare33;
rename v42 ushare34;
rename v43 ushare35;
rename v44 ushare36;

/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

bysort item man model license: gen N=_N;
tab N;
drop  in 1;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/


/*	We have a problem here in that there are about 9 items that appear twice
with the only difference I can tell being that in one observation the item's share in every month is 0%
while in the other observation, it may have a share of 0.1% or 0.3% in one or two months.  I don't
know what's up with these (have emailed Danny). In both obs, they show the total share to be 0%?  
Therefore for now just randomly keep one or the other?	*/

bysort item man model license brand: gen n=_n;
keep if n==1;

reshape long ushare, i(item man model license brand) j(date);
sort item man model license brand date;

save `ushare';


/*------------------------------------------------*/

/*	DOLLAR VOLUME	*/

#delimit;
clear;
insheet using ..\data\npd-csv-files\dollarvolume_by_toy.csv, comma;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 total_dollars;
rename v9 dollars1;
rename v10 dollars2;
rename v11 dollars3;
rename v12 dollars4;
rename v13 dollars5;
rename v14 dollars6;
rename v15 dollars7;
rename v16 dollars8;
rename v17 dollars9;
rename v18 dollars10;
rename v19 dollars11;
rename v20 dollars12;
rename v21 dollars13;
rename v22 dollars14;
rename v23 dollars15;
rename v24 dollars16;
rename v25 dollars17;
rename v26 dollars18;
rename v27 dollars19;
rename v28 dollars20;
rename v29 dollars21;
rename v30 dollars22;
rename v31 dollars23;
rename v32 dollars24;
rename v33 dollars25;
rename v34 dollars26;
rename v35 dollars27;
rename v36 dollars28;
rename v37 dollars29;
rename v38 dollars30;
rename v39 dollars31;
rename v40 dollars32;
rename v41 dollars33;
rename v42 dollars34;
rename v43 dollars35;
rename v44 dollars36;

/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

bysort item man model license: gen N=_N;
tab N;
drop  in 1;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/


reshape long dollars, i(item man model license brand) j(date);
sort item man model license brand date;

save `dollars';


/*----------------------------------------------------*/

/*	DOLLAR SHARE	*/
#delimit;
clear;
insheet using ..\data\npd-csv-files\dollarshare_by_toy.csv;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 total_dshare;
rename v9 dshare1;
rename v10 dshare2;
rename v11 dshare3;
rename v12 dshare4;
rename v13 dshare5;
rename v14 dshare6;
rename v15 dshare7;
rename v16 dshare8;
rename v17 dshare9;
rename v18 dshare10;
rename v19 dshare11;
rename v20 dshare12;
rename v21 dshare13;
rename v22 dshare14;
rename v23 dshare15;
rename v24 dshare16;
rename v25 dshare17;
rename v26 dshare18;
rename v27 dshare19;
rename v28 dshare20;
rename v29 dshare21;
rename v30 dshare22;
rename v31 dshare23;
rename v32 dshare24;
rename v33 dshare25;
rename v34 dshare26;
rename v35 dshare27;
rename v36 dshare28;
rename v37 dshare29;
rename v38 dshare30;
rename v39 dshare31;
rename v40 dshare32;
rename v41 dshare33;
rename v42 dshare34;
rename v43 dshare35;
rename v44 dshare36;

/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

bysort item man model license: gen N=_N;
tab N;
drop  in 1;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/


reshape long dshare, i(item man model license brand) j(date);
sort item man model license brand date;

save `dshare', replace;


/*--------------------------------------------------*/

/*	TRANSACTIONS	*/
#delimit;
clear;
insheet using ..\data\npd-csv-files\transactions_by_toy.csv;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 total_trans;
rename v9 transactions1;
rename v10 transactions2;
rename v11 transactions3;
rename v12 transactions4;
rename v13 transactions5;
rename v14 transactions6;
rename v15 transactions7;
rename v16 transactions8;
rename v17 transactions9;
rename v18 transactions10;
rename v19 transactions11;
rename v20 transactions12;
rename v21 transactions13;
rename v22 transactions14;
rename v23 transactions15;
rename v24 transactions16;
rename v25 transactions17;
rename v26 transactions18;
rename v27 transactions19;
rename v28 transactions20;
rename v29 transactions21;
rename v30 transactions22;
rename v31 transactions23;
rename v32 transactions24;
rename v33 transactions25;
rename v34 transactions26;
rename v35 transactions27;
rename v36 transactions28;
rename v37 transactions29;
rename v38 transactions30;
rename v39 transactions31;
rename v40 transactions32;
rename v41 transactions33;
rename v42 transactions34;
rename v43 transactions35;
rename v44 transactions36;

/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

bysort item man model license: gen N=_N;
tab N;
drop  in 1;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/

reshape long transactions, i(item man model license brand) j(date);
sort item man model license brand date;

save `transactions';



/*------------------------------------------------------------*/

/*	ARP	*/
#delimit;
clear;
insheet using ..\data\npd-csv-files\arp_by_toy.csv;
drop in 1/1;
rename v1 item;
rename v2 manufacturer;
rename v3 model_number;
rename v4 intro_date;
rename v5 category;
rename v6 brand;
rename v7 license;
rename v8 ave_price;
rename v9 price1;
rename v10 price2;
rename v11 price3;
rename v12 price4;
rename v13 price5;
rename v14 price6;
rename v15 price7;
rename v16 price8;
rename v17 price9;
rename v18 price10;
rename v19 price11;
rename v20 price12;
rename v21 price13;
rename v22 price14;
rename v23 price15;
rename v24 price16;
rename v25 price17;
rename v26 price18;
rename v27 price19;
rename v28 price20;
rename v29 price21;
rename v30 price22;
rename v31 price23;
rename v32 price24;
rename v33 price25;
rename v34 price26;
rename v35 price27;
rename v36 price28;
rename v37 price29;
rename v38 price30;
rename v39 price31;
rename v40 price32;
rename v41 price33;
rename v42 price34;
rename v43 price35;
rename v44 price36;

/*	Before reshaping, need to figure out what the unique identifier is (neither item nor model_no 
works).  There seem to be some duplicate observations.  We want to drop these (for now at least, until
we learn from Danny whether they are there for a reason)	*/
duplicates drop;

bysort item man model license: gen N=_N;
tab N;
drop  in 1;
tab N;

/*	Note that we have some entries with the item field blank but still have a manufacturer and model number
and actual data.  Keep these	*/

reshape long price, i(item man model license brand) j(date);
sort item man model license brand date;

save `price', replace;





/*------------------------------------------------*/

/*	Now merge them all together to have a single toy-month level dataset. Note
there is some discrepency between the number of obs in the different dataset.
For now drop if_merge==3 but talk to Danny about this	*/

/*	Merge by item man model license brand */
#delimit;
use `units', clear;
merge item man model license brand date using `ushare';
tab _merge; /*	36 have _merge==1 which means one item doens't match*/
tab manufacturer if _merge==1;
keep if _merge==3;
drop _merge;
sort item man model license brand date;
merge item man model license brand date using `dollars';
tab _merge; /*	all match	*/
keep if _merge==3;
drop _merge;
sort item man model license brand date;
merge item man model license brand date using `dshare-toy';
tab _merge; /*	one non match	*/
tab manufacturer if _merge==1;
keep if _merge==3;
drop _merge;
sort item man model license brand date;
merge item man model license brand date using `transactions';
tab _merge;  /*	all match	*/
keep if _merge==3;
drop _merge;
sort item man model license brand date;
merge item man model license brand date using `price-toy';
tab _merge; /* all match	*/
compress;



/*	Destring the key variables	*/
destring units, replace ignore(",");
destring dollars, replace ignore("$" ",");
destring ushare, replace ignore("%");
replace ushare=ushare/100;
destring dshare, replace ignore ("%");
replace dshare=dshare/100;
destring transactions, replace ignore (",");
destring price, replace ignore ("$");


/*	Adjust units (npd spreadsheet has units and dollars in 000s)	*/
replace units=units*1000;
replace dollars=dollars*1000;


/*	Make proper date variables	*/
gen month=.;
replace month=1 if date==1 | date==13 | date==25;
replace month=2 if date==2 | date==14 | date==26;
replace month=3 if date==3 | date==15 | date==27;
replace month=4 if date==4 | date==16 | date==28;
replace month=5 if date==5 | date==17 | date==29;
replace month=6 if date==6 | date==18 | date==30;
replace month=7 if date==7 | date==19 | date==31;
replace month=8 if date==8 | date==20 | date==32;
replace month=9 if date==9 | date==21 | date==33;
replace month=10 if date==10 | date==22 | date==34;
replace month=11 if date==11 | date==23 | date==35;
replace month=12 if date==12 | date==24 | date==36;

gen year=.;
replace year=2005 if date>0 & date<13;
replace year=2006 if date>12 & date<25;
replace year=2007 if date>24 & date<37;

drop date;
gen year_month=ym(year, month);
rename price price_npd;


/* We have to split the manufacturer variable into division 
and parent company so we can merge on info for the parent company	*/

split manufacturer, p("(");
rename manufacturer1 division;
rename manufacturer2 parent_company;

replace parent_company = division if parent_company=="";

split parent_company, p(")");
drop parent_company;
rename parent_company1 parent_company;
replace parent_company = "INTERNATIONAL PLAYTHINGS" if parent_company=="VIKING TOYS"; /*Viking Toys has only 2 toys in the sales data.  They are a division/subsidiary of International Playthings.  The only way I figured this out was because we had a recall to one of the Viking Toys toys and I need to do this so it merges properly.  Is this too arbitrary?  Not sure how we want to handle this.  TOMY is also a part of International Playthings according to the Internatinoal's Web Site.  TOMY has many more toys in the data.  Leaving it separate for now - again, this feels a little arbitrary. */
replace parent_company = "HASBRO" if parent_company == "HASBRO TOYS"; /*Want these to be on manufacturer*/
replace parent_company = "JAKKS PACIFIC" if parent_company == "JAKKS PACIF";

/*	Make proper Intro Date variable */
split intro_date, p(');
gen intro_month = 1 if intro_date1 == "JAN";
replace intro_month = 2 if intro_date1 == "FEB";
replace intro_month = 3 if intro_date1 == "MAR";
replace intro_month = 4 if intro_date1 == "APR";
replace intro_month = 5 if intro_date1 == "MAY";
replace intro_month = 6 if intro_date1 == "JUN";
replace intro_month = 7 if intro_date1 == "JUL";
replace intro_month = 8 if intro_date1 == "AUG";
replace intro_month = 9 if intro_date1 == "SEP";
replace intro_month = 10 if intro_date1 == "OCT";
replace intro_month = 11 if intro_date1 == "NOV";
replace intro_month = 12 if intro_date1 == "DEC";
replace intro_month = 1 if intro_date1 == "BEFORE 1986";
destring intro_date2, replace;
gen intro_ym = ym(1900+ intro_date2, intro_month) if intro_date2>85;
replace intro_ym = ym(2000+intro_date2, intro_month) if intro_date2<85;
replace intro_ym = ym(1986, intro_month) if intro_date1=="BEFORE 1986";
gen months_since_intro = year_month-intro_ym;
gen pre_intro = months_since_intro<0;


/*	Set Sales to missing if prior to intro date	*/
foreach var of varlist units dollars transactions{;
	replace `var'=. if pre_intro==1;
};


/*	Drop if intro date is missing	*/
drop if intro_date == "";

/*	Drop if Parent Company is ZZ-All Other or ZZ-Not Reported or missing	*/
drop if substr(parent_company,1,2)=="ZZ";
drop if parent_company =="";

/*	Create indicators for positive values	*/
gen pos_units = units>0 & units !=.;
gen pos_dollars = dollars>0 & dollars !=.;
gen pos_transactions = transactions>0 & transactions !=.;

/*	Make unique toy id	*/
replace license = "no license" if license=="";
replace brand = "no brand" if brand == "";
egen toy_id = group(manufacturer item model_number license brand);
display _N/36;
sum toy_id;
*the number of toy_ids matches the number of observations in the data set - this grouping gives us the right number of unique toys;

/*	Make numerical variable for Categories (names will become value labels)	*/
encode category, gen(cat);
lab list cat;
drop category;
rename cat category;

order year_month toy_id parent_company category brand license units dollars price_npd transactions pos_units pos_dollars pos_transactions item year month intro_date;

/*	Merge in CPI data and adjust "dollars" variable	*/
preserve;
insheet using ..\data\raw-data\cpi_urban.csv, comma names clear;
keep year period value;
destring period, replace ignore("M");
rename period month;
ta month;
rename value cpi;
/*	Make 2005 q1 the base quarter	*/
gen cpi_temp=0;
replace cpi_temp=cpi if year==2005 & month==01;
egen cpi_base=max(cpi_temp);
drop cpi_temp;
gen def=cpi/cpi_base;
keep year month def;
sort year month;
save ..\data\cpi, replace;
restore;
drop _merge;
sort year month;
merge year month using ..\data\cpi;
assert _merge == 3;
drop _merge;
rename dollars dollars_nom;
gen dollars = dollars_nom/def;
rename price_npd arp_nom;
replace arp = . if transactions == 0 | transactions == .;
gen arp = arp_nom/def;

order year_month toy_id parent_company category brand license units dollars arp transactions pos_units pos_dollars pos_transactions item year month intro_date;
compress;
save ..\data\toys_v1, replace;



/*	Create Data Set at the Quarter Level	*/
gen quarter = quarter(dofm(year_month));
gen year_qt = year*100+quarter;

/*	Drop if prior to intro date (otherwise, collapse will turn these from missing to 0)	*/
drop if pre_intro==1;
/*	Create "value" using arp to recover quarterly arp after collapse	*/
gen value = units*arp;
/*	Collapse relevant variables to quarter level	*/
collapse (sum) dollars units value transactions, by(toy_id item parent_company license brand category year_qt);
gen pos_units = units>0 & units !=.;
gen pos_dollars = dollars>0 & dollars !=.;
gen pos_transactions = transactions>0 & transactions !=.;
gen arp = value/units;
order  toy_id- transactions  arp;
compress;
save ..\data\toys_qtr, replace;










