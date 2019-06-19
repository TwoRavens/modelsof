version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AR AZ CA CT DC GA HI ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NM NV NY OH OK OR RI SC TN TX UT VA VT WI WV WY {;
	clear;
	infix SCH 17-19 str SCHNO 92-96 LEAID 87-91 DSEX 121 DRACE 122 SLUNCH1 44 RPTSAMP 46
		PUBPRIV 20 str NCESSCH 97-108 ORIGWT 234-240 FIPS00 60-61
		MTHCM1 1535-1540 MTHCM2 1541-1546 MTHCM3 1547-1552 MTHCM4 1553-1558 MTHCM5 1559-1564
		MRPCM1 1690-1694 MRPCM2 1695-1699 MRPCM3 1700-1704 MRPCM4 1705-1709 MRPCM5 1710-1714
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP9D\data\M31ST2`s'.dat";

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

	gen year=2000;
	gen grade=8;
	gen subject=1;
	keep year grade subject FIPS NCESSCH SCH SCHNO LEAID PUBPRIV
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr8_2000_`s'", replace;
};
use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr8_2000_AL", clear;
foreach s in AR AZ CA CT DC GA HI ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NM NV NY OH OK OR RI SC TN TX UT VA VT WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr8_2000_`s'";
};

*NOTE - Don't add in national sample;

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr8_2000", replace;



