version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AK AR AZ CA CO CT DC DE FL GA HI IN IA KY LA MA MD ME MI MN MO MS MT NC NE NH NM NV NY ND OR RI SC TN TX UT VA VT WA WI WV WY {;
	clear;
	infix SCH 17-19 DSEX 99 DRACE 100 SLUNCH1 1765 RPTSAMP 53 str OEDIST 85-89 str OEBLDG 90-94 
		PUBPRIV 54 ORIGWT 201-207 FIPS96 15-16 FIPS 83-84
		MTHCM1 1975-1980 MTHCM2 1981-1986 MTHCM3 1987-1992 MTHCM4 1993-1998 MTHCM5 1999-2004
		MRPCM1 2130-2134 MRPCM2 2135-2139 MRPCM3 2140-2144 MRPCM4 2145-2149 MRPCM5 2150-2154
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP4A\data\MST2ST`s'.dat";

	forvalues x=1/5 {;
		replace MTHCM`x' = MTHCM`x'/10000;
	};
	forvalues x=1/5 {;
		replace MRPCM`x' = MRPCM`x'/100;
	};
	replace ORIGWT = ORIGWT / 100;	

	*KEEP ONLY THOSE NOT EXCLUDED;
	keep if RPTSAMP==1;

	*NOTE ON FORMATS: Public school is code zero;
	/*
	*RACE: VALUE RACE      1='WHITE               '2='BLACK               '
                  3='HISPANIC            '    4='ASIAN               '
                  5='AMERICAN INDIAN     '    6='UNCLASSIFIED        '   ;
	*/

	gen year=1996;
	gen grade=8;
	gen subject=1;
	keep year grade subject FIPS FIPS96 SCH PUBPRIV OEDIST OEBLDG 
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr8_1996_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr8_1996_AL", clear;
foreach s in AK AR AZ CA CO CT DC DE FL GA HI IN IA KY LA MA MD ME MI MN MO MS MT NC NE NH NM NV NY ND OR RI SC TN TX UT VA VT WA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr8_1996_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr8_1996", replace;



