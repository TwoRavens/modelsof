version 8
clear
set memory 670m
set more off
#delimit;

infix str lea 1-7 str lea_sch 8-19 str foo 20-31 str n_name 32-61 str n_addr 62-91 str n_city 92-108
      str n_state 109-110 
      str n_zip 111-115
      str n_phone 116-128
      str n_id 129-135
          n_disp 136-137
          n_grade 138-139
          naep90 140
          naep92 141
          naep94 142
          naep96 143
          naep98 144
          n      145
      str verify 146
          grd_span 147
	using "C:\Users\Hyman\Desktop\pre2000 NAEP CCD crosswalk\DELIVER.dat";

 recode n_disp (0=0) (5=5) (11/20=11) (21/29=21) (31/39=31) (50=50), gen(alt_disp);
 label define displabl 0  "Non-cooperating" 
                        5  "Refusal" 
                        11 "Cooperating"
                        21 "Refusal"
                        31 "Out of scope"
                        50 "Cooperating";
 label values alt_disp displabl;
 
 destring verify, gen(altverify) force;
 replace altverify=10 if verify=="A";
 replace altverify=11 if verify=="B";
 replace altverify=12 if verify=="C";
 replace altverify=13 if verify=="D";
 replace altverify=14 if verify=="E";
 replace altverify=15 if verify=="F";
 assert altverify<. if verify~="";
 label define verlabl 1 "6 orig match pts"
                      2 "5 orig match pts (incl. school name)"
                      3 "4 orig match pts (incl. school name)"
                      4 "5 orig match pts (not school name)"
                      5 "4 orig match pts (not school name)"
                      6 "3 orig match pts"
                      7 "2 or 1 orig match pts"
                      8 "0 orig match pts"
                      9 "Schools w overlapping grades"
                      10 "Possible but uncertain match"
                      11 "Possible but uncertain match"
                      12 "Closed or inelig at NAEP time"
                      15 "Fail to match w CCD";
label values altverify verlabl;
                        
label var lea		   "NAEP/CCD agency match key";
label var lea_sch	 "NAEP/CCD school match key ";
label var foo      "Prelim key: FIPS+OE_DIST+OE_BLDG";
label var n_name   "School name from NAEP files";
label var n_addr   "School address from NAEP files";
label var n_city   "School city from NAEP files";
label var n_state	 "School state from NAEP files";
label var n_zip		 "School ZIP code from NAEP files";
label var n_phone	 "School phone number from NAEP files";
label var n_id		 "NAEP School ID";
label var n_disp	 "NAEP School participation Status";
label var n_grade	 "NAEP Grade: 04, 08, 12";
label var naep90	 "1990 NAEP Selection Flag";
label var naep92	 "1992 NAEP Selection Flag";
label var naep94	 "1994 NAEP Selection Flag";
label var naep96	 "1996 NAEP Selection Flag";
label var naep98	 "1998 NAEP Selection Flag";
label var n		     "Number of NAEP/CCD school points";
label var verify	 "Verify pass";
label var grd_span "=1 if CCD record contains NAEP grade: 0,1	";
                       
label var altverify "Numeric (labeled) verify pass";
label var alt_disp "Collapsed (labeled) participation status";

compress;
notes : "Crosswalk from NAEP schools to CCD codes";
notes : "Match to NAEP data using n_id or foo";
notes : "Match to CCD using lea or lea_sch";

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", replace;



