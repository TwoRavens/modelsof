version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AR AZ CA CT DC DE FL GA HI IL KA KY LA MA MD ME MN MO MS MT NC NE NM NV NY OK OR RI SC TN TX UT VA WA WI WV WY {;
	clear;
	infix SCH 17-19 DSEX 80 DRACE 81 SLUNCH1 42 RPTSAMP 44 str OEDIST 60-64 str OEBLDG 65-69 
		PUBPRIV 20 ORIGWT 186-192 FIPS96 15-16 FIPS 58-59
		RTHCM1 1697-1702 RTHCM2 1703-1708 RTHCM3 1709-1714 RTHCM4 1715-1720 RTHCM5 1721-1726
		RRPCM1 1802-1806 RRPCM2 1807-1811 RRPCM3 1812-1816 RRPCM4 1817-1821 RRPCM5 1822-1826
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP9\Y29RED2\data\RST2ST`s'.dat";

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
	gen grade=8;
	gen subject=2;
	keep year grade subject FIPS FIPS96 SCH PUBPRIV OEDIST OEBLDG 
	ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr8_1998_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr8_1998_AL", clear;
foreach s in AR AZ CA CT DC DE FL GA HI IL KA KY LA MA MD ME MN MO MS MT NC NE NM NV NY OK OR RI SC TN TX UT VA WA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr8_1998_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1998\naep_read_gr8_1998", replace;



