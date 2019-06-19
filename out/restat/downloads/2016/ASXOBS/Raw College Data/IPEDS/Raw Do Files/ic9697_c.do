* Created: 6/13/2004 4:07:49 AM
*                                                        
* Modify the path below to point to your data file.      
* The specified subdirectory was not created on          
* your computer. You will need to do this.               
*                                                        
* The stat program must be run against the specified     
* data file. This file is specified in the program       
* and must be saved separately.                          
*                                                        
* This program does not provide tab or summarize for all 
* variables.                                             
*                                                        
* There may be missing data for some institutions due    
* to the merge used to create this file.                 
*                                                        
* This program does not include reserved values in its   
* calculations for missing values.                       
*                                                        
* You may need to adjust your memory settings depending  
* upon the number of variables and records.              
*                                                        
* The save command may need to be modified per user      
* requirements.                                          
*                                                        
* For long lists of value labels, the titles may be      
* shortened per program requirements. 
*                                                        
insheet using "../Raw Data/ic9697_c_data_stata.csv", comma clear
label data "dct_ic9697_c"
label variable unitid "unitid"
label variable finaid1 "SFA"
label variable finaid2 "SFA"
label variable finaid3 "SFA"
label variable finaid4 "SFA"
label variable finaid5 "SFA"
label variable finaid6 "SFA"
label variable finaid7 "SFA"
label variable finaid8 "SFA"
label variable finaid9 "SFA"
label variable jtpa "Job Training Partnership Act (JTPA)"
label variable rotc "Reserve Officers Training Corps (ROTC)"
label variable rotc1 "Army"
label variable rotc2 "Navy"
label variable rotc3 "Air Force"
label variable athaid "Athletic Aid to Students"
label variable athaid1 "Football"
label variable athaid2 "Basketball"
label variable athaid3 "Baseball"
label variable athaid4 "Cross country and/or track"
label variable athaid5 "Other"
label variable ftslt15 "Number of full-time staff"
label variable facpt "ALL instructional faculty are part-time"
label variable facml "ALL instructional faculty are military personnel"
label variable facrl "ALL instructional faculty contribute services"
label variable facmd "ALL instructional faculty teach medicine"
label variable pctpost "Percentage primarily in postsecondary programs"
label variable ein "Employer Identification Number"
label variable chfnm "Name of Chief Administrator"
label variable chftitle "Title of Chief Administrator"
label variable licensed "Licensed by state or local"
label variable imp1 "imp1"
label variable imp2 "imp2"
label variable imp3 "imp3"
label variable imp4 "imp4"
label variable imp5 "imp5"
label variable imp6 "imp6"
label variable imp7 "imp7"
label variable imp8 "imp8"
label variable imp9 "imp9"
label variable imp10 "imp10"
label variable imp11 "imp11"
label variable imp12 "imp12"
label variable imp13 "imp13"
label variable imp14 "imp14"
label variable imp15 "imp15"
label variable imp16 "imp16"
label variable imp17 "imp17"
label variable imp18 "imp18"
label variable imp19 "imp19"
label variable imp20 "imp20"
label variable imp21 "imp21"
label variable imp22 "imp22"
label variable imp23 "imp23"
label variable imp24 "imp24"
label variable imp25 "imp25"
label variable imp26 "imp26"
label variable imp27 "imp27"
label variable imp28 "imp28"
label variable imp29 "imp29"
label variable imp30 "imp30"
label variable imp31 "imp31"
label variable imp32 "imp32"
label variable imp33 "imp33"
label variable imp34 "imp34"
label variable imp35 "imp35"
label variable imp36 "imp36"
label variable imp37 "imp37"
label variable imp38 "imp38"
label variable imp39 "imp39"
label variable imp40 "imp40"
label variable imp41 "imp41"
label variable imp42 "imp42"
label variable imp43 "imp43"
label variable imp44 "imp44"
label variable imp45 "imp45"
label variable imp46 "imp46"
label variable imp47 "imp47"
label variable imp48 "imp48"
label variable imp49 "imp49"
label variable imp50 "imp50"
label variable imp51 "imp51"
label variable imp52 "imp52"
label variable imp53 "imp53"
label variable imp54 "imp54"
label variable imp55 "imp55"
label variable imp56 "imp56"
label variable imp57 "imp57"
label variable imp58 "imp58"
label variable imp59 "imp59"
label variable imp60 "imp60"
label variable imp61 "imp61"
label variable imp62 "imp62"
label variable imp63 "imp63"
label variable imp64 "imp64"
label variable imp65 "imp65"
label variable imp66 "imp66"
label variable imp67 "imp67"
label variable imp68 "imp68"
label variable imp69 "imp69"
label variable imp70 "imp70"
label variable imp71 "imp71"
label variable imp72 "imp72"
label variable imp73 "imp73"
label variable imp74 "imp74"
label variable imp75 "imp75"
label variable imp76 "imp76"
label variable imp77 "imp77"
label variable imp78 "imp78"
label variable imp79 "imp79"
label variable imp80 "imp80"
label variable imp81 "imp81"
label variable imp82 "imp82"
label variable imp83 "imp83"
label variable imp84 "imp84"
label variable imp85 "imp85"
label variable imp86 "imp86"
label variable imp87 "imp87"
label variable imp88 "imp88"
label variable imp89 "imp89"
label variable imp90 "imp90"
label variable imp91 "imp91"
label variable imp92 "imp92"
label variable imp93 "imp93"
label variable imp94 "imp94"
label variable imp95 "imp95"
label variable imp96 "imp96"
label variable imp97 "imp97"
label variable imp98 "imp98"
label variable imp99 "imp99"
label variable imp100 "imp100"
label variable imp101 "imp101"
label variable imp102 "imp102"
label variable imp103 "imp103"
label variable imp104 "imp104"
label define label_finaid1 -1 "No Response/Missing" 
label define label_finaid1 1 "Yes", add 
label values finaid1 label_finaid1
label define label_finaid2 -1 "No Response/Missing" 
label define label_finaid2 1 "Yes", add 
label values finaid2 label_finaid2
label define label_finaid3 -1 "No Response/Missing" 
label define label_finaid3 1 "Yes", add 
label values finaid3 label_finaid3
label define label_finaid4 -1 "No Response/Missing" 
label define label_finaid4 1 "Yes", add 
label values finaid4 label_finaid4
label define label_finaid5 -1 "No Response/Missing" 
label define label_finaid5 1 "Yes", add 
label values finaid5 label_finaid5
label define label_finaid6 -1 "No Response/Missing" 
label define label_finaid6 1 "Yes", add 
label values finaid6 label_finaid6
label define label_finaid7 -1 "No Response/Missing" 
label define label_finaid7 1 "Yes", add 
label values finaid7 label_finaid7
label define label_finaid8 -1 "No Response/Missing" 
label define label_finaid8 1 "Yes", add 
label values finaid8 label_finaid8
label define label_finaid9 -1 "No Response/Missing" 
label define label_finaid9 1 "Yes", add 
label values finaid9 label_finaid9
label define label_jtpa -1 "No Response/Missing" 
label define label_jtpa 1 "Yes", add 
label define label_jtpa 2 "No", add 
label define label_jtpa 3 "Dont know", add 
label values jtpa label_jtpa
label define label_rotc -1 "No Response/Missing" 
label define label_rotc 1 "Yes", add 
label define label_rotc 2 "No", add 
label values rotc label_rotc
label define label_rotc1 -1 "No Response/Missing" 
label define label_rotc1 1 "Yes", add 
label values rotc1 label_rotc1
label define label_rotc2 -1 "No Response/Missing" 
label define label_rotc2 1 "Yes", add 
label values rotc2 label_rotc2
label define label_rotc3 -1 "No Response/Missing" 
label define label_rotc3 1 "Yes", add 
label values rotc3 label_rotc3
label define label_athaid -1 "No Response/Missing" 
label define label_athaid 1 "Yes", add 
label define label_athaid 2 "No", add 
label values athaid label_athaid
label define label_athaid1 -1 "No Response/Missing" 
label define label_athaid1 1 "Yes", add 
label values athaid1 label_athaid1
label define label_athaid2 -1 "No Response/Missing" 
label define label_athaid2 1 "Yes", add 
label values athaid2 label_athaid2
label define label_athaid3 -1 "No Response/Missing" 
label define label_athaid3 1 "Yes", add 
label values athaid3 label_athaid3
label define label_athaid4 -1 "No Response/Missing" 
label define label_athaid4 1 "Yes", add 
label values athaid4 label_athaid4
label define label_athaid5 -1 "No Response/Missing" 
label define label_athaid5 1 "Yes", add 
label values athaid5 label_athaid5
label define label_ftslt15 -1 "No Response/Missing" 
label define label_ftslt15 1 "Less than 15", add 
label define label_ftslt15 2 "15 or more", add 
label values ftslt15 label_ftslt15
label define label_facpt -1 "No Response/Missing" 
label define label_facpt 1 "Yes", add 
label define label_facpt 2 "No", add 
label values facpt label_facpt
label define label_facml -1 "No Response/Missing" 
label define label_facml 1 "Yes", add 
label define label_facml 2 "No", add 
label values facml label_facml
label define label_facrl -1 "No Response/Missing" 
label define label_facrl 1 "Yes", add 
label define label_facrl 2 "No", add 
label values facrl label_facrl
label define label_facmd -1 "No Response/Missing" 
label define label_facmd 1 "Yes", add 
label define label_facmd 2 "No", add 
label values facmd label_facmd
label define label_licensed -1 "No Response/Missing" 
label define label_licensed 1 "Yes", add 
label define label_licensed 2 "No", add 
label values licensed label_licensed
tab finaid1
tab finaid2
tab finaid3
tab finaid4
tab finaid5
tab finaid6
tab finaid7
tab finaid8
tab finaid9
tab jtpa
tab rotc
tab rotc1
tab rotc2
tab rotc3
tab athaid
tab athaid1
tab athaid2
tab athaid3
tab athaid4
tab athaid5
tab ftslt15
tab facpt
tab facml
tab facrl
tab facmd
tab licensed
summarize pctpost
save dct_ic9697_c

