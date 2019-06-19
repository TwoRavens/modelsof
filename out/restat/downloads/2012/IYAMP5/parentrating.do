infile using "parentrating.dct"
#delimit ;
keep if  (r3sample == 1 | 
       r3sample == 0); 
   keep if (r4r2schg == 1 | 
       r4r2schg == 2 | 
       r4r2schg == 3 | 
       r4r2schg == 4 | 
       r4r2schg == 5 | 
       r4r2schg == 6 | 
       r4r2schg == -1 | 
       r4r2schg == -9 | 
       r4r2schg == .); 
   keep if (r5r4schg == 1 | 
       r5r4schg == 2 | 
       r5r4schg == 3 | 
       r5r4schg == 4 | 
       r5r4schg == 5 | 
       r5r4schg == 6 | 
       r5r4schg == -1 | 
       r5r4schg == -9 | 
       r5r4schg == .); 
   keep if (p1firkdg == 1 | 
       p1firkdg == 2 | 
       p1firkdg == -8 | 
       p1firkdg == -9 | 
       p1firkdg == .); 
   keep if (t5glvl == 1 | 
       t5glvl == 2 | 
       t5glvl == 3 | 
       t5glvl == 4 | 
       t5glvl == 5 | 
       t5glvl == 6 | 
       t5glvl == 7 | 
       t5glvl == -9 | 
       t5glvl == .);
   label define tf
      1  "true"  
      0  "false"  
;
   label define gender
      1  "male"  
      2  "female"  
;
   label define race
      1  "white, non-hispanic"  
      2  "black or african american, non-hispanic"  
      3  "hispanic, race specified"  
      4  "hispanic, race not specified"  
      5  "asian"  
      6  "native hawaiian, other pacific islander"  
      7  "american indian or alaska native"  
      8  "more than one race, non hispanic"  
;
   label define schg
      1  "child did not change school"  
      2  "child transferred from public school to public school"  
      3  "child transferred from private school to private school"  
      4  "child transferred from public school to private school"  
      5  "child transferred from private school to public school"  
      6  "child transferred, other"  
;
   label define yn89f
      1  "yes"  
      2  "no"  
;
   label define t501f
      1  "kindergarten"  
      2  "first grade"  
      3  "second grade"  
      4  "third grade"  
      5  "fourth grade"  
      6  "fifth grade"  
      7  "ungraded classroom"  
;
   label values gender gender;
   label values race race;
   label values r4r2schg schg;
   label values r5r4schg schg;
   label values t5glvl t501f;
   label values r3sample tf;
   label values p1firkdg yn89f;
sort childid;
save "parentrating.dta", replace;
use "parentrating.dta";
tabulate gender;
tabulate race;
tabulate r3sample;
tabulate r4r2schg;
tabulate r5r4schg;
tabulate p1firkdg;
tabulate t5glvl;
summarize p1learn p1contro p1social p1sadlon p1impuls p2learn p2contro p2social p2sadlon p2impuls p4learn p4contro p4social p4sadlon p4impuls;
