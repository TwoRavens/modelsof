#delimit;
clear;
set memory 200m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\";

use census00_1a_foreignborn.dta;
sort  datanum serial pernum;
save census00_1a_foreignborn.dta, replace;
clear;
use census00_1b_foreignborn.dta;
sort  datanum serial pernum;
merge datanum serial pernum using census00_1a_foreignborn.dta;
drop _merge;
save census00_1_foreignborn.dta, replace;

clear;
use census00_2c_foreignborn.dta;
sort  datanum serial pernum;
save census00_2c_foreignborn.dta, replace;
clear;
use census00_2a_foreignborn.dta;
sort  datanum serial pernum;
save census00_2a_foreignborn.dta, replace;
clear;
use census00_2b_foreignborn.dta;
sort  datanum serial pernum;
save census00_2b_foreignborn.dta, replace;
clear;
use census00_3_foreignborn.dta;
sort  datanum serial pernum;
save census00_3_foreignborn.dta, replace;


use census00_1_foreignborn.dta;
sort  datanum serial pernum;
merge datanum serial pernum using census00_2c_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census00_2a_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census00_2b_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census00_3_foreignborn.dta;
drop _merge;

save census00_foreignborn.dta, replace;


clear;
use census90_2c_foreignborn.dta;
sort  datanum serial pernum;
save census90_2c_foreignborn.dta, replace;
clear;
use census90_2a_foreignborn.dta;
sort  datanum serial pernum;
save census90_2a_foreignborn.dta, replace;
clear;
use census90_2b_foreignborn.dta;
sort  datanum serial pernum;
save census90_2b_foreignborn.dta, replace;
clear;
use census90_3_foreignborn.dta;
sort  datanum serial pernum;
save census90_3_foreignborn.dta, replace;

use census90_1_foreignborn.dta;
sort  datanum serial pernum;
merge datanum serial pernum using census90_2c_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census90_2a_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census90_2b_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census90_3_foreignborn.dta;
drop _merge;

save census90_foreignborn.dta, replace;



clear;
use census80_2c_foreignborn.dta;
sort  datanum serial pernum;
save census80_2c_foreignborn.dta, replace;
clear;
use census80_2a_foreignborn.dta;
sort  datanum serial pernum;
save census80_2a_foreignborn.dta, replace;
clear;
use census80_2b_foreignborn.dta;
sort  datanum serial pernum;
save census80_2b_foreignborn.dta, replace;
clear;
use census80_3_foreignborn.dta;
sort  datanum serial pernum;
save census80_3_foreignborn.dta, replace;

use census80_1_foreignborn.dta;
sort  datanum serial pernum;
merge datanum serial pernum using census80_2c_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census80_2a_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census80_2b_foreignborn.dta;
drop _merge;
sort  datanum serial pernum;
merge datanum serial pernum using census80_3_foreignborn.dta;
drop _merge;


save census80_foreignborn.dta, replace;
