use ".../replication/replication_main.dta"

*** Table 3

reg pos_lm left right  , r
         outreg2 using poss_effects, bdec(2) sdec(2) side

          
 forval num = 1/6 {
         reg pos_lm left right if study_issue ==`num' , r
         outreg2 using poss_effects.xls, append bdec(2) sdec(2) side

          }


 forval num = 1/6 {
         reg pos_rm left right if study_issue ==`num' , r
         outreg2 using poss_effects.xls, append bdec(2) sdec(2) side

          }
          
           forval num = 1/4 {
         reg pos_own left right if study_issue ==`num' , r
         outreg2 using poss_effects.xls, append bdec(2) sdec(2) side

          }
          
areg pos_lm left right, a (study_issue)
outreg2 using poss_effectss, bdec(2) sdec(2) side
areg pos_rm left right, a (study_issue)
outreg2 using poss_effectss.xls, bdec(2) sdec(2) side append


*** Table 4

areg lib left right, a (study_issue) cl(id)
outreg2 left right using main_effects.xls, bdec(2) sdec(2) side

areg lib left right pos_own, a (study_issue) cl(id)
outreg2 using main_effects.xls, bdec(2) sdec(2) side append


           forval num = 1/6 {
         reg lib left right if study_is ==`num' , r
         outreg2 left right using main_effects.xls, append bdec(2) sdec(2) side
          }
          
                     forval num = 1/4 {
         reg lib left right pos_own if study_is ==`num' , r
         outreg2 lib left right using main_effects.xls, append bdec(2) sdec(2) side
          }
          
*******************************
***Table A1 *
*******************************

collapse (meankee) female age black hispanic college democrat independent republican, by (study)
use ".../replication/replication_main.dta", clear
collapse (sd) female age black hispanic college democrat independent republican, by (study)

*******************************
***Table A2 *
*******************************
		  
mlogit condition female age black hispanic college democrat independent republican
outreg2 using balancetable.xls, bdec(2) sdec(2)  e(chi2 p)

           forval num = 1/6 {
         mlogit condition female age black hispanic college democrat independent republican if study_is ==`num' 
		  outreg2 using balancetable.xls, bdec(2) sdec(2)  e(chi2 p) append
		  }

*******************************
***Supporting information
*******************************


**************************************************************          
*** Table S1 - Spatial advantage by study and treatment group *
**************************************************************

              areg rel left right  , a(study_iss) r
              outreg2  using dist_effects.xls, append bdec(2) sdec(2)

           forval num = 1/4 {
         reg rel left right if study_iss ==`num' ,  r
         outreg2  using dist_effects.xls, append bdec(2) sdec(2)
          }
          
          
  ************************************************************** 
*Table S2: Ruling out compromise effects
************************************************************** 

reg lib both if cond!="Right" & issue=="abortion", cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)         
reg lib both if cond!="Left" & issue=="abortion", cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)  append
reg lib both if cond!="Right" & issue=="minimum wage", cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)  append
reg lib both if cond!="Left" & issue=="minimum wage", cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)  append

reg lib both if cond!="Right" , cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)         
reg lib both if cond!="Left" , cl(id)
outreg2 using compr_effects.xls, bdec(2) sdec(2)         

          
**************************************************************          
*** Table S3: Own position by treatment group ***
**************************************************************
          
table study_is condition, c (mean pos_own sem pos_own)

**************************************************************          
*** Table S4 - Preference reversals by ideal points
**************************************************************          

areg lib left right, a (study_issue) r
outreg2 using h_effects.xls, bdec(2) sdec(2)


           forval num = 1/5 {
         areg lib left right if ccccc ==`num' , a(study_issue) r
		          outreg2 left right using h_effects.xls, append bdec(2) sdec(2)

          }
         
             
**************************************************************          
*** Table S5 - Preference reversals by PID
**************************************************************          
          
         areg lib left right if pid ==1 , a(study_issue) cl(id)
outreg2 using pid_eff, bdec(2) sdec(2)


           forval num = 2/7 {
         areg lib left right if pid ==`num' , a(study_issue) cl(id)
         outreg2 left right using pid_eff.tex, append bdec(2) sdec(2)
          }
          
**************************************************************          
*** Table S6 - Preference reversals by political sophistication *
**************************************************************            
          
          areg lib left right if correct_==0, a (study_issue) cl (id)
          outreg2 using soph_effects.xls, bdec(2) sdec(2)
          areg lib left right if correct_==1, a (study_issue) cl(id)
outreg2 using soph_effects.xls, bdec(2) sdec(2)  append        
areg lib left right if col==0, a (study_issue) cl(id)
outreg2 using soph_effects.xls, bdec(2) sdec(2) append
          areg lib left right if col==1, a (study_issue) cl(id)
outreg2 using soph_effects.xls, bdec(2) sdec(2) append

**************************************************************          
*** Table S7 - The perceived extremity of policy alternatives across issues *
************************************************************** 

table study_issue, c (mean pos_le mean pos_re)
table study_issue if control==1, c (mean pos_lm mean pos_rm)

**************************************************************          
*** Table S8 - Alternative specifications for the main results *
**************************************************************      

areg lib left right, a (study_issue) cl(id)
outreg2 using multi.xls, bdec(2) sdec(2)
xtreg lib left right i.study_issue, cl(id)
outreg2 using multi.xls, bdec(2) sdec(2) append
xtmixed lib left right || study_issue:
outreg2 using multi.xls, bdec(2) sdec(2) append
xtmixed lib left right || study_issue: left right || study_issue:
outreg2 using multi.xls, bdec(2) sdec(2) append




**************************************************************          
*** Table S9: The viability of policy alternatives *
************************************************************** 


use ".../replication/replication_followup.dta"
table pos issue, c (mean via )


