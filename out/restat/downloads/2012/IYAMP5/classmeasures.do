clear
set mem 300m
infile using "classmeasures.dct"
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
   label define f1class
      1  "am - morning"  
      2  "pm - afternoon"  
      3  "ad - all day"  
;
   label define f2class
      1  "am - morning"  
      2  "pm - afternoon"  
      3  "ad - all day"  
;
   label define specs
      1  "child got special education services"  
      2  "child did not get special education services"  
;
   label define tf
      1  "true"  
      0  "false"  
;
   label define tf19f
      1  "true"  
      0  "false"  
;
   label define dobmm
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
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
   label define r5age
      1  "less than 105"  
      2  "105 to less than 108"  
      3  "108 to less than 111"  
      4  "111 to less than 114"  
      5  "114 to less than 117"  
      6  "117 or more"  
;
   label define schg
      1  "child did not change school"  
      2  "child transferred from public school to public school"  
      3  "child transferred from private school to private school"  
      4  "child transferred from public school to private school"  
      5  "child transferred from private school to public school"  
      6  "child transferred, other"  
;
   label define a1class
      1  "am - morning"  
      2  "pm - afternoon"  
      3  "ad - all day"  
;
   label define a4class
      1  "k 2000 questionnaire morning class"  
      2  "k 2000 questionnaire afternoon class"  
      3  "k 2000 questionnaire full-day class"  
      4  "post-k 2000 questionnaire"  
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
   label define c1asmtmm
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define c1asmtyy
      1998  "1998"  
;
   label define c2asmtmm
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
;
   label define c2asmtyy
      1999  "1999"  
;
   label define c3asmtmm
      9  "september"  
      10  "october"  
      11  "november"  
;
   label define c3asmtyy
      1999  "1999"  
;
   label define c4asmtmm
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
;
   label define c4asmtyy
      2000  "2000"  
;
   label define c5asmtmm
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
;
   label define c5asmtyy
      2002  "2002"  
;
   label define a1021f
      1  "yes"  
      2  "no"  
;
   label define a1022f
      1  "none"  
      2  "1 - 25%"  
      3  "26 - 50%"  
      4  "51 - 75%"  
      5  "76% or more"  
;
   label define a1027f
      1  "group misbehaves very frequently"  
      2  "group misbehaves frequently"  
      3  "group misbehaves occasionally"  
      4  "group behaves well"  
      5  "group behaves exceptionally well"  
;
   label define a1045f
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define a1047f
      1998  "1998"  
;
   label define a2025f
      1  "group misbehaves very frequently"  
      2  "group misbehaves frequently"  
      3  "group misbehaves occasionally"  
      4  "group behaves well"  
      5  "group behaves exceptionally well"  
;
   label define a2029f
      1  "never"  
      2  "less than once a week"  
      3  "1-2 times a week"  
      4  "3-4 times a week"  
      5  "daily"  
;
   label define a2030f
      1  "1-30 minutes a day"  
      2  "31-60 minutes a day"  
      3  "61-90 minutes a day"  
      4  "more than 90 minutes a day"  
;
   label define a2031f
      1  "do not participate in physical education"  
      2  "1-15 minutes per day"  
      3  "16-30 minutes per day"  
      4  "31-60 minutes per day"  
      5  "more than 60 minutes per day"  
;
   label define a2033f
      1  "once"  
      2  "twice"  
      3  "three or more times"  
;
   label define a2034f
      1  "1-15 minutes"  
      2  "16-30 minutes"  
      3  "31-45 minutes"  
      4  "longer than 45 minutes"  
;
   label define a2035f
      1  "1-15 minutes"  
      2  "16-30 minutes"  
      3  "31-45 minutes"  
      4  "longer than 45 minutes"  
;
   label define a2036f
      1  "never"  
      2  "less than once a week"  
      3  "once or twice a week"  
      4  "three or four times a week"  
      5  "daily"  
;
   label define a2038f
      1  "1-15 minutes/day"  
      2  "16-30 minutes/day"  
      3  "31-60 minutes/day"  
      4  "longer than 60 minutes/day"  
;
   label define a2068f
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define a2070f
      1999  "1999"  
;
   label define b1002f
      1  "yes"  
      2  "no"  
;
   label define b1007f
      1  "strongly disagree"  
      2  "disagree"  
      3  "neither agree nor disagree"  
      4  "agree"  
      5  "strongly agree"  
;
   label define b1010f
      1  "male"  
      2  "female"  
;
   label define b1012f
      1  "yes"  
      2  "no"  
;
   label define b1024f
      1  "high school/associate's degree/bachelor's degree"  
      2  "at least one year beyond bachelor's"  
      3  "master's degree"  
      4  "education specialist/professional diploma"  
      5  "doctorate"  
;
   label define b1026f
      1  "none"  
      2  "temporary/probational certification"  
      3  "alternative program certification"  
      4  "regular certification, less than highest"  
      5  "highest certification available"  
;
   label define b1027f
      1  "yes"  
      2  "no"  
;
   label define b1028f
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define b1030f
      1998  "1998"  
      1999  "1999"  
;
   label define t1002f
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define t1004f
      1998  "1998"  
      1999  "1999"  
;
   label define t2014f
      1  "january"  
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define t2016f
      1999  "1999"  
;
   label define t4015f
      2000  "2000"  
;
   label define t4017f
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define t5qxcom
      2  "february"  
      3  "march"  
      4  "april"  
      5  "may"  
      6  "june"  
      7  "july"  
      8  "august"  
      9  "september"  
      10  "october"  
      11  "november"  
      12  "december"  
;
   label define t5qxcoy
      2002  "2002 "  
;
   label values a1otlan a1021f;
   label values a1presc a1021f;
   label values a1pcpre a1022f;
   label values a1behvr a1027f;
   label values a1compmm a1045f;
   label values a1compyy a1047f;
   label values a1class a1class;
   label values a2class a1class;
   label values a2behvr a2025f;
   label values a2oftart a2029f;
   label values a2oftdan a2029f;
   label values a2oftesl a2029f;
   label values a2oftfor a2029f;
   label values a2ofthtr a2029f;
   label values a2oftmth a2029f;
   label values a2oftmus a2029f;
   label values a2oftrdl a2029f;
   label values a2oftsci a2029f;
   label values a2oftsoc a2029f;
   label values a2txpe a2029f;
   label values a2txart a2030f;
   label values a2txdan a2030f;
   label values a2txesl a2030f;
   label values a2txfor a2030f;
   label values a2txmth a2030f;
   label values a2txmus a2030f;
   label values a2txrdla a2030f;
   label values a2txsci a2030f;
   label values a2txsoc a2030f;
   label values a2txthtr a2030f;
   label values a2txspen a2031f;
   label values a2txrce a2033f;
   label values a2lunch a2034f;
   label values a2recess a2035f;
   label values a2divmth a2036f;
   label values a2divrd a2036f;
   label values a2minmth a2038f;
   label values a2minrd a2038f;
   label values a2mmcomp a2068f;
   label values a2yycomp a2070f;
   label values a4class a4class;
   label values b1hisp b1002f;
   label values b2hisp b1002f;
   label values b1enjoy b1007f;
   label values b1mkdiff b1007f;
   label values b1teach b1007f;
   label values b2enjoy b1007f;
   label values b2mkdiff b1007f;
   label values b2teach b1007f;
   label values b1tgend b1010f;
   label values b2tgend b1010f;
   label values b1race1 b1012f;
   label values b1race2 b1012f;
   label values b1race3 b1012f;
   label values b1race5 b1012f;
   label values b2race1 b1012f;
   label values b2race2 b1012f;
   label values b2race3 b1012f;
   label values b2race5 b1012f;
   label values b1hghstd b1024f;
   label values b2hghstd b1024f;
   label values b1typcer b1026f;
   label values b2typcer b1026f;
   label values b1elemct b1027f;
   label values b1erlyct b1027f;
   label values b1othcrt b1027f;
   label values b2elemct b1027f;
   label values b2erlyct b1027f;
   label values b1mmcomp b1028f;
   label values b1yycomp b1030f;
   label values c1asmtmm c1asmtmm;
   label values c1asmtyy c1asmtyy;
   label values c2asmtmm c2asmtmm;
   label values c2asmtyy c2asmtyy;
   label values c3asmtmm c3asmtmm;
   label values c3asmtyy c3asmtyy;
   label values c4asmtmm c4asmtmm;
   label values c4asmtyy c4asmtyy;
   label values c5asmtmm c5asmtmm;
   label values c5asmtyy c5asmtyy;
   label values dobmm dobmm;
   label values f1class f1class;
   label values f2class f2class;
   label values gender gender;
   label values r5age r5age;
   label values race race;
   label values r4r2schg schg;
   label values r5r4schg schg;
   label values f2specs specs;
   label values a2autsm suppress;
   label values a2deaf suppress;
   label values a2multi suppress;
   label values b1race4 suppress;
   label values b2race4 suppress;
   label values t1rscomm t1002f;
   label values t1rscoyy t1004f;
   label values t2rscomm t2014f;
   label values t2rscoyy t2016f;
   label values t4qxcoy t4015f;
   label values t4qxcom t4017f;
   label values t5glvl t501f;
   label values t5qxcom t5qxcom;
   label values t5qxcoy t5qxcoy;
   label values r3sample tf;
   label values fkchgsch tf19f;
   label values fkchgtch tf19f;
   label values p1firkdg yn89f;
compress;
sort childid;
save "classmeasures.dta", replace;
use "classmeasures.dta";
tabulate f1class;
tabulate f2class;
tabulate f2specs;
tabulate dobmm;
tabulate gender;
tabulate race;
tabulate r3sample;
tabulate r5age;
tabulate fkchgtch;
tabulate fkchgsch;
tabulate r4r2schg;
tabulate r5r4schg;
tabulate a1class;
tabulate a2class;
tabulate a4class;
tabulate p1firkdg;
tabulate t5glvl;
tabulate c1asmtmm;
tabulate c1asmtyy;
tabulate c2asmtmm;
tabulate c2asmtyy;
tabulate c3asmtmm;
tabulate c3asmtyy;
tabulate c4asmtmm;
tabulate c4asmtyy;
tabulate c5asmtmm;
tabulate c5asmtyy;
tabulate a1presc;
tabulate a1pcpre;
tabulate a1behvr;
tabulate a1otlan;
tabulate a1compmm;
tabulate a1compyy;
tabulate a2multi;
tabulate a2autsm;
tabulate a2deaf;
tabulate a2behvr;
tabulate a2oftrdl;
tabulate a2txrdla;
tabulate a2oftmth;
tabulate a2txmth;
tabulate a2oftsoc;
tabulate a2txsoc;
tabulate a2oftsci;
tabulate a2txsci;
tabulate a2oftmus;
tabulate a2txmus;
tabulate a2oftart;
tabulate a2txart;
tabulate a2oftdan;
tabulate a2txdan;
tabulate a2ofthtr;
tabulate a2txthtr;
tabulate a2oftfor;
tabulate a2txfor;
tabulate a2oftesl;
tabulate a2txesl;
tabulate a2txpe;
tabulate a2txspen;
tabulate a2txrce;
tabulate a2lunch;
tabulate a2recess;
tabulate a2divrd;
tabulate a2divmth;
tabulate a2minrd;
tabulate a2minmth;
tabulate a2mmcomp;
tabulate a2yycomp;
tabulate b1enjoy;
tabulate b1mkdiff;
tabulate b1teach;
tabulate b1tgend;
tabulate b1hisp;
tabulate b1race1;
tabulate b1race2;
tabulate b1race3;
tabulate b1race4;
tabulate b1race5;
tabulate b1hghstd;
tabulate b1typcer;
tabulate b1elemct;
tabulate b1erlyct;
tabulate b1othcrt;
tabulate b1mmcomp;
tabulate b1yycomp;
tabulate b2enjoy;
tabulate b2mkdiff;
tabulate b2teach;
tabulate b2tgend;
tabulate b2hisp;
tabulate b2race1;
tabulate b2race2;
tabulate b2race3;
tabulate b2race4;
tabulate b2race5;
tabulate b2hghstd;
tabulate b2typcer;
tabulate b2elemct;
tabulate b2erlyct;
tabulate t1rscomm;
tabulate t1rscoyy;
tabulate t2rscomm;
tabulate t2rscoyy;
tabulate t4qxcom;
tabulate t4qxcoy;
tabulate t5qxcom;
tabulate t5qxcoy;
summarize dobdd dobyy r1_kage r2_kage r3age r4age a1pblk a1phis a1pmin b1age b2age b4age c1asmtdd c2asmtdd c3asmtdd c4asmtdd c5asmtdd a1hrsda a1dyswk a1totag a1asian a1hisp a1black a1white a1amrin a1raceo a1totra a1boys a1girls a1repk a1lett a1word a1sntnc a1compdd a2gift a2prtgf a2disab a2impai a2lrndi a2emprb a2retar a2delay a2vis a2hear a2ortho a2other a2traum a2otdis a2spcia a2dyrecs a2numrd a2numth a2ddcomp b1yrborn b1yrspre b1yrskin b1yrsfst b1yrs2t5 b1yrs6pl b1yrsesl b1yrsbil b1yrsspe b1yrspe b1yrsart b1yrsch b1ddcomp b2yrborn b2yrspre b2yrskin b2yrsfst b2yrs2t5 b2yrs6pl b2yrsesl b2yrsbil b2yrsspe b2yrspe b2yrsart b2yrsch t1rscodd t2rscodd t4qxcod t5qxcod;
