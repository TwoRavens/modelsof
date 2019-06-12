*Generating PPO summary categories 
**Examining and re-coding PPO when left uncoded
*Internal Political Change
label data "updated and cleaned March 19 2003"
*
**NOTE: September 2015
*
* 
*The following commands were employed in the initial processing and cleaning of the dataset.  The commands have 
*been previously executed and the results saved in the dataset (now RCE_USUOF_final.dta)
*
* some variables no longer exist. Specifically, the variable “roper” was the former “roper accession number” for 
*each question in the earlier version of the iPoll archive.  It no longer exists in web-based version.  However, using *the variables begin, edate, organiz, and phrase, users can retrieve each individual question in the dataset
*
*
*


***Coding PPO


generate IPC=0
label variable IPC "Internal political change"
replace IPC=1 if helpend==1 
*Not IPC if neutral peacekeeping is listed in question:
replace IPC=0 if helpend==1 & peackeep==1 & takeside==0
replace IPC=1 if  takeside==1
replace IPC=1 if  chggovt==1
replace IPC=1 if  assass_==1
*Humanitarian Intervention
gener HUM=0
replace HUM=1 if  humanit2==1 & IPC==0
replace HUM=1 if   protect2==1 & IPC==0
*table HUM IPC
gener PKEEP=0
replace PKEEP=1 if peackeep==1 & IPC==0 & HUM==0
replace PKEEP=1 if protect1==1 & IPC==0 & HUM==0
*Now full PPO variable
gener PPO=0
replace PPO=2 if IPC==1
replace PPO=3 if HUM==1
replace PPO=4 if PKEEP==1
label define ppo 1 "FPR" 2 "IPC" 3 "HUMANITARIAN" 4 "PEACEKEEP"
label values PPO ppo
label variable PPO "Principal Policy Objective"
tabulate PPO
*Now Gulf War is FPR unless IPC has been coded
replace PPO=1 if episode==0 & IPC==0
*Now Iraq is FPR unless IPC has been coded
replace PPO=1 if episode==2 & IPC==0
*Now WAT is FPR unless IPC has been coded
replace PPO=1 if episode==9 & IPC==0
*Haiti is all IPC if not already coded
replace PPO=2 if episode==4 
*Now Sudan/Afgh & NK are FPR unless IPC has been coded
replace PPO=1 if episode==7 & IPC==0
replace PPO=1 if episode==3 & IPC==0
gener sexgap= men_fav- wom_fav
label var sexgap "men-fav - wom_fav"
**********************************************
*Now some cleanup based on review of marginals for which
*PPO is left uncoded
***********************************************

*    FIRST A LISTING *
sort episode end
list episode phrase roper end if PPO==0
*******************
**Kosovo
*_____________________
** All following based on re-examination of originals
** Roper 325046 is clearly takeside=1 and thus PPO=2
replace takeside=1 if episode==8 & roper==325046
** Roper 325565 and 325564 same thing
replace takeside=1 if episode==8 & roper==325564
replace takeside=1 if episode==8 & roper==325565
*Now PPO:
replace IPC=1 if episode==8 & takeside==1
replace PPO=2 if episode==8 & takeside==1
****************
*     Somalia
*****************
**Following two immediately after Bush 92 speech and
**are clearly aimed at approval of relief mission:
replace HUM=1 if episode==5 & roper==192714
replace HUM=1 if episode==5 & roper==189995
**The following two in early 1993 are aimed clearly
**at approval of the relief mission:
replace HUM=1 if episode==5 & roper==190876
replace HUM=1 if episode==5 & roper==203864
*Now update PPO
replace PPO=3 if episode==5 & HUM==1
replace humanit2=1 if episode==5 & HUM==1

***The following 7 questions were not coded IPC originally,
**but all occur in the immediate aftermath of the fire fight
**in Somalia on OCT 5. Clearly, context is that US is "take side yes"
replace IPC=1 if episode==5 & PPO==0
replace takeside=1 if episode==5 & PPO==0
*now update PPO
replace PPO=2 if episode==5 & IPC==1
***many Somalia after summer 1993 coded humanitarian
*AFTER UN/USA got involved in fighting Aidid.  I am
*now recoding these to IPC UNLESS HUM is mentioned,
*as follows after June 16 UN attacks:
replace PPO=2 if episode==5 & end>12216 & quirky==0
replace HUM=0 if episode==5 & end>12216 & quirky==0
replace IPC=1 if episode==5 & end>12216 & quirky==0

***********************************
*BOSNIA
*As listed above, a fair number of "presence of troops"
*questions went uncoded as to PPO. The vast majority occur
*AFTER WJC speech announcing Dayton accords on 11/21/95.
*Thus, all of these are Peackeep == yes, as follows:
replace PKEEP=1 if PPO==0 & episode==1 & end>13107
replace PPO=4 if episode==1 & PKEEP==1
replace peackeep=1 if episode==1 & PKEEP==1
**********
*   RE LIST
*list phrase roper end if PPO==0
************
*This leaves 4 marginals with PPO uncoded, as follows:

***********
*The two aircraft questions involve enforcement of no-fly zone
*under UN sanction and are thus Mandate1=1 and takeside=1:
replace takeside=1 if episode==1 & roper==195931
replace takeside=1 if episode==1 & roper==192424
replace mandate1=1 if episode==1 & roper==195931
replace mandate1=1 if episode==1 & roper==192424
replace IPC=1 if takeside==1 & episode==1
replace PPO=2 if episode==1 & IPC==1
************
***Following case for Sudan/Afgh is a duplicate
drop if _n==558

**Following case for Sudan/Afghan is clearly FPR
replace PPO=1 if episode==7 & PPO==2
***Final list of uncoded PPO's
*Should be two remaining "send troops" questions
*for Bosnia, with no apparent other mentions. There 
*is no basis for coding PPO for these two.
list phrase roper end if PPO==0
tabulate PPO

