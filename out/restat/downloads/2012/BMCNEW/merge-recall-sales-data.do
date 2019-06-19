#delimit;
clear;
set more off;
capture log close;
set mem 1000m;
capture program drop _all;

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";

*------------------------------------------;
** STEP 1: PROGRAM TO CREAT UNIFORM RECALL VARIABLES ***;
*------------------------------------------;

*=====================;
program define recallvars;
*=====================;

/*Create uniform recall variables*/
/*Dummies for reported incidents*/

gen malf_reported = malfunctions>0 if rec_id!=.;
replace malf_reported = 0 if malfunctions==. & rec_id!=.;
gen dang_inc_reported = dang_incidents>0 if rec_id!=.;
replace dang_inc_reported = 0 if dang_incidents==. & rec_id!=.;
gen injuries_reported = injuries>0 if rec_id!=.;
replace injuries_reported = 0 if injuries==. & rec_id!=.;
gen deaths_reported = deaths>0 if rec_id!=.;
replace deaths_reported = 0 if deaths==. & rec_id!=.;

/*Made in China Dummy*/
gen made_in_china = made_in=="China" if rec_id!=.;
ta made_in_china if rec_id!=.;

/*Hazard Type Dummies*/
gen choking = prim_hazard=="Choking" if rec_id!=.;
gen entrapment = prim_hazard=="Entrapment" if rec_id!=.;
gen fire_burn_expl = prim_hazard=="Fire, Burn and Explosion" if rec_id!=.;
gen impact = prim_hazard=="Impact" if rec_id!=.;
gen lacer_punct = prim_hazard == "Laceration and Puncture" if rec_id!=.;
gen lead = prim_hazard=="Lead" if rec_id!=.;
gen magnets = prim_hazard == "Magnets" if rec_id!=.;
gen severing = prim_hazard == "Severing" if rec_id!=.;
gen strang_suff = prim_hazard == "Strangulation and Suffocation" if rec_id!=.;
gen toxic = prim_hazard == "Toxic" if rec_id!=.;

/*Number of units recalled*/
gen recun = numberofunitsrecalled if rec_id!=.;
replace recun = "500,000" if recun=="500,000 (additionaly 700,000 worldwide)" & rec_id!=.; /*want a numeric variable for number recalled.  for now will replace this one observation w/ the number of domestic units recalled*/
destring recun, replace ignore(",");
replace recun = recun/1000000;

/*Price of good*/
replace price = "0" if price == "Free" & rec_id!=.;
split price, p(-) ignore($) destring;
rename price1 price_min;
rename price2 price_max;
replace price_max = price_min if price_max==. & rec_id!=.; /*for prices without a range, price_min = price_max*/
gen price_avg = (price_min+price_max)/2 if rec_id!=.;
sort year month;
merge year month using ..\data\cpi, nokeep;
assert _merge == 3;
drop _merge;
rename price_avg price_avg_nom;
gen price_avg = price_avg_nom/def;


/*Recall Value - Price X units*/
gen recval = price_avg*recun if rec_id!=.;


/*News Articles*/
drop articles_neg30toneg1;
rename articles_0to30 articles;

/*On Market*/
gen onmkt = on_market_recdate;
gen onmkt4 = on_market_recdate==1 & on_market_q4==1;
gen nonmkt = 1-onmkt;
gen nonmkt4=1-onmkt4;

end;
*=====================;


*------------------------------------------;
** STEP 2: CREATE DATA SET OF FIRM LEVEL RECALLS -> recall_man.dta***;
*------------------------------------------;
use ..\data\recall-for-merge-sales, clear;
drop if rec_id <=30; /*Dropping recalls from 2004*/
assert manufacturer_merge1 !="";
drop product_merge* brand_merge* license_merge*;
gen recall_man = rec_id!=.;
reshape long manufacturer_merge, i(rec_id) j(manufacturer_num);
drop if manufacturer_merge=="";
/*Generate a parent company variable for all companies identified in sales data to have a parent company. 
(Most of these won't actually show up in recall data)*/
gen parent_company = "";
qui replace parent_company = "HEDSTROM" if strpos(manufacturer_merge, "HEDSTROM")>0 | strpos(manufacturer_merge, "AMAV")>0 | strpos(manufacturer_merge, "ERO")>0;;
qui replace parent_company = "RUSS BERRIE" if strpos(manufacturer_merge, "RUSS BERRIE")>0 | strpos(manufacturer_merge, "APPLAUSE")>0 | strpos(manufacturer_merge, "KIDS LINE")>0 | strpos(manufacturer_merge, "SASSY")>0;
qui replace parent_company = "RC2" if strpos(manufacturer_merge, "BRITAINS PETITE")>0 | strpos(manufacturer_merge, "RC2")>0 | strpos(manufacturer_merge, "THE FIRST YEARS")>0 | strpos(manufacturer_merge, "LEARNING CURVE TOYS")>0 | strpos(manufacturer_merge, "EDEN TOYS")>0;;
qui replace parent_company = "ARTSANA" if strpos(manufacturer_merge, "ARTSANA")>0 | strpos(manufacturer_merge, "CHICCO")>0;
qui replace parent_company = "JAKKS PACIFIC" if strpos(manufacturer_merge, "JAKKS PACIFIC")>0 | strpos(manufacturer_merge, "CHILD GUIDANCE")>0 | strpos(manufacturer_merge, "TOYMAX")>0 | strpos(manufacturer_merge, "TRENDMASTERS")>0 | strpos(manufacturer_merge, "PLAY ALONG")>0 | strpos(manufacturer_merge, "FLYING COLORS")>0 | strpos(manufacturer_merge, "CREATIVE DESIGNS")>0;
qui replace parent_company = "STROMBECKER" if strpos(manufacturer_merge, "STROMBECKER")>0 | strpos(manufacturer_merge, "CHILTON GLOBE")>0;
qui replace parent_company = "MATTEL" if strpos(manufacturer_merge, "MATTEL")>0 | strpos(manufacturer_merge, "COROLLE")>0 | strpos(manufacturer_merge, "FISHER-PRICE")>0 | strpos(manufacturer_merge, "RADICA")>0;;
qui replace parent_company = "THOMAS NELSON PUB" if strpos(manufacturer_merge, "THOMAS NELSON PUB")>0 | strpos(manufacturer_merge, "CR GIBSON")>0;
qui replace parent_company = "HASBRO" if strpos(manufacturer_merge, "HASBRO")>0 | strpos(manufacturer_merge, "CRANIUM")>0 | strpos(manufacturer_merge, "TIGER ELECTRONICS")>0;
qui replace parent_company = "HALLMARK" if strpos(manufacturer_merge, "HALLMARK")>0 | strpos(manufacturer_merge, "CRAYOLA LLC")>0;
qui replace parent_company = "MICHAEL FRIEDMAN" if strpos(manufacturer_merge, "MICHAEL FRIEDMAN")>0 | strpos(manufacturer_merge, "CRIBMATES")>0;
qui replace parent_company = "PAPER MAGIC" if strpos(manufacturer_merge, "PAPER MAGIC")>0 | strpos(manufacturer_merge, "EUREKA")>0;
qui replace parent_company = "DOREL" if strpos(manufacturer_merge, "INFANTINO")>0 | strpos(manufacturer_merge, "DOREL")>0;
qui replace parent_company = "POOF TOY PRODUCTS" if strpos(manufacturer_merge, "POOF TOY PRODUCTS")>0 | strpos(manufacturer_merge, "JAMES IND")>0;
qui replace parent_company = "JAK PAK" if strpos(manufacturer_merge, "JAK PAK")>0 | strpos(manufacturer_merge, "JARU")>0;
qui replace parent_company = "NATHAN" if strpos(manufacturer_merge, "NATHAN")>0 | strpos(manufacturer_merge, "KIDZ DELIGHT")>0;
qui replace parent_company = "MCGRAW HILL" if strpos(manufacturer_merge, "MCGRAW HILL")>0 | strpos(manufacturer_merge, "LANDOLL")>0;
qui replace parent_company = "STROMBECKER" if strpos(manufacturer_merge, "STROMBECKER")>0 | strpos(manufacturer_merge, "LIBBY LEE TOYS")>0 | strpos(manufacturer_merge, "TOOTSIETOY")>0;
qui replace parent_company = "CROWN CRAFTS" if strpos(manufacturer_merge, "CROWN CRAFTS")>0 | strpos(manufacturer_merge, "NOEL JOANNA")>0 | strpos(manufacturer_merge, "RED CALLIOPE")>0;
qui replace parent_company = "PSX" if strpos(manufacturer_merge, "PSX")>0 | strpos(manufacturer_merge, "PERSONAL STAMP EX")>0;
qui replace parent_company = "VTECH" if strpos(manufacturer_merge, "VTECH")>0 | strpos(manufacturer_merge, "PLAYTECH")>0;
qui replace parent_company = "MEGA BRANDS" if strpos(manufacturer_merge, "MEGABRANDS")>0 | strpos(manufacturer_merge, "ROSE ART")>0;
qui replace parent_company = "CHOSUN" if strpos(manufacturer_merge, "WINDSOR")>0 | strpos(manufacturer_merge, "KIDZ DELIGHT")>0;
* For all others, replace the parent company with the manufacturer;
qui replace parent_company = manufacturer_merge if parent_company == ""; 
replace parent_company = "MGA ENT" if parent_company == "LITTLE TIKES"; /*Little Tikes is a brand owned by MGA*/
replace parent_company = "MYKIDS" if parent_company == "KB Toys, Inc."; /*The recall description says that the toys are under the MYKIDS label.*/ 
/*If there was more than one toy from the same manufacturer in the same recall, we now have more than one parent company-recall observation.
Want to fix this so that when we merge, we only have one parent company-recall observation in the recall data*/
sort rec_id parent_company;
duplicates drop rec_id parent_company, force;
sort parent_company year_month;
/*
Want to check if we have any firms how have more than 1 recall in a month
*/
duplicates tag parent_company year_month, gen(dup_firm);
ta dup_firm;
ta parent_company dup_firm;
/*There are 6 incidents of 2 recalls for the same firm in the same month, 
1 incident of 3 recalls for the same firm in the same month, 1 of 4, and 1 of 6.*/
*----------;
recallvars;
*----------;

collapse 	(sum)  nrecalls = recall_man recval recun articles (max) lead *onmkt*, by(parent_company year_month);
foreach var of varlist  recval recun nrecalls lead articles *onmkt* {;
	rename `var' `var'_man;
};
sort parent_company year_month;
save ..\data\recall_man, replace;
desc;

*------------------------------------------;
** STEP 3: CREATE A DATASET OF MANUFACTURER-CATEGORY LEVEL RECALLS -> recall_man_cat.dta***;
** First merge recalls to sales data at product level, and then collapse to identify which man-cats experience recalls **;
*------------------------------------------;

* CREATE DATA SET OF PRODUCT LEVEL RECALLS;
use ..\data\recall-for-merge-sales, clear;

drop if rec_id <=30; /*Dropping recalls from 2004*/
assert product_merge1 !="";
drop  brand_merge* license_merge*;

/*For those recalls that include more than one toy (that is in the sales data), 
reshape so that we can merge the recall info to each toy.*/

reshape long product_merge manufacturer_merge, i(rec_id) j(product_num);
drop if product_merge=="";

*-----------------------------------------------------------;
sort rec_id product_num;
assert manufacturer_merge !="" if product_num==1;
assert  manufacturer_merge == "" if product_num!=1;
by rec_id: replace manufacturer_merge = manufacturer_merge[_n-1] if product_num>1;

/*Generate a parent company variable for all companies identified in sales data to have a parent company.  (Most of these won't actually show up in recall data)*/
gen parent_company = "";
replace parent_company = "HEDSTROM" if strpos(manufacturer_merge, "HEDSTROM")>0 | strpos(manufacturer_merge, "AMAV")>0 | strpos(manufacturer_merge, "ERO")>0;;
replace parent_company = "RUSS BERRIE" if strpos(manufacturer_merge, "RUSS BERRIE")>0 | strpos(manufacturer_merge, "APPLAUSE")>0 | strpos(manufacturer_merge, "KIDS LINE")>0 | strpos(manufacturer_merge, "SASSY")>0;
replace parent_company = "RC2" if strpos(manufacturer_merge, "BRITAINS PETITE")>0 | strpos(manufacturer_merge, "RC2")>0 | strpos(manufacturer_merge, "THE FIRST YEARS")>0 | strpos(manufacturer_merge, "LEARNING CURVE TOYS")>0 | strpos(manufacturer_merge, "EDEN TOYS")>0;;
replace parent_company = "ARTSANA" if strpos(manufacturer_merge, "ARTSANA")>0 | strpos(manufacturer_merge, "CHICCO")>0;
replace parent_company = "JAKKS PACIFIC" if strpos(manufacturer_merge, "JAKKS PACIFIC")>0 | strpos(manufacturer_merge, "CHILD GUIDANCE")>0 | strpos(manufacturer_merge, "TOYMAX")>0 | strpos(manufacturer_merge, "TRENDMASTERS")>0 | strpos(manufacturer_merge, "PLAY ALONG")>0 | strpos(manufacturer_merge, "FLYING COLORS")>0 | strpos(manufacturer_merge, "CREATIVE DESIGNS")>0;
replace parent_company = "STROMBECKER" if strpos(manufacturer_merge, "STROMBECKER")>0 | strpos(manufacturer_merge, "CHILTON GLOBE")>0;
replace parent_company = "MATTEL" if strpos(manufacturer_merge, "MATTEL")>0 | strpos(manufacturer_merge, "COROLLE")>0 | strpos(manufacturer_merge, "FISHER-PRICE")>0 | strpos(manufacturer_merge, "RADICA")>0;;
replace parent_company = "THOMAS NELSON PUB" if strpos(manufacturer_merge, "THOMAS NELSON PUB")>0 | strpos(manufacturer_merge, "CR GIBSON")>0;
replace parent_company = "HASBRO" if strpos(manufacturer_merge, "HASBRO")>0 | strpos(manufacturer_merge, "CRANIUM")>0 | strpos(manufacturer_merge, "TIGER ELECTRONICS")>0;
replace parent_company = "HALLMARK" if strpos(manufacturer_merge, "HALLMARK")>0 | strpos(manufacturer_merge, "CRAYOLA LLC")>0;
replace parent_company = "MICHAEL FRIEDMAN" if strpos(manufacturer_merge, "MICHAEL FRIEDMAN")>0 | strpos(manufacturer_merge, "CRIBMATES")>0;
replace parent_company = "PAPER MAGIC" if strpos(manufacturer_merge, "PAPER MAGIC")>0 | strpos(manufacturer_merge, "EUREKA")>0;
replace parent_company = "DOREL" if strpos(manufacturer_merge, "INFANTINO")>0 | strpos(manufacturer_merge, "DOREL")>0;
replace parent_company = "POOF TOY PRODUCTS" if strpos(manufacturer_merge, "POOF TOY PRODUCTS")>0 | strpos(manufacturer_merge, "JAMES IND")>0;
replace parent_company = "JAK PAK" if strpos(manufacturer_merge, "JAK PAK")>0 | strpos(manufacturer_merge, "JARU")>0;
replace parent_company = "NATHAN" if strpos(manufacturer_merge, "NATHAN")>0 | strpos(manufacturer_merge, "KIDZ DELIGHT")>0;
replace parent_company = "MCGRAW HILL" if strpos(manufacturer_merge, "MCGRAW HILL")>0 | strpos(manufacturer_merge, "LANDOLL")>0;
replace parent_company = "STROMBECKER" if strpos(manufacturer_merge, "STROMBECKER")>0 | strpos(manufacturer_merge, "LIBBY LEE TOYS")>0 | strpos(manufacturer_merge, "TOOTSIETOY")>0;
replace parent_company = "CROWN CRAFTS" if strpos(manufacturer_merge, "CROWN CRAFTS")>0 | strpos(manufacturer_merge, "NOEL JOANNA")>0 | strpos(manufacturer_merge, "RED CALLIOPE")>0;
replace parent_company = "PSX" if strpos(manufacturer_merge, "PSX")>0 | strpos(manufacturer_merge, "PERSONAL STAMP EX")>0;
replace parent_company = "VTECH" if strpos(manufacturer_merge, "VTECH")>0 | strpos(manufacturer_merge, "PLAYTECH")>0;
replace parent_company = "MEGA BRANDS" if strpos(manufacturer_merge, "MEGABRANDS")>0 | strpos(manufacturer_merge, "ROSE ART")>0;
replace parent_company = "CHOSUN" if strpos(manufacturer_merge, "WINDSOR")>0 | strpos(manufacturer_merge, "KIDZ DELIGHT")>0;
replace parent_company = manufacturer_merge if parent_company == ""; /*For all others, replace the parent company with the manufacturer*/
replace parent_company = "MGA ENT" if parent_company == "LITTLE TIKES"; /*Little Tikes is a brand owned by MGA*/
replace parent_company = "MYKIDS" if parent_company == "KB Toys, Inc."; /*The recall description says that the toys are under the MYKIDS label.*/ 
*-----------------------------------------------------------;
*----------;
recallvars;
*----------;

sort product_merge parent_company year_month;
save ..\data\recall_product, replace;
desc;

** MERGE PRODUCT LEVEL RECALLS TO SALES DATA***;

use ..\data\toys_v1;
gen product_merge = item;
sort product_merge parent_company year_month;
merge product parent_company year_month using ..\data\recall_product;

* product_merge is redundant with item;
assert product_merge==item if item~="";
replace item=product_merge if item=="";
drop product_merge;

ta _merge;
*ta rec_id _merge;
codebook rec_id if _merge == 3;
/*	23 recalls match to 65 toys in the data	*/


** COLLAPSE TO CREATE A DATASET OF MANUFACTURER-CATEGORY LEVEL RECALLS -> recall_man_cat.dta***;
collapse  recval recun lead articles *onmkt* if rec_id!=., 
	by(parent_company category year_month rec_id);
gen recall_man_cat = rec_id!=.;
duplicates drop rec_id parent_company category, force;
collapse 	(sum) nrecalls = recall_man_cat recval recun articles (max) lead *onmkt*, by(parent_company category year_month);
foreach var of varlist  recval recun nrecalls lead articles *onmkt*{;
	rename `var' `var'_man_cat;
};

drop if category==.;
sort parent_company category year_month;

save ..\data\recall_man_cat, replace;
desc;


*------------------------------------------;
** STEP 4: DATA SETUP PROGRAM TO COLLAPSE AND DEFINE VARIABLES AT VARIOUS LEVELS***;
*------------------------------------------;
program define datasetup;
	/*	Collapse Data to Appropirate Cells	*/
	collapse (max) top30 top15 nontop4 (sum) units dollars transactions nrecalls_* articles_* recval_* recun_* (max) lead_* *onmkt*, by(`1' `2' year_quarter);
	gen quarter = quarter(dofq(year_quarter));
	gen year = year(dofq(year_quarter));
	/*	Create a variable called "cell" which identifies the appropriate level of observation (such as man-cat, etc.)	*/
	egen cell=group(`1' `2');	
	/*	Sum number of recalls, number of articles, recall value, and recalled units for each year	*/
	foreach var of varlist nrecalls* articles* recval* recun* {;
		bysort cell: egen `var'07	= total(`var') if	year==2007;
		replace `var'07 = 0 if `var'07==.;
	    bysort cell: egen `var'06	= total(`var') if	year==2006;
	    replace `var'06 = 0 if `var'06==.;
	    bysort cell: egen `var'05	= total(`var') if	year==2005;
	    replace `var'05 = 0 if `var'05==.;
		bysort cell year: egen `var'_t	= total(`var');
		replace `var'_t = 0 if `var'_t==.;
	    drop `var';
	};
	/*	Dummies for having a lead recall and having a recall to a toy still on market	*/
	foreach var of varlist lead*  *onmkt* {;
		bysort cell: egen `var'07	= max(`var') if	year==2007;
		replace `var'07 = 0 if `var'07==.;
	    bysort cell: egen `var'06	= max(`var') if	year==2006;
	    replace `var'06 = 0 if `var'06==.;
	    bysort cell: egen `var'05	= max(`var') if	year==2005;
	    replace `var'05 = 0 if `var'05==.;
		bysort cell year: egen `var'_t	= max(`var');
		replace `var'_t = 0 if `var'_t==.;
	    drop `var';
	};
	/*	Keep Q4 and Q1 Data	*/
	keep if year_quarter == q(2005q4) | year_quarter == q(2006q4) | year_quarter == q(2007q4) | year_quarter == q(2005q1) | year_quarter == q(2006q1) | year_quarter == q(2007q1);
	drop year_quarter;
	/*	Reshape data to have sepparate variables for Q4 and Q1 sales (will mostly be using Q4 data	*/
	reshape wide units dollars transactions, i(cell year) j(quarter);	
	/*	Tab recall variables	*/
	foreach var of varlist nrecalls*07 {;
		ta `var' if year==2007;
	};
	foreach var of varlist nrecalls*06 {;
		ta `var' if year==2006;
	};
	foreach var of varlist nrecalls*05 {;
		ta `var' if year==2005;
	};
	/*	Sample restrictions based on transactions:
		Drop observations with less than 35 fourth quarter transactions at level `1' 
		(for example, in man-cat regs, droping man-cats with less than 35 total transactions to the manufacturer in a given year	*/
	bysort `1' year: egen total_trans = total(transactions4);
	sum total_trans, detail;
	drop if total_trans<35;
	sum total_trans, detail;
	sum transactions4, detail;
	/*	Take log of units and dollers, and create variable that indicates the number of non-missing observations for each cell	*/
	gen log_u1 = log(units1);
	gen log_u4 = log(units4);
	bysort cell: egen observations_u = count(log_u4);
	
	gen log_d1 = log(dollars1);
	gen log_d4 = log(dollars4);
	bysort cell: egen observations_d = count(log_d4);
	xi i.year;
end;

/*	Program to create recall dummies and leads of recall dummies (recall_t X year_t-1)	*/
program define recdummies;
	gen hvrec`1'07 = nrecalls`1'07 > 0;
	gen hvrec`1'06 = nrecalls`1'06 > 0;
	gen hvrec`1'05 = nrecalls`1'05 > 0;
	gen hvrec`1'_t = nrecalls`1'_t > 0;
	sort cell year;
	by cell: gen t06Xhvrec`1'07 = year==2006 & hvrec`1'07[_n+1]==1;
	by cell: gen t05Xhvrec`1'06 = year==2005 & hvrec`1'06[_n+1]==1;
	by cell: gen t07Xhvrec`1'06 = year==2007 & hvrec`1'06[_n-1]==1;
	by cell: gen t07Xhvrec`1'05 = year==2007 & hvrec`1'05[_n-2]==1;

	gen valbig`1'_t = recval`1'_t>=20;
	gen unbig`1'_t = recun`1'_t>=1;	
	gen valsmall`1'_t = recval`1'_t<20 & hvrec`1'_t==1;
	gen unsmall`1'_t = recun`1'_t<1 & hvrec`1'_t==1;
	gen newslow`1'_t = articles`1'_t<10 & hvrec`1'_t>0;
	gen newsmed`1'_t = articles`1'_t>=10 & articles`1'_t<100;
	gen newshigh`1'_t = articles`1'_t>=100;
	
	gen valbig`1'07 = recval`1'07>=20;
	gen unbig`1'07 = recun`1'07>=1;	
	gen valsmall`1'07 = recval`1'07<20 & hvrec`1'07==1;
	gen unsmall`1'07 = recun`1'07<1 & hvrec`1'07==1;
	gen newslow`1'07 = articles`1'07<10 & hvrec`1'07>0;
	gen newsmed`1'07 = articles`1'07>=10 & articles`1'07<100;
	gen newshigh`1'07 = articles`1'07>=100;
end;

*------------------------------------------;
** STEP 5: MERGE RECALLS TO SALES DATA AND CREATE MAN-CAT LEVEL REGRESSION DATA SET***;
*------------------------------------------;
/*	Create data set ranking firms by 2005 sales for later use	*/

use ..\data\toys_v1, clear;
collapse (sum) dollars units if year == 2005, by(parent_company);
egen total_dollars = total(dollars);
egen total_units = total(units);
gen share_dollars = dollars/total_dollars;
gen share_units = units/total_units;
egen rank_dollars = rank(share_dollars), f;
egen rank_units = rank(share_units), f;
drop total_dollars total_units;
order parent_company units share_units rank_units dollars share_dollars rank_dollars;
sort rank_units rank_dollars;
sort parent_company;
save ..\data\firmranks, replace;


/*	Start with toy level data set	*/
use ..\data\toys_v1, clear;
drop if pre_intro==1;
sort parent_company;
/*	Merge in firm ranks and identify top 15 and top 30	*/
merge parent_company using ..\data\firmranks, nokeep;
assert _merge == 3;
gen top30 = rank_units <=30;
gen top15 = rank_units <=15;
gen nontop4 = rank_units > 4;
/*	Generate quarterly time variable to later collapse at quarter level	*/
gen year_quarter = qofd(dofm(year_month));
format year_quarter %tq;	

/*-----------------------------------------------*/
/*	The following sections run regressions at various levels of observations (man, man-cat, and prop-cat). Each section contains the following steps:
	A) start with item level data
	B) collapse them to monthly data at the appropriate level of observation
	C) merge in the recall data (which is monthly)
	D) run the dataseup program above (which collapses to the quarterly level, and defines a bunch of recall variables)
	E) run the recvars program above (turns the recall variables into indicators)
	F) run regressions in units and dollars	*/
/*-----------------------------------------------*/
	

/* Collapse by man-cat and month	*/
collapse (sum) units dollars transactions (max) top30 top15 nontop4, by(parent_company category year_month year_quarter);
sort parent_company category year_month;
/*	Merge in man-cat level recalls	*/
merge parent_company category year_month using ..\data\recall_man_cat, _merge(_merge_man_cat);
ta _merge_man_cat;
drop if _merge_man_cat == 2;
/*	If _merge_man_cat == 1, this means there were no recalls in that month for that man.  */
foreach var of varlist  recval_man_cat recun_man_cat nrecalls_man_cat lead_man_cat articles_man_cat *onmkt_man_cat *onmkt4_man_cat {;
	replace `var' = 0 if _merge_man_cat == 1;
};
/*	Merge in man level recalls	*/
sort parent_company year_month;
merge parent_company year_month using ..\data\recall_man, _merge(_merge_man);
ta _merge_man;
drop if _merge_man == 2;
/*	If _merge_man == 1, this means there were no recalls in that month for that man.  */
foreach var of varlist  recval_man recun_man nrecalls_man lead_man articles_man *onmkt_man *onmkt4_man {;
	replace `var' = 0 if _merge_man == 1;
};

datasetup parent_company category;
sort cell year;
/*	Create Recall Dummies	*/
foreach type in _man_cat _man  {;
	recdummies `type';
};

save ..\data\man_cat_regdata, replace;

