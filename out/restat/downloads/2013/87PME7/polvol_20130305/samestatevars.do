
forvalues i=0/19{
quietly replace childage`i'=. if childage`i'>age
quietly replace childbpl`i'=. if childbpl`i'==99 | childbpl`i'==950 | childbpl`i'==999
}


/*1940: Persons age 5+.   
1970: Persons age 5+ who lived in different state 5 years ago (Form 2 samples); persons age 14+ (Form 1 samples).   
1980: Persons age 5+; 50 percent of cases (see MIGSAMP).   
1990-2000: Persons age 5+ who lived in different house 5 years ago.   
*/
replace migplac5=. if migplac5==0 | migplac5==999 
*NA or missing unknown
replace migplac5=statefip if migplac5==990 
*same house
gen migmissing=0
replace migmissing=1 if migplac5==.
tab year migmissing
/* I have a few missings from 1940 (actual missing data), answers from everyone in 1970, half the folks in 1980, and 40% of folks in 1990 and 2000 */
/* if you are missing in 1990 or 2000, it's because you live in the same house as 5ya, so must be the same state */ 
replace migplac5=statefip if (year==1990 & migplac5==.) | (year==2000 & migplac5==.)
drop migmissing
tab year migplac5 if migplac5==.
label values childbpl* migplac5lbl

/* so if you have a child between 0 and 5, you should have a nonmissing samestate5ya*/

gen samestate=0 if bpl!=. & statefip!=.
replace samestate=1 if bpl==statefip
gen samestate5yaMIG=0  if bpl!=. & migplac5!=. 
replace samestate5yaMIG=1 if bpl==migplac5

gen samestate5ya=.  
gen samestate10ya=. 
gen samestate15ya=.
gen samestate20ya=. 
gen samestate25ya=.
gen samestate30ya=.
gen samestate35ya=.
forvalues i=0/19{

      replace samestate5ya=0 if childage`i'<6 & childbpl`i'!=bpl
      replace samestate5ya=1 if childage`i'<6 & childbpl`i'==bpl

      replace samestate10ya=0 if childage`i'<11 & childage`i'>=6 & childbpl`i'!=bpl
      replace samestate10ya=1 if childage`i'<11 & childage`i'>=6 & childbpl`i'==bpl

      replace samestate15ya=0 if childage`i'<16 & childage`i'>=11 & childbpl`i'!=bpl
      replace samestate15ya=1 if childage`i'<16 & childage`i'>=11 & childbpl`i'==bpl

      replace samestate20ya=0 if childage`i'<21 & childage`i'>=16 & childbpl`i'!=bpl
      replace samestate20ya=1 if childage`i'<21 & childage`i'>=16 & childbpl`i'==bpl

      replace samestate25ya=0 if childage`i'<26 & childage`i'>=21 & childbpl`i'!=bpl
      replace samestate25ya=1 if childage`i'<26 & childage`i'>=21 & childbpl`i'==bpl

      replace samestate30ya=0 if childage`i'<31 & childage`i'>=26 & childbpl`i'!=bpl
      replace samestate30ya=1 if childage`i'<31 & childage`i'>=26 & childbpl`i'==bpl
}



     




