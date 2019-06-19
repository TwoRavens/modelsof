*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Figure-1.do								*
*************************************************************************

#delimit;

drop _all;

* food stamp start date;
use foodstamps;
sort stfips countyfips;
save temppop;

use pop1960;
sort stfips countyfips;

merge stfips countyfips using temppop;
tab _merge;

tab fs_year [weight=totalpop];

rm temppop;

exit, clear;
