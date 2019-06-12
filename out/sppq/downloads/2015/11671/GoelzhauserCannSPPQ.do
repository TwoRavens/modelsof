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

gen ctprofps_dock = .			;replace ctprofps_dock =	0.513	if stcode==	1;replace ctprofps_dock =	0.69	if stcode==	2;replace ctprofps_dock =	0.598	if stcode==	3;replace ctprofps_dock =	0.506	if stcode==	4;replace ctprofps_dock =	1.004	if stcode==	5;replace ctprofps_dock =	0.485	if stcode==	6;replace ctprofps_dock =	0.571	if stcode==	7;replace ctprofps_dock =	0.618	if stcode==	8;replace ctprofps_dock =	0.707	if stcode==	9;replace ctprofps_dock =	0.644	if stcode==	10;replace ctprofps_dock =	0.532	if stcode==	11;replace ctprofps_dock =	0.512	if stcode==	12;replace ctprofps_dock =	0.69	if stcode==	13;replace ctprofps_dock =	0.578	if stcode==	14;replace ctprofps_dock =	0.46	if stcode==	15;replace ctprofps_dock =	0.477	if stcode==	16;replace ctprofps_dock =	0.621	if stcode==	17;replace ctprofps_dock =	0.667	if stcode==	18;replace ctprofps_dock =	0.406	if stcode==	19;replace ctprofps_dock =	0.513	if stcode==	20;replace ctprofps_dock =	0.575	if stcode==	21;replace ctprofps_dock =	0.878	if stcode==	22;replace ctprofps_dock =	0.586	if stcode==	23;replace ctprofps_dock =	0.36	if stcode==	24;replace ctprofps_dock =	0.64	if stcode==	25;replace ctprofps_dock =	0.473	if stcode==	26;replace ctprofps_dock =	0.562	if stcode==	27;replace ctprofps_dock =	0.407	if stcode==	28;replace ctprofps_dock =	0.694	if stcode==	29;replace ctprofps_dock =	0.717	if stcode==	30;replace ctprofps_dock =	0.466	if stcode==	31;replace ctprofps_dock =	0.724	if stcode==	32;replace ctprofps_dock =	0.548	if stcode==	33;replace ctprofps_dock =	0.253	if stcode==	34;replace ctprofps_dock =	0.601	if stcode==	35;replace ctprofps_dock =	0.445	if stcode==	36;replace ctprofps_dock =	0.526	if stcode==	37;replace ctprofps_dock =	0.876	if stcode==	38;replace ctprofps_dock =	0.53	if stcode==	39;replace ctprofps_dock =	0.728	if stcode==	40;replace ctprofps_dock =	0.336	if stcode==	41;replace ctprofps_dock =	0.717	if stcode==	42;replace ctprofps_dock =	0.67	if stcode==	43;replace ctprofps_dock =	0.329	if stcode==	44;replace ctprofps_dock =	0.352	if stcode==	45;replace ctprofps_dock =	0.661	if stcode==	46;replace ctprofps_dock =	0.64	if stcode==	47;replace ctprofps_dock =	0.813	if stcode==	48;replace ctprofps_dock =	0.629	if stcode==	49;replace ctprofps_dock =	0.394	if stcode==	50;



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













