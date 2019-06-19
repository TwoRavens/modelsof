 /****************************************************************
 *** You may need to edit this code.                          *** 
 ***                                                          *** 
 *** Please check all INFILE statements and FORMAT            *** 
 *** specifications before running code.                      *** 
 ***                                                          *** 
 *** You may have selected variables that contain missing     *** 
 *** data or valid skips. Missing data are represented with a *** 
 *** negative nine (-9), nonrespondents are represented with  *** 
 *** negative four (-4) while valid skips are represented     *** 
 *** with a negative eight (-8). You may wish to recode one   *** 
 *** or both of these. You can recode these special values to *** 
 *** missing using the following code:                        *** 
 ***                                                          *** 
 *** replace {variable name} = . if {variable name} <= -4;    *** 
 ***                                                          *** 
 *** Replace {variable name} above with the name of the       *** 
 *** variable you wish to recode.                             *** 
 ***                                                          *** 
 *** Full sample weights, replicate weights, district control *** 
 *** numbers, and school control numbers are added            *** 
 *** automatically to the Stata program code.                 *** 
 ****************************************************************/
/* Clear everything */                                            
clear all                                                         
set more 1                                                        
                                                                  
/* Change Working Directory */                                    
/* in: Add the path where the dictionary code is located */       
/* out: Add the path where the STATA file will be saved */        
                                                                  
global in "C:\Users\Hyman\Desktop\SASS\2011-12\"                                                      
global out "C:\Users\Hyman\Desktop\SASS\2011-12\"                                                     
                                                                  
/* Increase Memory Size to allow for dataset */                   
set memory 500m                                                   
                                                                  
/* Import ASCII data using dictionary */                          
infile using "$in\District11.DCT"                                 
                                                                  
/* Change Delimiter */                                            
#delimit;                                                         
                                                                  
/* Create Variable Formats */                                     
                                                                  
 label data "District11";                                         

 label define AGTYPEF
   1 "Regular local school district"
   2 "Local school district that is a component of a supervisory union"
   3 "Supervisory Union"
   4 "Regional Education Service Agency"
   5 "State-Operated Agency"
   6 "Federally-Operated Agency"
   7 "Charter Agency"
   8 "Other Education Agency"
     ;
 label define CONTEAF
   -9 "Missing"
     ;
 label define D0006F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0007F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0008F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0009F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0390F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0391F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0392F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0393F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0394F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0400F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, grades K-12"
   2 "No, grades 1-12 only"
   3 "No"
     ;
 label define D0402F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0403F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0404F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0405F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0406F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0407F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0408F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0409F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0410F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0411F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0412F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0413F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0414F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0415F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0416F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0418F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0420F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0421F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0422F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0423F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0424F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0425F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0426F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0427F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0430F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0431F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0432F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0433F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0434F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0435F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0440F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0441F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0442F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0443F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0444F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0445F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0446F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0447F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0448F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0450F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0451F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0452F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, meet-and-confer"
   2 "Yes, collective bargaining"
   3 "Yes, other type of agreement"
   4 "No agreement"
     ;
 label define D0453F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0454F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0455F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, meet-and-confer"
   2 "Yes, collective bargaining"
   3 "Yes, other type of agreement"
   4 "No agreement"
     ;
 label define D0456F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0457F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0458F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0459F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0470F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0471F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0472F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0473F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0474F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0475F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0476F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0477F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0480F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0481F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0482F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0483F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0485F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Layoffs due to school closings or school mergers"
   2 "Layoffs due to reduced enrollment"
   3 "Layoffs due to a reduction in force, unrelated to reduced enrollment or school closings"
   4 "Failure to meet Highly Qualified Teacher (HQT) requirements"
   5 "Poor performance of teachers"
   6 "Teacher misconduct"
   7 "Other - Please specify"
     ;
 label define D0486F
   -8 "Valid Skip"
   -9 "Missing"
   1 "No second most common reason"
     ;
 label define D0487F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Layoffs due to school closings or school mergers"
   2 "Layoffs due to reduced enrollment"
   3 "Layoffs due to a reduction in force, unrelated to reduced enrollment or school closings"
   4 "Failure to meet Highly Qualified Teacher (HQT) requirements"
   5 "Poor performance of teachers"
   6 "Teacher misconduct"
   7 "Other - Please specify"
     ;
 label define D0488F
   -8 "Valid Skip"
   -9 "Missing"
   1 "No third most common reason"
     ;
 label define D0489F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Layoffs due to school closings or school mergers"
   2 "Layoffs due to reduced enrollment"
   3 "Layoffs due to a reduction in force, unrelated to reduced enrollment or school closings"
   4 "Failure to meet Highly Qualified Teacher (HQT) requirements"
   5 "Poor performance of teachers"
   6 "Teacher misconduct"
   7 "Other - Please specify"
     ;
 label define D0500F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0501F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0502F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0503F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0504F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0505F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0506F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0507F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0508F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0509F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0510F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0511F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0512F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0513F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0514F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0515F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0516F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0517F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0518F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, but some employee contribution required"
   2 "Yes, but no employee contribution required"
   3 "No"
     ;
 label define D0519F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0520F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0521F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0522F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0523F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0524F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0525F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0526F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0527F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0540F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0541F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0542F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0543F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0544F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0545F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0546F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0547F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0548F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0560F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0561F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0562F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0563F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0564F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0565F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0566F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0567F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0568F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0569F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0580F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0581F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0582F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0583F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0584F
   -8 "Valid Skip"
   -9 "Missing"
     ;
 label define D0585F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0595F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define D0596F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
     ;
 label define DLOCP12F
   11 "City, Large"
   12 "City, Midsize"
   13 "City, Small"
   21 "Suburb, Large"
   22 "Suburb, Midsize"
   23 "Suburb, Small"
   31 "Town, Fringe"
   32 "Town, Distant"
   33 "Town, Remote"
   41 "Rural, Fringe"
   42 "Rural, Distant"
   43 "Rural, Remote"
     ;
 label define FILEF
   1 "Public school district"
   2 "Public school"
   3 "Private school"
   5 "Public school principal"
   6 "Private school principal"
   8 "Public school teacher"
   9 "Private school teacher"
   11 "Public school library media center"
     ;
 label define F_D0006F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0007F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0008F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0009F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0390F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0391F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0392F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0393F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0394F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0400F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0402F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0403F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0404F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0405F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0406F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0407F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0408F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0409F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0410F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0411F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0412F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0413F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0414F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0415F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0416F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0418F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0420F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0421F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0422F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0423F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0424F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0425F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0426F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0427F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0430F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0431F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0432F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0433F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0434F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0435F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0440F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0441F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0442F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0443F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0444F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0445F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0446F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0447F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0448F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0450F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0451F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0452F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0453F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0454F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0455F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0456F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0457F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0458F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0459F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0470F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0471F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0472F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0473F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0474F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0475F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0476F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0477F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0480F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0481F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0482F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0483F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0485F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0486F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0487F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0488F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0489F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0500F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0501F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0502F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0503F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0504F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0505F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0506F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0507F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0508F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0509F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0510F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0511F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0512F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0513F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0514F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0515F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0516F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0517F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0518F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0519F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0520F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0521F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0522F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0523F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0524F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0525F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0526F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0527F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0540F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0541F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0542F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0543F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0544F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0545F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0546F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0547F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0548F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0560F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0561F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0562F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0563F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0564F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0565F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0566F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0567F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0568F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0569F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0580F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0581F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0582F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0583F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0584F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0585F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0595F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D0596F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D5484F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D9001F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D9002F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D9003F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define F_D9004F
   0 "Not imputed"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the mean or mode of data for groups of similar cases"
   9 "Data value was adjusted during analysts’ post-imputation review of data"
     ;
 label define NMINST_DF
   -9 "Missing"
     ;
 label define NMNTCH_DF
   -9 "Missing"
     ;
 label define NSLAPP_DF
   -8 "Valid Skip"
     ;
 label define NUMSTATEF
   1 "Alabama"
   2 "Alaska"
   3 "Arizona"
   4 "Arkansas"
   5 "California"
   6 "Colorado"
   7 "Connecticut"
   8 "Delaware"
   9 "District of Columbia"
   10 "Florida"
   11 "Georgia"
   12 "Hawaii"
   13 "Idaho"
   14 "Illinois"
   15 "Indiana"
   16 "Iowa"
   17 "Kansas"
   18 "Kentucky"
   19 "Louisiana"
   20 "Maine"
   21 "Maryland"
   22 "Massachusetts"
   23 "Michigan"
   24 "Minnesota"
   25 "Mississippi"
   26 "Missouri"
   27 "Montana"
   28 "Nebraska"
   29 "Nevada"
   30 "New Hampshire"
   31 "New Jersey"
   32 "New Mexico"
   33 "New York"
   34 "North Carolina"
   35 "North Dakota"
   36 "Ohio"
   37 "Oklahoma"
   38 "Oregon"
   39 "Pennsylvania"
   40 "Rhode Island"
   41 "South Carolina"
   42 "South Dakota"
   43 "Tennessee"
   44 "Texas"
   45 "Utah"
   46 "Vermont"
   47 "Virginia"
   48 "Washington"
   49 "West Virginia"
   50 "Wisconsin"
   51 "Wyoming"
     ;
 label define REGIONF
   1 "Northeast"
   2 "Midwest"
   3 "South"
   4 "West"
     ;
 label define SCDISTFLF
   1 "Single-school district"
   2 "Not a single-school district"
     ;
 label define SURVEYF
   1 "School District Questionnaire (1A)"
   2 "Principal Questionnaire (2A)"
   3 "Private School Principal Questionnaire (2B)"
   4 "School Questionnaire (3A)"
   5 "Private School Questionnaire (3B)"
   6 "School Survey With District Items (3Y)"
   7 "Teacher Questionnaire (4A)"
   8 "Private School Teacher Questionnaire (4B)"
   9 "School Library Media Center Questionnaire (LS-1A)"
     ;
 label define URBAND12F
   1 "City"
   2 "Suburb"
   3 "Town"
   4 "Rural"
     ;
 label values  AGTYPE  AGTYPEF ;
 label values  CONTEA  CONTEAF ;
 label values  D0006  D0006F ;
 label values  D0007  D0007F ;
 label values  D0008  D0008F ;
 label values  D0009  D0009F ;
 label values  D0390  D0390F ;
 label values  D0391  D0391F ;
 label values  D0392  D0392F ;
 label values  D0393  D0393F ;
 label values  D0394  D0394F ;
 label values  D0400  D0400F ;
 label values  D0402  D0402F ;
 label values  D0403  D0403F ;
 label values  D0404  D0404F ;
 label values  D0405  D0405F ;
 label values  D0406  D0406F ;
 label values  D0407  D0407F ;
 label values  D0408  D0408F ;
 label values  D0409  D0409F ;
 label values  D0410  D0410F ;
 label values  D0411  D0411F ;
 label values  D0412  D0412F ;
 label values  D0413  D0413F ;
 label values  D0414  D0414F ;
 label values  D0415  D0415F ;
 label values  D0416  D0416F ;
 label values  D0418  D0418F ;
 label values  D0420  D0420F ;
 label values  D0421  D0421F ;
 label values  D0422  D0422F ;
 label values  D0423  D0423F ;
 label values  D0424  D0424F ;
 label values  D0425  D0425F ;
 label values  D0426  D0426F ;
 label values  D0427  D0427F ;
 label values  D0430  D0430F ;
 label values  D0431  D0431F ;
 label values  D0432  D0432F ;
 label values  D0433  D0433F ;
 label values  D0434  D0434F ;
 label values  D0435  D0435F ;
 label values  D0440  D0440F ;
 label values  D0441  D0441F ;
 label values  D0442  D0442F ;
 label values  D0443  D0443F ;
 label values  D0444  D0444F ;
 label values  D0445  D0445F ;
 label values  D0446  D0446F ;
 label values  D0447  D0447F ;
 label values  D0448  D0448F ;
 label values  D0450  D0450F ;
 label values  D0451  D0451F ;
 label values  D0452  D0452F ;
 label values  D0453  D0453F ;
 label values  D0454  D0454F ;
 label values  D0455  D0455F ;
 label values  D0456  D0456F ;
 label values  D0457  D0457F ;
 label values  D0458  D0458F ;
 label values  D0459  D0459F ;
 label values  D0470  D0470F ;
 label values  D0471  D0471F ;
 label values  D0472  D0472F ;
 label values  D0473  D0473F ;
 label values  D0474  D0474F ;
 label values  D0475  D0475F ;
 label values  D0476  D0476F ;
 label values  D0477  D0477F ;
 label values  D0480  D0480F ;
 label values  D0481  D0481F ;
 label values  D0482  D0482F ;
 label values  D0483  D0483F ;
 label values  D0485  D0485F ;
 label values  D0486  D0486F ;
 label values  D0487  D0487F ;
 label values  D0488  D0488F ;
 label values  D0489  D0489F ;
 label values  D0500  D0500F ;
 label values  D0501  D0501F ;
 label values  D0502  D0502F ;
 label values  D0503  D0503F ;
 label values  D0504  D0504F ;
 label values  D0505  D0505F ;
 label values  D0506  D0506F ;
 label values  D0507  D0507F ;
 label values  D0508  D0508F ;
 label values  D0509  D0509F ;
 label values  D0510  D0510F ;
 label values  D0511  D0511F ;
 label values  D0512  D0512F ;
 label values  D0513  D0513F ;
 label values  D0514  D0514F ;
 label values  D0515  D0515F ;
 label values  D0516  D0516F ;
 label values  D0517  D0517F ;
 label values  D0518  D0518F ;
 label values  D0519  D0519F ;
 label values  D0520  D0520F ;
 label values  D0521  D0521F ;
 label values  D0522  D0522F ;
 label values  D0523  D0523F ;
 label values  D0524  D0524F ;
 label values  D0525  D0525F ;
 label values  D0526  D0526F ;
 label values  D0527  D0527F ;
 label values  D0540  D0540F ;
 label values  D0541  D0541F ;
 label values  D0542  D0542F ;
 label values  D0543  D0543F ;
 label values  D0544  D0544F ;
 label values  D0545  D0545F ;
 label values  D0546  D0546F ;
 label values  D0547  D0547F ;
 label values  D0548  D0548F ;
 label values  D0560  D0560F ;
 label values  D0561  D0561F ;
 label values  D0562  D0562F ;
 label values  D0563  D0563F ;
 label values  D0564  D0564F ;
 label values  D0565  D0565F ;
 label values  D0566  D0566F ;
 label values  D0567  D0567F ;
 label values  D0568  D0568F ;
 label values  D0569  D0569F ;
 label values  D0580  D0580F ;
 label values  D0581  D0581F ;
 label values  D0582  D0582F ;
 label values  D0583  D0583F ;
 label values  D0584  D0584F ;
 label values  D0585  D0585F ;
 label values  D0595  D0595F ;
 label values  D0596  D0596F ;
 label values  DLOCP12  DLOCP12F ;
 label values  FILE  FILEF ;
 label values  F_D0006  F_D0006F ;
 label values  F_D0007  F_D0007F ;
 label values  F_D0008  F_D0008F ;
 label values  F_D0009  F_D0009F ;
 label values  F_D0390  F_D0390F ;
 label values  F_D0391  F_D0391F ;
 label values  F_D0392  F_D0392F ;
 label values  F_D0393  F_D0393F ;
 label values  F_D0394  F_D0394F ;
 label values  F_D0400  F_D0400F ;
 label values  F_D0402  F_D0402F ;
 label values  F_D0403  F_D0403F ;
 label values  F_D0404  F_D0404F ;
 label values  F_D0405  F_D0405F ;
 label values  F_D0406  F_D0406F ;
 label values  F_D0407  F_D0407F ;
 label values  F_D0408  F_D0408F ;
 label values  F_D0409  F_D0409F ;
 label values  F_D0410  F_D0410F ;
 label values  F_D0411  F_D0411F ;
 label values  F_D0412  F_D0412F ;
 label values  F_D0413  F_D0413F ;
 label values  F_D0414  F_D0414F ;
 label values  F_D0415  F_D0415F ;
 label values  F_D0416  F_D0416F ;
 label values  F_D0418  F_D0418F ;
 label values  F_D0420  F_D0420F ;
 label values  F_D0421  F_D0421F ;
 label values  F_D0422  F_D0422F ;
 label values  F_D0423  F_D0423F ;
 label values  F_D0424  F_D0424F ;
 label values  F_D0425  F_D0425F ;
 label values  F_D0426  F_D0426F ;
 label values  F_D0427  F_D0427F ;
 label values  F_D0430  F_D0430F ;
 label values  F_D0431  F_D0431F ;
 label values  F_D0432  F_D0432F ;
 label values  F_D0433  F_D0433F ;
 label values  F_D0434  F_D0434F ;
 label values  F_D0435  F_D0435F ;
 label values  F_D0440  F_D0440F ;
 label values  F_D0441  F_D0441F ;
 label values  F_D0442  F_D0442F ;
 label values  F_D0443  F_D0443F ;
 label values  F_D0444  F_D0444F ;
 label values  F_D0445  F_D0445F ;
 label values  F_D0446  F_D0446F ;
 label values  F_D0447  F_D0447F ;
 label values  F_D0448  F_D0448F ;
 label values  F_D0450  F_D0450F ;
 label values  F_D0451  F_D0451F ;
 label values  F_D0452  F_D0452F ;
 label values  F_D0453  F_D0453F ;
 label values  F_D0454  F_D0454F ;
 label values  F_D0455  F_D0455F ;
 label values  F_D0456  F_D0456F ;
 label values  F_D0457  F_D0457F ;
 label values  F_D0458  F_D0458F ;
 label values  F_D0459  F_D0459F ;
 label values  F_D0470  F_D0470F ;
 label values  F_D0471  F_D0471F ;
 label values  F_D0472  F_D0472F ;
 label values  F_D0473  F_D0473F ;
 label values  F_D0474  F_D0474F ;
 label values  F_D0475  F_D0475F ;
 label values  F_D0476  F_D0476F ;
 label values  F_D0477  F_D0477F ;
 label values  F_D0480  F_D0480F ;
 label values  F_D0481  F_D0481F ;
 label values  F_D0482  F_D0482F ;
 label values  F_D0483  F_D0483F ;
 label values  F_D0485  F_D0485F ;
 label values  F_D0486  F_D0486F ;
 label values  F_D0487  F_D0487F ;
 label values  F_D0488  F_D0488F ;
 label values  F_D0489  F_D0489F ;
 label values  F_D0500  F_D0500F ;
 label values  F_D0501  F_D0501F ;
 label values  F_D0502  F_D0502F ;
 label values  F_D0503  F_D0503F ;
 label values  F_D0504  F_D0504F ;
 label values  F_D0505  F_D0505F ;
 label values  F_D0506  F_D0506F ;
 label values  F_D0507  F_D0507F ;
 label values  F_D0508  F_D0508F ;
 label values  F_D0509  F_D0509F ;
 label values  F_D0510  F_D0510F ;
 label values  F_D0511  F_D0511F ;
 label values  F_D0512  F_D0512F ;
 label values  F_D0513  F_D0513F ;
 label values  F_D0514  F_D0514F ;
 label values  F_D0515  F_D0515F ;
 label values  F_D0516  F_D0516F ;
 label values  F_D0517  F_D0517F ;
 label values  F_D0518  F_D0518F ;
 label values  F_D0519  F_D0519F ;
 label values  F_D0520  F_D0520F ;
 label values  F_D0521  F_D0521F ;
 label values  F_D0522  F_D0522F ;
 label values  F_D0523  F_D0523F ;
 label values  F_D0524  F_D0524F ;
 label values  F_D0525  F_D0525F ;
 label values  F_D0526  F_D0526F ;
 label values  F_D0527  F_D0527F ;
 label values  F_D0540  F_D0540F ;
 label values  F_D0541  F_D0541F ;
 label values  F_D0542  F_D0542F ;
 label values  F_D0543  F_D0543F ;
 label values  F_D0544  F_D0544F ;
 label values  F_D0545  F_D0545F ;
 label values  F_D0546  F_D0546F ;
 label values  F_D0547  F_D0547F ;
 label values  F_D0548  F_D0548F ;
 label values  F_D0560  F_D0560F ;
 label values  F_D0561  F_D0561F ;
 label values  F_D0562  F_D0562F ;
 label values  F_D0563  F_D0563F ;
 label values  F_D0564  F_D0564F ;
 label values  F_D0565  F_D0565F ;
 label values  F_D0566  F_D0566F ;
 label values  F_D0567  F_D0567F ;
 label values  F_D0568  F_D0568F ;
 label values  F_D0569  F_D0569F ;
 label values  F_D0580  F_D0580F ;
 label values  F_D0581  F_D0581F ;
 label values  F_D0582  F_D0582F ;
 label values  F_D0583  F_D0583F ;
 label values  F_D0584  F_D0584F ;
 label values  F_D0585  F_D0585F ;
 label values  F_D0595  F_D0595F ;
 label values  F_D0596  F_D0596F ;
 label values  F_D5484  F_D5484F ;
 label values  F_D9001  F_D9001F ;
 label values  F_D9002  F_D9002F ;
 label values  F_D9003  F_D9003F ;
 label values  F_D9004  F_D9004F ;
 label values  NMINST_D  NMINST_DF ;
 label values  NMNTCH_D  NMNTCH_DF ;
 label values  NSLAPP_D  NSLAPP_DF ;
 label values  NUMSTATE  NUMSTATEF ;
 label values  REGION  REGIONF ;
 label values  SCDISTFL  SCDISTFLF ;
 label values  SURVEY  SURVEYF ;
 label values  URBAND12  URBAND12F ;
 
 /* Compress the data to save some space */ 
 quietly compress;
 
 /* Save dataset */ 
 
 save "$out\District11.dta", replace;

 
 
 
 
 
