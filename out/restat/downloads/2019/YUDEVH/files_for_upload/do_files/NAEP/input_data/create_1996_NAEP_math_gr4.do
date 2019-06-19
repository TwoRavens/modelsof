version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AK AR AZ CA CO CT DC DE FL GA HI IN IA KY LA MA MD ME MI MN MO MS MT NC NE NM NV NY ND OR PA RI SC TN TX UT VA VT WA WI WV WY {;
	clear;
	infix SCH 17-19 DSEX 99 DRACE 100 SLUNCH1 1765 RPTSAMP 53 str OEDIST 85-89 str OEBLDG 90-94 
		PUBPRIV 54 ORIGWT 201-207 FIPS96 15-16 FIPS 83-84 SUBSAMP 51
		MTHCM1 1972-1977 MTHCM2 1978-1983 MTHCM3 1984-1989 MTHCM4 1990-1995 MTHCM5 1996-2001
		MRPCM1 2127-2131 MRPCM2 2132-2136 MRPCM3 2137-2141 MRPCM4 2142-2146 MRPCM5 2147-2151
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP49\data\MST1ST`s'.dat";

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
	gen grade=4;
	gen subject=1;
	keep year grade subject FIPS FIPS96 SCH PUBPRIV OEDIST OEBLDG 
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 SUBSAMP
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr4_1996_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr4_1996_AL", clear;
foreach s in AK AR AZ CA CO CT DC DE FL GA HI IN IA KY LA MA MD ME MI MN MO MS MT NC NE NM NV NY ND OR PA RI SC TN TX UT VA VT WA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr4_1996_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1996\naep_math_gr4_1996", replace;



