#delimit;
clear;
set more off;
set mem 900m;
set matsize 1000;
set scheme s2mono;

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";
/*	RA1 - looked up toy by toy on manufacturers' websites to identify country of origin	*/
insheet using insheet using ../data/manufactured-in-by-ra1.csv, comma names clear;
rename itemdescription item;
rename categorycat category;
rename model model_number;
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
duplicates drop parent_company item model_number license brand, force;
replace brand = "no brand" if brand == "";
replace license = "no license" if license ==""; 
drop introdatetodata;
sort parent_company item model_number license brand;
rename manufacturedin manufacturedin_ra1;
save ../data/manufacturedin-ra1, replace;

/*	RA2 - looked at manufacturer websites for general country of origin (not toy by toy)	*/
insheet using ../data/manufactured-in-by-ra2.csv, comma names clear;
rename company parent_company;
replace parent_company = upper(parent_company);
replace parent_company = "HALLMARK" if parent_company == "CRAYOLA LLC";
replace parent_company = "EDU SHAPE" if parent_company == "EDUSHAPE";
replace parent_company = "MAISTO INTL" if parent_company == "MAISTO INTL.";
rename country manufacturedin_ra2;
sort parent_company;
save ../data/manufacturedin-ra2, replace;


/*Combine versions of each RA	*/
use ../data/manufacturedin-ra1;
sort parent_company;
merge parent_company using ../data/manufacturedin-ra2;
ta _merge;
label var   manufacturedin_ra1 "ra1";
label var   manufacturedin_ra2 "ra2";
ta  manufacturedin_ra1 manufacturedin_ra2, missing;

gen china_ra1 = lower(manufacturedin_ra1)=="china" | manufacturedin_ra1 == "";
gen chinaother_ra1 = strpos(lower(manufacturedin_ra1), "china")>0 | manufacturedin_ra1 == "";
replace chinaother_ra1 = 1 if parent_company == "TOMY";

gen china_ra2 = lower(manufacturedin_ra2)=="china" | manufacturedin_ra2=="";
gen chinaother_ra2 = lower(manufacturedin_ra2)=="china" |
					  lower(manufacturedin_ra2)=="asia" |
					  lower(manufacturedin_ra2)=="hong kong" |
					  manufacturedin_ra2=="";
gen china = china_ra2==1 & china_ra1==1;
gen chinaother = chinaother_ra2==1 & chinaother_ra1==1;
ta manufacturedin_ra1 china, missing;
ta manufacturedin_ra1 chinaother, missing;
ta manufacturedin_ra2 china, missing;
ta manufacturedin_ra2 chinaother, missing;
sort parent_company item model_number license brand;
drop _merge;
save ../data/manufacturedin, replace;

/*	Merge country of origin to toy data	*/
use ../data/toys_v1, clear;
sort parent_company item model_number license brand;
merge parent_company item model_number license brand using ../data/manufacturedin, nokeep;
assert _merge == 3;
gen year_qt = qofd(dofm(year_month));


/*	Fraction of units made outside of china	*/
preserve;
collapse (sum) units dollars, by(year_qt china);
tsset china year_qt, quarterly;
bysort year_qt: egen total_units = total(units);
gen percent_units = units/total_units;
list year_qt percent_units if china==0;
restore;

/*	Fraction of units made outside of china including Hong Kong, "Asia," and those that list multiple locations including China
	This is version reported in paper	*/
preserve;
collapse (sum) units dollars, by(year_qt chinaother);
tsset china year_qt, quarterly;
bysort year_qt: egen total_units = total(units);
gen percent_units = units/total_units;
list year_qt percent_units if china==0;
restore;


/*	Sales of American Plastic Toys and Playmobil	*/
preserve;
collapse (sum) units dollars, by(parent_company year_qt);
egen firm = group(parent_company);
tsset firm year_qt, quarterly;
bysort year_qt: egen total_units = total(units);
gen share_units = units/total_units;
list year_qt share_units if parent_company == "AMERICAN PLASTIC TOYS";
list year_qt share_units if parent_company == "PLAYMOBIL";
tw (line share_units year_qt if parent_company == "AMERICAN PLASTIC TOYS") (line share_units year_qt if parent_company == "PLAYMOBIL"), legend(lab(1 "American Plastic Toys") lab(2 "Playmobil")) tlabel(2005q1(1)2007q4, angle(45))  tline(2007q2) tline(2007q3) ytitle(Share) ttitle(Quarter);
graph export ../output/amplastics_playmobil_share_q.tif, as(tif) replace;
restore;


