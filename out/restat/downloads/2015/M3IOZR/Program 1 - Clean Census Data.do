/****************************************************************************************/
/* This program cleans the Census Data                                                  */
/****************************************************************************************/

#delimit ;

clear;
set mem 1000m; 
set matsize 800;
set more off;
set trace off;


/****************************************************************************************/
/*Read in Data                                                                          */
/****************************************************************************************/

use  "raw_census_data.dta", clear;

/****************************************************************************************/
/*Keep those observations that are in the City of Syracuse                              */
/****************************************************************************************/

/*Drop census tracts that are not in the city and have no observations                  */

drop if census == "36067015900"
 | census == "36067011012"
 | census == "36067011402"
 | census == "36067011231"
 | census == "36067016502"
 | census == "36067016001"
 | census == "36067016901"
 | census == "36067010321"
 | census == "36067016501"
 | census == "36067011011"
 | census == "36067016802"
 | census == "36067016801"
 | census == "36067011242"
 | census == "36067015700"
 | census == "36067010200"
 | census == "36067015400"
 | census == "36067012300"
 | census == "36067011241"
 | census == "36067011021"
 | census == "36067010322"
 | census == "36067016600"
 | census == "36067011232"
 | census == "36067015000"
 | census == "36067011401"
 | census == "36067016902"
 | census == "36067015300"
 | census == "36067015500"
 | census == "36067011202"
 | census == "36067015203"
 | census == "36067016700"
 | census == "36067010301"
 | census == "36067013500"
 | census == "36067016002";

/****************************************************************************************/
/*Rename Variables                                                                      */
/****************************************************************************************/

ren trctpop0 tractpop;
ren shrwht0  sharewhite;
ren shrblk0  shareblack;
ren shrhsp0  sharehisp;

/****************************************************************************************/
/*Calculate Race Percentages                                                            */
/****************************************************************************************/

gen blacktotpertract = tractpop * shareblack;
gen whitetotpertract = tractpop * sharewhite;
egen totblack = sum(blacktotpertract);
egen totwhite = sum(whitetotpertract);
egen syrpop = sum(tractpop);
gen cityshrblack = totblack/syrpop;
gen cityshrwhite = totwhite/syrpop;
gen blacktract = shareblack >= cityshrblack;
gen whitetract = sharewhite >= cityshrwhite;

/****************************************************************************************/
/*Save Data Set                                                                         */
/****************************************************************************************/

sort census;
save Census_data_cleaned.dta, replace;                 
