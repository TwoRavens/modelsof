/****************************************
*PART 2: create variables
****************************************/

**drop cohort 1993 since cutoffs/prices and child care informations/deductions are not available or reliable

drop if foedselsaar==1993

*a)

gen faminc5yb_1=faminc1990_1 if foedselsaar==1986
replace faminc5yb_1=faminc1991_1 if foedselsaar==1987
replace faminc5yb_1=faminc1992_1 if foedselsaar==1988
replace faminc5yb_1=faminc1993_1 if foedselsaar==1989
replace faminc5yb_1=faminc1994_1 if foedselsaar==1990
replace faminc5yb_1=faminc1995_1 if foedselsaar==1991
replace faminc5yb_1=faminc1996_1 if foedselsaar==1992
replace faminc5yb_1=faminc1997_1 if foedselsaar==1993

gen faminc5_1=faminc1991_1 if foedselsaar==1986
replace faminc5_1=faminc1992_1 if foedselsaar==1987
replace faminc5_1=faminc1993_1 if foedselsaar==1988
replace faminc5_1=faminc1994_1 if foedselsaar==1989
replace faminc5_1=faminc1995_1 if foedselsaar==1990
replace faminc5_1=faminc1996_1 if foedselsaar==1991
replace faminc5_1=faminc1997_1 if foedselsaar==1992
replace faminc5_1=faminc1998_1 if foedselsaar==1993

forvalues i=1(1)28{ 
gen mprice5`i'=.

}

forvalues i=1(1)28{ 
replace mprice5`i'=mprice91`i' if foedselsaar==1986
replace mprice5`i'=mprice92`i' if foedselsaar==1987
replace mprice5`i'=mprice93`i' if foedselsaar==1988
replace mprice5`i'=mprice94`i' if foedselsaar==1989
replace mprice5`i'=mprice95`i' if foedselsaar==1990
replace mprice5`i'=mprice96`i' if foedselsaar==1991
replace mprice5`i'=mprice97`i' if foedselsaar==1992
replace mprice5`i'=mprice98`i' if foedselsaar==1993
}


forvalues i=1(1)27{ 
gen mcutoff5`i'=.

}

forvalues i=1(1)27{ 
replace mcutoff5`i'=mcutoff`i'91 if foedselsaar==1986
replace mcutoff5`i'=mcutoff`i'92 if foedselsaar==1987
replace mcutoff5`i'=mcutoff`i'93 if foedselsaar==1988
replace mcutoff5`i'=mcutoff`i'94 if foedselsaar==1989
replace mcutoff5`i'=mcutoff`i'95 if foedselsaar==1990
replace mcutoff5`i'=mcutoff`i'96 if foedselsaar==1991
replace mcutoff5`i'=mcutoff`i'97 if foedselsaar==1992
replace mcutoff5`i'=mcutoff`i'98 if foedselsaar==1993
}


*b) by mothers muncipality

gen mkom5=mkom1991 if foedselsaar==1986
replace mkom5=mkom1992 if foedselsaar==1987
replace mkom5=mkom1993 if foedselsaar==1988
replace mkom5=mkom1994 if foedselsaar==1989
replace mkom5=mkom1995 if foedselsaar==1990
replace mkom5=mkom1996 if foedselsaar==1991
replace mkom5=mkom1997 if foedselsaar==1992
replace mkom5=mkom1998 if foedselsaar==1993

gen kom5steep=1 if mcutoff51!=.
replace kom5steep=0 if kom5steep==. & mprice51!=.


*c) allocate price after income - use price allocated to mothers municipalities (note: can reconsider this one) - all measures of income 1-3

*1.

gen PRICE5_1=mprice51 if faminc5yb_1<=mcutoff51 & kom5steep==1 & mcutoff51!=.  & faminc5yb_1!=.
replace PRICE5_1=mprice52 if faminc5yb_1>mcutoff51 & faminc5yb_1<=mcutoff52 & (kom5steep==1) & mcutoff51!=. & faminc5yb_1!=.
replace PRICE5_1=mprice53 if faminc5yb_1>mcutoff52 & faminc5yb_1<=mcutoff53 & (kom5steep==1) & mcutoff52!=. & faminc5yb_1!=.
replace PRICE5_1=mprice54 if faminc5yb_1>mcutoff53 & faminc5yb_1<=mcutoff54 & (kom5steep==1) & mcutoff53!=. & faminc5yb_1!=.
replace PRICE5_1=mprice55 if faminc5yb_1>mcutoff54 & faminc5yb_1<=mcutoff55 & (kom5steep==1) & mcutoff54!=. & faminc5yb_1!=.
replace PRICE5_1=mprice56 if faminc5yb_1>mcutoff55 & faminc5yb_1<=mcutoff56 & (kom5steep==1) & mcutoff55!=. & faminc5yb_1!=.
replace PRICE5_1=mprice57 if faminc5yb_1>mcutoff56 & faminc5yb_1<=mcutoff57 & (kom5steep==1) & mcutoff56!=. & faminc5yb_1!=.
replace PRICE5_1=mprice58 if faminc5yb_1>mcutoff57 & faminc5yb_1<=mcutoff58 & (kom5steep==1) & mcutoff57!=. & faminc5yb_1!=.
replace PRICE5_1=mprice59 if faminc5yb_1>mcutoff58 & faminc5yb_1<=mcutoff59 & (kom5steep==1) & mcutoff58!=. & faminc5yb_1!=.
replace PRICE5_1=mprice510 if faminc5yb_1>mcutoff59 & faminc5yb_1<=mcutoff510 & (kom5steep==1) & mcutoff59!=. & faminc5yb_1!=.
replace PRICE5_1=mprice511 if faminc5yb_1>mcutoff510 & faminc5yb_1<=mcutoff511 & (kom5steep==1) & mcutoff510!=. & faminc5yb_1!=.
replace PRICE5_1=mprice512 if faminc5yb_1>mcutoff511 & faminc5yb_1<=mcutoff512 & (kom5steep==1) & mcutoff511!=. & faminc5yb_1!=.
replace PRICE5_1=mprice513 if faminc5yb_1>mcutoff512 & faminc5yb_1<=mcutoff513 & (kom5steep==1) & mcutoff512!=. & faminc5yb_1!=.
replace PRICE5_1=mprice514 if faminc5yb_1>mcutoff513 & faminc5yb_1<=mcutoff514 & (kom5steep==1) & mcutoff513!=. & faminc5yb_1!=.
replace PRICE5_1=mprice515 if faminc5yb_1>mcutoff514 & faminc5yb_1<=mcutoff515 & (kom5steep==1) & mcutoff514!=. & faminc5yb_1!=.
replace PRICE5_1=mprice516 if faminc5yb_1>mcutoff515 & faminc5yb_1<=mcutoff516 & (kom5steep==1) & mcutoff515!=. & faminc5yb_1!=.
replace PRICE5_1=mprice517 if faminc5yb_1>mcutoff516 & faminc5yb_1<=mcutoff517 & (kom5steep==1) & mcutoff516!=. & faminc5yb_1!=.
replace PRICE5_1=mprice518 if faminc5yb_1>mcutoff517 & faminc5yb_1<=mcutoff518 & (kom5steep==1) & mcutoff517!=. & faminc5yb_1!=.
replace PRICE5_1=mprice519 if faminc5yb_1>mcutoff518 & faminc5yb_1<=mcutoff519 & (kom5steep==1) & mcutoff518!=. & faminc5yb_1!=.
replace PRICE5_1=mprice520 if faminc5yb_1>mcutoff519 & faminc5yb_1<=mcutoff520 & (kom5steep==1) & mcutoff519!=. & faminc5yb_1!=.
replace PRICE5_1=mprice521 if faminc5yb_1>mcutoff520 & faminc5yb_1<=mcutoff521 & (kom5steep==1) & mcutoff520!=. & faminc5yb_1!=.
replace PRICE5_1=mprice522 if faminc5yb_1>mcutoff521 & faminc5yb_1<=mcutoff522 & (kom5steep==1) & mcutoff521!=. & faminc5yb_1!=.
replace PRICE5_1=mprice523 if faminc5yb_1>mcutoff522 & faminc5yb_1<=mcutoff523 & (kom5steep==1) & mcutoff522!=. & faminc5yb_1!=.
replace PRICE5_1=mprice524 if faminc5yb_1>mcutoff523 & faminc5yb_1<=mcutoff524 & (kom5steep==1) & mcutoff523!=. & faminc5yb_1!=.
replace PRICE5_1=mprice525 if faminc5yb_1>mcutoff524 & faminc5yb_1<=mcutoff525 & (kom5steep==1) & mcutoff524!=. & faminc5yb_1!=.
replace PRICE5_1=mprice526 if faminc5yb_1>mcutoff525 & faminc5yb_1<=mcutoff526 & (kom5steep==1) & mcutoff525!=. & faminc5yb_1!=.
replace PRICE5_1=mprice527 if faminc5yb_1>mcutoff526 & faminc5yb_1<=mcutoff527 & (kom5steep==1) & mcutoff526!=. & faminc5yb_1!=.
replace PRICE5_1=mprice528 if faminc5yb_1>mcutoff527 & (kom5steep==1) & mcutoff527!=. & faminc5yb_1!=.

* d) attending child care at age 5- different definitions

gen famdeduc5=famdeduc1993 if foedselsaar==1988
replace famdeduc5=famdeduc1994 if foedselsaar==1989
replace famdeduc5=famdeduc1995 if foedselsaar==1990
replace famdeduc5=famdeduc1996 if foedselsaar==1991
replace famdeduc5=famdeduc1997 if foedselsaar==1992
replace famdeduc5=famdeduc1998 if foedselsaar==1993

gen famdeduc5pluss1=famdeduc1994 if foedselsaar==1988
replace famdeduc5pluss1=famdeduc1995 if foedselsaar==1989
replace famdeduc5pluss1=famdeduc1996 if foedselsaar==1990
replace famdeduc5pluss1=famdeduc1997 if foedselsaar==1991
replace famdeduc5pluss1=famdeduc1998 if foedselsaar==1992
replace famdeduc5pluss1=famdeduc1999 if foedselsaar==1993

*simple definition

gen cc5s=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 
replace cc5s=0 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & cc5s==. 

*by family size

* family size 1-10 (may try different windows than 1-10).

*family size of 1

gen familysize1_10_93=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1983 & sfaaryounger1>1992) | (sfaarolder1==. & sfaaryounger1>1992) | (sfaarolder1<1983 & sfaaryounger1==.))
gen familysize1_10_94=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1984 & sfaaryounger1>1993) | (sfaarolder1==. & sfaaryounger1>1993) | (sfaarolder1<1984 & sfaaryounger1==.))
gen familysize1_10_95=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1985 & sfaaryounger1>1994) | (sfaarolder1==. & sfaaryounger1>1994) | (sfaarolder1<1985 & sfaaryounger1==.))
gen familysize1_10_96=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1986 & sfaaryounger1>1995) | (sfaarolder1==. & sfaaryounger1>1995) | (sfaarolder1<1986 & sfaaryounger1==.))
gen familysize1_10_97=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1987 & sfaaryounger1>1996) | (sfaarolder1==. & sfaaryounger1>1996) | (sfaarolder1<1987 & sfaaryounger1==.))
gen familysize1_10_98=1  if ((sfaarolder1==. & sfaaryounger1==.)| (sfaarolder1<1988 & sfaaryounger1>1997) | (sfaarolder1==. & sfaaryounger1>1997) | (sfaarolder1<1988 & sfaaryounger1==.))


*family size of 2

replace familysize1_10_93=2  if  familysize1_10_93==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1983 & sfaaryounger1>1992) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1983 & sfaaryounger1<=1992)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1992)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1983 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1992 & sfaarolder1>=1983 & sfaaryounger1>1992) | (sfaarolder2==. & sfaaryounger2>1992 & sfaarolder1<1983 & sfaaryounger1<=1992) | (sfaarolder2==. & sfaaryounger2>1992 & sfaarolder1>=1983 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1992 & sfaarolder1==. & sfaaryounger1<=1992) |  (sfaarolder2<1983 & sfaaryounger2==. & sfaarolder1>=1983 & sfaaryounger1>1992) |  (sfaarolder2<1983 & sfaaryounger2==. & sfaarolder1<1983 & sfaaryounger1<=1992)) |  (sfaarolder2<1983 & sfaaryounger2==. & sfaarolder1>=1983 & sfaaryounger1==.) |  (sfaarolder2<1983 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1992)) 

replace familysize1_10_94=2  if  familysize1_10_94==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1984 & sfaaryounger1>1993) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1984 & sfaaryounger1<=1993)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1993)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1984 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1993 & sfaarolder1>=1984 & sfaaryounger1>1993) | (sfaarolder2==. & sfaaryounger2>1993 & sfaarolder1<1984 & sfaaryounger1<=1993) | (sfaarolder2==. & sfaaryounger2>1993 & sfaarolder1>=1984 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1993 & sfaarolder1==. & sfaaryounger1<=1993) |  (sfaarolder2<1984 & sfaaryounger2==. & sfaarolder1>=1984 & sfaaryounger1>1993) |  (sfaarolder2<1984 & sfaaryounger2==. & sfaarolder1<1984 & sfaaryounger1<=1993)) |  (sfaarolder2<1984 & sfaaryounger2==. & sfaarolder1>=1984 & sfaaryounger1==.) |  (sfaarolder2<1984 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1993)) 

replace familysize1_10_95=2  if  familysize1_10_95==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1985 & sfaaryounger1>1994) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1985 & sfaaryounger1<=1994)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1994)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1985 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1994 & sfaarolder1>=1985 & sfaaryounger1>1994) | (sfaarolder2==. & sfaaryounger2>1994 & sfaarolder1<1985 & sfaaryounger1<=1994) | (sfaarolder2==. & sfaaryounger2>1994 & sfaarolder1>=1985 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1994 & sfaarolder1==. & sfaaryounger1<=1994) |  (sfaarolder2<1985 & sfaaryounger2==. & sfaarolder1>=1985 & sfaaryounger1>1994) |  (sfaarolder2<1985 & sfaaryounger2==. & sfaarolder1<1985 & sfaaryounger1<=1994)) |  (sfaarolder2<1985 & sfaaryounger2==. & sfaarolder1>=1985 & sfaaryounger1==.) |  (sfaarolder2<1985 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1994)) 

replace familysize1_10_96=2  if  familysize1_10_96==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1986 & sfaaryounger1>1995) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1986 & sfaaryounger1<=1995)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1995)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1986 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1995 & sfaarolder1>=1986 & sfaaryounger1>1995) | (sfaarolder2==. & sfaaryounger2>1995 & sfaarolder1<1986 & sfaaryounger1<=1995) | (sfaarolder2==. & sfaaryounger2>1995 & sfaarolder1>=1986 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1995 & sfaarolder1==. & sfaaryounger1<=1995) |  (sfaarolder2<1986 & sfaaryounger2==. & sfaarolder1>=1986 & sfaaryounger1>1995) |  (sfaarolder2<1986 & sfaaryounger2==. & sfaarolder1<1986 & sfaaryounger1<=1995)) |  (sfaarolder2<1986 & sfaaryounger2==. & sfaarolder1>=1986 & sfaaryounger1==.) |  (sfaarolder2<1986 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1995)) 

replace familysize1_10_97=2  if  familysize1_10_97==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1987 & sfaaryounger1>1996) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1987 & sfaaryounger1<=1996)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1996)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1987 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1996 & sfaarolder1>=1987 & sfaaryounger1>1996) | (sfaarolder2==. & sfaaryounger2>1996 & sfaarolder1<1987 & sfaaryounger1<=1996) | (sfaarolder2==. & sfaaryounger2>1996 & sfaarolder1>=1987 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1996 & sfaarolder1==. & sfaaryounger1<=1996) |  (sfaarolder2<1987 & sfaaryounger2==. & sfaarolder1>=1987 & sfaaryounger1>1996) |  (sfaarolder2<1987 & sfaaryounger2==. & sfaarolder1<1987 & sfaaryounger1<=1996)) |  (sfaarolder2<1987 & sfaaryounger2==. & sfaarolder1>=1987 & sfaaryounger1==.) |  (sfaarolder2<1987 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1996)) 

replace familysize1_10_98=2  if  familysize1_10_98==. & ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1988 & sfaaryounger1>1997) | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1<1988 & sfaaryounger1<=1997)  | (sfaarolder2==. & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1997)| ((sfaarolder2==. & sfaaryounger2==. & sfaarolder1>=1988 & sfaaryounger1==.) | (sfaarolder2==. & sfaaryounger2>1997 & sfaarolder1>=1988 & sfaaryounger1>1997) | (sfaarolder2==. & sfaaryounger2>1997 & sfaarolder1<1988 & sfaaryounger1<=1997) | (sfaarolder2==. & sfaaryounger2>1997 & sfaarolder1>=1988 & sfaaryounger1==.)  | (sfaarolder2==. & sfaaryounger2>1997 & sfaarolder1==. & sfaaryounger1<=1997) |  (sfaarolder2<1988 & sfaaryounger2==. & sfaarolder1>=1988 & sfaaryounger1>1997) |  (sfaarolder2<1988 & sfaaryounger2==. & sfaarolder1<1988 & sfaaryounger1<=1997)) |  (sfaarolder2<1988 & sfaaryounger2==. & sfaarolder1>=1988 & sfaaryounger1==.) |  (sfaarolder2<1988 & sfaaryounger2==. & sfaarolder1==. & sfaaryounger1<=1997)) 

*family size of 3+

replace familysize1_10_93=3  if  familysize1_10_93==.
replace familysize1_10_94=3  if  familysize1_10_94==.
replace familysize1_10_95=3  if  familysize1_10_95==.
replace familysize1_10_96=3  if  familysize1_10_96==.
replace familysize1_10_97=3  if  familysize1_10_97==.
replace familysize1_10_98=3  if  familysize1_10_98==.

gen familysize1_10_5=familysize1_10_93 if foedselsaar==1988
replace familysize1_10_5=familysize1_10_94 if foedselsaar==1989
replace familysize1_10_5=familysize1_10_95 if foedselsaar==1990
replace familysize1_10_5=familysize1_10_96 if foedselsaar==1991
replace familysize1_10_5=familysize1_10_97 if foedselsaar==1992
replace familysize1_10_5=familysize1_10_98 if foedselsaar==1993

gen msibred5=msibred1993 if foedselsaar==1988
replace msibred5=msibred1994 if foedselsaar==1989
replace msibred5=msibred1995 if foedselsaar==1990
replace msibred5=msibred1996 if foedselsaar==1991
replace msibred5=msibred1997 if foedselsaar==1992
replace msibred5=msibred1998 if foedselsaar==1993

replace msibred5=0 if msibred5==.

*family size of 1 - child is in child care if deduction>0

gen cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 & familysize1_10_5==1  

*family size of 2- sibling is younger: Child is in child care if deduction>0 - sibling is older: Child in child care if deduction > price of child care 

replace cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 & familysize1_10_5==2  & cc5fs==.  & sfaarolder1==.
replace cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 & (famdeduc5*(1+(msibred5/100))>=(famdeduc5pluss1)) & familysize1_10_5==2  & cc5fs==.  & sfaarolder1!=.

*family size of three or more - siblings are younger: Child is in child care if deduction>0 - siblings are one older and one younger: Child in child care if deduction > lowest price of child care - siblings are older: Child in child care if deduction > lowest price of child care*(1+sibling reduction) 
 
replace cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 & familysize1_10_5>=3  & cc5fs==.  & sfaarolder1==.
replace cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 &(famdeduc5*(1+(msibred5/100))>=(famdeduc5pluss1)) & familysize1_10_5>=3 & cc5fs==.  & sfaarolder1!=. & sfaaryounger1!=.
replace cc5fs=1 if (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993) & famdeduc5>0 &(famdeduc5*(1+(msibred5/100))>=(famdeduc5pluss1)) & familysize1_10_5>=3  & cc5fs==.  & sfaaryounger1==.
*no child care

replace cc5fs=0 if cc5fs==. & (foedselsaar==1988|foedselsaar==1989|foedselsaar==1990|foedselsaar==1991|foedselsaar==1992|foedselsaar==1993)


*e) married/cohabiting at birth

gen marrcohb=1 if ((mfamt1987!=9) | mstat1987==2) & foedselsaar==1986
replace marrcohb=0 if marrcohb==. & foedselsaar==1986
replace marrcohb=1 if ((mfamt1987!=9) | mstat1987==2) & foedselsaar==1987
replace marrcohb=0 if marrcohb==. & foedselsaar==1987
replace marrcohb=1 if ((mfamt1988!=9) | mstat1988==2) & foedselsaar==1988
replace marrcohb=0 if marrcohb==. & foedselsaar==1988
replace marrcohb=1 if ((mfamt1989!=9) | mstat1989==2) & foedselsaar==1989
replace marrcohb=0 if marrcohb==. & foedselsaar==1989
replace marrcohb=1 if ((mfamt1990!=9) | mstat1990==2) & foedselsaar==1990
replace marrcohb=0 if marrcohb==. & foedselsaar==1990
replace marrcohb=1 if ((mfamt1991!=9) | mstat1991==2) & foedselsaar==1991
replace marrcohb=0 if marrcohb==. & foedselsaar==1991
replace marrcohb=1 if ((mfamt1992!=9) | mstat1992==2) & foedselsaar==1992
replace marrcohb=0 if marrcohb==. & foedselsaar==1992
replace marrcohb=1 if ((mfamt1993!=9) | mstat1993==2) & foedselsaar==1993
replace marrcohb=0 if marrcohb==. & foedselsaar==1993

*f) mother labour supply at age 5 of child

gen G5=35033 if foedselsaar==1986
replace G5=36167 if foedselsaar==1987
replace G5=37033 if foedselsaar==1988
replace G5=37820 if foedselsaar==1989
replace G5=38847 if foedselsaar==1990
replace G5=40410 if foedselsaar==1991
replace G5=42000 if foedselsaar==1992
replace G5=44413 if foedselsaar==1993

gen mwork51G=1 if minc1991>(1*G5) & foedselsaar==1986
replace mwork51G=1 if minc1992>(1*G5) & foedselsaar==1987
replace mwork51G=1 if minc1993>(1*G5) & foedselsaar==1988
replace mwork51G=1 if minc1994>(1*G5) & foedselsaar==1989
replace mwork51G=1 if minc1995>(1*G5) & foedselsaar==1990
replace mwork51G=1 if minc1996>(1*G5) & foedselsaar==1991
replace mwork51G=1 if minc1997>(1*G5) & foedselsaar==1992
replace mwork51G=1 if minc1998>(1*G5) & foedselsaar==1993
replace mwork51G=0 if mwork51G==. 

gen mwork52G=1 if minc1991>(2*G5) & foedselsaar==1986
replace mwork52G=1 if minc1992>(2*G5) & foedselsaar==1987
replace mwork52G=1 if minc1993>(2*G5) & foedselsaar==1988
replace mwork52G=1 if minc1994>(2*G5) & foedselsaar==1989
replace mwork52G=1 if minc1995>(2*G5) & foedselsaar==1990
replace mwork52G=1 if minc1996>(2*G5) & foedselsaar==1991
replace mwork52G=1 if minc1997>(2*G5) & foedselsaar==1992
replace mwork52G=1 if minc1998>(2*G5) & foedselsaar==1993
replace mwork52G=0 if mwork52G==. 

gen mwork53G=1 if minc1991>(3*G5) & foedselsaar==1986
replace mwork53G=1 if minc1992>(3*G5) & foedselsaar==1987
replace mwork53G=1 if minc1993>(3*G5) & foedselsaar==1988
replace mwork53G=1 if minc1994>(3*G5) & foedselsaar==1989
replace mwork53G=1 if minc1995>(3*G5) & foedselsaar==1990
replace mwork53G=1 if minc1996>(3*G5) & foedselsaar==1991
replace mwork53G=1 if minc1997>(3*G5) & foedselsaar==1992
replace mwork53G=1 if minc1998>(3*G5) & foedselsaar==1993
replace mwork53G=0 if mwork53G==. 

gen mwork55G=1 if minc1991>(5*G5) & foedselsaar==1986
replace mwork55G=1 if minc1992>(5*G5) & foedselsaar==1987
replace mwork55G=1 if minc1993>(5*G5) & foedselsaar==1988
replace mwork55G=1 if minc1994>(5*G5) & foedselsaar==1989
replace mwork55G=1 if minc1995>(5*G5) & foedselsaar==1990
replace mwork55G=1 if minc1996>(5*G5) & foedselsaar==1991
replace mwork55G=1 if minc1997>(5*G5) & foedselsaar==1992
replace mwork55G=1 if minc1998>(5*G5) & foedselsaar==1993
replace mwork55G=0 if mwork55G==. 

gen mwork510G=1 if minc1991>(10*G5) & foedselsaar==1986
replace mwork510G=1 if minc1992>(10*G5) & foedselsaar==1987
replace mwork510G=1 if minc1993>(10*G5) & foedselsaar==1988
replace mwork510G=1 if minc1994>(10*G5) & foedselsaar==1989
replace mwork510G=1 if minc1995>(10*G5) & foedselsaar==1990
replace mwork510G=1 if minc1996>(10*G5) & foedselsaar==1991
replace mwork510G=1 if minc1997>(10*G5) & foedselsaar==1992
replace mwork510G=1 if minc1998>(10*G5) & foedselsaar==1993
replace mwork510G=0 if mwork510G==. 

*mothers income age 5
gen minc5=minc1991 if foedselsaar==1986
replace minc5=minc1992 if foedselsaar==1987
replace minc5=minc1993 if foedselsaar==1988
replace minc5=minc1994 if foedselsaar==1989 
replace minc5=minc1995 if foedselsaar==1990
replace minc5=minc1996 if foedselsaar==1991
replace minc5=minc1997 if foedselsaar==1992
replace minc5=minc1998 if foedselsaar==1993

*fathers income age 5
gen finc5=finc1991 if foedselsaar==1986
replace finc5=finc1992 if foedselsaar==1987
replace finc5=finc1993 if foedselsaar==1988
replace finc5=finc1994 if foedselsaar==1989 
replace finc5=finc1995 if foedselsaar==1990
replace finc5=finc1996 if foedselsaar==1991
replace finc5=finc1997 if foedselsaar==1992
replace finc5=finc1998 if foedselsaar==1993

gen fwork52G=1 if finc1991>(2*G5) & foedselsaar==1986
replace fwork52G=1 if finc1992>(2*G5) & foedselsaar==1987
replace fwork52G=1 if finc1993>(2*G5) & foedselsaar==1988
replace fwork52G=1 if finc1994>(2*G5) & foedselsaar==1989
replace fwork52G=1 if finc1995>(2*G5) & foedselsaar==1990
replace fwork52G=1 if finc1996>(2*G5) & foedselsaar==1991
replace fwork52G=1 if finc1997>(2*G5) & foedselsaar==1992
replace fwork52G=1 if finc1998>(2*G5) & foedselsaar==1993
replace fwork52G=0 if fwork52G==. 

*mothers income age 1
gen minc1=minc1987 if foedselsaar==1986
replace minc1=minc1988 if foedselsaar==1987
replace minc1=minc1989 if foedselsaar==1988
replace minc1=minc1990 if foedselsaar==1989 
replace minc1=minc1991 if foedselsaar==1990
replace minc1=minc1992 if foedselsaar==1991
replace minc1=minc1993 if foedselsaar==1992

*fathers income age 1
gen finc1=finc1987 if foedselsaar==1986
replace finc1=finc1988 if foedselsaar==1987
replace finc1=finc1989 if foedselsaar==1988
replace finc1=finc1990 if foedselsaar==1989 
replace finc1=finc1991 if foedselsaar==1990
replace finc1=finc1992 if foedselsaar==1991
replace finc1=finc1993 if foedselsaar==1992

*mothers income age 2
gen minc2=minc1988 if foedselsaar==1986
replace minc2=minc1989 if foedselsaar==1987
replace minc2=minc1990 if foedselsaar==1988
replace minc2=minc1991 if foedselsaar==1989 
replace minc2=minc1992 if foedselsaar==1990
replace minc2=minc1993 if foedselsaar==1991
replace minc2=minc1994 if foedselsaar==1992

*fathers income age 2
gen finc2=finc1988 if foedselsaar==1986
replace finc2=finc1989 if foedselsaar==1987
replace finc2=finc1990 if foedselsaar==1988
replace finc2=finc1991 if foedselsaar==1989 
replace finc2=finc1992 if foedselsaar==1990
replace finc2=finc1993 if foedselsaar==1991
replace finc2=finc1994 if foedselsaar==1992
replace finc2=finc1995 if foedselsaar==1993

*mothers income age 3
gen minc3=minc1989 if foedselsaar==1986
replace minc3=minc1990 if foedselsaar==1987
replace minc3=minc1991 if foedselsaar==1988
replace minc3=minc1992 if foedselsaar==1989 
replace minc3=minc1993 if foedselsaar==1990
replace minc3=minc1994 if foedselsaar==1991
replace minc3=minc1995 if foedselsaar==1992

*fathers income age 3
gen finc3=finc1989 if foedselsaar==1986
replace finc3=finc1990 if foedselsaar==1987
replace finc3=finc1991 if foedselsaar==1988
replace finc3=finc1992 if foedselsaar==1989 
replace finc3=finc1993 if foedselsaar==1990
replace finc3=finc1994 if foedselsaar==1991
replace finc3=finc1995 if foedselsaar==1992

*mothers income age 4
gen minc4=minc1990 if foedselsaar==1986
replace minc4=minc1991 if foedselsaar==1987
replace minc4=minc1992 if foedselsaar==1988
replace minc4=minc1993 if foedselsaar==1989 
replace minc4=minc1994 if foedselsaar==1990
replace minc4=minc1995 if foedselsaar==1991
replace minc4=minc1996 if foedselsaar==1992

*fathers income age 4
gen finc4=finc1990 if foedselsaar==1986
replace finc4=finc1991 if foedselsaar==1987
replace finc4=finc1992 if foedselsaar==1988
replace finc4=finc1993 if foedselsaar==1989 
replace finc4=finc1994 if foedselsaar==1990
replace finc4=finc1995 if foedselsaar==1991
replace finc4=finc1996 if foedselsaar==1992

*mothers income age 6
gen minc6=minc1992 if foedselsaar==1986
replace minc6=minc1993 if foedselsaar==1987
replace minc6=minc1994 if foedselsaar==1988
replace minc6=minc1995 if foedselsaar==1989 
replace minc6=minc1996 if foedselsaar==1990
replace minc6=minc1997 if foedselsaar==1991
replace minc6=minc1998 if foedselsaar==1992

*fathers income age 6
gen finc6=finc1992 if foedselsaar==1986
replace finc6=finc1993 if foedselsaar==1987
replace finc6=finc1994 if foedselsaar==1988
replace finc6=finc1995 if foedselsaar==1989 
replace finc6=finc1996 if foedselsaar==1990
replace finc6=finc1997 if foedselsaar==1991
replace finc6=finc1998 if foedselsaar==1992

*mothers income age 7
gen minc7=minc1993 if foedselsaar==1986
replace minc7=minc1994 if foedselsaar==1987
replace minc7=minc1995 if foedselsaar==1988
replace minc7=minc1996 if foedselsaar==1989 
replace minc7=minc1997 if foedselsaar==1990
replace minc7=minc1998 if foedselsaar==1991
replace minc7=minc1999 if foedselsaar==1992

*fathers income age 7
gen finc7=finc1993 if foedselsaar==1986
replace finc7=finc1994 if foedselsaar==1987
replace finc7=finc1995 if foedselsaar==1988
replace finc7=finc1996 if foedselsaar==1989 
replace finc7=finc1997 if foedselsaar==1990
replace finc7=finc1998 if foedselsaar==1991
replace finc7=finc1999 if foedselsaar==1992

*mothers income age 8
gen minc8=minc1994 if foedselsaar==1986
replace minc8=minc1995 if foedselsaar==1987
replace minc8=minc1996 if foedselsaar==1988
replace minc8=minc1997 if foedselsaar==1989 
replace minc8=minc1998 if foedselsaar==1990
replace minc8=minc1999 if foedselsaar==1991
replace minc8=minc2000 if foedselsaar==1992

*fathers income age 8
gen finc8=finc1994 if foedselsaar==1986
replace finc8=finc1995 if foedselsaar==1987
replace finc8=finc1996 if foedselsaar==1988
replace finc8=finc1997 if foedselsaar==1989 
replace finc8=finc1998 if foedselsaar==1990
replace finc8=finc1999 if foedselsaar==1991
replace finc8=finc2000 if foedselsaar==1992

*mothers income age 9
gen minc9=minc1995 if foedselsaar==1986
replace minc9=minc1996 if foedselsaar==1987
replace minc9=minc1997 if foedselsaar==1988
replace minc9=minc1998 if foedselsaar==1989 
replace minc9=minc1999 if foedselsaar==1990
replace minc9=minc2000 if foedselsaar==1991
replace minc9=minc2001 if foedselsaar==1992

*fathers income age 9
gen finc9=finc1995 if foedselsaar==1986
replace finc9=finc1996 if foedselsaar==1987
replace finc9=finc1997 if foedselsaar==1988
replace finc9=finc1998 if foedselsaar==1989 
replace finc9=finc1999 if foedselsaar==1990
replace finc9=finc2000 if foedselsaar==1991
replace finc9=finc2001 if foedselsaar==1992

*mothers income age 10
gen minc10=minc1996 if foedselsaar==1986
replace minc10=minc1997 if foedselsaar==1987
replace minc10=minc1998 if foedselsaar==1988
replace minc10=minc1999 if foedselsaar==1989 
replace minc10=minc2000 if foedselsaar==1990
replace minc10=minc2001 if foedselsaar==1991
replace minc10=minc2002 if foedselsaar==1992

*fathers income age 10
gen finc10=finc1996 if foedselsaar==1986
replace finc10=finc1997 if foedselsaar==1987
replace finc10=finc1998 if foedselsaar==1988
replace finc10=finc1999 if foedselsaar==1989 
replace finc10=finc2000 if foedselsaar==1990
replace finc10=finc2001 if foedselsaar==1991
replace finc10=finc2002 if foedselsaar==1992

*mothers income age 11
gen minc11=minc1997 if foedselsaar==1986
replace minc11=minc1998 if foedselsaar==1987
replace minc11=minc1999 if foedselsaar==1988
replace minc11=minc2000 if foedselsaar==1989 
replace minc11=minc2001 if foedselsaar==1990
replace minc11=minc2002 if foedselsaar==1991
replace minc11=minc2003 if foedselsaar==1992

*fathers income age 11
gen finc11=finc1997 if foedselsaar==1986
replace finc11=finc1998 if foedselsaar==1987
replace finc11=finc1999 if foedselsaar==1988
replace finc11=finc2000 if foedselsaar==1989 
replace finc11=finc2001 if foedselsaar==1990
replace finc11=finc2002 if foedselsaar==1991
replace finc11=finc2003 if foedselsaar==1992

*mothers income age 12
gen minc12=minc1998 if foedselsaar==1986
replace minc12=minc1999 if foedselsaar==1987
replace minc12=minc2000 if foedselsaar==1988
replace minc12=minc2001 if foedselsaar==1989 
replace minc12=minc2002 if foedselsaar==1990
replace minc12=minc2003 if foedselsaar==1991
replace minc12=minc2004 if foedselsaar==1992

*fathers income age 12
gen finc12=finc1998 if foedselsaar==1986
replace finc12=finc1999 if foedselsaar==1987
replace finc12=finc2000 if foedselsaar==1988
replace finc12=finc2001 if foedselsaar==1989 
replace finc12=finc2002 if foedselsaar==1990
replace finc12=finc2003 if foedselsaar==1991
replace finc12=finc2004 if foedselsaar==1992

*mothers income age 13
gen minc13=minc1999 if foedselsaar==1986
replace minc13=minc2000 if foedselsaar==1987
replace minc13=minc2001 if foedselsaar==1988
replace minc13=minc2002 if foedselsaar==1989 
replace minc13=minc2003 if foedselsaar==1990
replace minc13=minc2004 if foedselsaar==1991
replace minc13=minc2005 if foedselsaar==1992

*fathers income age 13
gen finc13=finc1999 if foedselsaar==1986
replace finc13=finc2000 if foedselsaar==1987
replace finc13=finc2001 if foedselsaar==1988
replace finc13=finc2002 if foedselsaar==1989 
replace finc13=finc2003 if foedselsaar==1990
replace finc13=finc2004 if foedselsaar==1991
replace finc13=finc2005 if foedselsaar==1992

*mothers income age 14
gen minc14=minc2000 if foedselsaar==1986
replace minc14=minc2001 if foedselsaar==1987
replace minc14=minc2002 if foedselsaar==1988
replace minc14=minc2003 if foedselsaar==1989 
replace minc14=minc2004 if foedselsaar==1990
replace minc14=minc2005 if foedselsaar==1991
replace minc14=minc2006 if foedselsaar==1992

*fathers income age 14
gen finc14=finc2000 if foedselsaar==1986
replace finc14=finc2001 if foedselsaar==1987
replace finc14=finc2002 if foedselsaar==1988
replace finc14=finc2003 if foedselsaar==1989 
replace finc14=finc2004 if foedselsaar==1990
replace finc14=finc2005 if foedselsaar==1991
replace finc14=finc2006 if foedselsaar==1992

*mothers income age 15
gen minc15=minc2001 if foedselsaar==1986
replace minc15=minc2002 if foedselsaar==1987
replace minc15=minc2003 if foedselsaar==1988
replace minc15=minc2004 if foedselsaar==1989 
replace minc15=minc2005 if foedselsaar==1990
replace minc15=minc2006 if foedselsaar==1991
replace minc15=minc2007 if foedselsaar==1992

*fathers income age 15
gen finc15=finc2001 if foedselsaar==1986
replace finc15=finc2002 if foedselsaar==1987
replace finc15=finc2003 if foedselsaar==1988
replace finc15=finc2004 if foedselsaar==1989 
replace finc15=finc2005 if foedselsaar==1990
replace finc15=finc2006 if foedselsaar==1991
replace finc15=finc2007 if foedselsaar==1992

*gen annuity of income age 6-15
gen faminc615=((faminc1992_1/(1.023))+(faminc1993_1/(1.023^2))+(faminc1994_1/(1.023^3))+(faminc1995_1/(1.023^4))+(faminc1996_1/(1.023^5))+(faminc1997_1/(1.023^6))+(faminc1998_1/(1.023^7))+(faminc1999_1/(1.023^8))+(faminc2000_1/(1.023^9))+(faminc2001_1/(1.023^10)))/10 if foedselsaar==1986
replace faminc615=((faminc1993_1/(1.023))+(faminc1994_1/(1.023^2))+(faminc1995_1/(1.023^3))+(faminc1996_1/(1.023^4))+(faminc1997_1/(1.023^5))+(faminc1998_1/(1.023^6))+(faminc1999_1/(1.023^7))+(faminc2000_1/(1.023^8))+(faminc2001_1/(1.023^9))+(faminc2002_1/(1.023^10)))/10 if foedselsaar==1987
replace faminc615=((faminc1994_1/(1.023))+(faminc1995_1/(1.023^2))+(faminc1996_1/(1.023^3))+(faminc1997_1/(1.023^4))+(faminc1998_1/(1.023^5))+(faminc1999_1/(1.023^6))+(faminc2000_1/(1.023^7))+(faminc2001_1/(1.023^8))+(faminc2002_1/(1.023^9))+(faminc2003_1/(1.023^10)))/10 if foedselsaar==1988
replace faminc615=((faminc1995_1/(1.023))+(faminc1996_1/(1.023^2))+(faminc1997_1/(1.023^3))+(faminc1998_1/(1.023^4))+(faminc1999_1/(1.023^5))+(faminc2000_1/(1.023^6))+(faminc2001_1/(1.023^7))+(faminc2002_1/(1.023^8))+(faminc2003_1/(1.023^9))+(faminc2004_1/(1.023^10)))/10 if foedselsaar==1989
replace faminc615=((faminc1996_1/(1.023))+(faminc1997_1/(1.023^2))+(faminc1998_1/(1.023^3))+(faminc1999_1/(1.023^4))+(faminc2000_1/(1.023^5))+(faminc2001_1/(1.023^6))+(faminc2002_1/(1.023^7))+(faminc2003_1/(1.023^8))+(faminc2004_1/(1.023^9))+(faminc2005_1/(1.023^10)))/10 if foedselsaar==1990
replace faminc615=((faminc1997_1/(1.023))+(faminc1998_1/(1.023^2))+(faminc1999_1/(1.023^3))+(faminc2000_1/(1.023^4))+(faminc2001_1/(1.023^5))+(faminc2002_1/(1.023^6))+(faminc2003_1/(1.023^7))+(faminc2004_1/(1.023^8))+(faminc2005_1/(1.023^9))+(faminc2006_1/(1.023^10)))/10 if foedselsaar==1991
replace faminc615=((faminc1998_1/(1.023))+(faminc1999_1/(1.023^2))+(faminc2000_1/(1.023^3))+(faminc2001_1/(1.023^4))+(faminc2002_1/(1.023^5))+(faminc2003_1/(1.023^6))+(faminc2004_1/(1.023^7))+(faminc2005_1/(1.023^8))+(faminc2006_1/(1.023^9))+(faminc2007_1/(1.023^10)))/10 if foedselsaar==1992

gen faminc615ln=ln(faminc615)

gen minc615=((minc1992/(1.023))+(minc1993/(1.023^2))+(minc1994/(1.023^3))+(minc1995/(1.023^4))+(minc1996/(1.023^5))+(minc1997/(1.023^6))+(minc1998/(1.023^7))+(minc1999/(1.023^8))+(minc2000/(1.023^9))+(minc2001/(1.023^10)))/10 if foedselsaar==1986
replace minc615=((minc1993/(1.023))+(minc1994/(1.023^2))+(minc1995/(1.023^3))+(minc1996/(1.023^4))+(minc1997/(1.023^5))+(minc1998/(1.023^6))+(minc1999/(1.023^7))+(minc2000/(1.023^8))+(minc2001/(1.023^9))+(minc2002/(1.023^10)))/10 if foedselsaar==1987
replace minc615=((minc1994/(1.023))+(minc1995/(1.023^2))+(minc1996/(1.023^3))+(minc1997/(1.023^4))+(minc1998/(1.023^5))+(minc1999/(1.023^6))+(minc2000/(1.023^7))+(minc2001/(1.023^8))+(minc2002/(1.023^9))+(minc2003/(1.023^10)))/10 if foedselsaar==1988
replace minc615=((minc1995/(1.023))+(minc1996/(1.023^2))+(minc1997/(1.023^3))+(minc1998/(1.023^4))+(minc1999/(1.023^5))+(minc2000/(1.023^6))+(minc2001/(1.023^7))+(minc2002/(1.023^8))+(minc2003/(1.023^9))+(minc2004/(1.023^10)))/10 if foedselsaar==1989
replace minc615=((minc1996/(1.023))+(minc1997/(1.023^2))+(minc1998/(1.023^3))+(minc1999/(1.023^4))+(minc2000/(1.023^5))+(minc2001/(1.023^6))+(minc2002/(1.023^7))+(minc2003/(1.023^8))+(minc2004/(1.023^9))+(minc2005/(1.023^10)))/10 if foedselsaar==1990
replace minc615=((minc1997/(1.023))+(minc1998/(1.023^2))+(minc1999/(1.023^3))+(minc2000/(1.023^4))+(minc2001/(1.023^5))+(minc2002/(1.023^6))+(minc2003/(1.023^7))+(minc2004/(1.023^8))+(minc2005/(1.023^9))+(minc2006/(1.023^10)))/10 if foedselsaar==1991
replace minc615=((minc1998/(1.023))+(minc1999/(1.023^2))+(minc2000/(1.023^3))+(minc2001/(1.023^4))+(minc2002/(1.023^5))+(minc2003/(1.023^6))+(minc2004/(1.023^7))+(minc2005/(1.023^8))+(minc2006/(1.023^9))+(minc2007/(1.023^10)))/10 if foedselsaar==1992

gen minc615ln=ln(minc615)

gen finc615=((finc1992/(1.023))+(finc1993/(1.023^2))+(finc1994/(1.023^3))+(finc1995/(1.023^4))+(finc1996/(1.023^5))+(finc1997/(1.023^6))+(finc1998/(1.023^7))+(finc1999/(1.023^8))+(finc2000/(1.023^9))+(finc2001/(1.023^10)))/10 if foedselsaar==1986
replace finc615=((finc1993/(1.023))+(finc1994/(1.023^2))+(finc1995/(1.023^3))+(finc1996/(1.023^4))+(finc1997/(1.023^5))+(finc1998/(1.023^6))+(finc1999/(1.023^7))+(finc2000/(1.023^8))+(finc2001/(1.023^9))+(finc2002/(1.023^10)))/10 if foedselsaar==1987
replace finc615=((finc1994/(1.023))+(finc1995/(1.023^2))+(finc1996/(1.023^3))+(finc1997/(1.023^4))+(finc1998/(1.023^5))+(finc1999/(1.023^6))+(finc2000/(1.023^7))+(finc2001/(1.023^8))+(finc2002/(1.023^9))+(finc2003/(1.023^10)))/10 if foedselsaar==1988
replace finc615=((finc1995/(1.023))+(finc1996/(1.023^2))+(finc1997/(1.023^3))+(finc1998/(1.023^4))+(finc1999/(1.023^5))+(finc2000/(1.023^6))+(finc2001/(1.023^7))+(finc2002/(1.023^8))+(finc2003/(1.023^9))+(finc2004/(1.023^10)))/10 if foedselsaar==1989
replace finc615=((finc1996/(1.023))+(finc1997/(1.023^2))+(finc1998/(1.023^3))+(finc1999/(1.023^4))+(finc2000/(1.023^5))+(finc2001/(1.023^6))+(finc2002/(1.023^7))+(finc2003/(1.023^8))+(finc2004/(1.023^9))+(finc2005/(1.023^10)))/10 if foedselsaar==1990
replace finc615=((finc1997/(1.023))+(finc1998/(1.023^2))+(finc1999/(1.023^3))+(finc2000/(1.023^4))+(finc2001/(1.023^5))+(finc2002/(1.023^6))+(finc2003/(1.023^7))+(finc2004/(1.023^8))+(finc2005/(1.023^9))+(finc2006/(1.023^10)))/10 if foedselsaar==1991
replace finc615=((finc1998/(1.023))+(finc1999/(1.023^2))+(finc2000/(1.023^3))+(finc2001/(1.023^4))+(finc2002/(1.023^5))+(finc2003/(1.023^6))+(finc2004/(1.023^7))+(finc2005/(1.023^8))+(finc2006/(1.023^9))+(finc2007/(1.023^10)))/10 if foedselsaar==1992

gen finc615ln=ln(finc615)



*g) mother welfare recipients at age 5
gen mwelfare5=1 if mmndutbet1992!=. & foedselsaar==1986
replace mwelfare5=1 if mmndutbet1992!=. & foedselsaar==1987
replace mwelfare5=1 if mmndutbet1993!=. & foedselsaar==1988
replace mwelfare5=1 if mmndutbet1994!=. & foedselsaar==1989
replace mwelfare5=1 if mmndutbet1995!=. & foedselsaar==1990
replace mwelfare5=1 if mmndutbet1996!=. & foedselsaar==1991
replace mwelfare5=1 if mmndutbet1997!=. & foedselsaar==1992
replace mwelfare5=1 if mmndutbet1998!=. & foedselsaar==1993
replace mwelfare5=0 if mwelfare5==.

* mother welfare recipients at age 4
gen mwelfare4=1 if mmndutbet1992!=. & foedselsaar==1986
replace mwelfare4=1 if mmndutbet1993!=. & foedselsaar==1987
replace mwelfare4=1 if mmndutbet1994!=. & foedselsaar==1988
replace mwelfare4=1 if mmndutbet1995!=. & foedselsaar==1989
replace mwelfare4=1 if mmndutbet1996!=. & foedselsaar==1990
replace mwelfare4=1 if mmndutbet1997!=. & foedselsaar==1991
replace mwelfare4=1 if mmndutbet1998!=. & foedselsaar==1992
replace mwelfare4=1 if mmndutbet1998!=. & foedselsaar==1993
replace mwelfare4=0 if mwelfare4==.

*h) difference in price at first discontinuity

sort mkom5
by mkom5: gen diffprice5=mprice52-mprice51 if kom5steep==1

*i) dropout

gen drop=1 if eduy08<12 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989)
replace drop=0 if drop ==. & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989)

*j) age in 2008

gen age08=2008-foedselsaar

*k) parents age and education at birth

gen mageb=mage08-(2008-foedselsaar)
gen fageb=fage08-(2008-foedselsaar)

gen meduyb=meduy1986 if foedselsaar==1986
replace meduyb=meduy1987 if foedselsaar==1987
replace meduyb=meduy1988 if foedselsaar==1988
replace meduyb=meduy1989 if foedselsaar==1989
replace meduyb=meduy1990 if foedselsaar==1990
replace meduyb=meduy1991 if foedselsaar==1991
replace meduyb=meduy1992 if foedselsaar==1992
replace meduyb=meduy1993 if foedselsaar==1993
replace meduyb=meduy08 if meduyb<9 | meduyb==.

gen feduyb=feduy1986 if foedselsaar==1986
replace feduyb=feduy1987 if foedselsaar==1987
replace feduyb=feduy1988 if foedselsaar==1988
replace feduyb=feduy1989 if foedselsaar==1989
replace feduyb=feduy1990 if foedselsaar==1990
replace feduyb=feduy1991 if foedselsaar==1991
replace feduyb=feduy1992 if foedselsaar==1992
replace feduyb=feduy1993 if foedselsaar==1993

replace feduyb=feduy08 if feduyb<9 | feduyb==.


*l) immigrant at birth

gen mimmigrantb=1 if  mcitz1986!=0 & mcitz1986!=. & foedselsaar==1986
replace mimmigrantb=0 if mimmigrantb==. & mcitz1986!=. & foedselsaar==1986
replace mimmigrantb=1 if  mcitz1987!=0 & mcitz1987!=. & foedselsaar==1987
replace mimmigrantb=0 if mimmigrantb==. & mcitz1987!=. & foedselsaar==1987
replace mimmigrantb=1 if  mcitz1988!=0 & mcitz1988!=. & foedselsaar==1988
replace mimmigrantb=0 if mimmigrantb==. & mcitz1988!=. & foedselsaar==1988
replace mimmigrantb=1 if  mcitz1989!=0 & mcitz1989!=. & foedselsaar==1989
replace mimmigrantb=0 if mimmigrantb==. & mcitz1989!=. & foedselsaar==1989
replace mimmigrantb=1 if  mcitz1990!=0 &  mcitz1990!=. & foedselsaar==1990
replace mimmigrantb=0 if mimmigrantb==. & mcitz1990!=. & foedselsaar==1990
replace mimmigrantb=1 if  mcitz1991!=0 & mcitz1991!=. & foedselsaar==1991
replace mimmigrantb=0 if mimmigrantb==. & mcitz1991!=. & foedselsaar==1991
replace mimmigrantb=1 if  mcitz1992!=0 & mcitz1992!=. & foedselsaar==1992
replace mimmigrantb=0 if mimmigrantb==. & mcitz1992!=. & foedselsaar==1992
replace mimmigrantb=1 if  mcitz1993!=0 & mcitz1993!=. & foedselsaar==1993
replace mimmigrantb=0 if mimmigrantb==. & mcitz1993!=. & foedselsaar==1993
*replace mimmigrantb=0 if mimmigrantb==.

gen fimmigrantb=1 if  fcitz1986!=0 & fcitz1986!=. & foedselsaar==1986
replace fimmigrantb=0 if fimmigrantb==. & fcitz1986!=. &foedselsaar==1986
replace fimmigrantb=1 if  fcitz1987!=0 & fcitz1987!=. & foedselsaar==1987
replace fimmigrantb=0 if fimmigrantb==. & fcitz1987!=. &foedselsaar==1987
replace fimmigrantb=1 if  fcitz1988!=0 & fcitz1988!=. & foedselsaar==1988
replace fimmigrantb=0 if fimmigrantb==. & fcitz1988!=. &foedselsaar==1988
replace fimmigrantb=1 if  fcitz1989!=0 & fcitz1989!=. & foedselsaar==1989
replace fimmigrantb=0 if fimmigrantb==. & fcitz1989!=. &foedselsaar==1989
replace fimmigrantb=1 if  fcitz1990!=0 & fcitz1990!=. & foedselsaar==1990
replace fimmigrantb=0 if fimmigrantb==. & fcitz1990!=. &foedselsaar==1990
replace fimmigrantb=1 if  fcitz1991!=0 & fcitz1991!=. & foedselsaar==1991
replace fimmigrantb=0 if fimmigrantb==. & fcitz1991!=. &foedselsaar==1991
replace fimmigrantb=1 if  fcitz1992!=0 & fcitz1992!=. & foedselsaar==1992
replace fimmigrantb=0 if fimmigrantb==. & fcitz1992!=. &foedselsaar==1992
replace fimmigrantb=1 if  fcitz1993!=0 & fcitz1993!=. & foedselsaar==1993
replace fimmigrantb=0 if fimmigrantb==. & fcitz1993!=. &foedselsaar==1993
*replace fimmigrantb=0 if fimmigrantb==.

*m) family income years after + year of birth

gen faminc6_1=faminc1992_1 if foedselsaar==1986
replace faminc6_1=faminc1993_1 if foedselsaar==1987
replace faminc6_1=faminc1994_1 if foedselsaar==1988
replace faminc6_1=faminc1995_1 if foedselsaar==1989
replace faminc6_1=faminc1996_1 if foedselsaar==1990
replace faminc6_1=faminc1997_1 if foedselsaar==1991
replace faminc6_1=faminc1998_1 if foedselsaar==1992
replace faminc6_1=faminc1999_1 if foedselsaar==1993

gen faminc7_1=faminc1993_1 if foedselsaar==1986
replace faminc7_1=faminc1994_1 if foedselsaar==1987
replace faminc7_1=faminc1995_1 if foedselsaar==1988
replace faminc7_1=faminc1996_1 if foedselsaar==1989
replace faminc7_1=faminc1997_1 if foedselsaar==1990
replace faminc7_1=faminc1998_1 if foedselsaar==1991
replace faminc7_1=faminc1999_1 if foedselsaar==1992
replace faminc7_1=faminc2000_1 if foedselsaar==1993

gen faminc8_1=faminc1994_1 if foedselsaar==1986
replace faminc8_1=faminc1995_1 if foedselsaar==1987
replace faminc8_1=faminc1996_1 if foedselsaar==1988
replace faminc8_1=faminc1997_1 if foedselsaar==1989
replace faminc8_1=faminc1998_1 if foedselsaar==1990
replace faminc8_1=faminc1999_1 if foedselsaar==1991
replace faminc8_1=faminc2000_1 if foedselsaar==1992
replace faminc8_1=faminc2001_1 if foedselsaar==1993

gen faminc9_1=faminc1995_1 if foedselsaar==1986
replace faminc9_1=faminc1996_1 if foedselsaar==1987
replace faminc9_1=faminc1997_1 if foedselsaar==1988
replace faminc9_1=faminc1998_1 if foedselsaar==1989
replace faminc9_1=faminc1999_1 if foedselsaar==1990
replace faminc9_1=faminc2000_1 if foedselsaar==1991
replace faminc9_1=faminc2001_1 if foedselsaar==1992
replace faminc9_1=faminc2002_1 if foedselsaar==1993

gen faminc10_1=faminc1996_1 if foedselsaar==1986
replace faminc10_1=faminc1997_1 if foedselsaar==1987
replace faminc10_1=faminc1998_1 if foedselsaar==1988
replace faminc10_1=faminc1999_1 if foedselsaar==1989
replace faminc10_1=faminc2000_1 if foedselsaar==1990
replace faminc10_1=faminc2001_1 if foedselsaar==1991
replace faminc10_1=faminc2002_1 if foedselsaar==1992
replace faminc10_1=faminc2003_1 if foedselsaar==1993

gen faminc11_1=faminc1997_1 if foedselsaar==1986
replace faminc11_1=faminc1998_1 if foedselsaar==1987
replace faminc11_1=faminc1999_1 if foedselsaar==1988
replace faminc11_1=faminc2000_1 if foedselsaar==1989
replace faminc11_1=faminc2001_1 if foedselsaar==1990
replace faminc11_1=faminc2002_1 if foedselsaar==1991
replace faminc11_1=faminc2003_1 if foedselsaar==1992
replace faminc11_1=faminc2004_1 if foedselsaar==1993

gen faminc12_1=faminc1998_1 if foedselsaar==1986
replace faminc12_1=faminc1999_1 if foedselsaar==1987
replace faminc12_1=faminc2000_1 if foedselsaar==1988
replace faminc12_1=faminc2001_1 if foedselsaar==1989
replace faminc12_1=faminc2002_1 if foedselsaar==1990
replace faminc12_1=faminc2003_1 if foedselsaar==1991
replace faminc12_1=faminc2004_1 if foedselsaar==1992
replace faminc12_1=faminc2005_1 if foedselsaar==1993

gen faminc133_1=faminc1999_1 if foedselsaar==1986
replace faminc133_1=faminc2000_1 if foedselsaar==1987
replace faminc133_1=faminc2001_1 if foedselsaar==1988
replace faminc133_1=faminc2002_1 if foedselsaar==1989
replace faminc133_1=faminc2003_1 if foedselsaar==1990
replace faminc133_1=faminc2004_1 if foedselsaar==1991
replace faminc133_1=faminc2005_1 if foedselsaar==1992
replace faminc133_1=faminc2006_1 if foedselsaar==1993

gen faminc14_1=faminc2000_1 if foedselsaar==1986
replace faminc14_1=faminc2001_1 if foedselsaar==1987
replace faminc14_1=faminc2002_1 if foedselsaar==1988
replace faminc14_1=faminc2003_1 if foedselsaar==1989
replace faminc14_1=faminc2004_1 if foedselsaar==1990
replace faminc14_1=faminc2005_1 if foedselsaar==1991
replace faminc14_1=faminc2006_1 if foedselsaar==1992
replace faminc14_1=faminc2007_1 if foedselsaar==1993

gen faminc15_1=faminc2001_1 if foedselsaar==1986
replace faminc15_1=faminc2002_1 if foedselsaar==1987
replace faminc15_1=faminc2003_1 if foedselsaar==1988
replace faminc15_1=faminc2004_1 if foedselsaar==1989
replace faminc15_1=faminc2005_1 if foedselsaar==1990
replace faminc15_1=faminc2006_1 if foedselsaar==1991
replace faminc15_1=faminc2007_1 if foedselsaar==1992
replace faminc15_1=faminc2007_1 if foedselsaar==1993

gen faminc0_1=faminc1986_1 if foedselsaar==1986
replace faminc0_1=faminc1987_1 if foedselsaar==1987
replace faminc0_1=faminc1988_1 if foedselsaar==1988
replace faminc0_1=faminc1989_1 if foedselsaar==1989
replace faminc0_1=faminc1990_1 if foedselsaar==1990
replace faminc0_1=faminc1991_1 if foedselsaar==1991
replace faminc0_1=faminc1992_1 if foedselsaar==1992
replace faminc0_1=faminc1993_1 if foedselsaar==1993

gen faminc1_1=faminc1987_1 if foedselsaar==1986
replace faminc1_1=faminc1988_1 if foedselsaar==1987
replace faminc1_1=faminc1989_1 if foedselsaar==1988
replace faminc1_1=faminc1990_1 if foedselsaar==1989
replace faminc1_1=faminc1991_1 if foedselsaar==1990
replace faminc1_1=faminc1992_1 if foedselsaar==1991
replace faminc1_1=faminc1993_1 if foedselsaar==1992
replace faminc1_1=faminc1994_1 if foedselsaar==1993

gen faminc2_1=faminc1988_1 if foedselsaar==1986
replace faminc2_1=faminc1989_1 if foedselsaar==1987
replace faminc2_1=faminc1990_1 if foedselsaar==1988
replace faminc2_1=faminc1991_1 if foedselsaar==1989
replace faminc2_1=faminc1992_1 if foedselsaar==1990
replace faminc2_1=faminc1993_1 if foedselsaar==1991
replace faminc2_1=faminc1994_1 if foedselsaar==1992
replace faminc2_1=faminc1995_1 if foedselsaar==1993

gen faminc3_1=faminc1989_1 if foedselsaar==1986
replace faminc3_1=faminc1990_1 if foedselsaar==1987
replace faminc3_1=faminc1991_1 if foedselsaar==1988
replace faminc3_1=faminc1992_1 if foedselsaar==1989
replace faminc3_1=faminc1993_1 if foedselsaar==1990
replace faminc3_1=faminc1994_1 if foedselsaar==1991
replace faminc3_1=faminc1995_1 if foedselsaar==1992
replace faminc3_1=faminc1996_1 if foedselsaar==1993

gen faminc03_1=(faminc0_1+faminc1_1+faminc2_1+faminc3_1)/4
gen faminc13_1=(faminc1_1+faminc2_1+faminc3_1)/3
gen faminc56_1=(faminc5_1+faminc6_1)/2
gen faminc78_1=(faminc7_1+faminc8_1)/2

gen faminc6_1ln=ln(faminc6_1)
gen faminc7_1ln=ln(faminc7_1)

*n2) students

gen studentb=1 if student1986==1 & foedselsaar==1986
replace studentb=1 if student1987==1 & foedselsaar==1987
replace studentb=1 if student1988==1 & foedselsaar==1988
replace studentb=1 if student1989==1 & foedselsaar==1989
replace studentb=1 if student1990==1 & foedselsaar==1990
replace studentb=1 if student1991==1 & foedselsaar==1991
replace studentb=1 if student1992==1 & foedselsaar==1992
replace studentb=1 if student1993==1 & foedselsaar==1993

gen student4=1 if student1990==1 & foedselsaar==1986
replace student4=1 if student1991==1 & foedselsaar==1987
replace student4=1 if student1992==1 & foedselsaar==1988
replace student4=1 if student1993==1 & foedselsaar==1989
replace student4=1 if student1994==1 & foedselsaar==1990
replace student4=1 if student1995==1 & foedselsaar==1991
replace student4=1 if student1996==1 & foedselsaar==1992
replace student4=1 if student1997==1 & foedselsaar==1993

gen student5=1 if student1991==1 & foedselsaar==1986
replace student5=1 if student1992==1 & foedselsaar==1987
replace student5=1 if student1993==1 & foedselsaar==1988
replace student5=1 if student1994==1 & foedselsaar==1989
replace student5=1 if student1995==1 & foedselsaar==1990
replace student5=1 if student1996==1 & foedselsaar==1991
replace student5=1 if student1997==1 & foedselsaar==1992
replace student5=1 if student1998==1 & foedselsaar==1993

replace studentb=0 if studentb==.
replace student4=0 if student4==.
replace student5=0 if student5==.

*n3) part time

gen mpart5=1 if (hrs1991==1|hrs1991==2) & foedselsaar==1986
replace mpart5=0 if hrs1991==3 & foedselsaar==1986
replace mpart5=1 if (hrs1992==1|hrs1992==2) & foedselsaar==1987
replace mpart5=0 if hrs1992==3 & foedselsaar==1987
replace mpart5=1 if (hrs1993==1|hrs1993==2) & foedselsaar==1988
replace mpart5=0 if hrs1993==3 & foedselsaar==1988
replace mpart5=1 if (hrs1994==1|hrs1994==2) & foedselsaar==1989
replace mpart5=0 if hrs1994==3 & foedselsaar==1989
replace mpart5=1 if (hrs1995==1|hrs1995==2) & foedselsaar==1990
replace mpart5=0 if hrs1995==3 & foedselsaar==1990
replace mpart5=1 if (hrs1996==1|hrs1996==2) & foedselsaar==1991
replace mpart5=0 if hrs1996==3 & foedselsaar==1991
replace mpart5=1 if (hrs1997==1|hrs1997==2) & foedselsaar==1992
replace mpart5=0 if hrs1997==3 & foedselsaar==1992
replace mpart5=1 if (hrs1998==1|hrs1998==2) & foedselsaar==1993
replace mpart5=0 if hrs1998==3 & foedselsaar==1993
replace mpart5=0 if mpart5==.

gen fpart5=1 if (fhrs1991==1|fhrs1991==2) & foedselsaar==1986
replace fpart5=0 if fhrs1991==3 & foedselsaar==1986
replace fpart5=1 if (fhrs1992==1|fhrs1992==2) & foedselsaar==1987
replace fpart5=0 if fhrs1992==3 & foedselsaar==1987
replace fpart5=1 if (fhrs1993==1|fhrs1993==2) & foedselsaar==1988
replace fpart5=0 if fhrs1993==3 & foedselsaar==1988
replace fpart5=1 if (fhrs1994==1|fhrs1994==2) & foedselsaar==1989
replace fpart5=0 if fhrs1994==3 & foedselsaar==1989
replace fpart5=1 if (fhrs1995==1|fhrs1995==2) & foedselsaar==1990
replace fpart5=0 if fhrs1995==3 & foedselsaar==1990
replace fpart5=1 if (fhrs1996==1|fhrs1996==2) & foedselsaar==1991
replace fpart5=0 if fhrs1996==3 & foedselsaar==1991
replace fpart5=1 if (fhrs1997==1|fhrs1997==2) & foedselsaar==1992
replace fpart5=0 if fhrs1997==3 & foedselsaar==1992
replace fpart5=1 if (fhrs1998==1|fhrs1998==2) & foedselsaar==1993
replace fpart5=0 if fhrs1998==3 & foedselsaar==1993

*long term family outcomes

*married/cohabiting when child is aged 8

gen marrcoh8=1 if ((mfamt1994!=9) | mstat1994==2) & foedselsaar==1986
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1986
replace marrcoh8=1 if ((mfamt1995!=9) | mstat1995==2) & foedselsaar==1987
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1987
replace marrcoh8=1 if ((mfamt1996!=9) | mstat1996==2) & foedselsaar==1988
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1988
replace marrcoh8=1 if ((mfamt1997!=9) | mstat1997==2) & foedselsaar==1989
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1989
replace marrcoh8=1 if ((mfamt1998!=9) | mstat1998==2) & foedselsaar==1990
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1990
replace marrcoh8=1 if ((mfamt1999!=9) | mstat1999==2) & foedselsaar==1991
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1991
replace marrcoh8=1 if ((mfamt2000!=9) | mstat2000==2) & foedselsaar==1992
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1992
replace marrcoh8=1 if ((mfamt2001!=9) | mstat2001==2) & foedselsaar==1993
replace marrcoh8=0 if marrcoh8==. & foedselsaar==1993

*married/cohabiting when child is aged 10
gen marrcoh10=1 if ((mfamt1996!=9) | mstat1996==2) & foedselsaar==1986
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1986
replace marrcoh10=1 if ((mfamt1997!=9) | mstat1997==2) & foedselsaar==1987
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1987
replace marrcoh10=1 if ((mfamt1998!=9) | mstat1998==2) & foedselsaar==1988
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1988
replace marrcoh10=1 if ((mfamt1999!=9) | mstat1999==2) & foedselsaar==1989
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1989
replace marrcoh10=1 if ((mfamt2000!=9) | mstat2000==2) & foedselsaar==1990
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1990
replace marrcoh10=1 if ((mfamt2001!=9) | mstat2001==2) & foedselsaar==1991
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1991
replace marrcoh10=1 if ((mfamt2002!=9) | mstat2002==2) & foedselsaar==1992
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1992
replace marrcoh10=1 if ((mfamt2002!=9) | mstat2002==2) & foedselsaar==1993
replace marrcoh10=0 if marrcoh10==. & foedselsaar==1993

*f) mother/fatehr labour supply at age6-15

*define base level of income in Norway
gen G1985=25333
gen G1986=27433
gen G1987=29267
gen G1988=30850
gen G1989=32275
gen G1990=33575
gen G1991=35033
gen G1992=36167
gen G1993=37033
gen G1994=37820
gen G1995=38847
gen G1996=40410
gen G1997=42000
gen G1998=44413
gen G1999=46423
gen G2000=48377
gen G2001=50603
gen G2002=53233
gen G2003=55964
gen G2004=58139
gen G2005=60059
gen G2006=62161
gen G2007=65505
gen G2008=69108
gen G2009=72006

gen mwork62G=.
gen fwork62G=.
forvalues i=1992(1)1998{
replace mwork62G=(minc`i'>(2*G`i')) if foedselsaar==`i'-6
replace fwork62G=(finc`i'>(2*G`i')) if foedselsaar==`i'-6
}

gen mwork72G=.
gen fwork72G=.
forvalues i=1993(1)1999{
replace mwork72G=(minc`i'>(2*G`i')) if foedselsaar==`i'-7
replace fwork72G=(finc`i'>(2*G`i')) if foedselsaar==`i'-7
}

gen mwork82G=.
gen fwork82G=.
forvalues i=1994(1)2000{
replace mwork82G=(minc`i'>(2*G`i')) if foedselsaar==`i'-8
replace fwork82G=(finc`i'>(2*G`i')) if foedselsaar==`i'-8
}

gen mwork92G=.
gen fwork92G=.
forvalues i=1995(1)2001{
replace mwork92G=(minc`i'>(2*G`i')) if foedselsaar==`i'-9
replace fwork92G=(finc`i'>(2*G`i')) if foedselsaar==`i'-9
}

gen mwork102G=.
gen fwork102G=.
forvalues i=1996(1)2002{
replace mwork102G=(minc`i'>(2*G`i')) if foedselsaar==`i'-10
replace fwork102G=(finc`i'>(2*G`i')) if foedselsaar==`i'-10
}

gen mwork112G=.
gen fwork112G=.
forvalues i=1997(1)2003{
replace mwork112G=(minc`i'>(2*G`i')) if foedselsaar==`i'-11
replace fwork112G=(finc`i'>(2*G`i')) if foedselsaar==`i'-11
}

gen mwork122G=.
gen fwork122G=.
forvalues i=1998(1)2004{
replace mwork122G=(minc`i'>(2*G`i')) if foedselsaar==`i'-12
replace fwork122G=(finc`i'>(2*G`i')) if foedselsaar==`i'-12
}

gen mwork132G=.
gen fwork132G=.
forvalues i=1999(1)2005{
replace mwork132G=(minc`i'>(2*G`i')) if foedselsaar==`i'-13
replace fwork132G=(finc`i'>(2*G`i')) if foedselsaar==`i'-13
}

gen mwork142G=.
gen fwork142G=.
forvalues i=2000(1)2006{
replace mwork142G=(minc`i'>(2*G`i')) if foedselsaar==`i'-14
replace fwork142G=(finc`i'>(2*G`i')) if foedselsaar==`i'-14
}

gen mwork152G=.
gen fwork152G=.
forvalues i=2001(1)2007{
replace mwork152G=(minc`i'>(2*G`i')) if foedselsaar==`i'-15
replace fwork152G=(finc`i'>(2*G`i')) if foedselsaar==`i'-15
}

gen mtotalemp615=mwork62G+mwork72G+mwork82G+mwork92G+mwork102G+mwork112G+mwork122G+mwork132G+mwork142G+mwork152G
gen ftotalemp615=fwork62G+fwork72G+fwork82G+fwork92G+fwork102G+fwork112G+fwork122G+fwork132G+fwork142G+fwork152G

*part time age 8
gen mpart8=1 if (hrs1994==1|hrs1994==2) & foedselsaar==1986
replace mpart8=0 if hrs1994==3 & foedselsaar==1986
replace mpart8=1 if (hrs1995==1|hrs1995==2) & foedselsaar==1987
replace mpart8=0 if hrs1995==3 & foedselsaar==1987
replace mpart8=1 if (hrs1996==1|hrs1996==2) & foedselsaar==1988
replace mpart8=0 if hrs1996==3 & foedselsaar==1988
replace mpart8=1 if (hrs1997==1|hrs1997==2) & foedselsaar==1989
replace mpart8=0 if hrs1997==3 & foedselsaar==1989
replace mpart8=1 if (hrs1998==1|hrs1998==2) & foedselsaar==1990
replace mpart8=0 if hrs1998==3 & foedselsaar==1990
replace mpart8=1 if (hrs1999==1|hrs1999==2) & foedselsaar==1991
replace mpart8=0 if hrs1999==3 & foedselsaar==1991
replace mpart8=1 if (hrs2000==1|hrs2000==2) & foedselsaar==1992
replace mpart8=0 if hrs2000==3 & foedselsaar==1992
replace mpart8=0 if mpart8==.

gen fpart8=1 if (fhrs1994==1|fhrs1994==2) & foedselsaar==1986
replace fpart8=0 if fhrs1994==3 & foedselsaar==1986
replace fpart8=1 if (fhrs1995==1|fhrs1995==2) & foedselsaar==1987
replace fpart8=0 if fhrs1995==3 & foedselsaar==1987
replace fpart8=1 if (fhrs1996==1|fhrs1996==2) & foedselsaar==1988
replace fpart8=0 if fhrs1996==3 & foedselsaar==1988
replace fpart8=1 if (fhrs1997==1|fhrs1997==2) & foedselsaar==1989
replace fpart8=0 if fhrs1997==3 & foedselsaar==1989
replace fpart8=1 if (fhrs1998==1|fhrs1998==2) & foedselsaar==1990
replace fpart8=0 if fhrs1998==3 & foedselsaar==1990
replace fpart8=1 if (fhrs1999==1|fhrs1999==2) & foedselsaar==1991
replace fpart8=0 if fhrs1999==3 & foedselsaar==1991
replace fpart8=1 if (fhrs2000==1|fhrs2000==2) & foedselsaar==1992
replace fpart8=0 if fhrs2000==3 & foedselsaar==1992
replace fpart8=0 if fpart8==.

*part time age 10
gen mpart10=1 if (hrs1996==1|hrs1996==2) & foedselsaar==1986
replace mpart10=0 if hrs1996==3 & foedselsaar==1986
replace mpart10=1 if (hrs1997==1|hrs1997==2) & foedselsaar==1987
replace mpart10=0 if hrs1997==3 & foedselsaar==1987
replace mpart10=1 if (hrs1998==1|hrs1998==2) & foedselsaar==1988
replace mpart10=0 if hrs1998==3 & foedselsaar==1988
replace mpart10=1 if (hrs1999==1|hrs1999==2) & foedselsaar==1989
replace mpart10=0 if hrs1999==3 & foedselsaar==1989
replace mpart10=1 if (hrs2000==1|hrs2000==2) & foedselsaar==1990
replace mpart10=0 if hrs2000==3 & foedselsaar==1990
replace mpart10=1 if (hrs2001==1|hrs2001==2) & foedselsaar==1991
replace mpart10=0 if hrs2001==3 & foedselsaar==1991
replace mpart10=1 if (hrs2002==1|hrs2002==2) & foedselsaar==1992
replace mpart10=0 if hrs2002==3 & foedselsaar==1992
replace mpart10=0 if mpart10==.

gen fpart10=1 if (fhrs1996==1|fhrs1996==2) & foedselsaar==1986
replace fpart10=0 if fhrs1996==3 & foedselsaar==1986
replace fpart10=1 if (fhrs1997==1|fhrs1997==2) & foedselsaar==1987
replace fpart10=0 if fhrs1997==3 & foedselsaar==1987
replace fpart10=1 if (fhrs1998==1|fhrs1998==2) & foedselsaar==1988
replace fpart10=0 if fhrs1998==3 & foedselsaar==1988
replace fpart10=1 if (fhrs1999==1|fhrs1999==2) & foedselsaar==1989
replace fpart10=0 if fhrs1999==3 & foedselsaar==1989
replace fpart10=1 if (fhrs2000==1|fhrs2000==2) & foedselsaar==1990
replace fpart10=0 if fhrs2000==3 & foedselsaar==1990
replace fpart10=1 if (fhrs2001==1|fhrs2001==2) & foedselsaar==1991
replace fpart10=0 if fhrs2001==3 & foedselsaar==1991
replace fpart10=1 if (fhrs2002==1|fhrs2002==2) & foedselsaar==1992
replace fpart10=0 if fhrs2002==3 & foedselsaar==1992
replace fpart10=0 if fpart10==.


*gender

gen female=1 if sex==2
replace female=0 if sex==1

***probability of being below cutoff before subsidy

gen faminc1yb_1=faminc1992_1 if foedselsaar==1992
replace faminc1yb_1=faminc1991_1 if foedselsaar==1991
replace faminc1yb_1=faminc1990_1 if foedselsaar==1990

forvalues i=1(1)28{ 
gen mprice1`i'=.
}

forvalues i=1(1)28{ 
replace mprice1`i'=mprice93`i' if foedselsaar==1992
replace mprice1`i'=mprice92`i' if foedselsaar==1991
replace mprice1`i'=mprice91`i' if foedselsaar==1990
}


forvalues i=1(1)27{ 
gen mcutoff1`i'=.

}

forvalues i=1(1)27{ 

replace mcutoff1`i'=mcutoff`i'93 if foedselsaar==1992
replace mcutoff1`i'=mcutoff`i'92 if foedselsaar==1991
replace mcutoff1`i'=mcutoff`i'91 if foedselsaar==1990
}


gen mkom1=mkom1993 if foedselsaar==1992
replace mkom1=mkom1992 if foedselsaar==1991
replace mkom1=mkom1991 if foedselsaar==1990

gen kom1steep=1 if mcutoff11!=.
replace kom1steep=0 if kom1steep==. & mprice11!=.


gen norminc1=faminc1yb_1/mcutoff11
replace norminc1=norminc1-1
gen dum1=1 if norminc1<0
replace dum1=0 if dum1==. & norminc1!=.

*age 2 child care and related variables

gen faminc2yb_1=faminc1993_1 if foedselsaar==1992
replace faminc2yb_1=faminc1992_1 if foedselsaar==1991
replace faminc2yb_1=faminc1991_1 if foedselsaar==1990
replace faminc2yb_1=faminc1990_1 if foedselsaar==1989

forvalues i=1(1)28{ 
gen mprice2`i'=.
}

forvalues i=1(1)28{ 
replace mprice2`i'=mprice94`i' if foedselsaar==1992
replace mprice2`i'=mprice93`i' if foedselsaar==1991
replace mprice2`i'=mprice92`i' if foedselsaar==1990
replace mprice2`i'=mprice91`i' if foedselsaar==1989
}

forvalues i=1(1)27{ 
gen mcutoff2`i'=.

}

forvalues i=1(1)27{ 

replace mcutoff2`i'=mcutoff`i'94 if foedselsaar==1992
replace mcutoff2`i'=mcutoff`i'93 if foedselsaar==1991
replace mcutoff2`i'=mcutoff`i'92 if foedselsaar==1990
replace mcutoff2`i'=mcutoff`i'91 if foedselsaar==1989
}


gen mkom2=mkom1994 if foedselsaar==1992
replace mkom2=mkom1993 if foedselsaar==1991
replace mkom2=mkom1992 if foedselsaar==1990
replace mkom2=mkom1991 if foedselsaar==1989

gen kom2steep=1 if mcutoff21!=.
replace kom2steep=0 if kom2steep==. & mprice21!=.

gen norminc2=faminc2yb_1/mcutoff21
replace norminc2=norminc2-1
gen dum2=1 if norminc2<0
replace dum2=0 if dum2==. & norminc2!=.



*age 3 child care and related variables

gen faminc3yb_1=faminc1994_1 if foedselsaar==1992
replace faminc3yb_1=faminc1993_1 if foedselsaar==1991
replace faminc3yb_1=faminc1992_1 if foedselsaar==1990
replace faminc3yb_1=faminc1991_1 if foedselsaar==1989
replace faminc3yb_1=faminc1990_1 if foedselsaar==1988

forvalues i=1(1)28{ 
gen mprice3`i'=.

}

forvalues i=1(1)28{ 
replace mprice3`i'=mprice95`i' if foedselsaar==1992
replace mprice3`i'=mprice94`i' if foedselsaar==1991
replace mprice3`i'=mprice93`i' if foedselsaar==1990
replace mprice3`i'=mprice92`i' if foedselsaar==1989
replace mprice3`i'=mprice91`i' if foedselsaar==1988
}

forvalues i=1(1)27{ 
gen mcutoff3`i'=.

}

forvalues i=1(1)27{ 

replace mcutoff3`i'=mcutoff`i'95 if foedselsaar==1992
replace mcutoff3`i'=mcutoff`i'94 if foedselsaar==1991
replace mcutoff3`i'=mcutoff`i'93 if foedselsaar==1990
replace mcutoff3`i'=mcutoff`i'92 if foedselsaar==1989
replace mcutoff3`i'=mcutoff`i'91 if foedselsaar==1988
}

gen norminc3=faminc3yb_1/mcutoff31
replace norminc3=norminc3-1
gen dum3=1 if norminc3<0
replace dum3=0 if dum3==. & norminc3!=.

gen mkom3=mkom1995 if foedselsaar==1992
replace mkom3=mkom1994 if foedselsaar==1991
replace mkom3=mkom1993 if foedselsaar==1990
replace mkom3=mkom1992 if foedselsaar==1989
replace mkom3=mkom1991 if foedselsaar==1988

gen kom3steep=1 if mcutoff31!=.
replace kom3steep=0 if kom3steep==. & mprice31!=.

*age 4 child care and related variables

gen faminc4yb_1=faminc1995_1 if foedselsaar==1992
replace faminc4yb_1=faminc1994_1 if foedselsaar==1991
replace faminc4yb_1=faminc1993_1 if foedselsaar==1990
replace faminc4yb_1=faminc1992_1 if foedselsaar==1989
replace faminc4yb_1=faminc1991_1 if foedselsaar==1988
replace faminc4yb_1=faminc1990_1 if foedselsaar==1987

forvalues i=1(1)28{ 
gen mprice4`i'=.

}

forvalues i=1(1)28{ 
replace mprice4`i'=mprice96`i' if foedselsaar==1992
replace mprice4`i'=mprice95`i' if foedselsaar==1991
replace mprice4`i'=mprice94`i' if foedselsaar==1990
replace mprice4`i'=mprice93`i' if foedselsaar==1989
replace mprice4`i'=mprice92`i' if foedselsaar==1988
replace mprice4`i'=mprice91`i' if foedselsaar==1987
}

forvalues i=1(1)27{ 
gen mcutoff4`i'=.

}

forvalues i=1(1)27{ 

replace mcutoff4`i'=mcutoff`i'96 if foedselsaar==1992
replace mcutoff4`i'=mcutoff`i'95 if foedselsaar==1991
replace mcutoff4`i'=mcutoff`i'94 if foedselsaar==1990
replace mcutoff4`i'=mcutoff`i'93 if foedselsaar==1989
replace mcutoff4`i'=mcutoff`i'92 if foedselsaar==1988
replace mcutoff4`i'=mcutoff`i'91 if foedselsaar==1987
}

gen mkom4=mkom1996 if foedselsaar==1992
replace mkom4=mkom1995 if foedselsaar==1991
replace mkom4=mkom1994 if foedselsaar==1990
replace mkom4=mkom1993 if foedselsaar==1989
replace mkom4=mkom1992 if foedselsaar==1988
replace mkom4=mkom1991 if foedselsaar==1987

gen kom4steep=1 if mcutoff41!=.
replace kom4steep=0 if kom4steep==. & mprice41!=.

gen norminc4=faminc4yb_1/mcutoff41
replace norminc4=norminc4-1
gen dum4=1 if norminc4<0
replace dum4=0 if dum4==. &norminc4!=.


*average probability of being below cutoff age1-4
gen dum1_4=(dum1+dum2+dum3+dum4)/4


***chil care age 4

*b) by mothers muncipality

*c) allocate price after income - use price allocated to mothers municipalities (note: can reconsider this one) - all measures of income 1-3

*1.

gen PRICE4_1=mprice41 if faminc4yb_1<=mcutoff41 & kom4steep==1 & mcutoff41!=.  & faminc4yb_1!=.
replace PRICE4_1=mprice42 if faminc4yb_1>mcutoff41 & faminc4yb_1<=mcutoff42 & (kom4steep==1) & mcutoff41!=. & faminc4yb_1!=.
replace PRICE4_1=mprice43 if faminc4yb_1>mcutoff42 & faminc4yb_1<=mcutoff43 & (kom4steep==1) & mcutoff42!=. & faminc4yb_1!=.
replace PRICE4_1=mprice44 if faminc4yb_1>mcutoff43 & faminc4yb_1<=mcutoff44 & (kom4steep==1) & mcutoff43!=. & faminc4yb_1!=.
replace PRICE4_1=mprice45 if faminc4yb_1>mcutoff44 & faminc4yb_1<=mcutoff45 & (kom4steep==1) & mcutoff44!=. & faminc4yb_1!=.
replace PRICE4_1=mprice46 if faminc4yb_1>mcutoff45 & faminc4yb_1<=mcutoff46 & (kom4steep==1) & mcutoff45!=. & faminc4yb_1!=.
replace PRICE4_1=mprice47 if faminc4yb_1>mcutoff46 & faminc4yb_1<=mcutoff47 & (kom4steep==1) & mcutoff46!=. & faminc4yb_1!=.
replace PRICE4_1=mprice48 if faminc4yb_1>mcutoff47 & faminc4yb_1<=mcutoff48 & (kom4steep==1) & mcutoff47!=. & faminc4yb_1!=.
replace PRICE4_1=mprice49 if faminc4yb_1>mcutoff48 & faminc4yb_1<=mcutoff49 & (kom4steep==1) & mcutoff48!=. & faminc4yb_1!=.
replace PRICE4_1=mprice410 if faminc4yb_1>mcutoff49 & faminc4yb_1<=mcutoff410 & (kom4steep==1) & mcutoff49!=. & faminc4yb_1!=.
replace PRICE4_1=mprice411 if faminc4yb_1>mcutoff410 & faminc4yb_1<=mcutoff411 & (kom4steep==1) & mcutoff410!=. & faminc4yb_1!=.
replace PRICE4_1=mprice412 if faminc4yb_1>mcutoff411 & faminc4yb_1<=mcutoff412 & (kom4steep==1) & mcutoff411!=. & faminc4yb_1!=.
replace PRICE4_1=mprice413 if faminc4yb_1>mcutoff412 & faminc4yb_1<=mcutoff413 & (kom4steep==1) & mcutoff412!=. & faminc4yb_1!=.
replace PRICE4_1=mprice414 if faminc4yb_1>mcutoff413 & faminc4yb_1<=mcutoff414 & (kom4steep==1) & mcutoff413!=. & faminc4yb_1!=.
replace PRICE4_1=mprice415 if faminc4yb_1>mcutoff414 & faminc4yb_1<=mcutoff415 & (kom4steep==1) & mcutoff414!=. & faminc4yb_1!=.
replace PRICE4_1=mprice416 if faminc4yb_1>mcutoff415 & faminc4yb_1<=mcutoff416 & (kom4steep==1) & mcutoff415!=. & faminc4yb_1!=.
replace PRICE4_1=mprice417 if faminc4yb_1>mcutoff416 & faminc4yb_1<=mcutoff417 & (kom4steep==1) & mcutoff416!=. & faminc4yb_1!=.
replace PRICE4_1=mprice418 if faminc4yb_1>mcutoff417 & faminc4yb_1<=mcutoff418 & (kom4steep==1) & mcutoff417!=. & faminc4yb_1!=.
replace PRICE4_1=mprice419 if faminc4yb_1>mcutoff418 & faminc4yb_1<=mcutoff419 & (kom4steep==1) & mcutoff418!=. & faminc4yb_1!=.
replace PRICE4_1=mprice420 if faminc4yb_1>mcutoff419 & faminc4yb_1<=mcutoff420 & (kom4steep==1) & mcutoff419!=. & faminc4yb_1!=.
replace PRICE4_1=mprice421 if faminc4yb_1>mcutoff420 & faminc4yb_1<=mcutoff421 & (kom4steep==1) & mcutoff420!=. & faminc4yb_1!=.
replace PRICE4_1=mprice422 if faminc4yb_1>mcutoff421 & faminc4yb_1<=mcutoff422 & (kom4steep==1) & mcutoff421!=. & faminc4yb_1!=.
replace PRICE4_1=mprice423 if faminc4yb_1>mcutoff422 & faminc4yb_1<=mcutoff423 & (kom4steep==1) & mcutoff422!=. & faminc4yb_1!=.
replace PRICE4_1=mprice424 if faminc4yb_1>mcutoff423 & faminc4yb_1<=mcutoff424 & (kom4steep==1) & mcutoff423!=. & faminc4yb_1!=.
replace PRICE4_1=mprice425 if faminc4yb_1>mcutoff424 & faminc4yb_1<=mcutoff425 & (kom4steep==1) & mcutoff424!=. & faminc4yb_1!=.
replace PRICE4_1=mprice426 if faminc4yb_1>mcutoff425 & faminc4yb_1<=mcutoff426 & (kom4steep==1) & mcutoff425!=. & faminc4yb_1!=.
replace PRICE4_1=mprice427 if faminc4yb_1>mcutoff426 & faminc4yb_1<=mcutoff427 & (kom4steep==1) & mcutoff426!=. & faminc4yb_1!=.
replace PRICE4_1=mprice428 if faminc4yb_1>mcutoff427 & (kom4steep==1) & mcutoff427!=. & faminc4yb_1!=.

* d) attending child care at age 4- different definitions

gen famdeduc4=famdeduc1996 if foedselsaar==1992
replace famdeduc4=famdeduc1995 if foedselsaar==1991
replace famdeduc4=famdeduc1994 if foedselsaar==1990
replace famdeduc4=famdeduc1993 if foedselsaar==1989

*simple definition

gen cc4s=1 if  famdeduc4>0 
replace cc4s=0 if cc4s==.

*by family size

gen familysize1_10_4=familysize1_10_96 if foedselsaar==1992
replace familysize1_10_4=familysize1_10_95 if foedselsaar==1991
replace familysize1_10_4=familysize1_10_94 if foedselsaar==1990
replace familysize1_10_4=familysize1_10_93 if foedselsaar==1989

*family size of 1 - child is in child care if deduction>0

gen cc4fs=1 if famdeduc4>0 & familysize1_10_4==1  
   
gen msibred4=msibred1996 if foedselsaar==1992
replace msibred4=msibred1995 if foedselsaar==1991
replace msibred4=msibred1994 if foedselsaar==1990
replace msibred4=msibred1993 if foedselsaar==1989
replace msibred4=msibred1992 if foedselsaar==1988
replace msibred4=msibred1991 if foedselsaar==1987
replace msibred4=0 if msibred4==.

*family size of 2- sibling is younger: Child is in child care if deduction>0 - sibling is older: Child in child care if deduction > price of child care 

replace cc4fs=1 if famdeduc4>0 & familysize1_10_4==2  & cc4fs==.  & sfaarolder1==.
replace cc4fs=1 if famdeduc4>0 & (famdeduc4*(1+(msibred4/100))>=(famdeduc5)) & familysize1_10_4==2  & cc4fs==.  & sfaarolder1!=.

*family size of three or more - siblings are younger: Child is in child care if deduction>0 - siblings are one older and one younger: Child in child care if deduction > lowest price of child care - siblings are older: Child in child care if deduction > lowest price of child care*(1+sibling reduction) 
 
replace cc4fs=1 if  famdeduc4>0 & familysize1_10_4>=3  & cc4fs==.  & sfaarolder1==.
replace cc4fs=1 if famdeduc4>0 &(famdeduc4*(1+(msibred4/100))>=(famdeduc5)) & familysize1_10_4>=3 & cc4fs==.  & sfaarolder1!=. & sfaaryounger1!=.

*no child care

replace cc4fs=0 if cc4fs==. & (foedselsaar==1992 |foedselsaar==1991|foedselsaar==1990|foedselsaar==1989)
*replace cc5fs=1 if cc5fs==0 & cc4fs==1



**sample selection

drop if faminc13_1==. 
drop if mwelfare4==.
drop if student4==. 
drop if marrcohb==.
drop if meduy08==. 
drop if feduy08==. 
drop if mageb==.
drop if fageb==.
drop if mimmigrantb==. 
drop if fimmigrantb==.
drop if female==.

drop if finc5==0 & minc5==0

end
