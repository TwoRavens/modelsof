version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AR AZ CA CT DC DE FL GA HI IA IL KA KY LA MA MD ME MI MN MO MS MT NC NE NM NV NH NY OK OR RI SC TN TX UT VA WA WI WV WY {;
	clear;
	infix SCH 17-19 DSEX 79 DRACE 80 SLUNCH1 41 RPTSAMP 43 str OEDIST 59-63 str OEBLDG 64-68 
		PUBPRIV 20 ORIGWT 185-191 FIPS96 15-16 FIPS 57-58
		RTHCM1 1665-1670 RTHCM2 1671-1676 RTHCM3 1677-1682 RTHCM4 1683-1688 RTHCM5 1689-1694
		RRPCM1 1745-1749 RRPCM2 1750-1754 RRPCM3 1755-1759 RRPCM4 1760-1764 RRPCM5 1765-1769
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP9\Y29RED1\data\RST1ST`s'.dat";

	forvalues x=1/5 {;
		replace RTHCM`x' = RTHCM`x'/10000;
	};
	forvalues x=1/5 {;
		replace RRPCM`x' = RRPCM`x'/100;
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

	gen year=1998;
	gen grade=4;
	gen subject=2;
	keep year grade subject FIPS FIPS96 SCH PUBPRIV OEDIST OEBLDG 
	ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr4_1998_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr4_1998_AL", clear;
foreach s in AR AZ CA CT DC DE FL GA HI IA IL KA KY LA MA MD ME MI MN MO MS MT NC NE NM NV NH NY OK OR RI SC TN TX UT VA WA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr4_1998_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr4_1998", replace;



