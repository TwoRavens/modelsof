version 8
clear
set memory 670m
set more off
#delimit;

foreach s in AL AR AZ CA CT DC GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NM NV NY OH OK OR RI SC TN TX UT VA VT WI WV WY {;
	clear;
	infix SCH 17-19 str SCHNO 92-96 LEAID 87-91 DSEX 121 DRACE 122 SLUNCH1 44 RPTSAMP 46
		PUBPRIV 20 str NCESSCH 97-108 ORIGWT 234-240 FIPS00 60-61
		MTHCM1 1534-1539 MTHCM2 1540-1545 MTHCM3 1546-1551 MTHCM4 1552-1557 MTHCM5 1558-1563
		MRPCM1 1689-1693 MRPCM2 1694-1698 MRPCM3 1699-1703 MRPCM4 1704-1708 MRPCM5 1709-1713
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP9M\data\M31ST1`s'.dat";

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
	gen grade=4;
	gen subject=1;
	keep year grade subject FIPS NCESSCH SCH SCHNO LEAID PUBPRIV  
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 
	DSEX SLUNCH1 DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr4_2000_`s'", replace;
};
use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr4_2000_AL", clear;
foreach s in AR AZ CA CT DC GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NM NV NY OH OK OR RI SC TN TX UT VA VT WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr4_2000_`s'";
};

*NOTE - Jesse in his .do files (NAEP_district.do) seems to say he uses national sample as well for this year, but there's only 6000 public school
obs for grade 4 in this national sample, so I don't add it in, and the weights are weird;

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2000\naep_math_gr4_2000", replace;



