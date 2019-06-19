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
	infix SCH 22-24 DSEX 90 DRACE 91 str OEDIST 76-80 str OEBLDG 81-85 
		ORIGWT 150-156 FIPS 20-21 
		RTHCM1 740-745 RTHCM2 746-751 RTHCM3 752-757 RTHCM4 758-763 RTHCM5 764-769
		RRPCM1 820-824 RRPCM2 825-829 RRPCM3 830-834 RRPCM4 835-839 RRPCM5 840-844
		using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP43\DATA\TSR1ST`s'.dat";

	forvalues x=1/5 {;
		replace RTHCM`x' = RTHCM`x'/10000;
	};
	forvalues x=1/5 {;
		replace RRPCM`x' = RRPCM`x'/100;
	};
	replace ORIGWT = ORIGWT / 100;	


	/*
  VALUE RACE      1='WHITE               '    2='BLACK               '
                  3='HISPANIC            '    4='ASIAN               '
                  5='AMERICAN INDIAN     '    6='UNCLASSIFIED        ' ;
				  
	VALUE SEX       1='MALE                '    2='FEMALE              ' ;
	*/

	gen year=1992;
	gen grade=4;
	gen subject=2;
	keep year grade subject FIPS SCH OEDIST OEBLDG 
	ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 
	DSEX DRACE;

	compress;
	save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_read_gr4_1992_`s'", replace;
};

use "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_read_gr4_1992_AL", clear;
foreach s in AR AZ CA CO CT DE DC FL GA HI ID IN IA KY LA MA MD ME MI MN MO MS NE NH NJ NM NY NC ND OH OK PA RI SC TN TX UT VA WI WV WY {;
	append using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_read_gr4_1992_`s'";
};

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\1992\naep_read_gr4_1992", replace;



