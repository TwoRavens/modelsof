clear
clear matrix
capture log close
set mem 400m
set more on

#delimit ;

log using 4sumstats, replace;
use 3BcarinstDrop25.dta, replace;


tab Fclass, gen(cla);

gen price= princ*inc;

sort ma;
tabstat q princ hp eurokm wi he nhome market_duration , stat(mean sd) long col(stat) save;
by ma: tabstat q princ hp eurokm wi he nhome market_duration , stat(mean sd) long col(stat) save;


by ma: tabstat q hp li wi he price cla1-cla7, stat (mean sd) long col(stat) save;
tabstat nhome [weight=q], stat(mean sd) save;
by ma: tabstat nhome [weight=q], stat(mean sd) save;

return list;

table Fclass, contents (mean q mean price mean hp mean eurokm);
table Fclass, contents (mean wi mean he mean nhome);
table ma year, contents (count model);


log close;
exit;
