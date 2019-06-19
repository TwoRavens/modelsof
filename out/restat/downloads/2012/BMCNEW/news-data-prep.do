#delimit;
clear;
set more off;
capture log close;
set mem 300m;
cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";

/*****************************************************
Read in news article lists for each company.
Create data set of news article counts by date and company.
*****************************************************/


foreach comp in 
	almar
	americangreeting
	armyair
	battat
	bookspan
	boydscollection
	brio
	creativeinov
	dollargeneral
	dorel
	dunkindonuts
	eeboo
	estescox
	eveready
	fareast
	gemmy
	geometrix
	graco
	greenbrier
	guidecraft
	gund
	gymboree
	hamptondirect
	hape
	hasbroall
	henrygordy
	internationalplaythings
	internationalsourcing
	jakkspacific
	jcpenney
	joann
	kbtoys
	kidsii
	kidspreferred
	kidsstation
	kippbrothers
	leapfrog
	manstrading
	marveltoys
	mattelall
	maximenterprise
	megabrands
	mgaent
	oceandesertsales
	okktrading
	orientaltrading
	orviscompany
	rc2
	schyllingassociates
	simplyfun
	smallworldimport
	spinmaster
	sportcraft
	storkcraft
	swimways
	toysrus
	victoria
	walmart
	wildplanettoys
{;

	insheet using ../data/news/`comp'-pub.txt, clear;
	
	keep if
	strpos(v1,"January")>0	|
	strpos(v1,"February")>0	|
	strpos(v1,"March")>0	|
	strpos(v1,"April")>0	|
	strpos(v1,"May")>0	|
	strpos(v1,"June")>0	|
	strpos(v1,"July")>0	|
	strpos(v1,"August")>0	|
	strpos(v1,"September")>0	|
	strpos(v1,"October")>0	|
	strpos(v1,"November")>0	|
	strpos(v1,"December")>0	;
	gen article_num=_n;
	split v1, p(",") ignore(".   ");
	
	rename v11 source;
	rename v12 month_day;
	rename v13 year;
	
	egen source2 = concat(source month_day) if
	strpos(month_day,"January")==0	&
	strpos(month_day,"February")==0	&
	strpos(month_day,"March")==0	&
	strpos(month_day,"April")==0	&
	strpos(month_day,"May")==0	&
	strpos(month_day,"June")==0	&
	strpos(month_day,"July")==0	&
	strpos(month_day,"August")==0	&
	strpos(month_day,"September")==0	&
	strpos(month_day,"October")==0	&
	strpos(month_day,"November")==0	&
	strpos(month_day,"December")==0
	, punct(",");
	
	replace month_day = year if source2!="";
	replace year = v14 if source2!="";
	replace source = source2 if source2!="";
	
	split year, p(" ");
	drop year;
	rename year1 year;
	replace year = "" if year!="2005" & year!="2006" & year !="2007" & year !="2008" & year !="2009";
	
	egen date_string = concat(month_day year), p(", ");
	
	gen date = date(date_string, "MDY");
	format date %d;
	
	keep source article_num date_string date;
	
	gen company = "`comp'";
	save ../data/news/`comp'-pub, replace;

};

use 	../data/news/almar-pub	, clear;
foreach comp in 	
	almar
	americangreeting
	armyair
	battat
	bookspan
	boydscollection
	brio
	creativeinov
	dollargeneral
	dorel
	dunkindonuts
	eeboo
	estescox
	eveready
	fareast
	gemmy
	geometrix
	graco
	greenbrier
	guidecraft
	gund
	gymboree
	hamptondirect
	hape
	hasbroall
	henrygordy
	internationalplaythings
	internationalsourcing
	jakkspacific
	jcpenney
	joann
	kbtoys
	kidsii
	kidspreferred
	kidsstation
	kippbrothers
	leapfrog
	manstrading
	marveltoys
	mattelall
	maximenterprise
	megabrands
	mgaent
	oceandesertsales
	okktrading
	orientaltrading
	orviscompany
	rc2
	schyllingassociates
	simplyfun
	smallworldimport
	spinmaster
	sportcraft
	storkcraft
	swimways
	toysrus
	victoria
	walmart
	wildplanettoys
{;
	append using	../data/news/`comp'-pub	;
};

ta company;

/*some articles dated with a month and a year, but no day.  
Most of these have the source of "Kiplinger Retirement Report, Kiplinger's Personal Finance, or Industry Week.*/
gen date_string_a = regexr(date_string,",", " " ) if date==.;
replace date_string_a = trim(date_string_a) if date==.;
replace date_string_a = regexr(date_string_a, " "," 1, ") if date==.;
gen date_miss = date==.;
replace date = date(date_string_a, "MDY") if date == .;
drop date_string_a date_miss;

/*I have too many articles for some companies.  This occurs when there is a month in the title 
of the article.*/
drop if date==.;

ta company;

drop article_num;
gen article_num = 1 if company!=company[_n-1];
replace article_num = article_num[_n-1]+1 if company==company[_n-1];

ta source;
/*clean up the ones where the origional article number is still included in the source field*/
split source, p("   ");
replace source = source2 if source2!="";
ta source;
drop source1 source2;
split source, p("  ");
replace source = source2 if source2!="";
ta source;

drop source1 source2;

rename company news_comp;
collapse (count) article_num, by(news_comp date);
drop if date >=d(1apr2008);
preserve;
bysort news_comp: egen firstdate = min(date);
keep if firstdate==date;
drop if date==d(1jan2005);
replace date = d(1jan2005);
replace article_num=0;
drop firstdate;
save firstdate, replace;
restore;
append using firstdate;
erase firstdate.dta;

preserve;
bysort news_comp: egen lastdate=max(date);
keep if lastdate==date;
drop if date==d(31mar2008);
replace date = d(31mar2008);
replace article_num=0;
drop lastdate;
save lastdate, replace;
restore;
append using lastdate;
erase lastdate.dta;
egen comp_num = group(news_comp);
tsset comp_num date;
tsfill;
bysort comp_num: replace news_comp=news_comp[1];
replace article_num = 0 if article_num==.;


/*	articles last 30 days	*/
foreach x of numlist 0/30{;
	gen articles_day`x'=F`x'.article_num;
};
egen articles_0to30=rowtotal(articles_day*);
drop articles_day*;
foreach x of numlist 1/30{;
	gen articles_day`x'=L`x'.article_num;
};
egen articles_neg30toneg1=rowtotal(articles_day*);	
drop articles_day*;
sort news_comp date;
save ../data/newsdata, replace;

