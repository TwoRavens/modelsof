
*/ 
*/
*/ 
*/
*/
*/
*/
*/
*/ First, I code all dependent variables, including pre-treatment (when available) and post-treatment estimates

*/ 
*/
*/ Dependent Variables #1A and #1B: Accuracy of Left-Right Candidate Evaluations (Expert and Survey Average)

*/ 
*/
*/ First, Coding distance scores for the pre-election survey

*/ Summary statistics for sample reported positions of 25 candiates on 11-point left-right scale
sum pre_sf_mayor_libcon1 pre_sf_mayor_libcon2 pre_sf_mayor_libcon3 pre_sf_mayor_libcon4 pre_sf_mayor_libcon5 pre_sf_mayor_libcon6 pre_sf_mayor_libcon7 pre_sf_mayor_libcon8 pre_sf_mayor_libcon9 pre_sf_mayor_libcon10 pre_sf_mayor_libcon11 pre_sf_mayor_libcon12 pre_sf_mayor_libcon13 pre_sf_mayor_libcon14 pre_sf_mayor_libcon15 pre_sf_mayor_libcon16 pre_sf_sheriff_libcon1 pre_sf_sheriff_libcon2 pre_sf_sheriff_libcon3 pre_sf_sheriff_libcon4 pre_sf_da_libcon1 pre_sf_da_libcon2 pre_sf_da_libcon3 pre_sf_da_libcon4 pre_sf_da_libcon5

*/ Generating new variables indicating average left-right position of all 25 candidates, based on survey sample report
gen pre_s_mayor1_avg = 3.861111
gen pre_s_mayor2_avg = 4.899408
gen pre_s_mayor3_avg = 3.606061
gen pre_s_mayor4_avg = 2.886905
gen pre_s_mayor5_avg = 3.91358 
gen pre_s_mayor6_avg = 4.512048
gen pre_s_mayor7_avg = 4.742857
gen pre_s_mayor8_avg = 3.491124
gen pre_s_mayor9_avg = 5.06383
gen pre_s_mayor10_avg = 4.07
gen pre_s_mayor11_avg = 4.043478
gen pre_s_mayor12_avg = 4.608163 
gen pre_s_mayor13_avg = 4.987805 
gen pre_s_mayor14_avg = 5.090164
gen pre_s_mayor15_avg = 4.894737
gen pre_s_mayor16_avg = 4.727273
gen pre_s_sheriff1_avg = 4.615385
gen pre_s_sheriff2_avg = 2.976471 
gen pre_s_sheriff3_avg = 4.679389
gen pre_s_sheriff4_avg = 5.018182
gen pre_s_da1_avg = 4.192661
gen pre_s_da2_avg = 4.535714
gen pre_s_da3_avg = 4.825301 
gen pre_s_da4_avg = 4.245455 
gen pre_s_da5_avg = 4.955056

*/ Generating new variable for absolute distance between respondent's left-right placement of each candidate and the survey average placement
gen pre_s_mayor1_distb = abs(pre_s_mayor1_avg - pre_sf_mayor_libcon1) 
gen pre_s_mayor2_distb = abs(pre_s_mayor2_avg - pre_sf_mayor_libcon2) 
gen pre_s_mayor3_distb = abs(pre_s_mayor3_avg - pre_sf_mayor_libcon3) 
gen pre_s_mayor4_distb = abs(pre_s_mayor4_avg - pre_sf_mayor_libcon4) 
gen pre_s_mayor5_distb = abs(pre_s_mayor5_avg - pre_sf_mayor_libcon5) 
gen pre_s_mayor6_distb = abs(pre_s_mayor6_avg - pre_sf_mayor_libcon6) 
gen pre_s_mayor7_distb = abs(pre_s_mayor7_avg - pre_sf_mayor_libcon7) 
gen pre_s_mayor8_distb = abs(pre_s_mayor8_avg - pre_sf_mayor_libcon8) 
gen pre_s_mayor9_distb = abs(pre_s_mayor9_avg - pre_sf_mayor_libcon9) 
gen pre_s_mayor10_distb = abs(pre_s_mayor10_avg - pre_sf_mayor_libcon10) 
gen pre_s_mayor11_distb = abs(pre_s_mayor11_avg - pre_sf_mayor_libcon11) 
gen pre_s_mayor12_distb = abs(pre_s_mayor12_avg - pre_sf_mayor_libcon12) 
gen pre_s_mayor13_distb = abs(pre_s_mayor13_avg - pre_sf_mayor_libcon13) 
gen pre_s_mayor14_distb = abs(pre_s_mayor14_avg - pre_sf_mayor_libcon14) 
gen pre_s_mayor15_distb = abs(pre_s_mayor15_avg - pre_sf_mayor_libcon15) 
gen pre_s_mayor16_distb = abs(pre_s_mayor16_avg - pre_sf_mayor_libcon16) 
gen pre_s_sheriff1_distb = abs(pre_s_sheriff1_avg - pre_sf_sheriff_libcon1) 
gen pre_s_sheriff2_distb = abs(pre_s_sheriff2_avg - pre_sf_sheriff_libcon2) 
gen pre_s_sheriff3_distb = abs(pre_s_sheriff3_avg - pre_sf_sheriff_libcon3) 
gen pre_s_sheriff4_distb = abs(pre_s_sheriff4_avg - pre_sf_sheriff_libcon4) 
gen pre_s_da1_distb = abs(pre_s_da1_avg - pre_sf_da_libcon1) 
gen pre_s_da2_distb = abs(pre_s_da2_avg - pre_sf_da_libcon2) 
gen pre_s_da3_distb = abs(pre_s_da3_avg - pre_sf_da_libcon3) 
gen pre_s_da4_distb = abs(pre_s_da4_avg - pre_sf_da_libcon4) 
gen pre_s_da5_distb = abs(pre_s_da5_avg - pre_sf_da_libcon5) 

*/ Summary statistics for absolute distance b/w respondent LRS evaluation and sample average LRS evaluation
sum pre_s_mayor1_distb pre_s_mayor2_distb pre_s_mayor3_distb pre_s_mayor4_distb pre_s_mayor5_distb pre_s_mayor6_distb pre_s_mayor7_distb pre_s_mayor8_distb pre_s_mayor9_distb pre_s_mayor10_distb pre_s_mayor11_distb pre_s_mayor12_distb pre_s_mayor13_distb pre_s_mayor14_distb pre_s_mayor15_distb pre_s_mayor16_distb pre_s_sheriff1_distb pre_s_sheriff2_distb pre_s_sheriff3_distb pre_s_sheriff4_distb pre_s_da1_distb pre_s_da2_distb pre_s_da3_distb pre_s_da4_distb pre_s_da5_distb

*/ Replacing "don't know" responses with the maximum error made by subjects who provided evaluation
replace pre_s_mayor1_distb = 6.138889 if pre_s_mayor1_distb == .
replace pre_s_mayor2_distb = 5.100592  if pre_s_mayor2_distb == .
replace pre_s_mayor3_distb = 5.393939  if pre_s_mayor3_distb == .
replace pre_s_mayor4_distb = 7.113095  if pre_s_mayor4_distb == .
replace pre_s_mayor5_distb = 6.08642  if pre_s_mayor5_distb == .
replace pre_s_mayor6_distb = 5.487952  if pre_s_mayor6_distb == .
replace pre_s_mayor7_distb = 5.257143  if pre_s_mayor7_distb == .
replace pre_s_mayor8_distb = 6.508876  if pre_s_mayor8_distb == .
replace pre_s_mayor9_distb = 5.06383  if pre_s_mayor9_distb == .
replace pre_s_mayor10_distb = 5.93  if pre_s_mayor10_distb == .
replace pre_s_mayor11_distb = 5.956522  if pre_s_mayor11_distb == .
replace pre_s_mayor12_distb = 5.391837  if pre_s_mayor12_distb == .
replace pre_s_mayor13_distb = 5.012195  if pre_s_mayor13_distb == .
replace pre_s_mayor14_distb = 5.090164  if pre_s_mayor14_distb == .
replace pre_s_mayor15_distb = 5.105263  if pre_s_mayor15_distb == .
replace pre_s_mayor16_distb = 5.272727  if pre_s_mayor16_distb == .
replace pre_s_sheriff1_distb = 5.384615  if pre_s_sheriff1_distb == .
replace pre_s_sheriff2_distb = 7.023529  if pre_s_sheriff2_distb == .
replace pre_s_sheriff3_distb = 5.320611  if pre_s_sheriff3_distb == .
replace pre_s_sheriff4_distb = 5.018182  if pre_s_sheriff4_distb == .
replace pre_s_da1_distb =  4.807339  if pre_s_da1_distb == .
replace pre_s_da2_distb =  5.464286  if pre_s_da2_distb == .
replace pre_s_da3_distb =  5.174699  if pre_s_da3_distb == .
replace pre_s_da4_distb =  4.754545  if pre_s_da4_distb == .
replace pre_s_da5_distb =  5.044944  if pre_s_da5_distb == .

*/ Generating new variable for absolute distance between respondent's left-right placement of each candidate and the expert average placement
gen pre_e_mayor1_distb = abs(emayor1 - pre_sf_mayor_libcon1) 
gen pre_e_mayor2_distb = abs(emayor2 - pre_sf_mayor_libcon2) 
gen pre_e_mayor3_distb = abs(emayor3 - pre_sf_mayor_libcon3) 
gen pre_e_mayor4_distb = abs(emayor4 - pre_sf_mayor_libcon4) 
gen pre_e_mayor5_distb = abs(emayor5 - pre_sf_mayor_libcon5) 
gen pre_e_mayor6_distb = abs(emayor6 - pre_sf_mayor_libcon6) 
gen pre_e_mayor7_distb = abs(emayor7 - pre_sf_mayor_libcon7) 
gen pre_e_mayor8_distb = abs(emayor8 - pre_sf_mayor_libcon8) 
gen pre_e_mayor9_distb = abs(emayor9 - pre_sf_mayor_libcon9) 
gen pre_e_mayor10_distb = abs(emayor10 - pre_sf_mayor_libcon10) 
gen pre_e_mayor11_distb = abs(emayor11 - pre_sf_mayor_libcon11) 
gen pre_e_mayor12_distb = abs(emayor12 - pre_sf_mayor_libcon12) 
gen pre_e_mayor13_distb = abs(emayor13 - pre_sf_mayor_libcon13) 
gen pre_e_mayor14_distb = abs(emayor14 - pre_sf_mayor_libcon14) 
gen pre_e_mayor15_distb = abs(emayor15 - pre_sf_mayor_libcon15) 
gen pre_e_mayor16_distb = abs(emayor16 - pre_sf_mayor_libcon16) 
gen pre_e_sheriff1_distb = abs(esheriff1 - pre_sf_sheriff_libcon1) 
gen pre_e_sheriff2_distb = abs(esheriff2 - pre_sf_sheriff_libcon2) 
gen pre_e_sheriff3_distb = abs(esheriff3 - pre_sf_sheriff_libcon3) 
gen pre_e_sheriff4_distb = abs(esheriff4 - pre_sf_sheriff_libcon4) 
gen pre_e_da1_distb = abs(eda1 - pre_sf_da_libcon1) 
gen pre_e_da2_distb = abs(eda2 - pre_sf_da_libcon2) 
gen pre_e_da3_distb = abs(eda3 - pre_sf_da_libcon3) 
gen pre_e_da4_distb = abs(eda4 - pre_sf_da_libcon4) 
gen pre_e_da5_distb = abs(eda5 - pre_sf_da_libcon5) 

*/ Summary statistics for absolute distance b/w respondent LRS evaluation and expert average LRS evaluation
sum pre_e_mayor1_distb pre_e_mayor2_distb pre_e_mayor3_distb pre_e_mayor4_distb pre_e_mayor5_distb pre_e_mayor6_distb pre_e_mayor7_distb pre_e_mayor8_distb pre_e_mayor9_distb pre_e_mayor10_distb pre_e_mayor11_distb pre_e_mayor12_distb pre_e_mayor13_distb pre_e_mayor14_distb pre_e_mayor15_distb pre_e_mayor16_distb pre_e_sheriff1_distb pre_e_sheriff2_distb pre_e_sheriff3_distb pre_e_sheriff4_distb pre_e_da1_distb pre_e_da2_distb pre_e_da3_distb pre_e_da4_distb pre_e_da5_distb

*/ Replacing "don't know" responses with the maximum error made by subjects who provided evaluation
replace pre_e_mayor1_distb =   6.44444  if pre_e_mayor1_distb == .
replace pre_e_mayor2_distb =    5.625    if pre_e_mayor2_distb == .
replace pre_e_mayor3_distb =   4.66667    if pre_e_mayor3_distb == .
replace pre_e_mayor4_distb =   9.111111    if pre_e_mayor4_distb == .
replace pre_e_mayor5_distb =   9.857143    if pre_e_mayor5_distb == .
replace pre_e_mayor6_distb =   6.66667    if pre_e_mayor6_distb == .
replace pre_e_mayor7_distb =    7    if pre_e_mayor7_distb == .
replace pre_e_mayor8_distb =   6.22222    if pre_e_mayor8_distb == .
replace pre_e_mayor9_distb =   7.125    if pre_e_mayor9_distb == .
replace pre_e_mayor10_distb =   6.88889    if pre_e_mayor10_distb == .
replace pre_e_mayor11_distb =    6    if pre_e_mayor11_distb == .
replace pre_e_mayor12_distb =   5.66667    if pre_e_mayor12_distb == .
replace pre_e_mayor13_distb =    7    if pre_e_mayor13_distb == .
replace pre_e_mayor14_distb =   5.33333    if pre_e_mayor14_distb == .
replace pre_e_mayor15_distb =   6.375    if pre_e_mayor15_distb == .
replace pre_e_mayor16_distb =   6    if pre_e_mayor16_distb == .
replace pre_e_sheriff1_distb =    5.16667    if pre_e_sheriff1_distb == .
replace pre_e_sheriff2_distb =   8.66667    if pre_e_sheriff2_distb == .
replace pre_e_sheriff3_distb =    5    if pre_e_sheriff3_distb == .
replace pre_e_sheriff4_distb =    5.5    if pre_e_sheriff4_distb == .
replace pre_e_da1_distb =    4.57143    if pre_e_da1_distb == .
replace pre_e_da2_distb =    5.85714    if pre_e_da2_distb == .
replace pre_e_da3_distb =    5.44445    if pre_e_da3_distb == .
replace pre_e_da4_distb =    6.85714    if pre_e_da4_distb == .
*/ Note: None of the experts offered an evaluation of DA Candidate #5, so this observation is missing for all subjects

*/ Generating new variable for total distance across all 25 candidates
gen pre_e_total_dist = pre_e_mayor1_distb + pre_e_mayor2_distb   + pre_e_mayor3_distb   + pre_e_mayor4_distb   + pre_e_mayor5_distb   + pre_e_mayor6_distb   + pre_e_mayor7_distb   + pre_e_mayor8_distb   + pre_e_mayor9_distb   + pre_e_mayor10_distb   + pre_e_mayor11_distb   + pre_e_mayor12_distb   + pre_e_mayor13_distb   + pre_e_mayor14_distb   + pre_e_mayor15_distb   + pre_e_mayor16_distb   + pre_e_sheriff1_distb   + pre_e_sheriff2_distb   + pre_e_sheriff3_distb   + pre_e_sheriff4_distb   + pre_e_da1_distb    + pre_e_da2_distb  + pre_e_da3_distb  + pre_e_da4_distb  
gen pre_s_total_dist = pre_s_mayor1_distb + pre_s_mayor2_distb   + pre_s_mayor3_distb   + pre_s_mayor4_distb   + pre_s_mayor5_distb   + pre_s_mayor6_distb   + pre_s_mayor7_distb   + pre_s_mayor8_distb   + pre_s_mayor9_distb   + pre_s_mayor10_distb   + pre_s_mayor11_distb   + pre_s_mayor12_distb   + pre_s_mayor13_distb   + pre_s_mayor14_distb   + pre_s_mayor15_distb   + pre_s_mayor16_distb   + pre_s_sheriff1_distb   + pre_s_sheriff2_distb   + pre_s_sheriff3_distb   + pre_s_sheriff4_distb   + pre_s_da1_distb    + pre_s_da2_distb  + pre_s_da3_distb  + pre_s_da4_distb  

*/ Generating new variable for total distance from expert average, re-scaled from 0 - 100, with 100 being more accurate responses
*/ First, multiplying by (-1) so larger numbers mean less distance
*/ Then, re-scaling so (0) is the minimum value, and (100) is the maximum value
gen pre_e_total_dist_inverted = pre_e_total_dist * -1
egen max_pre_e_total_dist_inverted = max(pre_e_total_dist_inverted)
egen min_pre_e_total_dist_inverted = min(pre_e_total_dist_inverted)
gen pre_e_total_dist_100 = (pre_e_total_dist_inverted - min_pre_e_total_dist_inverted) * (100 / ( max_pre_e_total_dist_inverted - min_pre_e_total_dist_inverted) )

*/ Generating new variable for total distance from survey average, re-scaled from 0 - 100, with 100 being more accurate responses
*/ First, multiplying by (-1) so larger numbers mean less distance
gen pre_s_total_dist_inverted = pre_s_total_dist * -1
egen max_pre_s_total_dist_inverted = max(pre_s_total_dist_inverted)
egen min_pre_s_total_dist_inverted = min(pre_s_total_dist_inverted)
gen pre_s_total_dist_100 = (pre_s_total_dist_inverted - min_pre_s_total_dist_inverted) * (100 / ( max_pre_s_total_dist_inverted - min_pre_s_total_dist_inverted) )

*/ 
*/
*/ Now, Coding distance scores for the post-election survey

*/ Summary statistics for sample reported positions of 25 candiates on 11-point left-right scale
sum sf_mayor_libcon1 sf_mayor_libcon2 sf_mayor_libcon3 sf_mayor_libcon4 sf_mayor_libcon5 sf_mayor_libcon6 sf_mayor_libcon7 sf_mayor_libcon8 sf_mayor_libcon9 sf_mayor_libcon10 sf_mayor_libcon11 sf_mayor_libcon13 sf_mayor_libcon12 sf_mayor_libcon14 sf_mayor_libcon15 sf_mayor_libcon16   sf_sheriff_libcon1  sf_sheriff_libcon2   sf_sheriff_libcon3  sf_sheriff_libcon4  sf_da_libcon1 sf_da_libcon2 sf_da_libcon3 sf_da_libcon4 sf_da_libcon5 

*/ Generating new variables indicating average left-right position of all 25 candidates, based on survey sample report
gen s_mayor1_avg = 3.956938    
gen s_mayor2_avg = 4.96875    
gen s_mayor3_avg = 4.222222   
gen s_mayor4_avg = 2.929461   
gen s_mayor5_avg = 3.096296    
gen s_mayor6_avg = 4.441026    
gen s_mayor7_avg = 4.489362   
gen s_mayor8_avg = 3.586022   
gen s_mayor9_avg = 5.625   
gen s_mayor10_avg = 4.107981    
gen s_mayor11_avg = 4.637363   
gen s_mayor12_avg = 4.578431    
gen s_mayor13_avg = 4.789683     
gen s_mayor14_avg = 5.035211   
gen s_mayor15_avg = 4.804348    
gen s_mayor16_avg = 4.38914    
gen s_sheriff1_avg = 4.804469    
gen s_sheriff2_avg = 3.354839        
gen s_sheriff3_avg = 4.755556    
gen s_sheriff4_avg = 4.953125    
gen s_da1_avg = 4.262857    
gen s_da2_avg = 4.787356   
gen s_da3_avg = 5.266667    
gen s_da4_avg = 3.925926     
gen s_da5_avg = 4.558824   

*/ Generating new variable for absolute distance between respondent's left-right placement of each candidate and the survey average placement
gen s_mayor1_distb = abs(s_mayor1_avg - sf_mayor_libcon1) 
gen s_mayor2_distb = abs(s_mayor2_avg - sf_mayor_libcon2) 
gen s_mayor3_distb = abs(s_mayor3_avg - sf_mayor_libcon3) 
gen s_mayor4_distb = abs(s_mayor4_avg - sf_mayor_libcon4) 
gen s_mayor5_distb = abs(s_mayor5_avg - sf_mayor_libcon5) 
gen s_mayor6_distb = abs(s_mayor6_avg - sf_mayor_libcon6) 
gen s_mayor7_distb = abs(s_mayor7_avg - sf_mayor_libcon7) 
gen s_mayor8_distb = abs(s_mayor8_avg - sf_mayor_libcon8) 
gen s_mayor9_distb = abs(s_mayor9_avg - sf_mayor_libcon9) 
gen s_mayor10_distb = abs(s_mayor10_avg - sf_mayor_libcon10) 
gen s_mayor11_distb = abs(s_mayor11_avg - sf_mayor_libcon11) 
gen s_mayor12_distb = abs(s_mayor12_avg - sf_mayor_libcon12) 
gen s_mayor13_distb = abs(s_mayor13_avg - sf_mayor_libcon13) 
gen s_mayor14_distb = abs(s_mayor14_avg - sf_mayor_libcon14) 
gen s_mayor15_distb = abs(s_mayor15_avg - sf_mayor_libcon15) 
gen s_mayor16_distb = abs(s_mayor16_avg - sf_mayor_libcon16) 
gen s_sheriff1_distb = abs(s_sheriff1_avg - sf_sheriff_libcon1) 
gen s_sheriff2_distb = abs(s_sheriff2_avg - sf_sheriff_libcon2) 
gen s_sheriff3_distb = abs(s_sheriff3_avg - sf_sheriff_libcon3) 
gen s_sheriff4_distb = abs(s_sheriff4_avg - sf_sheriff_libcon4) 
gen s_da1_distb = abs(s_da1_avg - sf_da_libcon1) 
gen s_da2_distb = abs(s_da2_avg - sf_da_libcon2) 
gen s_da3_distb = abs(s_da3_avg - sf_da_libcon3) 
gen s_da4_distb = abs(s_da4_avg - sf_da_libcon4) 
gen s_da5_distb = abs(s_da5_avg - sf_da_libcon5) 

*/ Summary statistics for absolute distance b/w respondent LRS evaluation and sample average LRS evaluation
sum s_mayor1_distb s_mayor2_distb s_mayor3_distb s_mayor4_distb s_mayor5_distb s_mayor6_distb s_mayor7_distb s_mayor8_distb s_mayor9_distb s_mayor10_distb s_mayor11_distb s_mayor12_distb s_mayor13_distb s_mayor14_distb s_mayor15_distb s_mayor16_distb s_sheriff1_distb s_sheriff2_distb s_sheriff3_distb s_sheriff4_distb s_da1_distb s_da2_distb s_da3_distb s_da4_distb s_da5_distb

*/ Replacing "don't know" responses with the maximum error made by subjects who provided evaluation
replace s_mayor1_distb = 6.043062   if s_mayor1_distb == .
replace s_mayor2_distb = 5.03125    if s_mayor2_distb == .
replace s_mayor3_distb = 5.777778    if s_mayor3_distb == .
replace s_mayor4_distb = 7.070539    if s_mayor4_distb == .
replace s_mayor5_distb = 6.903704    if s_mayor5_distb == .
replace s_mayor6_distb = 5.558974    if s_mayor6_distb == .
replace s_mayor7_distb = 5.510638    if s_mayor7_distb == .
replace s_mayor8_distb = 6.413978    if s_mayor8_distb == .
replace s_mayor9_distb = 5.625    if s_mayor9_distb == .
replace s_mayor10_distb = 5.892019    if s_mayor10_distb == .
replace s_mayor11_distb = 5.362637    if s_mayor11_distb == .
replace s_mayor12_distb = 5.421569    if s_mayor12_distb == .
replace s_mayor13_distb = 5.210317    if s_mayor13_distb == .
replace s_mayor14_distb = 5.035211    if s_mayor14_distb == .
replace s_mayor15_distb = 5.195652    if s_mayor15_distb == .
replace s_mayor16_distb = 5.61086    if s_mayor16_distb == .
replace s_sheriff1_distb = 5.195531    if s_sheriff1_distb == .
replace s_sheriff2_distb = 6.645161    if s_sheriff2_distb == .
replace s_sheriff3_distb = 5.244444    if s_sheriff3_distb == .
replace s_sheriff4_distb = 5.046875    if s_sheriff4_distb == .
replace s_da1_distb = 5.737143    if s_da1_distb == .
replace s_da2_distb = 5.212644    if s_da2_distb == .
replace s_da3_distb = 5.266667    if s_da3_distb == .
replace s_da4_distb = 6.074074    if s_da4_distb == .
replace s_da5_distb = 5.441176    if s_da5_distb == .

*/ Generating new variable for absolute distance between respondent's left-right placement of each candidate and the expert average placement
gen e_mayor1_distb = abs(emayor1 - sf_mayor_libcon1) 
gen e_mayor2_distb = abs(emayor2 - sf_mayor_libcon2) 
gen e_mayor3_distb = abs(emayor3 - sf_mayor_libcon3) 
gen e_mayor4_distb = abs(emayor4 - sf_mayor_libcon4) 
gen e_mayor5_distb = abs(emayor5 - sf_mayor_libcon5) 
gen e_mayor6_distb = abs(emayor6 - sf_mayor_libcon6) 
gen e_mayor7_distb = abs(emayor7 - sf_mayor_libcon7) 
gen e_mayor8_distb = abs(emayor8 - sf_mayor_libcon8) 
gen e_mayor9_distb = abs(emayor9 - sf_mayor_libcon9) 
gen e_mayor10_distb = abs(emayor10 - sf_mayor_libcon10) 
gen e_mayor11_distb = abs(emayor11 - sf_mayor_libcon11) 
gen e_mayor12_distb = abs(emayor12 - sf_mayor_libcon12) 
gen e_mayor13_distb = abs(emayor13 - sf_mayor_libcon13) 
gen e_mayor14_distb = abs(emayor14 - sf_mayor_libcon14) 
gen e_mayor15_distb = abs(emayor15 - sf_mayor_libcon15) 
gen e_mayor16_distb = abs(emayor16 - sf_mayor_libcon16) 
gen e_sheriff1_distb = abs(esheriff1 - sf_sheriff_libcon1) 
gen e_sheriff2_distb = abs(esheriff2 - sf_sheriff_libcon2) 
gen e_sheriff3_distb = abs(esheriff3 - sf_sheriff_libcon3) 
gen e_sheriff4_distb = abs(esheriff4 - sf_sheriff_libcon4) 
gen e_da1_distb = abs(eda1 - sf_da_libcon1) 
gen e_da2_distb = abs(eda2 - sf_da_libcon2) 
gen e_da3_distb = abs(eda3 - sf_da_libcon3) 
gen e_da4_distb = abs(eda4 - sf_da_libcon4) 
gen e_da5_distb = abs(eda5 - sf_da_libcon5) 

*/ Summary statistics for absolute distance b/w respondent LRS evaluation and expert average LRS evaluation
sum e_mayor1_distb e_mayor2_distb e_mayor3_distb e_mayor4_distb e_mayor5_distb e_mayor6_distb e_mayor7_distb e_mayor8_distb e_mayor9_distb e_mayor10_distb e_mayor11_distb e_mayor12_distb e_mayor13_distb e_mayor14_distb e_mayor15_distb e_mayor16_distb e_sheriff1_distb e_sheriff2_distb e_sheriff3_distb e_sheriff4_distb e_da1_distb e_da2_distb e_da3_distb e_da4_distb e_da5_distb

*/ Replacing "don't know" responses with the maximum error made by subjects who provided evaluation
replace e_mayor1_distb = 6.44444  if e_mayor1_distb == .
replace e_mayor2_distb = 5.625 if e_mayor2_distb == .
replace e_mayor3_distb = 5.33333 if e_mayor3_distb == .
replace e_mayor4_distb = 9.111111 if e_mayor4_distb == .
replace e_mayor5_distb = 9.857143 if e_mayor5_distb == .
replace e_mayor6_distb = 6.66667 if e_mayor6_distb == .
replace e_mayor7_distb = 7 if e_mayor7_distb == .
replace e_mayor8_distb = 6.22222 if e_mayor8_distb == .
replace e_mayor9_distb = 7.125 if e_mayor9_distb == .
replace e_mayor10_distb = 6.88889 if e_mayor10_distb == .
replace e_mayor11_distb = 6 if e_mayor11_distb == .
replace e_mayor12_distb = 5.66667 if e_mayor12_distb == .
replace e_mayor13_distb = 7 if e_mayor13_distb == .
replace e_mayor14_distb = 5.33333 if e_mayor14_distb == .
replace e_mayor15_distb = 6.375 if e_mayor15_distb == .
replace e_mayor16_distb = 6 if e_mayor16_distb == .
replace e_sheriff1_distb = 5.16667 if e_sheriff1_distb == .
replace e_sheriff2_distb = 8.66667 if e_sheriff2_distb == .
replace e_sheriff3_distb = 5 if e_sheriff3_distb == .
replace e_sheriff4_distb = 5.5 if e_sheriff4_distb == .
replace e_da1_distb = 5.42857 if e_da1_distb == .
replace e_da2_distb = 5.85714 if e_da2_distb == .
replace e_da3_distb = 5.44445 if e_da3_distb == .
replace e_da4_distb = 7.85714 if e_da4_distb == .
*/ Note: None of the experts offered an evaluation of DA Candidate #5, so this observation is missing for all subjects

*/ Generating new variable for total distance across all 25 candidates
gen e_total_dist = e_mayor1_distb + e_mayor2_distb   + e_mayor3_distb   + e_mayor4_distb   + e_mayor5_distb   + e_mayor6_distb   + e_mayor7_distb   + e_mayor8_distb   + e_mayor9_distb   + e_mayor10_distb   + e_mayor11_distb   + e_mayor12_distb   + e_mayor13_distb   + e_mayor14_distb   + e_mayor15_distb   + e_mayor16_distb   + e_sheriff1_distb   + e_sheriff2_distb   + e_sheriff3_distb   + e_sheriff4_distb   + e_da1_distb    + e_da2_distb  + e_da3_distb  + e_da4_distb  
gen s_total_dist = s_mayor1_distb + s_mayor2_distb   + s_mayor3_distb   + s_mayor4_distb   + s_mayor5_distb   + s_mayor6_distb   + s_mayor7_distb   + s_mayor8_distb   + s_mayor9_distb   + s_mayor10_distb   + s_mayor11_distb   + s_mayor12_distb   + s_mayor13_distb   + s_mayor14_distb   + s_mayor15_distb   + s_mayor16_distb   + s_sheriff1_distb   + s_sheriff2_distb   + s_sheriff3_distb   + s_sheriff4_distb   + s_da1_distb    + s_da2_distb  + s_da3_distb  + s_da4_distb  + s_da5_distb

*/ Generating new variable for total distance from expert average, re-scaled from 0 - 100, with 100 being more accurate responses
*/ First, multiplying by (-1) so larger numbers mean less distance
*/ Then, re-scaling so (0) is the minimum value, and (100) is the maximum value
gen e_total_dist_inverted = e_total_dist * -1
egen max_e_total_dist_inverted = max(e_total_dist_inverted)
egen min_e_total_dist_inverted = min(e_total_dist_inverted)
gen e_total_dist_100 = (e_total_dist_inverted - min_e_total_dist_inverted) * (100 / ( max_e_total_dist_inverted - min_e_total_dist_inverted) )

*/ Generating new variable for total distance from survey average, re-scaled from 0 - 100, with 100 being more accurate responses
*/ First, multiplying by (-1) so larger numbers mean less distance
gen s_total_dist_inverted = s_total_dist * -1
egen max_s_total_dist_inverted = max(s_total_dist_inverted)
egen min_s_total_dist_inverted = min(s_total_dist_inverted)
gen s_total_dist_100 = (s_total_dist_inverted - min_s_total_dist_inverted) * (100 / ( max_s_total_dist_inverted - min_s_total_dist_inverted) )

*/ 
*/
*/ Dependent Variable #2: Knows Candidate Party Affiliation

*/ 
*/
*/ First, Coding scores for the pre-election survey

*/ Generating a new dummy variable for whether subject knew each candidate's party affiliation
gen pre_sf_mayor_party1_correct = 0
replace pre_sf_mayor_party1_correct = 1 if pre_sf_mayor_party1 == 2
gen pre_sf_mayor_party2_correct = 0
replace pre_sf_mayor_party2_correct = 1 if pre_sf_mayor_party2 == 2
gen pre_sf_mayor_party3_correct = 0
replace pre_sf_mayor_party3_correct = 1 if pre_sf_mayor_party3 == 1
gen pre_sf_mayor_party4_correct = 0
replace pre_sf_mayor_party4_correct = 1 if pre_sf_mayor_party4 == 2
gen pre_sf_mayor_party5_correct = 0
replace pre_sf_mayor_party5_correct = 1 if pre_sf_mayor_party5 == 3
gen pre_sf_mayor_party6_correct = 0
replace pre_sf_mayor_party6_correct = 1 if pre_sf_mayor_party6 == 2
gen pre_sf_mayor_party7_correct = 0
replace pre_sf_mayor_party7_correct = 1 if pre_sf_mayor_party7 == 2
gen pre_sf_mayor_party8_correct = 0
replace pre_sf_mayor_party8_correct = 1 if pre_sf_mayor_party8 == 2
gen pre_sf_mayor_party9_correct = 0
replace pre_sf_mayor_party9_correct = 1 if pre_sf_mayor_party9 == 5
gen pre_sf_mayor_party10_correct = 0
replace pre_sf_mayor_party10_correct = 1 if pre_sf_mayor_party10 == 2
gen pre_sf_mayor_party12_correct = 0
replace pre_sf_mayor_party12_correct = 1 if pre_sf_mayor_party12 == 2
gen pre_sf_mayor_party13_correct = 0
replace pre_sf_mayor_party13_correct = 1 if pre_sf_mayor_party13 == 1
gen pre_sf_mayor_party14_correct = 0
replace pre_sf_mayor_party14_correct = 1 if pre_sf_mayor_party14 == 5
gen pre_sf_mayor_party15_correct = 0
replace pre_sf_mayor_party15_correct = 1 if pre_sf_mayor_party15 == 2
gen pre_sf_mayor_party16_correct = 0
replace pre_sf_mayor_party16_correct = 1 if pre_sf_mayor_party16 == 2

*/ Combining all dummy variables to generate an index score for recognition of party affiliations
gen pre_sf_mayor_party_total = pre_sf_mayor_party1_correct+ pre_sf_mayor_party2_correct+ pre_sf_mayor_party3_correct +pre_sf_mayor_party4_correct+ pre_sf_mayor_party5_correct+ pre_sf_mayor_party6_correct +pre_sf_mayor_party7_correct +pre_sf_mayor_party8_correct+ pre_sf_mayor_party9_correct +pre_sf_mayor_party10_correct +pre_sf_mayor_party12_correct+ pre_sf_mayor_party13_correct +pre_sf_mayor_party14_correct +pre_sf_mayor_party15_correct+ pre_sf_mayor_party16_correct
gen pre_sf_mayor_party_100 = pre_sf_mayor_party_total * 100/15

*/ 
*/
*/ Now, Coding scores for the post-election survey

*/ Generating a new dummy variable for whether subject knew each candidate's party affiliation
gen sf_mayor_party1_correct = 0
replace sf_mayor_party1_correct = 1 if sf_mayor_party1 == 2
gen sf_mayor_party2_correct = 0
replace sf_mayor_party2_correct = 1 if sf_mayor_party2 == 2
gen sf_mayor_party3_correct = 0
replace sf_mayor_party3_correct = 1 if sf_mayor_party3 == 1
gen sf_mayor_party4_correct = 0
replace sf_mayor_party4_correct = 1 if sf_mayor_party4 == 2
gen sf_mayor_party5_correct = 0
replace sf_mayor_party5_correct = 1 if sf_mayor_party5 == 3
gen sf_mayor_party6_correct = 0
replace sf_mayor_party6_correct = 1 if sf_mayor_party6 == 2
gen sf_mayor_party7_correct = 0
replace sf_mayor_party7_correct = 1 if sf_mayor_party7 == 2
gen sf_mayor_party8_correct = 0
replace sf_mayor_party8_correct = 1 if sf_mayor_party8 == 2
gen sf_mayor_party9_correct = 0
replace sf_mayor_party9_correct = 1 if sf_mayor_party9 == 5
gen sf_mayor_party10_correct = 0
replace sf_mayor_party10_correct = 1 if sf_mayor_party10 == 2
gen sf_mayor_party12_correct = 0
replace sf_mayor_party12_correct = 1 if sf_mayor_party12 == 2
gen sf_mayor_party13_correct = 0
replace sf_mayor_party13_correct = 1 if sf_mayor_party13 == 1
gen sf_mayor_party14_correct = 0
replace sf_mayor_party14_correct = 1 if sf_mayor_party14 == 5
gen sf_mayor_party15_correct = 0
replace sf_mayor_party15_correct = 1 if sf_mayor_party15 == 2
gen sf_mayor_party16_correct = 0
replace sf_mayor_party16_correct = 1 if sf_mayor_party16 == 2

*/ Combining all dummy variables to generate an index score for recognition of party affiliations
gen sf_mayor_party_total = sf_mayor_party1_correct +sf_mayor_party2_correct+ sf_mayor_party3_correct +sf_mayor_party4_correct +sf_mayor_party5_correct +sf_mayor_party6_correct+ sf_mayor_party7_correct +sf_mayor_party8_correct +sf_mayor_party9_correct +sf_mayor_party10_correct +sf_mayor_party12_correct +sf_mayor_party13_correct +sf_mayor_party14_correct +sf_mayor_party15_correct +sf_mayor_party16_correct
gen sf_mayor_party_100 = sf_mayor_party_total * 100/15

*/ 
*/
*/ Dependent Variables #3A and #3B: Knows Democratic Party Endorsements (Mayor and All Contests)

*/ 
*/
*/ First, Coding scores for the pre-election survey

*/ Generating new dummy variable for whether subject knew Democratic Party endorsements in each race
*/ Coded as 1 if knew either endorsement (when Dem nominated 2); Coded as 0 if subject SK or named any non-endorsed candidate
gen pre_knew_dem_endorse_mayor = 0
replace pre_knew_dem_endorse_mayor = 1 if pre_sf_mayor_demendorsed == 3
replace pre_knew_dem_endorse_mayor = 1 if pre_sf_mayor_demendorsed == 4
replace pre_knew_dem_endorse_mayor = 1 if pre_sf_mayor_demendorsed == 34
gen pre_knew_dem_endorse_sheriff = 0
replace pre_knew_dem_endorse_sheriff = 1 if pre_sf_sheriff_demendorse == 2
gen pre_knew_dem_endorse_da = 0
replace pre_knew_dem_endorse_da = 1 if pre_sf_da_demendorse == 1
replace pre_knew_dem_endorse_da = 1 if pre_sf_da_demendorse == 4

*/ Adding dummy variables into an index across all three contests
gen pre_knew_dem_endorse_index = pre_knew_dem_endorse_mayor + pre_knew_dem_endorse_da + pre_knew_dem_endorse_sheriff

*/ Generating DV's that scale from a minimum of (0) and maximum of (100)
gen pre_knew_dem_endorse_100 = pre_knew_dem_endorse_index * 100/3
gen pre_knew_endorse_mayor_100 =  pre_knew_dem_endorse_mayor*100

*/ 
*/
*/ Now, Coding scores for the post-election survey

*/ Generating new dummy variable for whether subject knew Democratic Party endorsements in each race
*/ Coded as 1 if knew either endorsement (when Dem nominated 2); Coded as 0 if subject SK or named any non-endorsed candidate
gen knew_dem_endorse_mayor = 0
replace knew_dem_endorse_mayor = 1 if sf_mayor_demendorsed3 == 1
replace knew_dem_endorse_mayor = 1 if sf_mayor_demendorsed4 == 1
replace knew_dem_endorse_mayor = 0 if sf_mayor_demendorsed1 == 1
replace knew_dem_endorse_mayor = 0 if sf_mayor_demendorsed2 == 1
replace knew_dem_endorse_mayor = 0 if sf_mayor_demendorsed5 == 1
replace knew_dem_endorse_mayor = 0 if sf_mayor_demendorsed6 == 1
replace knew_dem_endorse_mayor = 0 if sf_mayor_demendorsed7 == 1
gen knew_dem_endorse_da = 0
replace knew_dem_endorse_da = 1 if sf_da_demendorse == 4
replace knew_dem_endorse_da = 1 if sf_da_demendorse == 1
replace knew_dem_endorse_da = 0 if sf_da_demendorse == 2
replace knew_dem_endorse_da = 0 if sf_da_demendorse == 3
replace knew_dem_endorse_da = 0 if sf_da_demendorse == 5
replace knew_dem_endorse_da = 0 if sf_da_demendorse == 6
gen knew_dem_endorse_sheriff = 0
replace knew_dem_endorse_sheriff = 1 if sf_sheriff_demendorse == 2
replace knew_dem_endorse_sheriff = 0 if sf_sheriff_demendorse == 1
replace knew_dem_endorse_sheriff = 0 if sf_sheriff_demendorse == 3
replace knew_dem_endorse_sheriff = 0 if sf_sheriff_demendorse == 4
replace knew_dem_endorse_sheriff = 0 if sf_sheriff_demendorse == 5

*/ Adding dummy variables into an index across all three contests
gen knew_dem_endorse_index = knew_dem_endorse_mayor + knew_dem_endorse_da + knew_dem_endorse_sheriff

*/ Generating DV's that scale from a minimum of (0) and maximum of (100)
gen knew_dem_endorse_100 = knew_dem_endorse_index * 100/3
gen knew_endorse_mayor_100 =  knew_dem_endorse_mayor*100

*/ 
*/
*/ Dependent Variable #4: Knows Rules of Ranked-Choice Voting

*/ 
*/
*/ First, Coding scores for the pre-election survey

*/ Generating dummy variable for whether subject knew RCV allowed 3 ranked choice candidates in each contest
gen pre_rcv_mayor_correct = 0
replace pre_rcv_mayor_correct = 1 if pre_sf_mayor_numbercandidates == 3
gen pre_rcv_sheriff_correct = 0
replace pre_rcv_sheriff_correct = 1 if pre_sf_sheriff_numbercandidates == 3
gen pre_rcv_da_correct = 0
replace pre_rcv_da_correct = 1 if pre_sf_da_numbercandidates == 3

*/ Combining 3 dummy variables into an index score
gen pre_rcv_correct_index = pre_rcv_mayor_correct + pre_rcv_sheriff_correct + pre_rcv_da_correct

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen pre_rcv3_100 = pre_rcv_correct_index * 100 / 3


*/
*/ Now, Coding scores for the post-election survey

*/ Generating dummy variable for whether subject knew RCV allowed 3 ranked choice candidates in each contest
gen rcv_mayor_correct = 0
replace rcv_mayor_correct = 1 if sf_mayor_numbercandidates == 3
gen rcv_sheriff_correct = 0
replace rcv_sheriff_correct = 1 if sf_sheriff_numbercandidates == 3
gen rcv_da_correct = 0
replace rcv_da_correct = 1 if sf_da_numbercandidates == 3

*/ Combining 3 dummy variables into an index score
gen rcv_correct_index = rcv_mayor_correct + rcv_sheriff_correct + rcv_da_correct

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen rcv3_100 = rcv_correct_index * 100 / 3

*/ 
*/
*/ Dependent Variable #5: Watched Candidate Debates

*/
*/ Not recorded in pre-election survey, Coding scores for the post-election survey

*/ Generating dummy variable for whether subject watched any debate in each contest
gen sf_mayor_debate_attn = sf_mayor_debate
recode sf_mayor_debate_attn (1=0) (2=1) (3=1) (4=0)
gen sf_sheriff_debate_attn = sf_sheriff_debate
recode sf_sheriff_debate_attn (1=0) (2=1) (3=1) (4=0)
gen sf_da_debate_attn = sf_da_debate
recode sf_da_debate_attn (1=0) (2=1) (3=1) (4=0)

*/ Combining 3 dummy variables into an index score
gen sf_debate_attn_index =  sf_mayor_debate_attn + sf_sheriff_debate_attn  + sf_da_debate_attn 

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen sf_debate_attn_100 = sf_debate_attn_index * 100 / 3

*/ 
*/
*/ Dependent Variable #6A: Ballot Preferences Exist 

*/
*/ First, Coding scores for the pre-election survey

*/ Generating dummy variable for whether subject has an opinion on each referenda
gen pre_ballota_opinion = 0
replace pre_ballota_opinion = 1 if pre_ballota_support < 5
gen pre_ballotb_opinion = 0
replace pre_ballotb_opinion = 1 if pre_ballotb_support < 5
gen pre_ballotc_opinion = 0
replace pre_ballotc_opinion = 1 if pre_ballotc_support < 5
gen pre_ballotd_opinion = 0
replace pre_ballotd_opinion = 1 if pre_ballotd_support < 5
gen pre_ballote_opinion = 0
replace pre_ballote_opinion = 1 if pre_ballote_support < 5
gen pre_ballotf_opinion = 0
replace pre_ballotf_opinion = 1 if pre_ballotf_support < 5
gen pre_ballotg_opinion = 0
replace pre_ballotg_opinion = 1 if pre_ballotg_support < 5
gen pre_balloth_opinion = 0
replace pre_balloth_opinion = 1 if pre_balloth_support < 5

*/ Combining 8 dummy variables into an index score
gen pre_ballot_opinion_index =  pre_ballota_opinion + pre_ballotb_opinion +   pre_ballotc_opinion +   pre_ballotd_opinion +   pre_ballote_opinion +   pre_ballotf_opinion +   pre_ballotg_opinion +   pre_balloth_opinion 

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen pre_ballot_opinion_100 = pre_ballot_opinion_index * 100 / 8

*/
*/ Now, Coding scores for the post-election survey

*/ Generating dummy variable for whether subject has an opinion on each referenda
gen ballota_opinion = 0
replace ballota_opinion = 1 if ballota_support < 7
gen ballotb_opinion = 0
replace ballotb_opinion = 1 if ballotb_support < 7
gen ballotc_opinion = 0
replace ballotc_opinion = 1 if ballotc_support < 7
gen ballotd_opinion = 0
replace ballotd_opinion = 1 if ballotd_support < 7
gen ballote_opinion = 0
replace ballote_opinion = 1 if ballote_support < 7
gen ballotf_opinion = 0
replace ballotf_opinion = 1 if ballotf_support < 7
gen ballotg_opinion = 0
replace ballotg_opinion = 1 if ballotg_support < 7
gen balloth_opinion = 0
replace balloth_opinion = 1 if balloth_support < 7
	
*/ Combining 8 dummy variables into an index score
gen ballot_opinion_index =  ballota_opinion + ballotb_opinion +   ballotc_opinion +   ballotd_opinion +   ballote_opinion +   ballotf_opinion +   ballotg_opinion +   balloth_opinion 

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen ballot_opinion_100 = ballot_opinion_index * 100 / 8

*/ 
*/
*/ Dependent Variable #6B: Candidate Preferences Exist

*/ 
*/
*/ Not Recorded in pre-treatment survey, Coding scores for the post-election survey

*/ Generating a variable ranging from a low of (0) to a high of (1) indicating whether subject developed preferences between candidates in each contest
gen prefs_mayor = sf_mayor_prefs
recode prefs_mayor (1=2) (2=1) (3=0)
gen prefs_sheriff = sf_sheriff_prefs
recode prefs_sheriff (1=2) (2=1) (3=0)
gen prefs_da = sf_da_prefs
recode prefs_da (1=2) (2=1) (3=0)

*/ Combining 3 variables into an index score
gen prefs_index = prefs_mayor + prefs_sheriff + prefs_da

*/ Re-scaling index to produce DV with minimum of (0) and maximum of (100)
gen candidate_prefs_100 = prefs_index * 100 / 6

*/ 
*/
*/ Dependent Variable #7A: Self-Assessment: Informed About Referenda

*/
*/ First, Coding scores for the pre-election survey
*/ Pre-treatment survey categories (1 = Not at all informed; 2 = Somewhat informed; 3 = Very informed)
gen pre_ballot_info_indexb = pre_ballota_info + pre_ballotb_info + pre_ballotc_info + pre_ballotd_info + pre_ballote_info + pre_ballotf_info + pre_ballotg_info + pre_balloth_info - 8
gen pre_ballot_info_100 = pre_ballot_info_indexb * 100 / 16 

*/
*/ Now, Coding scores for the post-election survey (as described in appendix)
gen ballot_info_indexb = ballota_info + ballotb_info + ballotc_info + ballotd_info + ballote_info + ballotf_info + ballotg_info + balloth_info - 8
gen ballot_info_100 = ballot_info_indexb * 100 / 40

*/ 
*/
*/ Dependent Variable #7B: Self-Assessment: Informed about Campaign

*/
*/ Not recorded in pre-treatment survey, Coding scores for the post-election survey
gen candidate_info_index = sf_mayor_info + sf_sheriff_info + sf_da_info - 3
gen candidate_info_100 = candidate_info_index * 100 / 15

*/ 
*/
*/ Dependent Variable #8: Non-Campaign Political Engagement

*/
*/ First, Coding scores for the pre-election survey
gen pre_noncampaign_engagement_index = pre_polint_local  + pre_polint_natl  + pre_polint_intl  + pre_polattn_local  + pre_polattn_natl  + pre_polattn_intl  + pre_polinfo_local  + pre_polinfo_natl  + pre_polinfo_intl  + pre_poldisc_family  + pre_poldisc_friends  + pre_poldisc_work  + pre_localpoldisc_family  + pre_localpoldisc_friends  + pre_localpoldisc_work  + pre_natlpoldisc_family  + pre_natlpoldisc_friends  + pre_natlpoldisc_work  + pre_intlpoldisc_family  + pre_intlpoldisc_friends + pre_intlpoldisc_work
egen max_pre_noncamp_engagement = max(pre_noncampaign_engagement_index)
egen min_pre_noncamp_engagement = min(pre_noncampaign_engagement_index)
gen pre_noncampaign_engage_100 = (pre_noncampaign_engagement_index - min_pre_noncamp_engagement) * (100 / ( max_pre_noncamp_engagement - min_pre_noncamp_engagement) )

*/
*/ Now, Coding scores for the post-election survey
gen noncampaign_engagement_index = polint_local  + polint_natl  + polint_intl  + polattn_local  + polattn_natl  + polattn_intl  + polinfo_local  + polinfo_natl  + polinfo_intl  + poldisc_family  + poldisc_friends  + poldisc_work  + localpoldisc_family  + localpoldisc_friends  + localpoldisc_work  + natlpoldisc_family  + natlpoldisc_friends  + natlpoldisc_work  + intlpoldisc_family  + intlpoldisc_friends  + intlpoldisc_work 
egen max_noncamp_engagement = max(noncampaign_engagement_index)
egen min_noncamp_engagement = min(noncampaign_engagement_index)
gen noncampaign_engage_100 = (noncampaign_engagement_index - min_noncamp_engagement) * (100 / ( max_noncamp_engagement - min_noncamp_engagement) )

*/ 
*/
*/ 
*/
*/
*/
*/
*/
*/ Second, I generate all tables and figures from the main body of the paper

*/
*/
*/
*/
*/ Table 1: Validated Voter Turnout, by Election and Treatment Group
*/ Note, all analyses are restricted by age, to only include subjects who were eligible to vote in each year

ttest vote_2007m if info == 0 & age >= 22, by(visa)
ttest vote_2008p if info == 0 & age >= 21, by(visa)
ttest vote_2008g if info == 0 & age >= 21, by(visa)
ttest vote_2009s if info == 0 & age >= 20, by(visa)
ttest vote_2009m if info == 0 & age >= 20, by(visa)
ttest vote_2010p if info == 0 & age >= 19, by(visa)
ttest vote_2010g if info == 0 & age >= 19, by(visa)
ttest vote_2011m if info == 0 , by(visa)

*/
*/
*/
*/
*/ Table 2: Estimated Effects of Mobilization Treatment on Estimates of Political Information
regress e_total_dist_100  visa  if info == 0
regress e_total_dist_100  visa pre_e_total_dist_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress s_total_dist_100 visa  if info == 0
regress s_total_dist_100 visa pre_s_total_dist_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress knew_endorse_mayor_100 visa if info == 0 
regress knew_endorse_mayor_100 visa pre_knew_endorse_mayor_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0 , robust
regress knew_dem_endorse_100 visa if info == 0 
regress knew_dem_endorse_100 visa pre_knew_dem_endorse_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0 , robust
regress sf_mayor_party_100 visa   if     info == 0   
regress sf_mayor_party_100 visa pre_sf_mayor_party_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs   if     info == 0, robust 
regress rcv3_100  visa  if info == 0
regress rcv3_100  visa pre_rcv3_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress sf_debate_attn_100 visa  if info == 0
regress sf_debate_attn_100 visa  age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress ballot_opinion_100  visa  if info == 0
regress ballot_opinion_100  visa pre_ballot_opinion_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress candidate_prefs_100  visa if info == 0
regress candidate_prefs_100  visa  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress ballot_info_100  visa  if info == 0
regress ballot_info_100  visa pre_ballot_info_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress candidate_info_100  visa if info == 0
regress candidate_info_100  visa  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust
regress noncampaign_engage_100  visa if info == 0
regress noncampaign_engage_100  visa  pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0, robust


*/
*/
*/
*/
*/ Figure 3: Predicted Post-Election Political Information Scores, by Treatment Group
*/ Note: Figure 3 generated with data from regressions from Table 2, as described in text

*/
*/
*/
*/
*/ Figure 4: Effect of Mobilization Treatment on Voter Turnout, by Initial Propensity to Vote

*/ First: Generating propensity scores, based on previous voter turnout
gen vote_total_local = vote_2007m + vote_2009m
gen propensity_local_low = 0
replace propensity_local_low = 1 if reg_before_t == 0
gen propensity_local_mod = 0
replace propensity_local_mod = 1   if vote_total_local == 0 & reg_before_t == 1
gen propensity_local_high = 0
replace propensity_local_high = 1  if vote_total_local > 0 & reg_before_t == 1
gen propensity_local = .
replace propensity_local = 1 if propensity_local_low == 1
replace propensity_local = 2 if propensity_local_mod == 1
replace propensity_local = 3 if propensity_local_high == 1
tab propensity_local

*/ Demonstrating propensity coding successfully differentiates types
	*/ Low = 4%, Mod = 46%, High = 95%
	*/ Treatment --> Low = 66%, Mod = 85%, High = 100%
tab propensity_local if visa == 0 & info == 0, sum(vote_2011m)
tab propensity_local if visa == 1 & info == 0, sum(vote_2011m)

*/ Estimating treatment effects on voter turnout, by propensity score
ttest vote_2011m if info == 0, by(visa)
ttest vote_2011m if info == 0 & propensity_local == 3, by(visa)
ttest vote_2011m if info == 0 & propensity_local == 2, by(visa)
ttest vote_2011m if info == 0 & propensity_local == 1, by(visa)

*/
*/
*/
*/
*/ Figure 5: Estimated Effects of Mobilization Treatment on 12 Estimates of Political Information, by Subject’s Pre-Treatment Propensity to Vote
*/ Note: Figure 5 was generated by pasting estimated treatment effects from the models with covariates into Microsoft Excel

*/ Estimating Treatment Effects by Subgroup: High, Moderate, and Low Propensity Voters (baseline model)
regress vote_2011m visa if     info == 0  & propensity_local == 1
regress vote_2011m visa if     info == 0  & propensity_local == 2
regress vote_2011m visa if     info == 0  & propensity_local == 3
regress e_total_dist_100 visa pre_e_total_dist_100      if     info == 0  & propensity_local == 1
regress e_total_dist_100 visa pre_e_total_dist_100      if     info == 0  & propensity_local == 2
regress e_total_dist_100 visa pre_e_total_dist_100      if     info == 0  & propensity_local == 3
regress s_total_dist_100  visa pre_s_total_dist_100      if   info == 0  & propensity_local == 1
regress s_total_dist_100  visa pre_s_total_dist_100      if   info == 0  & propensity_local == 2
regress s_total_dist_100  visa pre_s_total_dist_100      if   info == 0  & propensity_local == 3
regress rcv3_100  visa      if     info == 0  & propensity_local == 1
regress rcv3_100  visa      if     info == 0  & propensity_local == 2
regress rcv3_100  visa      if     info == 0  & propensity_local == 3
regress sf_debate_attn_100 visa      if     info == 0  & propensity_local == 1
regress sf_debate_attn_100 visa      if     info == 0  & propensity_local == 2
regress sf_debate_attn_100 visa      if     info == 0  & propensity_local == 3
regress ballot_opinion_100  visa       if     info == 0  & propensity_local == 1
regress ballot_opinion_100  visa       if     info == 0  & propensity_local == 2
regress ballot_opinion_100  visa       if     info == 0  & propensity_local == 3
regress candidate_prefs_100  visa      if     info == 0  & propensity_local == 1
regress candidate_prefs_100  visa      if     info == 0  & propensity_local == 2
regress candidate_prefs_100  visa      if     info == 0  & propensity_local == 3
regress ballot_info_100  visa       if     info == 0  & propensity_local == 1
regress ballot_info_100  visa       if     info == 0  & propensity_local == 2
regress ballot_info_100  visa       if     info == 0  & propensity_local == 3
regress candidate_info_100  visa      if     info == 0  & propensity_local == 1
regress candidate_info_100  visa      if     info == 0  & propensity_local == 2
regress candidate_info_100  visa      if     info == 0  & propensity_local == 3
regress noncampaign_engage_100  visa      if     info == 0  & propensity_local == 1
regress noncampaign_engage_100  visa      if     info == 0  & propensity_local == 2
regress noncampaign_engage_100  visa      if     info == 0  & propensity_local == 3
regress knew_endorse_mayor_100 visa if info == 0  & propensity_local == 1
regress knew_endorse_mayor_100 visa if info == 0  & propensity_local == 2
regress knew_endorse_mayor_100 visa if info == 0  & propensity_local == 3
regress knew_dem_endorse_100 visa if info == 0  & propensity_local == 1
regress knew_dem_endorse_100 visa if info == 0  & propensity_local == 2
regress knew_dem_endorse_100 visa if info == 0  & propensity_local == 3
regress sf_mayor_party_100  visa       if     info == 0  & propensity_local == 1
regress sf_mayor_party_100  visa       if     info == 0  & propensity_local == 2
regress sf_mayor_party_100  visa       if     info == 0  & propensity_local == 3

*/ Estimating Treatment Effects by Subgroup: High, Moderate, and Low Propensity Voters (with covariates)
regress e_total_dist_100 visa pre_e_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress e_total_dist_100 visa pre_e_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress e_total_dist_100 visa pre_e_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress s_total_dist_100  visa pre_s_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if   info == 0  & propensity_local == 1
regress s_total_dist_100  visa pre_s_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if   info == 0  & propensity_local == 2
regress s_total_dist_100  visa pre_s_total_dist_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if   info == 0  & propensity_local == 3
regress knew_endorse_mayor_100 visa pre_knew_endorse_mayor_100   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 1
regress knew_endorse_mayor_100 visa pre_knew_endorse_mayor_100    age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 2
regress knew_endorse_mayor_100 visa pre_knew_endorse_mayor_100    age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 3
regress knew_dem_endorse_100 visa pre_knew_dem_endorse_100   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 1
regress knew_dem_endorse_100 visa pre_knew_dem_endorse_100   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 2
regress knew_dem_endorse_100 visa pre_knew_dem_endorse_100   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if info == 0  & propensity_local == 3
regress sf_mayor_party_100  visa pre_sf_mayor_party_100        age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress sf_mayor_party_100  visa pre_sf_mayor_party_100        age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress sf_mayor_party_100  visa pre_sf_mayor_party_100        age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress rcv3_100  visa       pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress rcv3_100  visa       pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress rcv3_100  visa       pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress ballot_opinion_100  visa pre_ballot_opinion_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress ballot_opinion_100  visa pre_ballot_opinion_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress ballot_opinion_100  visa pre_ballot_opinion_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress candidate_prefs_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress candidate_prefs_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress candidate_prefs_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress ballot_info_100  visa pre_ballot_info_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress ballot_info_100  visa pre_ballot_info_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress ballot_info_100  visa pre_ballot_info_100       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress candidate_info_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress candidate_info_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress candidate_info_100  visa       age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3
regress noncampaign_engage_100  visa   pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 1
regress noncampaign_engage_100  visa   pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 2
regress noncampaign_engage_100  visa   pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs if     info == 0  & propensity_local == 3

*/ Testing whether estimated effects across propensity scores are significantly different from each other
*/ Note: Differences between coefficients are referenced in the discussion of Figure 5
quietly regress e_total_dist_100 visa pre_e_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store edist1
quietly regress e_total_dist_100 visa pre_e_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store edist2
quietly regress e_total_dist_100 visa pre_e_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store edist3
estimates table edist1 edist2 edist3 
quietly suest edist1 edist2 edist3
lincom  [edist1_mean]_b[visa]  -  [edist2_mean]_b[visa]
lincom  [edist1_mean]_b[visa]  -  [edist3_mean]_b[visa]
lincom  [edist2_mean]_b[visa]  -  [edist3_mean]_b[visa]

quietly regress s_total_dist_100  visa pre_s_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store sdist1
quietly regress s_total_dist_100  visa pre_s_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store sdist2
quietly regress s_total_dist_100  visa pre_s_total_dist_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store sdist3
estimates table sdist1 sdist2 sdist3 
quietly suest sdist1 sdist2 sdist3
lincom  [sdist1_mean]_b[visa]  -  [sdist2_mean]_b[visa]
lincom  [sdist1_mean]_b[visa]  -  [sdist3_mean]_b[visa]
lincom  [sdist2_mean]_b[visa]  -  [sdist3_mean]_b[visa]
	
quietly regress rcv3_100  visa pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store rcv31
quietly regress rcv3_100  visa pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store rcv32
quietly regress rcv3_100  visa pre_rcv3_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store rcv33
estimates table rcv31 rcv32 rcv33 
quietly suest rcv31 rcv32 rcv33	
lincom  [rcv31_mean]_b[visa]  -  [rcv32_mean]_b[visa]
lincom  [rcv31_mean]_b[visa]  -  [rcv33_mean]_b[visa]
lincom  [rcv32_mean]_b[visa]  -  [rcv33_mean]_b[visa]

quietly regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store debate1
quietly regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store debate2
quietly regress sf_debate_attn_100 visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store debate3
estimates table debate1 debate2 debate3
quietly suest debate1 debate2 debate3
lincom  [debate1_mean]_b[visa]  -  [debate2_mean]_b[visa]
lincom  [debate1_mean]_b[visa]  -  [debate3_mean]_b[visa]
lincom  [debate2_mean]_b[visa]  -  [debate3_mean]_b[visa]

quietly regress ballot_opinion_100  visa pre_ballot_opinion_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store ballotprefs1
quietly regress ballot_opinion_100  visa pre_ballot_opinion_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store ballotprefs2
quietly regress ballot_opinion_100  visa pre_ballot_opinion_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store ballotprefs3
estimates table ballotprefs1  ballotprefs2  ballotprefs3
quietly suest ballotprefs1  ballotprefs2  ballotprefs3
lincom  [ballotprefs1 _mean]_b[visa]  -  [ballotprefs2 _mean]_b[visa]
lincom  [ballotprefs1 _mean]_b[visa]  -  [ballotprefs3_mean]_b[visa]
lincom  [ballotprefs2 _mean]_b[visa]  -  [ballotprefs3_mean]_b[visa]

quietly regress candidate_prefs_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store sfprefs1
quietly regress candidate_prefs_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store sfprefs2
quietly regress candidate_prefs_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store sfprefs3
estimates table sfprefs1 sfprefs2 sfprefs3
quietly suest sfprefs1 sfprefs2 sfprefs3
lincom  [sfprefs1_mean]_b[visa]  -  [sfprefs2_mean]_b[visa]
lincom  [sfprefs1_mean]_b[visa]  -  [sfprefs3_mean]_b[visa]
lincom  [sfprefs2_mean]_b[visa]  -  [sfprefs3_mean]_b[visa]

quietly regress ballot_info_100  visa pre_ballot_info_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store ballotinfo1 
quietly regress ballot_info_100  visa pre_ballot_info_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store ballotinfo2
quietly regress ballot_info_100  visa pre_ballot_info_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store ballotinfo3
estimates table ballotinfo1 ballotinfo2 ballotinfo3
quietly suest ballotinfo1 ballotinfo2 ballotinfo3
lincom  [ballotinfo1_mean]_b[visa]  -  [ballotinfo2_mean]_b[visa]
lincom  [ballotinfo1_mean]_b[visa]  -  [ballotinfo3_mean]_b[visa]
lincom  [ballotinfo2_mean]_b[visa]  -  [ballotinfo3_mean]_b[visa]
	
quietly regress candidate_info_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store sfinfo1
quietly regress candidate_info_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store sfinfo2
quietly regress candidate_info_100  visa   age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store sfinfo3
estimates table sfinfo1 sfinfo2 sfinfo3
quietly suest sfinfo1 sfinfo2 sfinfo3
lincom  [sfinfo1_mean]_b[visa]  -  [sfinfo2_mean]_b[visa]
lincom  [sfinfo1_mean]_b[visa]  -  [sfinfo3_mean]_b[visa]
lincom  [sfinfo2_mean]_b[visa]  -  [sfinfo3_mean]_b[visa]

quietly regress noncampaign_engage_100  visa pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store otherpol1
quietly regress noncampaign_engage_100  visa pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store otherpol2
quietly regress noncampaign_engage_100  visa pre_noncampaign_engage_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store otherpol3
estimates table otherpol1  otherpol2  otherpol3
quietly suest otherpol1  otherpol2  otherpol3
lincom  [otherpol1 _mean]_b[visa]  -  [otherpol2 _mean]_b[visa]
lincom  [otherpol1 _mean]_b[visa]  -  [otherpol3_mean]_b[visa]
lincom  [otherpol2 _mean]_b[visa]  -  [otherpol3_mean]_b[visa]

quietly regress knew_endorse_mayor_100  visa pre_knew_endorse_mayor_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store demmayorendorse1
quietly regress knew_endorse_mayor_100  visa pre_knew_endorse_mayor_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store demmayorendorse2
quietly regress knew_endorse_mayor_100  visa pre_knew_endorse_mayor_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store demmayorendorse3
estimates table demmayorendorse1 demmayorendorse2  demmayorendorse3
quietly suest demmayorendorse1 demmayorendorse2  demmayorendorse3
lincom  [demmayorendorse1_mean]_b[visa]  -  [demmayorendorse2 _mean]_b[visa]
lincom  [demmayorendorse1_mean]_b[visa]  -  [demmayorendorse3_mean]_b[visa]
lincom  [demmayorendorse2 _mean]_b[visa]  -  [demmayorendorse3_mean]_b[visa]

quietly regress knew_dem_endorse_100  visa pre_knew_dem_endorse_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store demendorseindex1
quietly regress knew_dem_endorse_100  visa pre_knew_dem_endorse_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store demendorseindex2
quietly regress knew_dem_endorse_100  visa pre_knew_dem_endorse_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store demendorseindex3
estimates table demendorseindex1  demendorseindex2  demendorseindex3
quietly suest demendorseindex1  demendorseindex2  demendorseindex3	
lincom  [demendorseindex1 _mean]_b[visa]  -  [demendorseindex2 _mean]_b[visa]
lincom  [demendorseindex1 _mean]_b[visa]  -  [demendorseindex3_mean]_b[visa]
lincom  [demendorseindex2 _mean]_b[visa]  -  [demendorseindex3_mean]_b[visa]
	
quietly regress sf_mayor_party_100  visa pre_sf_mayor_party_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 1
estimates store mayorparty1
quietly regress sf_mayor_party_100  visa pre_sf_mayor_party_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 2
estimates store mayorparty2
quietly regress sf_mayor_party_100  visa pre_sf_mayor_party_100  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index  partisan_strength partisan_lrs    if     info == 0  & propensity_local == 3
estimates store mayorparty3
estimates table mayorparty1  mayorparty2  mayorparty3
quietly suest mayorparty1  mayorparty2  mayorparty3
lincom  [mayorparty1 _mean]_b[visa]  -  [mayorparty2 _mean]_b[visa]
lincom  [mayorparty1 _mean]_b[visa]  -  [mayorparty3_mean]_b[visa]
lincom  [mayorparty2 _mean]_b[visa]  -  [mayorparty3_mean]_b[visa]

*/
*/
*/
*/ Results Continued: Information Among the Active Voting Population
*/ Note: Tables not presented in paper, but null results discussed in Section 6
*/
*/

*/ Estimating effects of mobilization treatment on average level of information among active voting population, baseline model
ttest e_total_dist_100 if info == 0 & vote_2011m == 1, by(visa)
ttest s_total_dist_100 if info == 0 & vote_2011m == 1, by(visa)
ttest rcv3_100 if info == 0 & vote_2011m == 1, by(visa)
ttest sf_debate_attn_100 if info == 0 & vote_2011m == 1, by(visa)
ttest ballot_opinion_100 if info == 0 & vote_2011m == 1, by(visa)
ttest candidate_prefs_100 if info == 0 & vote_2011m == 1, by(visa)
ttest ballot_info_100 if info == 0 & vote_2011m == 1, by(visa)
ttest candidate_info_100 if info == 0 & vote_2011m == 1, by(visa)
ttest noncampaign_engage_100 if info == 0 & vote_2011m == 1, by(visa)
ttest knew_endorse_mayor_100 if info == 0 & vote_2011m == 1, by(visa)
ttest knew_dem_endorse_100 if info == 0 & vote_2011m == 1, by(visa)
ttest sf_mayor_party_100 if info == 0 & vote_2011m == 1, by(visa)

*/ Estimating effects of mobilization treatment on average level of information among active voting population, with covariates
regress    e_total_dist_100 visa pre_e_total_dist_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    s_total_dist_100  visa pre_s_total_dist_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    rcv3_100    visa pre_rcv3_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    sf_debate_attn_100    visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    ballot_opinion_100    visa pre_ballot_opinion_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    candidate_prefs_100    visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    ballot_info_100    visa pre_ballot_info_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    candidate_info_100    visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    noncampaign_engage_100    visa pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    knew_endorse_mayor_100    visa pre_knew_endorse_mayor_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    knew_dem_endorse_100    visa pre_knew_dem_endorse_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1
regress    sf_mayor_party_100    visa pre_sf_mayor_party_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs if info == 0 & vote_2011m == 1

*/ 
*/
*/ 
*/
*/
*/
*/
*/
*/ Third, I generate all tables and figures from the appendixes

*/
*/
*/
*/
*/ Appendix G: Descriptive Statistics of Sample, by Treatment Group
tab visa if info == 0, sum(female)
tab visa if info == 0, sum(race_white)
tab visa if info == 0, sum(  race_asian  )
tab visa if info == 0, sum(  race_black  )
tab visa if info == 0, sum(  race_hispanic  )
tab visa if info == 0, sum(  race_mixed  )
tab visa if info == 0, sum(  employ_fulltime  )
tab visa if info == 0, sum(  employ_parttime  )
tab visa if info == 0, sum(  school_fulltime  )
tab visa if info == 0, sum(  school_parttime  )
tab visa if info == 0, sum(  highschool  )
tab visa if info == 0, sum(  associate  )
tab visa if info == 0, sum(  college  )
tab visa if info == 0, sum(  advanced_degree  )
tab visa if info == 0, sum(  married  )
tab visa if info == 0, sum(  parent  )
tab visa if info == 0, sum(  residency_years  )
tab visa if info == 0, sum(  age  )
tab visa if info == 0, sum(  age2  )
tab visa if info == 0, sum(  income  )
tab visa if info == 0, sum(  pre_partic_index  )
tab visa if info == 0, sum(  reg_before_t  )
tab visa if info == 0, sum(  vh_vv_total  )
tab visa if info == 0, sum(  pre_libcon  )
tab visa if info == 0, sum(  partisan_strength  )
tab visa if info == 0, sum(  partisan_lrs  )

*/
*/
*/
*/
*/ Appendix I: Information Treatment
*/ Table A1: Estimated Effects of the Combined Treatment (Mobilization + Information) on Estimates of Political Sophistication

*/ Estimating all models, comparing combined treatment (mobilization + information) to the baseline (no treatment)
regress e_total_dist_100  t4  if t2 != 1 & t3 != 1
regress e_total_dist_100  visa pre_e_total_dist_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress s_total_dist_100 t4  if t2 != 1 & t3 != 1
regress s_total_dist_100 visa pre_s_total_dist_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress knew_endorse_mayor_100 t4  if t2 != 1 & t3 != 1
regress knew_endorse_mayor_100 visa pre_knew_endorse_mayor_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs   if  t2 != 1 & t3 != 1, robust
regress knew_dem_endorse_100 t4  if t2 != 1 & t3 != 1
regress knew_dem_endorse_100 visa pre_knew_dem_endorse_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs   if  t2 != 1 & t3 != 1, robust
regress sf_mayor_party_100 t4  if t2 != 1 & t3 != 1
regress sf_mayor_party_100 visa pre_sf_mayor_party_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years  income pre_partic_index vh_vv_total partisan_strength partisan_lrs   if  t2 != 1 & t3 != 1, robust
regress rcv3_100  visa  t4  if t2 != 1 & t3 != 1
regress rcv3_100  visa pre_rcv3_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress sf_debate_attn_100 t4  if t2 != 1 & t3 != 1
regress sf_debate_attn_100 visa  age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress ballot_opinion_100  t4  if t2 != 1 & t3 != 1
regress ballot_opinion_100  visa pre_ballot_opinion_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress candidate_prefs_100  t4  if t2 != 1 & t3 != 1
regress candidate_prefs_100  visa  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress ballot_info_100  t4  if t2 != 1 & t3 != 1
regress ballot_info_100  visa pre_ballot_info_100 age age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress candidate_info_100 t4  if t2 != 1 & t3 != 1
regress candidate_info_100  visa  age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust
regress noncampaign_engage_100  t4  if t2 != 1 & t3 != 1
regress noncampaign_engage_100  visa  pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1, robust



regress noncampaign_engage_100  visa  pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1 & propensity_local == 1, robust
regress noncampaign_engage_100  visa  pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1 & propensity_local == 2, robust
regress noncampaign_engage_100  visa  pre_noncampaign_engage_100 age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if  t2 != 1 & t3 != 1 & propensity_local == 3, robust



*/
*/
*/
*/
*/ Appendix L: Estimating Effect of Mobilization Treatment on Change in Information
*/Table A2: Effect of Mobilization Treatment on Change in Information Between Pre-Election Survey and Post-Election Survey

*/ First: Generating new variables indicating how much subject INCREASED pol info between surveys:
gen e_dist_inc = e_total_dist_100 -   pre_e_total_dist_100      
gen s_dist_inc =  s_total_dist_100  -  pre_s_total_dist_100     
gen partycorrect_inc = sf_mayor_party_100  -   pre_sf_mayor_party_100       
gen knew_endorsement_mayor_inc = knew_endorse_mayor_100 - pre_knew_endorse_mayor_100      
gen knew_endorsement_all_inc = knew_dem_endorse_100 - pre_knew_dem_endorse_100
gen numbercand_inc = rcv3_100  -   pre_rcv3_100
gen ballot_opinions_inc = ballot_opinion_100  -  pre_ballot_opinion_100
gen ballot_info_inc = ballot_info_100  -   pre_ballot_info_100
gen other_pol_inc = noncampaign_engage_100  -   pre_noncampaign_engage_100  

*/ Second: Estimating treatment effects on increase in information
regress e_dist_inc visa if info == 0
regress e_dist_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress s_dist_inc visa if info == 0
regress s_dist_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress partycorrect_inc visa if info == 0
regress partycorrect_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress knew_endorsement_mayor_inc visa if info == 0
regress knew_endorsement_mayor_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress knew_endorsement_all_inc visa if info == 0
regress knew_endorsement_all_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress numbercand_inc visa if info == 0
regress numbercand_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress ballot_opinions_inc visa if info == 0
regress ballot_opinions_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress ballot_info_inc visa if info == 0
regress ballot_info_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0
regress other_pol_inc visa if info == 0
regress other_pol_inc visa age  age2 female race_asian race_black race_hispanic race_other employ_fulltime employ_parttime school_fulltime school_parttime associate college advanced_degree married parent residency_years income pre_partic_index vh_vv_total partisan_strength partisan_lrs  if info == 0















