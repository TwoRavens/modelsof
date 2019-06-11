**LOG FOR POLICE PROJECT
**BY JACK M. MEWHIRTER 
**LAST UPDATE 12/14/2016



**THIS FILE CONTAINS THE "STEPS" TO REPLICATE OUR STUDY


**INDEX OF STEPS
//STEP 1= LOAD DATA
//STEP 2= CREATE WORKING DIRECTORY WHERE IMPUTED DATA FILES WILL BE SENT 
//STEP 3= IMPUTE DATA 
//STEP 4= CONDUCT NEGATIVE BINOMIAL REGRESSIONS USING CIVILIAN CASUALTIES  AS THE DEPENDENT VARIABLE
//STEP 5= CONDUCT OLS REGRESSIONS USING CHANGE IN CIVILIAN CASUALTIES  AS THE DEPENDENT VARIABLE
//STEP 6= CONDUCT NEGATIVE BINOMIAL REGRESSIONS USING DOG CASUALTIES  AS THE DEPENDENT VARIABLE
//STEP 7= CREATE PREDCITED VALUE GRAPH FOR CIVILIAN CASUALTIES
//STEP 8= CREATE PREDCITED VALUE GRAPH FOR CHANGE IN CIVILIAN CASUALTIES
//STEP 9= GENERATE EXPECTED VALUES OF DOG CASUALTIES WHEN LAGGED EXPENDITURES =MIN & =MAX VALUES
//STEP 10= REPREAT REGRESSIONS FROM STEPS 4&5 INCLUDING A DUMMY VARIABLE FOR NEVADA
//STEP 11= GENERATE SUMMARY STATISTICS 


**VARIABLE NAMES & DESCRIPTIONS
//logexplag= Value of 1033 transfers received the previous year (county level & logged)
//count = Number of civilians killed by police in a given year (county level)
//countlag= Number of civilians killed by police in the previous year (county level)
//dogkill= Number of dogs killed by police in a given year (county level)
//dogkilllag= Number of dogs killed by police in the previous year (county level)
//changecount = Change in the number of civilians killed by police between the current and previus year (county level)
//meancount= Average number of civilians killed by police between 2006=2014 (county level & logged)
//logcounty_vcrime= Number of violent crimes committed by civilians in a given year (county level) 
//logblack = Number of residents that are black (county level & logged)
//logpopulation= Toal number of residents (county level & logged) 
//drugest = Percentage of residents that admit to "using drugs" in the previous year (state level)
//logmedincome= Average income of residents (county level & logged) 




**STEP 1= LOAD DATA 
	    //NOTE THAT FILE NAME WILL HAVE TO BE UPDATED BY THE INDIVIDUAL REPLICATING THIS FILE. 
clear
set more off
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\POL0924.dta" 




**STEP 2= CREATE WORKING DIRECTORY WHERE IMPUTED DATA FILES WILL BE SENT 
		//NOTE THAT LOCATION WILL HAVE TO BE UPDATED BY THE INDIVIDUAL REPLICATING THIS FILE. 
cd "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps"



**STEP 3= IMPUTE DATA
	    //SET SEED AT 12345 TO ASSURE THAT IMPUTED FILES MATCH THE ONES THAT WE USED. CREATE 5 FILES
set seed 12345
mi set flongsep imputed 
mi register imputed changecount changecountdog meancount dogkilllag meancountdog logcounty_vcrime countlag logexplag logblack logpopulation logmedincome logexpenditures  drugest perpoverty year statedum state_vcrime_est locationid
mi impute chained (regress) logcounty_vcrime changecountdog meancountdog changecount logblack logpopulation drugest  logmedincome logexpenditures  perpoverty year statedum state_vcrime_est locationid, force add(5) 



//STEP 4= CONDUCT NEGATIVE BINOMIAL REGRESSIONS USING CIVILIAN CASUALTIES  AS THE DEPENDENT VARIABLE
mi estimate: nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)


//STEP 5= CONDUCT OLS REGRESSIONS USING CHANGE IN CIVILIAN CASUALTIES  AS THE DEPENDENT VARIABLE
mi estimate: reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)


//STEP 6= CONDUCT NEGATIVE BINOMIAL REGRESSIONS USING DOG CASUALTIES  AS THE DEPENDENT VARIABLE
mi estimate: nbreg dogkill dogkilllag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)



//STEP 7= CREATE PREDCITED VALUE GRAPH FOR CIVILIAN CASUALTIES
	    //THIS REQUIRES SEVERAL STEPS---LISTED BELOW
		
//7A=CLEAR DATA AND LOAD IMPUTED DATASET 1
set more off
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_1_imputed.dta"
//7B= CONDUCT NEGATIVE BINOMIAL REGRESSIONS (USING IMPUTED DATASET 1)USING CIVILIAN CASUALTIES (called count) AS THE DEPENDENT VARIABLE
nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
//7C= ESTIMATE PREDICTED VALUE OF Y AND STANDARED ERRORS AT VARYING LEVELS OF LAGGED  EXPENDITURES
margins, at(logexplag=(0(1)15))
//7D= CREATE A NEW DATASET THAT CONTAINS THE EXPECTED VALUE OF Y AND STANDARD ERRORS GENERATE IN THE PREVIOUS LINE
	//MEAN=EXPECTED CASUALTIES ; SE= STANDARD ERROR ; XVALUE=VALUE OF X
clear 
set obs 16
gen mean=.
gen se=.
gen xvalue=(_n)-1
//7E= IMPUT THE EXPECTED VALUE OF Y & SE AT THE CORRESPONDING VALUE OF X (GENERATE BY THE MARGINS COMMAND)
replace mean= .2750687  if  _n==1
replace se=  .0520252   if _n==1

replace mean=  .2921917  if  _n==2
replace se=  .0495202  if _n==2

replace mean=  .3103806 if  _n==3
replace se=   .0466328  if _n==3

replace mean= .3297017   if  _n==4
replace se=  .0433944  if _n==4

replace mean=.3502256 if  _n==5
replace se=    .0398895    if _n==5

replace mean= .3720272   if  _n==6
replace se=  .0363013  if _n==6

replace mean=  .3951858  if  _n==7
replace se=   .0329919    if _n==7

replace mean= .4197861    if  _n==8
replace se= .0306115    if _n==8

replace mean=  .4459178 if _n==9
replace se=  .0301284   if _n==9

replace mean=  .4736761   if  _n==10
replace se=  .0325149  if _n==10

replace mean= .5031624    if  _n==11
replace se=   .0381822   if _n==11

replace mean=   .5344843 if  _n==12
replace se=  .0469144     if _n==12

replace mean= .5677559  if  _n==13
replace se=   .058316   if _n==13

replace mean=   .6030986 if _n==14
replace se= .0721077  if _n==14

replace mean=  .6406415    if  _n==15
replace se=   .088166   if _n==15

replace mean= .6805213 if  _n==16
replace se= .1064832 if _n==16

//STEP 7F=SAVE THE FILE
save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta", replace


//STEP 7G= REPEAT STEPS 7A-7E FOR EVERY IMPUTED FILE
	     //MAKE SURE TO SAVE EXPECTED VALUES OF Y AND SE IN THE SAME FILES BUT WITH UNIQUE COLUMN IDS
		//FOR INSTANCE INSTEAD OF MEAN CREATE A COLUMN NAMED MEAN2 WHEN USING IMPUTED DATA FILE 2
		//USE MEAN3 WHEN USING DATA FILE 3

//2
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_2_imputed.dta"
nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta"
gen mean2=.
gen se2=.


replace mean2= .2931194 if  _n==1
replace se2= .0604713    if _n==1

replace mean2=  .3088631  if  _n==2
replace se2=     .0573039   if _n==2

replace mean2=      .3254524   if  _n==3
replace se2=   .0537121  if _n==3

replace mean2=  .3429327       if  _n==4
replace se2=  .0497048   if _n==4

replace mean2= .3613519   if  _n==5
replace se2=  .0453239  if _n==5

replace mean2=   .3807604  if  _n==6
replace se2= .0406744  if _n==6

replace mean2=   .4012113    if  _n==7
replace se2=   .035986   if _n==7

replace mean2= .4227607   if  _n==8
replace se2=      .0317293    if _n==8

replace mean2=   .4454675     if _n==9
replace se2=  .0287847   if _n==9

replace mean2=  .4693939    if  _n==10
replace se2=     .0284449  if _n==10

replace mean2=  .4946055   if  _n==11
replace se2=   .0317614      if _n==11

replace mean2=   .5211711  if  _n==12
replace se2=   .0387546   if _n==12

replace mean2=     .5491636   if  _n==13
replace se2=  .0487793   if _n==13

replace mean2=   .5786596 if _n==14
replace se2=  .0612522    if _n==14

replace mean2=   .6097399  if  _n==15
replace se2=   .075848       if _n==15

replace mean2=   .6424895  if  _n==16
replace se2=     .0924328      if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta", replace


//3

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_3_imputed.dta"
nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta"
gen mean3=.
gen se3=.

replace mean3= .2885681  if  _n==1
replace se3=  .0592133       if _n==1

replace mean3=  .3046583  if  _n==2
replace se3=  .0559992    if _n==2

replace mean3=   .3216457  if  _n==3
replace se3=   .0523562  if _n==3

replace mean3=    .3395802    if  _n==4
replace se3=    .0483059   if _n==4

replace mean3=  .3585148   if  _n==5
replace se3=    .0439158  if _n==5

replace mean3=   .3785051   if  _n==6
replace se3=  .0393417    if _n==6

replace mean3=  .3996101  if  _n==7
replace se3=  .0349101  if _n==7

replace mean3=   .4218918  if  _n==8
replace se3=    .0312593    if _n==8

replace mean3= .4454159   if _n==9
replace se3= .0294695   if _n==9

replace mean3= .4702518   if  _n==10
replace se3=  .0308169     if _n==10

replace mean3=  .4964724  if  _n==11
replace se3=   .0359431    if _n==11

replace mean3=  .5241551    if  _n==12
replace se3=    .0445307    if _n==12

replace mean3=  .5533813     if  _n==13
replace se3=    .0559537   if _n==13

replace mean3=.5842371   if _n==14
replace se3=    .0697651    if _n==14

replace mean3= .6168134  if  _n==15
replace se3=  .0857448     if _n==15

replace mean3= .6512061   if  _n==16
replace se3=    .1038246    if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta", replace

//4
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_4_imputed.dta"
nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta"
gen mean4=.
gen se4=.

replace mean4=  .2841557  if  _n==1
replace se4= .0628465   if _n==1

replace mean4=  .300599    if  _n==2
replace se4=  .059691    if _n==2

replace mean4=     .3179939   if  _n==3
replace se4=    .0560609  if _n==3

replace mean4=   .3363953     if  _n==4
replace se4=    .0519637    if _n==4

replace mean4=    .3558615   if  _n==5
replace se4=    .047446      if _n==5

replace mean4=   .3764542   if  _n==6
replace se4=   .0426299    if _n==6

replace mean4=     .3982386 if  _n==7
replace se4=   .037788    if _n==7

replace mean4=    .4212835   if  _n==8
replace se4=       .0334831   if _n==8

replace mean4=  .445662   if _n==9
replace se4=   .0307569   if _n==9

replace mean4=    .4714512   if  _n==10
replace se4=    .0310654   if _n==10

replace mean4=   .4987328   if  _n==11
replace se4=      .035455      if _n==11

replace mean4= .527593   if  _n==12
replace se4=      .0438207   if _n==12

replace mean4=   .5581234     if  _n==13
replace se4=   .055466   if _n==13

replace mean4=    .5904204   if _n==14
replace se4=    .0698268       if _n==14

replace mean4=   .6245863     if  _n==15
replace se4=     .0866137    if _n==15

replace mean4=    .6607294    if  _n==16
replace se4=    .1057308   if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta", replace

//5
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_5_imputed.dta"
nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
margins, at(logexplag=(0(1)15))
marginsplot


clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata3.dta"
gen mean5=.
gen se5=.

replace mean5=  .2920886   if  _n==1
replace se5=    .0617437   if _n==1

replace mean5=    .3079392   if  _n==2
replace se5=   .0582246    if _n==2

replace mean5=       .32465   if  _n==3
replace se5=     .0542506   if _n==3

replace mean5=   .3422676      if  _n==4
replace se5=     .0498405   if _n==4

replace mean5=  .3608413   if  _n==5
replace se5=     .0450584    if _n==5

replace mean5=     .3804229   if  _n==6
replace se5=  .0400579    if _n==6

replace mean5=    .4010672        if  _n==7
replace se5=   .0351708     if _n==7

replace mean5=  .4228317   if  _n==8
replace se5=     .0310705   if _n==8

replace mean5=    .4457773    if _n==9
replace se5=   .0289458   if _n==9

replace mean5= .4699681    if  _n==10
replace se5=     .0302401  if _n==10

replace mean5=    .4954717  if  _n==11
replace se5=     .0356308   if _n==11

replace mean5=      .5223592 if  _n==12
replace se5=   .0446605    if _n==12

replace mean5=   .5507058    if  _n==13
replace se5=    .0565794   if _n==13

replace mean5=   .5805907  if _n==14
replace se5=  .0708898      if _n==14

replace mean5=  .6120974  if  _n==15
replace se5=  .0873571   if _n==15

replace mean5=   .6453138  if  _n==16
replace se5=    .1059093   if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\mefdata3.dta", replace


//STEP 7H= CREAT PREDICTED VALUES USING ESTIMATES FROM PREVIOUS GRAPHS (90% CI)
egen rowmean=rowmean( mean mean2 mean3 mean4 mean5)
egen rowde=rowmean( se se2 se3 se4 se5)
serrbar rowmean rowde xvalue, scale (1.64) 














**STEP 8= CREATE PREDCITED VALUE GRAPH FOR CHANGE IN CIVILIAN CASUALTIES
        //REPEAT STEP 7 USING CHANGE IN CIVILIAN CASUSALTIES AS THE DV (NOTE: USE OLS REG INSTEAD OF NBREG)
set more off
**
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_1_imputed.dta"
reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
margins, at(logexplag=(0(1)15))
marginsplot, level(90)

clear 
set obs 16
gen mean=.
gen se=.
gen xvalue=(_n)-1


replace mean= -.0646516   if  _n==1
replace se=  .0328283     if _n==1

replace mean=   -.0485224    if  _n==2
replace se=    .0254345     if _n==2

replace mean=   -.0323932    if  _n==3
replace se= .0195233  if _n==3

replace mean=   -.016264     if  _n==4
replace se=  .0167464   if _n==4

replace mean=   -.0001347   if  _n==5
replace se=   .0185676     if _n==5

replace mean=      .0159945   if  _n==6
replace se=  .0239605    if _n==6

replace mean=    .0321237    if  _n==7
replace se=   .0311206   if _n==7

replace mean=   .0482529    if  _n==8
replace se=  .0390884     if _n==8

replace mean=   .0643821       if _n==9
replace se=   .047459     if _n==9

replace mean=     .0805113    if  _n==10
replace se=    .0560521    if _n==10

replace mean=  .0966405   if  _n==11
replace se=    .0647793   if _n==11

replace mean=  .1127697  if  _n==12
replace se=  .0735929      if _n==12

replace mean=  .1288989    if  _n==13
replace se=    .0824651     if _n==13

replace mean= .1450281  if _n==14
replace se=      .091379   if _n==14

replace mean=  .1611573    if  _n==15
replace se=   .1003233     if _n==15

replace mean=    .1772865  if  _n==16
replace se=  .1092907      if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\\mefdata4.dta", replace
serrbar mean se xvalue, scale (1.96) 


//2
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_2_imputed.dta"
 reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta"
gen mean2=.
gen se2=.


replace mean2=  -.080622    if  _n==1
replace se2=       .033964   if _n==1

replace mean2=      -.060344    if  _n==2
replace se2=   .0252975      if _n==2

replace mean2=   -.0400659       if  _n==3
replace se2= .0180591   if _n==3

replace mean2=     -.0197879    if  _n==4
replace se2=   .0145623  if _n==4

replace mean2=   .0004901    if  _n==5
replace se2=     .0172554     if _n==5

replace mean2=   .0207682        if  _n==6
replace se2=   .0241495      if _n==6

replace mean2=  .0410462       if  _n==7
replace se2=  .0326864    if _n==7

replace mean2=   .0613243      if  _n==8
replace se2=      .0418733   if _n==8

replace mean2=   .0816023        if _n==9
replace se2=     .0513624    if _n==9

replace mean2=     .1018803     if  _n==10
replace se2=   .0610129       if _n==10

replace mean2=  .1221584    if  _n==11
replace se2=  .0707589       if _n==11

replace mean2=   .1424364  if  _n==12
replace se2=      .0805657  if _n==12

replace mean2=     .1627145    if  _n==13
replace se2=     .0904134      if _n==13

replace mean2= .1829925   if _n==14
replace se2=      .1002901     if _n==14

replace mean2=     .2032705   if  _n==15
replace se2=       .110188   if _n==15

replace mean2=   .2235486    if  _n==16
replace se2=    .1201018    if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta", replace


//3
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_3_imputed.dta"
 reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta"
gen mean3=.
gen se3=.

replace mean3=  -.0687698   if  _n==1
replace se3= .0316366      if _n==1

replace mean3=    -.0515707   if  _n==2
replace se3=  .0237831     if _n==2

replace mean3=   -.0343717  if  _n==3
replace se3=   .0173362    if _n==3

replace mean3=  -.0171727     if  _n==4
replace se3=  .0143388    if _n==4

replace mean3=   .0000264     if  _n==5
replace se3=     .0167574    if _n==5

replace mean3=    .0172254   if  _n==6
replace se3=    .0229383   if _n==6

replace mean3=    .0344245  if  _n==7
replace se3=    .0306866     if _n==7

replace mean3=    .0516235    if  _n==8
replace se3=    .039081       if _n==8

replace mean3= .0688226     if _n==9
replace se3=  .047782        if _n==9

replace mean3=     .0860216    if  _n==10
replace se3=    .0566487    if _n==10

replace mean3=    .1032207   if  _n==11
replace se3=  .0656138      if _n==11

replace mean3=   .1204197   if  _n==12
replace se3=     .074642    if _n==12

replace mean3=  .1376187   if  _n==13
replace se3=    .0837127      if _n==13

replace mean3=   .1548178    if _n==14
replace se3=  .0928136    if _n==14

replace mean3=    .1720168    if  _n==15
replace se3=   .1019365  if _n==15

replace mean3=    .1892159    if  _n==16
replace se3=   .1110761      if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta", replace



//4
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_4_imputed.dta"
 reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(1)15))
marginsplot

clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta"
gen mean4=.
gen se4=.

replace mean4=   -.0643864  if  _n==1
replace se4=     .032189    if _n==1

replace mean4=    -.048326  if  _n==2
replace se4=    .0241973   if _n==2

replace mean4=   -.0322657     if  _n==3
replace se4=     .0176031  if _n==3

replace mean4=    -.0162054    if  _n==4
replace se4=    .0144641  if _n==4

replace mean4=   -.0001451    if  _n==5
replace se4=    .0168386   if _n==5

replace mean4=    .0159152  if  _n==6
replace se4=    .0230835      if _n==6

replace mean4= .0319755    if  _n==7
replace se4=      .0309377     if _n==7

replace mean4=   .0480358    if  _n==8
replace se4= .0394514     if _n==8

replace mean4=  .0640961   if _n==9
replace se4=    .0482771    if _n==9

replace mean4=   .0801564    if  _n==10
replace se4=    .0572706   if _n==10

replace mean4=    .0962167   if  _n==11
replace se4=      .0663637    if _n==11

replace mean4=    .112277      if  _n==12
replace se4=   .0755205    if _n==12

replace mean4=   .1283373     if  _n==13
replace se4=   .0847204  if _n==13

replace mean4=    .1443976  if _n==14
replace se4=    .0939506    if _n==14

replace mean4=    .1604579     if  _n==15
replace se4=     .1032031     if _n==15

replace mean4=   .1765182    if  _n==16
replace se4=    .1124723     if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta", replace




//5
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_5_imputed.dta"
 reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(1)15))
marginsplot


clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\mefdata4.dta"
gen mean5=.
gen se5=.

replace mean5=   -.0633892   if  _n==1
replace se5=   .032438     if _n==1

replace mean5=      -.047588   if  _n==2
replace se5=    .0244067     if _n==2

replace mean5=    -.0317867     if  _n==3
replace se5=   .0177914   if _n==3

replace mean5=    -.0159854    if  _n==4
replace se5=   .0146551    if _n==4

replace mean5=     -.0001841   if  _n==5
replace se5=   .0170412   if _n==5

replace mean5=     .0156171     if  _n==6
replace se5=   .0233114    if _n==6

replace mean5=      .0314184   if  _n==7
replace se5=      .0312062      if _n==7

replace mean5=     .0472197       if  _n==8
replace se5=   .0397696    if _n==8

replace mean5=     .0630209       if _n==9
replace se5=   .0486499  if _n==9

replace mean5=    .0788222     if  _n==10
replace se5=   .0577008  if _n==10

replace mean5=     .0946235    if  _n==11
replace se5=     .0668532  if _n==11

replace mean5= .1104248    if  _n==12
replace se5=   .0760704  if _n==12

replace mean5=     .126226      if  _n==13
replace se5=    .0853314   if _n==13

replace mean5=  .1420273     if _n==14
replace se5=     .0946234    if _n==14

replace mean5=   .1578286    if  _n==15
replace se5=    .103938   if _n==15

replace mean5=     .1736298   if  _n==16
replace se5=   .1132697   if _n==16

save "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\mefdata4.dta", replace


//GRAPH
egen rowmean=rowmean( mean mean2 mean3 mean4 mean5)
egen rowde=rowmean( se se2 se3 se4 se5)
serrbar rowmean rowde xvalue, scale (1.64) 





**STEP 9= GENERATE EXPECTED VALUES OF DOG CASUALTIES WHEN LAGGED EXPENDITURES =MIN & =MAX VALUES
//STEP 9A= CALCULATE EXPEXTED VALUE WHEN X=MIN & MAX USING IMPUTED DATASET 1
clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_1_imputed.dta"
nbreg dogkill meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(15)15))
 //  .0094529 
 //  .1525221
 
 //STEP 9B= ALCULATE EXPEXTED VALUE WHEN X=MIN & MAX USING DATASETS 2-5
 clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_2_imputed.dta"
nbreg dogkill meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(15)15))
  //  .009485 
 //.1580918  
 
 clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_3_imputed.dta"
nbreg dogkill meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(15)15))
  //   .0091827
 //   .1622725
 
 clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_4_imputed.dta"
nbreg dogkill meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(15)15))
  //  .0084454  
 //  .1723197  
 
 
 clear 
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps\_5_imputed.dta"
nbreg dogkill meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag , cluster(locationid)
 margins, at(logexplag=(0(15)15))
//    .009277 
//    .1608573

** CALCULATE MEAN OF EXPECTED VALUES ACROSS ESTIMATES
***MEAN OF MIN EST= .0091686
** MEAN OF MAX EST= .16121268 
**change= 1658% increase



**STEP 10= REPREAT REGRESSIONS FROM STEPS 4&5 INCLUDING A DUMMY VARIABLE FOR NEVADA
//REPREAT STEPS 1-5 THIS TIME INCLUDING A DUMMY VARIABLE FOR NEVADA
clear
set more off
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\POL0924.dta" 
cd "C:\Users\Mewhirjk\Desktop\Working Projects\1033\imps2"
mi set flongsep imputed 
mi register imputed changecount changecountdog meancount dogkilllag meancountdog logcounty_vcrime countlag logexplag logblack logpopulation logmedincome logexpenditures  drugest perpoverty year ctdummy medummy nvdummy state_vcrime_est locationid
mi impute chained (regress) logcounty_vcrime changecountdog meancountdog changecount logblack logpopulation drugest  logmedincome logexpenditures  perpoverty year ctdummy medummy nvdummy state_vcrime_est locationid, force add(5) 

mi estimate: nbreg count countlag logcounty_vcrime logblack logpopulation drugest logmedincome logexplag nvdummy, cluster(locationid)
mi estimate: reg changecount meancount logcounty_vcrime  logblack logpopulation drugest logmedincome logexplag nvdummy , cluster(locationid)



**STEP 11= GENERATE SUMMARY STATISTICS 
clear
set more off
use "C:\Users\Mewhirjk\Desktop\Working Projects\1033\POL0924.dta" 
sum count dogkill logexplag logcounty_vcrime logblack logpopulation drugest logmedincome 
