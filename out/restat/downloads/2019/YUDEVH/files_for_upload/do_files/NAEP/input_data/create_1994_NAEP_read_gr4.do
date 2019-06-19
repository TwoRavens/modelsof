version 8
clear
set memory 670m
set more off
#delimit;

*NOTE - no school lunch indicator, so trying to grab something else, but we'll see if it works. YES WORKS, just have to replace 0 and 8 as missing;
*NOTE - no reporting sample variable, because the data is only those in reporting sample;
*NOTE - pubprv is different variable, so check to see it is what I think it is, yes, value of 1 is public;

foreach s in AL AR AZ CA CO CT DE FL GA HI ID IN IA KY LA MA MD ME MI MN MO MS MT NC NE NH NJ NM NY ND PA RI SC TN TX UT VA WA WI WV WY {;
	clear;
	infix SCH 17-19 DSEX 82 DRACE 83 SLUNCH1 886 str OEDIST 68-72 str OEBLDG 73-77 
		PUBPRIV 20 ORIGWT 145-152 FIPS 15-16 
		RTHCM1 775-780 RTHCM2 781-786 RTHCM3 787-792 RTHCM4 793-798 RTHCM5 799-804
		RRPCM1 855-859 RRPCM2 860-864 RRPCM3 865-869 RRPCM4 870-874 RRPCM5 875-879
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP47\DATA\TSR1ST`s'.dat";

	forvalues x=1/5 {;
		replace RTHCM`x' = RTHCM`x'/10000;
	};
	forvalues x=1/5 {;
		replace RRPCM`x' = RRPCM`x'/100;
	};
	replace ORIGWT = ORIGWT / 100;	

	*NOTE ON FORMATS: Public school is code one;
	/*
  VALUE DRACE7V   1='WHITE               '    2='BLACK               '
                  3='HISPANIC            '    4='ASIAN               '
                  5='PACIFIC ISLANDER    '    6='AMERICAN INDIAN     '
                  7='UNCLASSIFIED        
	*/

	gen year=1994;
	gen grade=4;
	gen subject=2;
	keep year grade subject FIPS SCH PUBPRIV OEDIST OEBLDG 
	ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1994\naep_read_gr4_1994_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1994\naep_read_gr4_1994_AL", clear;
foreach s in AR AZ CA CO CT DE FL GA HI ID IN IA KY LA MA MD ME MI MN MO MS MT NC NE NH NJ NM NY ND PA RI SC TN TX UT VA WA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1994\naep_read_gr4_1994_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1994\naep_read_gr4_1994", replace;



