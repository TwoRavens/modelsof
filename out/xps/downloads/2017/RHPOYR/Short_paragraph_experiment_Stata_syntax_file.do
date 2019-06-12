/// This Dataverse file prensents a list of commands allowing users to replicate some of results to be published in 
/// Morin-Chassé, Alexandre. In Press. "How to survey about electoral turnout? Additional evidence." Journal of Experimental Political Science
/// The Dataverse replication file is divided in two parts. 
///   1) Replication for the Short Paragraph Experiment
///   2) Replication for the Face-Saving Response Items experiments.

///The present syntax file is for the first item of this list: "1) Replication of the Short Paragraph Experiment"

///The dataset for the 2015 Canadian election survey was downloaded from the website of the Canadian Election Study on the 3rd of March, 2017.
///This website can be accessed from the following URL: http://ces-eec.arts.ubc.ca/ . 
///I used the data file that combines all the waves conducted for this election study.

///To save space, the file included in the Dataverse includes only those variables relevant for the present study. 
///I kept the same variable labels as those that appear in the original file, making it easier to retrace which variables I used.
 
///Open the datafile named "Short paragraph experiment - Stata data file".
///Once the data file is open, run the following commands.


                                          
 ///     db                 mm     db        `7MM          
 ///    ;MM:                MM                 MM          
 ///   ,V^MM.    `7Mb,od8 mmMMmm `7MM  ,p6"bo  MM  .gP"Ya  
 ///  ,M  `MM      MM' "'   MM     MM 6M'  OO  MM ,M'   Yb 
 ///  AbmmmqMA     MM       MM     MM 8M       MM 8M"""""" 
 /// A'     VML    MM       MM     MM YM.    , MM YM.    , 
///.AMA.   .AMMA..JMML.     `Mbmo.JMML.YMbmd'.JMML.`Mbmmd' 


order  p_disab, after(p_votedlong)
order sex_r age education interest voted_2011, after (p_disab)

gen treatment=.
replace treatment=0 if p_voted!=.
replace treatment=1 if p_votedlong!=.
label def treatment  0 "control" 1 "treatment"
label val treatment treatment

gen voted=.
replace voted=p_voted if p_voted!=.
replace voted=p_votedlong if p_votedlong!=.
recode voted 3=.
recode voted 4=.
recode voted 1000=.
recode voted 2=0
label def voted  0 "No" 1 "Yes"
label val voted voted

recode p_disab 2=0 3=. 4=. 1000=.

***Main effect


/// #######                                 #####  
///    #      ##   #####  #      ######    #     # 
///    #     #  #  #    # #      #               # 
///    #    #    # #####  #      #####      #####  
///    #    ###### #    # #      #         #       
///    #    #    # #    # #      #         #       
///    #    #    # #####  ###### ######    ####### 
                                                              

tab voted treatment if p_disab==1, chi col // Disabilities: Yes
tab voted treatment if p_disab==0, chi col // Disabilities: No 
tab voted treatment, chi col  // All sample




///    ____              ___                                                                                 ___                
///   6MMMMb             `MM 68b                                                                             `MM 68b            
///  8P    Y8             MM Y89                                                                              MM Y89            
/// 6M      Mb ___  __    MM ___ ___  __     ____            ___   __ ____  __ ____     ____  ___  __     ____MM ___ ____   ___ 
/// MM      MM `MM 6MMb   MM `MM `MM 6MMb   6MMMMb         6MMMMb  `M6MMMMb `M6MMMMb   6MMMMb `MM 6MMb   6MMMMMM `MM `MM(   )P' 
/// MM      MM  MMM9 `Mb  MM  MM  MMM9 `Mb 6M'  `Mb       8M'  `Mb  MM'  `Mb MM'  `Mb 6M'  `Mb MMM9 `Mb 6M'  `MM  MM  `MM` ,P   
/// MM      MM  MM'   MM  MM  MM  MM'   MM MM    MM           ,oMM  MM    MM MM    MM MM    MM MM'   MM MM    MM  MM   `MM,P    
/// MM      MM  MM    MM  MM  MM  MM    MM MMMMMMMM       ,6MM9'MM  MM    MM MM    MM MMMMMMMM MM    MM MM    MM  MM    `MM.    
/// YM      M9  MM    MM  MM  MM  MM    MM MM             MM'   MM  MM    MM MM    MM MM       MM    MM MM    MM  MM    d`MM.   
///  8b    d8   MM    MM  MM  MM  MM    MM YM    d9       MM.  ,MM  MM.  ,M9 MM.  ,M9 YM    d9 MM    MM YM.  ,MM  MM   d' `MM.  
///   YMMMM9   _MM_  _MM__MM__MM__MM_  _MM_ YMMMM9        `YMMM9'Yb.MMYMMM9  MMYMMM9   YMMMM9 _MM_  _MM_ YMMMMMM__MM__d_  _)MM_ 
///                                                                 MM       MM                                                 
///                                                                 MM       MM                                                 
///                                                                _MM_     _MM_                                                


recode interest 1000=.
replace interest=interest-14

recode voted_2011 2=0 3=0 4=. 5=. 6=. 1000=.

gen age_cat=2015-age if age>1899
replace age_cat=0 if age_cat>=18 &age_cat<=24
replace age_cat=1 if age_cat>=25 &age_cat<=34
replace age_cat=2 if age_cat>=35 &age_cat<=44
replace age_cat=3 if age_cat>=45 &age_cat<=54
replace age_cat=4 if age_cat>=55 &age_cat<=64
replace age_cat=5 if age_cat>=65 &age_cat<=74
replace age_cat=6 if age_cat>=75
order age_cat, after(age)
label def age_cat 0 "18-24" 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75+"
label val age_cat age_cat

recode education 1000=. 13=. 12=.
gen educ_cat=.
replace educ_cat=0 if education==1
replace educ_cat=0 if education==2
replace educ_cat=0 if education==3
replace educ_cat=0 if education==4
replace educ_cat=1 if education==5
replace educ_cat=2 if education==6
replace educ_cat=2 if education==7
replace educ_cat=2 if education==8
replace educ_cat=3 if education==9
replace educ_cat=3 if education==10
replace educ_cat=3 if education==11
order educ_cat, after(education)
label def educ_cat 0 "Less than HS" 1 "High School" 2"Some College" 3 "Univ. Degree"
label val educ_cat educ_cat




/// #######                                   #     #####  
///    #      ##   #####  #      ######      # #   #     # 
///    #     #  #  #    # #      #          #   #        # 
///    #    #    # #####  #      #####     #     #  #####  
///    #    ###### #    # #      #         ####### #       
///    #    #    # #    # #      #         #     # #       
///    #    #    # #####  ###### ######    #     # ####### 
	
tab sex_r treatment if voted!=.  & sex_r<3, col chi
tab age_cat treatment if voted!=. , col chi
tab educ_cat treatment if voted!=. , col chi
oneway interest treatment if voted!=., t
mean interest if treatment!=. & voted!=.
tab voted_2011 treatment if voted!=. , col chi

/// #######                                   #     #####  
///    #      ##   #####  #      ######      # #   #     # 
///    #     #  #  #    # #      #          #   #        # 
///    #    #    # #####  #      #####     #     #  #####  
///    #    ###### #    # #      #         #######       # 
///    #    #    # #    # #      #         #     # #     # 
///    #    #    # #####  ###### ######    #     #  #####  

logit voted i.treatment c.interest c.educ_cat /// Direct effects
c.age_cat  i.voted_2011 i.p_disab

logit voted i.treatment c.interest c.educ_cat c.age_cat i.voted_2011 i.p_disab /// Interaction effects
i.treatment#c.interest i.treatment#c.educ_cat i.treatment#c.age_cat /// 
i.treatment#i.voted_2011 i.treatment#i.p_disab


