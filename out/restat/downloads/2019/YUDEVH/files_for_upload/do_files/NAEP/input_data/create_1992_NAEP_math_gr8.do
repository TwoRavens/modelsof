version 8
clear
set memory 670m
set more off
#delimit;

*NOTE - no school lunch indicator;
*NOTE - no reporting sample variable, because the data is only those in reporting sample;
*NOTE - no pubprv variable, so assume all public;

foreach s in AL AR AZ CA CO CT DE DC FL GA HI ID IN IA KY LA MA MD ME MI MN MO MS NE NH NJ NM NY NC ND OH OK PA RI SC TN TX UT VA WI WV WY {;
	clear;
	infix SCH 22-24 DSEX 93 DRACE 94 str OEDIST 79-83 str OEBLDG 84-88 
		ORIGWT 153-159 FIPS 20-21 
		MTHCM1 875-880 MTHCM2 881-886 MTHCM3 887-892 MTHCM4 893-898 MTHCM5 899-904
		MRPCM1 1055-1059 MRPCM2 1060-1064 MRPCM3 1065-1069 MRPCM4 1070-1074 MRPCM5 1075-1079
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP44\DATA\TSM2ST`s'.dat";

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

	gen year=1992;
	gen grade=8;
	gen subject=1;
	keep year grade subject FIPS SCH OEDIST OEBLDG 
	ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 
	DSEX DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_math_gr8_1992_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_math_gr8_1992_AL", clear;
foreach s in AR AZ CA CO CT DE DC FL GA HI ID IN IA KY LA MA MD ME MI MN MO MS NE NH NJ NM NY NC ND OH OK PA RI SC TN TX UT VA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_math_gr8_1992_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_math_gr8_1992", replace;



