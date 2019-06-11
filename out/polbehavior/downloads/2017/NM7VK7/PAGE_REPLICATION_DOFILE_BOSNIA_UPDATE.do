	 
*use PAGE_REPLICATION_DATA_BOSNIA.dta, clear 
	 
	*Table 1 
  ****************************************  
	  *Reporting
	  tab REPORT_WOMEN
	  tab REPORT_GAY
	  
	  *Responsible
	  tab RESPONGAY
	  tab RESPONWOMEN
	  
	  *Activism
	  tab ACTIVISTWOMEN
	  tab ACTIVISTGAY
	  
	  *Closeness
	  tab WomenClose
	  tab GayClose
	 
	 *Table 2
****************************************  
	  *Giving the EU control of gay rights
	  mean EUCONTROLGAY [pweight=rim_w_1] if GayClose>5
	  mean EUCONTROLGAY [pweight=rim_w_1] if GayClose<5
	  
	  *Giving the EU control of women’s rights
	  mean EUCONTROLWOMEN [pweight=rim_w_1] if GayClose>5
	  mean EUCONTROLWOMEN [pweight=rim_w_1] if GayClose<5
	  
	  *Equal treatment for gay people is important
	  mean GAYIMPORTANT [pweight=rim_w_1] if GayClose>5
	  mean GAYIMPORTANT [pweight=rim_w_1] if GayClose<5
	  
	  *Voting for a pro-gay rights political party
	  mean PROGAYPARTY [pweight=rim_w_1] if GayClose>5
	  mean PROGAYPARTY [pweight=rim_w_1] if GayClose<5
	  
	  *Trust in EU institutions
	  mean EUTRUST [pweight=rim_w_1] if GayClose>5
	  mean EUTRUST [pweight=rim_w_1] if GayClose<5
	  
	  *Dissatisfaction with the government
	  mean GOVSATIS [pweight=rim_w_1] if GayClose>5
	  mean GOVSATIS [pweight=rim_w_1] if GayClose<5
	  
	  *Ideology (Right - Left)
	  mean Ideology [pweight=rim_w_1] if GayClose>5
	  mean Ideology [pweight=rim_w_1] if GayClose<5
	  
	  *Political Knowledge
	  mean SophScore [pweight=rim_w_1] if GayClose>5
	  mean SophScore [pweight=rim_w_1] if GayClose<5
	 
	  *Table 3 
******************************************
	   reg EUCONTROLGAY GayClose EUTRUST [pweight=rim_w_1]
	 
	   reg EUCONTROLGAY GayClose EUTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1]
  
	   reg EUCONTROLGAY GayClose EUTRUST GayTRUST [pweight=rim_w_1]
	  
	   reg EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1]
	 
	   reg EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1] if entitet==1 
		
	   reg EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1] if entitet==2
	   
	 
	 *Appendix Table 1
******************************************
	  reg EUCONTROLWOMEN GayClose EUTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1]

	  reg EUCONTROLWOMEN GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1]

	 *Appendix Table 2 
******************************************
      tobit EUCONTROLGAY GayClose EUTRUST [pweight=rim_w_1], ll(0) 
	 
	  tobit EUCONTROLGAY GayClose EUTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1], ll(0) 
  
	  tobit EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1], ll(0) 
	 
	  tobit EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1] if entitet==1, ll(0)  
		
	  tobit EUCONTROLGAY GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1] if entitet==2, ll(0) 
	
	  tobit EUCONTROLWOMEN GayClose EUTRUST GayTRUST GOVSATIS SophScore Ideology GAYIMPORTANT [pweight=rim_w_1], ll(0) 

	 *Appendix Table 3
******************************************
	 #delimit ;
	 reg EUCONTROLGAY GayClose EUTRUST Ideology GOVSATIS SophScore 
	 GAYIMPORTANT BosniacCloseX CroatCloseX SerbCloseX EuropeanClose BiHClose [pweight=rim_w_1];
	 
	 #delimit ;
	 reg EUCONTROLGAY GayClose EUTRUST Ideology GOVSATIS SophScore 
	 GAYIMPORTANT BosniacCloseX CroatCloseX SerbCloseX EuropeanClose BiHClose unemployed income [pweight=rim_w_1];
