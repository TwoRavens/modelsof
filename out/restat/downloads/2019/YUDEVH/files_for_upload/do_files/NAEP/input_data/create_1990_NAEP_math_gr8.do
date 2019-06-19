version 8
clear
set memory 670m
set more off
#delimit;

*NOTE - no school lunch indicator;
*NOTE - no reporting sample variable, because the data is only those in reporting sample;
*NOTE - no pubprv variable, so assume all public;

foreach s in AL AR AZ CA CO CT DE DC FL GA HI ID IN IA IL KY LA MD MI MN MT NE NH NJ NM NY NC ND OH OK OR PA RI TX VA WI WV WY {;
	clear;
	infix SCH 20-22 DSEX 66 DRACE 67 str OEDIST 49-53 str OEBLDG 54-58 
		ORIGWT 949-955 FIPS 1030-1031 
		MTHCM1 1182-1187 MTHCM2 1188-1193 MTHCM3 1194-1199 MTHCM4 1200-1205 MTHCM5 1206-1211
		MRPCM1 1337-1341 MRPCM2 1342-1346 MRPCM3 1347-1351 MRPCM4 1352-1356 MRPCM5 1357-1361
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP40\DATA\TSM2ST`s'.dat";

	forvalues x=1/5 {;
		replace MTHCM`x' = MTHCM`x'/10000;
	};
	forvalues x=1/5 {;
		replace MRPCM`x' = MRPCM`x'/100;
	};
	replace ORIGWT = ORIGWT / 100;	


	/*
  VALUE RACE      1='WHITE               '    2='BLACK               '
                  3='HISPANIC            '    4='ASIAN               '
                  5='AMERICAN INDIAN     '    6='UNCLASSIFIED        ' ;
				  
	VALUE SEX       1='MALE                '    2='FEMALE              ' ;
	*/

	gen year=1990;
	gen grade=8;
	gen subject=1;
	keep year grade subject FIPS SCH OEDIST OEBLDG 
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 
	DSEX DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1990\naep_math_gr8_1990_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1990\naep_math_gr8_1990_AL", clear;
foreach s in AR AZ CA CO CT DE DC FL GA HI ID IN IA IL KY LA MD MI MN MT NE NH NJ NM NY NC ND OH OK OR PA RI TX VA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1990\naep_math_gr8_1990_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1990\naep_math_gr8_1990", replace;



