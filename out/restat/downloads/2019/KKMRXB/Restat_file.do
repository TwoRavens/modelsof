/*identification of version of the software used and the operating system*/

/*Windows ' Porfessional*/
/**Inter (R) Core(TM) i7-5600U*/
/*CPU@2.60GHz*/
/*64 bits*/
/*Stata 14.0 (SE) is used for the analysis.*/

/*It takes about 20-40 minutes to obtain the results in each estimaiton*/


 set matsize 11000
/*Table 1*/
ttest  time  if exclud!=1, by(women_dat)
ttest  rank  if exclud!=1, by(women_dat)
ttest  exh_time  if exclud!=1, by(women_dat)
ttest  weight  if exclud!=1, by(women_dat)
ttest  dch_in  if exclud!=1, by(women_dat)
ttest  dch_ou  if exclud!=1, by(women_dat)
ttest  malbeh  if exclud!=1, by(women_dat)
ttest  disqual  if exclud!=1, by(women_dat)
ttest  mix_ra  if exclud!=1, by(women_dat)
ttest  nop_gend  if exclud!=1, by(women_dat)
ttest  high_class   if exclud!=1 , by(women_dat)
ttest   low_class  if exclud!=1 , by(women_dat)
ttest   high_expe   if exclud!=1 , by(women_dat)
ttest   low_expe  if exclud!=1 , by(women_dat)
ttest   nheavy   if exclud!=1 , by(women_dat)
ttest   nlight  if exclud!=1 , by(women_dat)

ttest   exh_rank1  if exclud!=1 , by(women_dat)
ttest   exh_rank2  if exclud!=1 , by(women_dat)
ttest   exh_rank3  if exclud!=1 , by(women_dat)
ttest   exh_rank4  if exclud!=1 , by(women_dat)
ttest   exh_rank5  if exclud!=1 , by(women_dat)
ttest   exh_rank6  if exclud!=1 , by(women_dat)

ttest   grade1  if exclud!=1 , by(women_dat)
ttest   grade2  if exclud!=1 , by(women_dat)
ttest   grade3  if exclud!=1 , by(women_dat)
ttest   grade4  if exclud!=1 , by(women_dat)
ttest   grade5  if exclud!=1 , by(women_dat)

ttest   course1  if exclud!=1 , by(women_dat)
ttest   course2  if exclud!=1 , by(women_dat)
ttest   course3  if exclud!=1 , by(women_dat)
ttest   course4  if exclud!=1 , by(women_dat)
ttest   course5  if exclud!=1 , by(women_dat)
ttest   course6  if exclud!=1 , by(women_dat)




 /*Table2*/
/*time:Dependent variable*/
/*(1)interaction*/
 reg rank mix_ra_women mix_ra women_dat I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. ,robust cluster(race_id )
 /*(2)female*/
reg rank  nmen    I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=.,robust cluster(race_id)
 /*(3)male*/
 reg rank  nwomen  I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=.,robust cluster(race_id )


 /*(4)interaction*/
 reg rank  mix_ra_women mix_ra women_dat high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=.,robust cluster(race_id )
 /*(5)female*/
 reg rank  nmen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=.,robust cluster(race_id)
 /*(6)male*/
  reg rank  nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=.,robust cluster(race_id )
 ttest  rank  if exclud!=1 & course==1, by(women_dat)

/*control group mean value*/
/*tab2*/
ttest  rank  if exclud!=1 , by(mix_women)
 ttest  rank  if exclud!=1 , by(mix_ra)
 ttest  rank  if exclud!=1 , by(women_dat)


 /*Table3(a)*/
 /*time:Dependent variable*/
/*(1)with interaction term*/
 reg ltime mix_ra_women mix_ra women_dat I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. ,robust cluster(race_id )
 /*(2)female*/
reg ltime  nmen    I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=.,robust cluster(race_id)
 /*(3)male*/
 reg ltime  nwomen  I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=.,robust cluster(race_id )

 /* With interaction term and control variables for ability*/
 /*(4)*/
 reg ltime  mix_ra_women mix_ra women_dat high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=.,robust cluster(race_id )
 /*(5)female*/
 reg ltime  nmen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=.,robust cluster(race_id)
 /*(6)male*/
  reg ltime  nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=.,robust cluster(race_id )
 
/*control group mean value*/
 /*tab3(a)*/
ttest  ltime  if exclud!=1 , by(mix_women)
 ttest  ltime  if exclud!=1 , by(mix_ra)
 ttest  ltime  if exclud!=1 , by(women_dat)

 /*Table3(b)*/
/*(1)female*/
reg rank nmenc13 nmen c13 high_class low_class high_expe low_expe nheavy nlight nheavy      I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==1 & ltime!=. ,robust cluster(race_id)
/*(2)male*/
reg rank nwomenc13 nwomen c13 high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==0 & ltime!=.  ,robust cluster(race_id)
/*(3)female*/
reg ltime nmenc13 nmen c13 high_class low_class high_expe low_expe nheavy nlight nheavy     I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==1 & ltime!=. ,robust cluster(race_id)
/*(4)male*/
reg ltime nwomenc13 nwomen c13 high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==0 & ltime!=.  ,robust cluster(race_id)

/*control group mean value*/
/*tab3b*/
ttest  rank  if exclud!=1 & women_dat==1, by(c13)
ttest  rank  if exclud!=1 & women_dat==0, by(c13)
 
ttest  ltime  if exclud!=1 & women_dat==1, by(c13)
ttest  ltime  if exclud!=1 & women_dat==0, by(c13)
 
 
 /*Table4*/
 /*lweight:Dependent variable*/
 /*(1)with interaction term*/
 reg dgch_in mix_ra_women mix_ra women_dat  high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. & course!=1,robust cluster(race_id )
 /*(2) female*/
reg dgch_in nmen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=. & course!=1,robust cluster(race_id)
 /*(3) male*/
reg dgch_in nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=. & course!=1,robust cluster(race_id )
 
/*(4)with interaction term*/
reg dgch_ou mix_ra_women mix_ra women_dat  high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. & course!=6,robust cluster(race_id )
/*(5) female*/
reg dgch_ou nmen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=. & course!=6,robust cluster(race_id)
/*(6) male*/
reg dgch_ou nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=. & course!=6,robust cluster(race_id )
 
/*control group mean value*/
/*tab4*/
 ttest  dgch_in  if exclud!=1 & c1!=1, by(mix_women)
 ttest  dgch_in  if exclud!=1 & c1!=1, by(mix_ra)
 ttest  dgch_in  if exclud!=1 & c1!=1, by(women_dat)
 
 ttest  dgch_ou  if exclud!=1 & course!=6, by(mix_women)
 ttest  dgch_ou  if exclud!=1 & course!=6, by(mix_ra)
 ttest  dgch_ou  if exclud!=1 & course!=6, by(women_dat)
 
 

/*Table5*/
/*Dummies for disqualification:Dependent variable*/
/*(1)interaction*/
reg disqual  c.mix_ra##c.women_dat high_class low_class high_expe low_expe nheavy nlight   nheavy   I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1,robust cluster(race_id)
  /*(2) female*/
reg disqual nmen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==1,robust cluster(race_id)
  /*(3) male*/
reg disqual nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy      I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==0,robust cluster(race_id)
/*Dummies for for poor navigation:Dependent variable*/
/*(4)interaction*/
reg malbeh  c.mix_ra##c.women_dat high_class low_class high_expe low_expe nheavy nlight   nheavy   I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1,robust cluster(race_id)
  /*(5) female*/
reg malbeh nmen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==1,robust cluster(race_id)
  /*(6) male*/
reg malbeh nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy     I.course  I.grade I.yrmt_locid  I.p_race I.p_id if  exclud!=1 & women_dat==0,robust cluster(race_id)

/*control group mean value*/
/*tab5*/
 ttest  disqual  if exclud!=1 , by(mix_women)
 ttest  disqual  if exclud!=1 , by(mix_ra)
 ttest  disqual  if exclud!=1 , by(women_dat)

 ttest  malbeh  if exclud!=1 , by(mix_women)
 ttest  malbeh  if exclud!=1 , by(mix_ra)
 ttest  malbeh  if exclud!=1 , by(women_dat)
 
/*table6*/

/*table6(a)*/
/*lweight : dependent variable*/
 reg lweight  mix_ra  I.grade  I.yrmt_locid I.p_id if exclud!=1 & women_dat==1,robust   cluster(race_id)
 reg lweight  mix_ra  I.grade  I.yrmt_locid I.p_id if exclud!=1 & women_dat==0,robust   cluster(race_id)

 /*table6(b)*/
 /* Log of recorded exhibition time : dependent variable*/
reg lexh_time  mix_ra high_class low_class high_expe low_expe nheavy nlight nheavy  I.grade I.course  I.race I.p_race I.p_id I.yrmt_locid if exclud!=1 & women_dat==1,robust cluster(race_id)
reg lexh_time  nmen high_class low_class high_expe low_expe nheavy nlight nheavy  I.grade I.course  I.race I.p_race I.p_id I.yrmt_locid if exclud!=1 & women_dat==1,robust cluster(race_id)
reg lexh_time  mix_ra high_class low_class high_expe low_expe nheavy nlight nheavy  I.grade I.course  I.race I.p_race I.p_id I.yrmt_locid if exclud!=1 & women_dat==0,robust cluster(race_id)
reg lexh_time  nwomen high_class low_class high_expe low_expe nheavy nlight nheavy  I.grade I.course  I.race I.p_race I.p_id I.yrmt_locid if exclud!=1 & women_dat==0,robust cluster(race_id)

/*control group mean value*/
/*tab6(a)*/
ttest  lweight  if exclud!=1 & women_dat==1, by(mix_ra)
ttest  lweight  if exclud!=1 & women_dat==0, by(mix_ra)
/*tab6(b)*/
ttest  lexh_time  if exclud!=1 & women_dat==1, by(mix_ra)
ttest  lexh_time  if exclud!=1 & women_dat==0, by(mix_ra)

/*Appendix*/
/*Table A1*/
ttest  rank   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  rank   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  time   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  time   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  exh_time   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  exh_time   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  weight   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  weight   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  dch_in   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  dch_in   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  dch_ou   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  dch_ou   if exclud!=1 & women_dat==0, by(mix_ra)


ttest  malbeh   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  malbeh   if exclud!=1 & women_dat==0, by(mix_ra)

ttest  disqual   if exclud!=1 & women_dat==1, by(mix_ra)
ttest  disqual   if exclud!=1 & women_dat==0, by(mix_ra)

/*Table A2*/
 /*without 1 lane*/
 /*(1)interaction*/
 reg rank mix_ra_women mix_ra women_dat  high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. & c1!=1,robust cluster(race_id )
 /*(2)female*/
 reg rank  nmen high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=. & c1!=1,robust cluster(race_id)
/*(3)male*/
 reg rank  nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=. & c1!=1,robust cluster(race_id )

/*Table A3*/
/*without 1 lane*/
 /*(1)interaction*/
 reg ltime mix_ra_women mix_ra women_dat  high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid if exclud!=1 &  ltime!=. & c1!=1,robust cluster(race_id )
 /*(2)female*/
 reg ltime  nmen high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid   if exclud!=1 & women_dat==1 & ltime!=. & c1!=1,robust cluster(race_id)
/*(3)male*/
 reg ltime  nwomen high_class low_class high_expe low_expe nheavy nlight   nheavy   lweight   I.course  I.grade I.p_id  I.p_race I.yrmt_locid  if exclud!=1 & women_dat==0 & ltime!=. & c1!=1,robust cluster(race_id )

/*Table A4*/

tabstat tid if exclud!=1 &  ltime!=. & mix_ra==1,stat(count)by(class)
tabstat tid if exclud!=1 &  ltime!=. & mix_ra==0,stat(count) by(class)

