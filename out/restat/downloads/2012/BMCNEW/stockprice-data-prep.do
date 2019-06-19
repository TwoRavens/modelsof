#delimit;
clear;
set more off;
capture log close;
clear matrix;
set mem 500m;

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";

**********************************;
**Read in Mergent Data on SIC codes and stock tickers**;
**********************************;

insheet using ..\data\raw-data\mergent-sic.csv, c n;
sort companyname;
save ..\data\mergent-sic, replace;

insheet using ..\data\raw-data\mergent-tickers.csv, c n clear;
sort companyname;
save ..\data\mergent-tickers, replace;

merge companyname using ..\data\mergent-sic;
ta _merge;
assert _merge==3;

split siccodes, p(,) destring;
drop siccodes1; /*siccodes1 is blank for all companies as the first character in siccodes is a "," for all companies*/
assert siccode == siccodes2; /*siccode is the primary siccode from the mergent-ticker file.  it should match the first siccode listed in mergent-sic*/

/**********************************************************************************
Note: This file includes all companies with any SIC code in the following categories:
394: Dolls, Toys, Games And Sporting And Athletic (Manufacturing)
	This includes
	3942 Dolls and Stuffed Toys
	3944 Games, Toys, and Children's Vehicles, Except Dolls and Bicycles
	3949 Sporting and Athletic Goods, Not Elsewhere Classified

5091: Sporting and Recreational Goods and Supplies (Wholesale Trade)
5092: Toys and Hobby Goods and Supplies (Wholesale Trade)

53: General Merchandise Stores 
	This Includes
	5311 Department Stores
	5331 Variety Stores
	5399 Miscellaneous General Merchandise Stores

594: Miscellaneous Shopping Goods Stores
	This Includes
	5941 Sporting Goods Stores and Bicycle Shops
	5942 Book Stores
	5943 Stationery Stores
	5944 Jewelry Stores
	5945 Hobby, Toy, and Game Shops
	5946 Camera and Photographic Supply Stores
	5947 Gift, Novelty, and Souvenir Shops
	5948 Luggage and Leather Goods Stores
	5949 Sewing, Needlework, and Piece Goods Stores
************************************************************************************/

/***********************************************************************************
siccode2 is the primary sic code of the company.  the rest are secondary codes.
below I create dummies to indicate if the primary or any of the secondary sic codes are in the following categories:
Toy Manufacturer, Toy Wholesaler, General Merchandise, Toy Retailer, Other Misc. Shopping Goods retailer

NOTE: Each company can be in at most 1 of the primary categories.  Some may be in 0.
Each company must be in at least 1 of the secondary categories, but can be in more.
**************************************************************************************/

gen prim_toy_man = siccodes2 == 3942 | siccodes2== 3944;
egen sec_toy_man = anymatch(siccodes3-siccodes24), v(3942,3944);

gen prim_toy_whol = siccodes2 == 5092;
egen sec_toy_whol = anymatch(siccodes3-siccodes24), v(5092);

gen prim_toy_ret = siccodes2 == 5945 | siccodes2 == 5941;
egen sec_toy_ret = anymatch(siccodes3-siccodes24), v(5945);

gen prim_oth_ret = siccodes2 == 5942 | siccodes2 == 5943 | siccodes2 == 5944 | siccodes2 == 5946 | siccodes2 == 5947 | siccodes2 == 5948 | siccodes2 == 5949;
egen sec_oth_ret = anymatch(siccodes3-siccodes24), v(5942/5944, 5946/5949);

gen prim_gen_merch = siccodes2 == 5311 | siccodes2 == 5331 | siccodes2 == 5399;
egen sec_gen_merch = anymatch(siccodes3-siccodes24), v(5311, 5331, 5399);

sum prim* sec*;

/*some tickers specify a share type, but want to merge to the stock price data on just the ticker*/
sort ticker;
split ticker, p(" ");
rename ticker ticker_mergent_raw;
rename ticker1 ticker;
rename ticker2 share_type_mergent;

sort ticker;
list if (ticker == ticker[_n-1] | ticker == ticker[_n+1]) & ticker !="-";
/*Two companies have the ticker FUN.  Neither are traded in the US*/

sort ticker;
save ..\data\mergent-sic-ticker, replace;

**********************************;
**Read in Fama-French data on stock market indices**;
**********************************;

insheet using ../data/raw-data\F-F_Factors.csv, comma names clear;
gen year = int(v1/10000);
gen tempdate = v1-year*10000;
gen month = int(tempdate/100);
gen day = tempdate - month*100;
gen date = mdy(month, day, year);
format date %d;
destring smb, ignore("NaN") replace;
destring hml, ignore("NaN") replace;
drop v1 year tempdate month day;
sort date;
save ../data/F-F_Factors, replace;

insheet using ../data/raw-data\F-F_49ind.csv, comma names clear;
gen year = int(v1/10000);
gen tempdate = v1-year*10000;
gen month = int(tempdate/100);
gen day = tempdate - month*100;
gen date = mdy(month, day, year);
format date %d;
drop v1 year tempdate month day;
sort date;
save ../data/F-F_49ind, replace;

/*---------------------------------------------------------------------------*/



/**********************
Clean the CRSP data
**********************/
use ..\data\raw-data\crsp-02-07, clear;
gen month = substr(date, 1, 2);
gen day = substr(date, 3, 2);
gen year = substr(date, 5, 4);
destring month day year, replace;
drop date;
gen date = mdy(month, day, year);
sort ticker date;
/*IMPORTANT: in CRSP data, if the closing price is not available for a security on a given day, the prc varialbe instead records
a bid/ask average.  This is indicated by a NEGATIVE price.  I will change these values to a positive price and create an indicator
for days on which the price is the bid/ask average*/
gen prc_avg = prc<0;
gen stock_price = abs(prc);
rename comnam comp_name_CRSP;
ta comp_name_CRSP if ticker=="";
drop if ticker==""; 
/*324 observations on "S O R L AUTO PARTS INC" have missing  and 573 observations for "DREAMS INC" Ticker, and missing prices.  These are all of the observations for this company prior to April 18,2006.  Maybe before it actually started trading?*/
drop if comp_name == "D R C RESOURCES CORP" ; /*Want DREAMS, but CRSP is pulling up DRC Resources also.  Looks like DRC used the ticker prior to DREAMS using it*/

/*CRSP has a permno variable that stays the same even if company name or ticker chagnes.  Use this to check that I have fixed all tickers that change*/
list ticker if (ticker != ticker[_n-1] & permno==permno[_n-1]) | (ticker != ticker[_n+1]& permno==permno[_n+1]);
list comp_name if (comp_name != comp_name[_n-1] & permno==permno[_n-1]) | (comp_name != comp_name[_n+1]& permno==permno[_n+1]);

/*Some companies experience name or ticker changes during the sample period
I will make the names uniform throughout the sample by taking the most recent name */

drop if comp_name_CRSP == "SPECTRASITE INC";
replace ticker = "SSI" if ticker == "STGS"; /*SSI was used for Spectrasite Inc through Aug 2005.  March 16, 2006, Stage Stores switched from STGS to SSI.  Drop observations for Spectrasite and change Stage Stores ticker to SSI for all dates*/


rename ticker ticker_CRSP;
gsort permno -date;
by permno: gen ticker = ticker_CRSP[1];

rename comp_name_CRSP comp_name_CRSP_orig;
gsort permno -date;
by permno: gen comp_name_CRSP = comp_name_CRSP_orig[1];

ta ticker shrcls;
replace ticker = "SPCH" if ticker == "SPCHB";

/******************
Merge SIC code info from Mergent
*******************/
sort ticker;
merge ticker using ..\data\mergent-sic-ticker, keep(prim_toy_man sec_toy_man prim_toy_whol sec_toy_whol prim_toy_ret sec_toy_ret prim_oth_ret sec_oth_ret prim_gen_merch sec_gen_merch) _merge(_sic_merge);
ta ticker _sic_merge;

drop if _sic_merge==2; /*companies not on the NA exchanges pulled from mergent*/;
sort ticker date;
format date %d;

/*_sic_merge==1 implies we don't have sic info on the company from Mergent.  This means that it must not be in one of the categories we pulled from mergent,
so i will replace all the dummies = 0 for these firms.  Note, Toys R Us isn't pulled by Mergent because it is currently private, though
it was public earlier in our sample.  So these sic dummies will be 0 for Toys R Us. In the end we focus on manufacturers, so this won't matter*/
foreach var of varlist prim_toy_man sec_toy_man prim_toy_whol sec_toy_whol prim_toy_ret sec_toy_ret prim_oth_ret sec_oth_ret prim_gen_merch sec_gen_merch {;
	replace `var' = 0 if _sic_merge==1;
};

keep stock_price shrout ret retx sprtrn vwret*  prim_toy_man sec_toy_man prim_toy_whol sec_toy_whol prim_toy_ret sec_toy_ret prim_oth_ret sec_oth_ret prim_gen_merch sec_gen_merch ticker shrcls date;

gen toy_producer = prim_toy_man==1 | sec_toy_man==1;

/******************
Merge Fama French factors and series for houshold goods
*******************/
sort date;
merge date using ../data/F-F_Factors, nokeep;
assert _merge==3;
drop _merge;
sort date;
merge date using ../data/F-F_49ind, nokeep keep(hshld);
assert _merge == 3;
drop _merge;


/*Keep only observations for share class A*/
drop if shrcls == "B"; 

compress;

save ..\data\stock-price-data, replace;


/******************
*Merge recall information and prepare data set for event studies;
*******************/
sort ticker;
merge ticker using ../data/eventcount;
ta _merge;
keep if _merge==3;
drop _merge;

/*	Generate a full set of stock price observations for EACH event that a firm is associated with	*/
expand eventcount; 
drop eventcount;
bysort ticker shrcls date: gen set = _n;
sort ticker set;


/*	Merge the event dates to the stock data	*/
merge ticker set using  ../data/pubtraded_recall_dates;
assert _merge==3;
drop _merge;

/*	Make an identifier for each event date/company combo (ie: each event).*/
egen group_id = group(ticker set); 
sum group_id;
/*	56 events	*/
preserve;
bysort group_id: keep if _n==1;
ta toy_producer;
gen year = year(event_date);
ta year toy_producer;
/*	25 events involving toy producer - 13 in 2007	*/
ta ticker year if toy_producer==1;
bysort ticker year: keep if _n==1;
ta toy_producer;
ta year toy_producer;
/*	8 total firms - 6 in 2007	*/
restore;

/*	Count the number of trading days since the event date	*/
sort group_id date;
by group_id: gen datenum = _n;
by group_id: gen target = datenum if date == event_date;
egen td = min(target), by(group_id);
drop target;
gen dif=datenum-td; 

sort group_id date;
by group_id: gen return = (stock_price - stock_price[_n-1])/stock_price[_n-1];

/*	SMB is missing for one day - replace it with 0	*/
ta date if smb == .;
replace smb = 0 if smb == .;

foreach var of varlist mktrf smb hml rf {;
	replace `var' = `var'/100;
};	
gen retrf = retx-rf;
save ../data/event-study-data, replace;





