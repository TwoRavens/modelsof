 
* ************************************** *;
* ************************************** *;
* ************************************** *;
* The Rise Predicts the Fall             *;
*                                        *;
* ISQ Forthcoming                        *;
* Jun Koga Sudduth & Curtis Bell         *;
* April 2017                             *;
* ************************************** *;
* ************************************** *;
* ************************************** *;

**  
** Data        
**  

* Please read "Readme(data)" file! We describe key variables (i.e. entry and exit variables) used in our empirical analyses in the "Readme(data)" file. 

use "C:\Users\pjb13215\Dropbox\Entry & Exit manner in Dictatorships\FINAL SUBMISSION TO ISQ\ISQ_Sudduth_Bell_entryexit.dta", clear 

** 
** Table Results 
** 

* Model 1:   
#delimit; 
mlogit multiexit  c.log_tenure##i.reg_entry  i.uncoord_entry##c.log_tenure c.log_tenure##i.foreign_entry  lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid if  puppet!=1  , robust cluster(ccode); 

* Model 2 : 
#delimit; 
mlogit multiexit   c.log_tenure##rebelentry  c.log_tenure##regimecoup_entry  c.log_tenure##foreign_entry    c.log_tenure##leadercoup_entry
 c.log_tenure##ireg_election_entry  lngdp growth   military monarch party  log_milper age  dwin dlose ddraw incid if   puppet!=1 , robust cluster(ccode); 
 

* Model 3: 
#delimit; 
mlogit multiexit   c.log_tenure##rebelentry  c.log_tenure##regimecoup_entry  c.log_tenure##foreign_entry    
 c.log_tenure##first_election_entry   c.log_tenure##reg_election_entry lngdp growth   military monarch party  log_milper 
 age  dwin dlose ddraw incid if   puppet!=1 , robust cluster(ccode); 
 
  
 
* Model 4  
#delimit; 
logit  regimecoup_exit  c.log_tenure##regimecoup_entry  c.log_tenure##leadercoup_entry   
lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid if  puppet!=1 , robust cluster(ccode); 


*Model 5
#delimit; 
logit  regimecoup_exit  c.log_tenure    regimecoup_entry  leadercoup_entry   
lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid if  puppet!=1 , robust cluster(ccode); 

* Model 6 
#delimit; 
logit  leadercoup_exit  c.log_tenure##regimecoup_entry  c.log_tenure##leadercoup_entry   
lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid if  puppet!=1 , robust cluster(ccode); 
 
* Model 7
#delimit; 
logit   leadercoup_exit  c.log_tenure   regimecoup_entry  leadercoup_entry  
lngdp growth  military monarch  party log_milper 
age   dwin dlose ddraw incid if  puppet!=1 , robust cluster(ccode); 
   
 
 
 
 
** 
** Figures (using R)
**
 
**
** Figure 1 & 2 

* Variacne-covariance matrix (we'll use it in R to make figures) 
gen reg_tenure= reg_entry*log_tenure  
gen uncoord_tenure= uncoord_entry*log_tenure
gen foreign_tenure = foreign_entry*log_tenure 

#delimit;
mlogit multiexit  reg_entry log_tenure uncoord_entry foreign_entry  lngdp growth  military monarch party log_milper age   
        dwin dlose ddraw incid reg_tenure uncoord_tenure foreign_tenure   if  puppet!=1 , robust cluster(ccode) ;
  
* Get the variance covariance matrix so that we can use info in R (We saved this in "VCVMatrix_v1.csv")
# delimit; 
drawnorm a b c d e f g h i j k l m n o p q r s  a2 b2 c2 d2 e2 f2 g2 h2 i2 j2 k2 l2 m2 n2 o2 p2 q2 r2 s2
 a3 b3 c3 d3 e3 f3 g3 h3 i3 j3 k3 l3 m3 n3 o3 p3 q3 r3 s3 a4 b4 c4 d4 e4 f4 g4 h4 i4 j4 k4 l4 m4 n4 o4 p4 q4 r4 s4
 a5 b5 c5 d5 e5 f5 g5 h5 i5 j5 k5 l5 m5 n5 o5 p5 q5 r5 s5 a6 b6 c6 d6 e6 f6 g6 h6 i6 j6 k6 l6 m6 n6 o6 p6 q6 r6 s6 , n(10000) means(e(b)) cov(e(V)) clear; 

 
* ******************************************************************************************************************************** *;
* Note that (1) you need to delete the "base DV" category/clumns(i.e. staying power), and then (2) change the positions of the     *;
* "constant" column -- that is, copy the last column of each exit DV category and insert it in the first column for the category.  *;                                                                                
* I then saved it in the "VCVmatrix_v1.csv"                                                                                        *;
* ******************************************************************************************************************************** *; 
   
  

  
**
** Figure 3 

* Model 2  
gen rebel_tenure= rebelentry*log_tenure  
gen regimecoup_tenure=regimecoup_entry*log_tenure
gen leadercoup_tenure = leadercoup_entry*log_tenure 
gen ireg_election_tenure = ireg_election_entry*log_tenure 
 
*drop b* 

#delimit; 
mlogit multiexit  rebelentry log_tenure regimecoup_entry leadercoup_entry ireg_election_entry  foreign_entry  lngdp growth  military monarch party 
   log_milper age dwin dlose ddraw incid rebel_tenure regimecoup_tenure  leadercoup_tenure    ireg_election_tenure   foreign_tenure   if  puppet!=1 ,  robust cluster(ccode) ;
 
 
* Get the variance covariance matrix so that we can use info in R  (Save as "VCVMatrix_v2.csv")
# delimit; 
drawnorm a b c d e f g h i j k l m n o p q r s t u v x a2 b2 c2 d2 e2 f2 g2 h2 i2 j2 k2 l2 m2 n2 o2 p2 q2 r2 s2 t2 u2 v2 x2
 a3 b3 c3 d3 e3 f3 g3 h3 i3 j3 k3 l3 m3 n3 o3 p3 q3 r3 s3 t3 u3 v3 x3 a4 b4 c4 d4 e4 f4 g4 h4 i4 j4 k4 l4 m4 n4 o4 p4 q4 r4 s4 t4 u4 v4 x4 
a5 b5 c5 d5 e5 f5 g5 h5 i5 j5 k5 l5 m5 n5 o5 p5 q5 r5 s5 t5 u5 v5 x5 a6 b6 c6 d6 e6 f6 g6 h6 i6 j6 k6 l6 m6 n6 o6 p6 q6 r6 s6 t6 u6 v6 x6  , n(10000) means(e(b)) cov(e(V)) clear; 

* *********************************************************************************************************************************** *;
* See the above comments. I saved this as "VCVmatrix_v2.csv""
* *********************************************************************************************************************************** *;
  
    
  
  
* Model 3 
   
gen felection_tenure= log_tenure*first_election_entry   
gen relection_tenure=log_tenure*reg_election_entry 
 
*drop b* 

#delimit; 
mlogit multiexit  rebelentry log_tenure regimecoup_entry foreign_entry first_election_entry  reg_election_entry lngdp growth  military monarch party 
   log_milper age dwin dlose ddraw incid rebel_tenure regimecoup_tenure foreign_tenure  felection_tenure relection_tenure if  puppet!=1 ,  robust cluster(ccode) ;
 
# delimit; 
drawnorm a b c d e f g h i j k l m n o p q r s t u v x a2 b2 c2 d2 e2 f2 g2 h2 i2 j2 k2 l2 m2 n2 o2 p2 q2 r2 s2 t2 u2 v2 x2
 a3 b3 c3 d3 e3 f3 g3 h3 i3 j3 k3 l3 m3 n3 o3 p3 q3 r3 s3 t3 u3 v3 x3 a4 b4 c4 d4 e4 f4 g4 h4 i4 j4 k4 l4 m4 n4 o4 p4 q4 r4 s4 t4 u4 v4 x4 
a5 b5 c5 d5 e5 f5 g5 h5 i5 j5 k5 l5 m5 n5 o5 p5 q5 r5 s5 t5 u5 v5 x5 a6 b6 c6 d6 e6 f6 g6 h6 i6 j6 k6 l6 m6 n6 o6 p6 q6 r6 s6 t6 u6 v6 x6  , n(10000) means(e(b)) cov(e(V)) clear; 

* *********************************************************************************************************************************** *;                                                                 *;
* Saved as "VCVmatrix_v2_2.csv""
* *********************************************************************************************************************************** *;
  
     
 
 
  
* Model 4 (Coup -trap logit model)
 
gen regimecoup_tenure=regimecoup_entry*log_tenure
gen leadercoup_tenure = leadercoup_entry*log_tenure 
 
#delimit; 
logit  regimecoup_exit  regimecoup_entry log_tenure  leadercoup_entry   
lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid  regimecoup_tenure  leadercoup_tenure   if  puppet!=1 , robust cluster(ccode); 

   
drawnorm a b c d e f g h i j k l m n o p q , n(10000) means(e(b)) cov(e(V)) clear ;


* *********************************************************************************************************************************** *;                                                                 *;
* Saved as "VCVmatrix_v3.csv""
* *********************************************************************************************************************************** *;
  
     

* Model 6 

#delimit;   
logit  leadercoup_exit regimecoup_entry log_tenure  leadercoup_entry   
lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid regimecoup_tenure  leadercoup_tenure  if  puppet!=1 , robust cluster(ccode); 


drawnorm a b c d e f g h i j k l m n o p q , n(10000) means(e(b)) cov(e(V)) clear ;


* *********************************************************************************************************************************** *;                                                                 *;
* Saved as "VCVmatrix_v4.csv""
* *********************************************************************************************************************************** *;
   
 
 
 
 
 
 
 
 
 
  
**                                
**                                
** Online Appendix Table Results   
**  
**
                               

* We test our hypotheses treating natural death exit as a censored category. 

gen multiexit3 = multiexit 
replace multiexit3 = 0 if multiexit==5 

tabulate multiexit multiexit3 

* DV: Multiexit3  ==0 if no exit or  natural death exit,
*                =1 if Coalition-competing exit including Regime Coup, Successful Rebellion and  Protest.
*               =2 if Coalitiln-Circumventing : including Foreign overthrow and Assassination
*               =3 if Coalition-Collapsing: including Leader coup and Legal Removal
*               =4 if Voluntary Resignation Exit including Resignation, health and Resignation, election/selection
*                

     

* Model 1 in Online Appendix
#delimit; 
mlogit multiexit3  c.log_tenure##reg_entry  uncoord_entry##c.log_tenure c.log_tenure##foreign_entry  lngdp growth  military monarch party log_milper 
age   dwin dlose ddraw incid if  puppet!=1  , robust cluster(ccode); 

          
* Model 2  in Online Appendix
   
#delimit; 
mlogit multiexit3   c.log_tenure##rebelentry  c.log_tenure##regimecoup_entry  c.log_tenure##foreign_entry    c.log_tenure##leadercoup_entry
 c.log_tenure##ireg_election_entry
lngdp growth   military monarch party  log_milper 
 age  dwin dlose ddraw incid if   puppet!=1 , robust cluster(ccode); 
    
     
* Model 3 in Online Appendix
  
 
#delimit; 
mlogit multiexit3  c.log_tenure##rebelentry  c.log_tenure##regimecoup_entry  c.log_tenure##foreign_entry    
 c.log_tenure##first_election_entry   c.log_tenure##reg_election_entry
lngdp growth   military monarch party  log_milper 
 age  dwin dlose ddraw incid if   puppet!=1 , robust cluster(ccode); 
 
 
 
 
  
 
  
  
  
** 
** End. 
**
 
 
 
