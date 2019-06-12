#delimit ;
log using ~/parr/selden.sta, replace;
infile 
respmin minority age blkcoll educ days_tr partyid yrs_fed yrs_pos
  peerboth peereff peersup mincol efficncy minelig hardship
using /home/gov/faculty/ppaolino/parr/selden.asc;
set more off;
regress minelig efficncy respmin hardship minority;
predict res, resid;
hettest;
hettest respmin;
swilk res;
sktest res;
swilk minelig;
gen mineligs=(minelig+.01)*100/10002  if res<100;
ksmirnov mineligs = ibeta(1.62,1.22,mineligs);
gen lminelig=ln(mineligs/(1-mineligs));
regress lminelig efficncy respmin hardship minority;
predict lres, resid;
swilk lres;
sktest lres;
swilk lminelig;
gen mineligl=ln(minelig+1);
regress mineligl efficncy respmin hardship minority;
predict resl, resid;
swilk resl;
sktest resl;
swilk mineligl;
log close;