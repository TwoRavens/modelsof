***************************
* Replication  Materials  *
*   Goelzhauser & Cann    *
* SPPQ Opinion Clarity    *
***************************


#delimit;


***Means ;
means flesch_ease if competitive==1;
means flesch_level if competitive==1;
means colemanliau if competitive==1;
means passive if competitive==1;

means flesch_ease if retent==1;
means flesch_level if retent ==1;
means colemanliau if retent ==1;
means passive if retent ==1;

means flesch_ease if reappointment==1;
means flesch_level if reappointment ==1;
means colemanliau if reappointment ==1;
means passive if reappointment ==1;

means flesch_ease if lifetenure==1;
means flesch_level if lifetenure ==1;
means colemanliau if lifetenure ==1;
means passive if lifetenure ==1;


***Basic ANOVA;
gen system = 1 if competitive ==1;
replace system = 2 if retent ==1 ;
replace system = 3 if reappointment==1 ;
replace system = 4 if lifetenure==1;

anova flesch_ease system;
anova flesch_level system;
anova passive system;
anova colemanliau system;


************************
************************
**    Final Model     **
**   from Tables 3/4  **
************************
************************

*** Add Court Professionalism;

gen ctprofps_dock = .			;



xi: reg flesch_ease competitive salient competitive_salient
numissues2 multiparties amicus  
ctprofps_dock casesperjudge discdocket 
college
constitutional i.genissue i.year
, cluster(stateid);



nlcom _b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1;
nlcom _b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0;

*competitive vs. noncompetitive when salient;
nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0);

*competitive vs. noncompetitive when not salient;

nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0);

*difference in effect of competitive elections across levels of salience;

nlcom ((_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0)) 
- ((_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0));


 
xi: reg flesch_level competitive salient competitive_salient
numissues2 multiparties amicus  
ctprofps_dock casesperjudge discdocket 
college
constitutional i.genissue i.year
, cluster(stateid);


nlcom _b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1;
nlcom _b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0;

*competitive vs. noncompetitive when salient;
nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0);

*competitive vs. noncompetitive when not salient;

nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0);

*difference in effect of competitive elections across levels of salience;

nlcom ((_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0)) 
- ((_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0));




xi: reg passive competitive salient competitive_salient
numissues2 multiparties amicus  
ctprofps_dock casesperjudge discdocket 
college
constitutional i.genissue i.year
, cluster(stateid);


nlcom _b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1;
nlcom _b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0;

*competitive vs. noncompetitive when salient;
nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0);

*competitive vs. noncompetitive when not salient;

nlcom (_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0);

*difference in effect of competitive elections across levels of salience;

nlcom ((_b[_cons] + _b[competitive]*1 + _b[salient]*1 + _b[competitive_salient]*1 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*1 + _b[competitive_salient]*0)) 
- ((_b[_cons] + _b[competitive]*1 + _b[salient]*0 + _b[competitive_salient]*0 ) - (_b[_cons] + _b[competitive]*0 + _b[salient]*0 + _b[competitive_salient]*0));












