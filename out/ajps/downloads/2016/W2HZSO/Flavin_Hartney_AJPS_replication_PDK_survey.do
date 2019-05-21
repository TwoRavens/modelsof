*USER NOTE: This .do file lists syntax for replicating the analysis of the Phi Delta Kappa and Gallup poll 
*USER NOTE: Full questionnaire from the survey is provided with the replication materials

*Title: PDK/Gallup Poll # 2001-PDK: 33rd Annual Survey of the Public's Attitudes Toward the Public Schools
*Survey Organization: Gallup Organization
*Field Dates: May 23-June 6, 2001
*Sample: National adult with an oversample of parents
*Sample Size: 1,108
*Interview method: Telephone

use "Flavin_Hartney_AJPS_replication_PDK_survey.dta", clear

*Does respondent accurately identify that Black/Hispanic students, on average, do worse than white students? (1=Yes, 0=No)
tab gap
tab gap if blklatino==0
tab gap if blklatino==1

*Is closing the achievement gap important? (1=Very or Somewhat important, 0=Not too important or Not important at all)
tab important if gap==1

*What is the cause of the achievement gap? (1=Schools, 0=Other factors)
tab gapcause if gap==1 & important==1

*Are schools responsible for fixing the achivement gap? (1=Yes, 0=No)
tab schoolsresponsible if gap==1 & important==1 & gapcause==1
