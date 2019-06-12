#delimit ;
log using ~/parr/soss.sta, replace;
infile 
year scostfam sbvalue sdemgovt secon sflabor swash sgcfound sapps
  year1991 year1992 id sort 
  using /home/gov/faculty/ppaolino/parr/soss.asc;
set more off;
regress sgcfound scostfam sbvalue sapps sflabor secon sdemgovt year1991
    year1992;
predict res, resid;
hettest;
hettest sbvalue;
hettest sapps;
swilk res;
swilk sgcfound;
gen sgcfs=(sgcfound)*100/10001;
sum sgcfs;
ksmirnov sgcfs = ibeta(3.80,1.586,sgcfs);
ksmirnov sgcfs = ibeta(3.35,1.35,sgcfs);
gen lsgcfs=ln(sgcfs/(1-sgcfs));
regress lsgcfs scostfam sbvalue sapps sflabor secon sdemgovt year1991
    year1992;
predict lres, resid;
hettest;
hettest sbvalue;
hettest sapps;
swilk lres;
sktest lres;
log close;