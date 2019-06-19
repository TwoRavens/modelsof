#delimit ;
*REStat paper, "Breastfeeding and Children's Early Cognitive Outcomes";
log using x:/Donnanew/bfwage08.log, replace;
clear;
set mem 40m;
set more off;
set matsize 800;

use x:/Donnanew/bfwage08;

gen wt08x = int(wt08);

drop wt08;

sum;
sum [fweight=wt08x];
sum if female==0 [fweight=wt08x];
sum if female==1 [fweight=wt08x];

**missing obs., dvs;
replace exp20e = 0 if expedv == 1;
replace exp20a = 0 if expadv == 1;
replace lnhhinc = 0 if hhincdv == 1;

replace biodaded = 0 if daddv == 1;
replace biomomed = 0 if momdv == 1;

replace twobio97 = 0 if famdv == 1;
replace twostp97 = 0 if famdv == 1;
replace biom97 = 0 if famdv == 1;
replace biod97 = 0 if famdv == 1;
replace other97 = 0 if famdv == 1;

gen exp20a2 = exp20a*exp20a;
gen exp20e2 = exp20e*exp20e;

*summarize;

				  
reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv
                 [pweight=wt08x] if female == 0, robust; 

reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv
                 [pweight=wt08x] if female == 1, robust; 
				 
				 
**add in experience, pt/ft, age at job;				 
reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv exp20e exp20e2 pt08 expedv agej24 agej25
                 [pweight=wt08x] if female == 0, robust; 

reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv exp20e exp20e2 pt08 expedv agej24 agej25
                 [pweight=wt08x] if female == 1, robust; 

				 
**add in highest grade of education;				 
reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv exp20e exp20e2 pt08 expedv agej24 agej25
          hgc08    [pweight=wt08x] if female == 0, robust; 

reg lnw08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv exp20e exp20e2 pt08 expedv agej24 agej25
          hgc08       [pweight=wt08x] if female == 1, robust; 				 
				 
			 
**what is the effect of piat on hgc;
reg hgc08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv     [pweight=wt08x] if female == 0, robust; 

reg hgc08 piat97r black hispanic b82 b83 biodaded biomomed lnhhinc
          twostp97 biom97 biod97 other97 hhsize97 regnc regs regw 
		  famdv daddv momdv hhincdv       [pweight=wt08x] if female == 1, robust; 				 


				 
clear matrix;
				 
log close;
