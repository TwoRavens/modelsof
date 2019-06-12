************************************************************************
* The alleged consensus: Italian elites and publics on foreign policy
* By Francesco Olmastroni
* University of Siena
* E-mail: olmastroni3@unisi.it
* Date: March 3, 2017
************************************************************************

* KEEP RELEVANT VARIABLES
keep vSEX vAGE_puntuale vEDUC vQ29 Livello vQ01_01 vQ01_02 vQ01_03 vQ01_04 vQ01_05 vQ01_06 vQ01_07 S_A_A_E_con_elite vQ03_03 vQ03_02 vQ03_08 vQ14 vQ21 vQ18 vQ15_01 vQ15_02 vQ15_03 vQ15_04 vQ15_05 vQ15_06 vQ9A vQ9B

/**DEMOGRAPHICS

*Gender
tab vSEX
tab vSEX, m nolabel

generate gender = vSEX
recode gender (1=2) (2=1)
label var gender "Gender"
label define gender 1 "Female" 2 "Male" 
label val gender gender

tab vSEX gender, m

* Age
tab vAGE_puntuale, m

*Education
tab vEDUC
tab vEDUC, m nolabel

generate education3 = vEDUC
recode education3 (1/4=1) (5=2) (6/9=3) (99=.a)
label var education3 "Ideology recoded 3 categories"
label define education3 1 "Primary" 2 "Secondary" 3 "Tertiary" .a "Refusal"
label val education3 education3

tab vEDUC education3, m
*/
************************************************************************
* INDEPENDENT VARIABLES
************************************************************************

* IDEOLOGY
generate ideology = vQ29
recode ideology (0/4=1) (5=2) (6/10=3) (77=4) (98/99=.a)
label var ideology "Ideology recoded"
label define ideology 1 "Centre-Left" 2 "Centre" 3 "Centre-Right" 4 "Can't place myslef on a left-right scale" .a "DK/Refusal"
label val ideology ideology

tab vQ29 ideology, m

* Setting the reference category
fvset base 4 ideology

/*generate ideology_scale1 = vQ29
recode ideology_scale1 (77=.b) (98/99=.a)
label var ideology_scale1 "Ideology (scale)"
label define ideology_scale1 0 "Left" 5 "Centre" 10 "Right" .b "Can't place myslef on a left-right scale" .a "DK/Refusal"
label val ideology_scale1 ideology_scale1

tab vQ29 ideology_scale1, m*/

generate ideology_scale = vQ29
recode ideology_scale (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=8) (8=9) (9=10) (10=11) (77=.b) (98/99=.a)
label var ideology_scale "Ideology (scale)"
label define ideology_scale 1 "Left" 6 "Centre" 11 "Right" .b "Can't place myslef on a left-right scale" .a "DK/Refusal"
label val ideology_scale ideology_scale

tab vQ29 ideology_scale, m

* DUMMY CAN'T PLACE MYSELF ON A LEFT-RIGHT SCALE
generate noideology = ideology
recode noideology (4=1) (1/3=0)
label var noideology "Ideology (scale)"
label define noideology 1 "No ideology" 0 "Ideology" .a "DK/Refusal"
label val noideology noideology

tab vQ29 noideology, m

* LEVEL OF ACTION
tab Livello
tab Livello [aw=S_A_A_E_con_elite]

* Setting the reference category
fvset base 4 Livello

*Dummies for level of action
tab Livello, g(LivelloDUM)

************************************************************************
* TABLE 1: Distribution of the sample by ideology and level of action (%)
************************************************************************
tab ideology Livello [aw=S_A_A_E_con_elite], m col nofreq
tab ideology Livello [aw=S_A_A_E_con_elite], m col

bysort Livello: sum vQ29 if vQ29<77 [aw=S_A_A_E_con_elite], d
sum vQ29 if vQ29<77 [aw=S_A_A_E_con_elite], d

sktest vQ29 if (vQ29<77 & Livello==1) [aw=S_A_A_E_con_elite]
sktest vQ29 if (vQ29<77 & Livello==2) [aw=S_A_A_E_con_elite]
sktest vQ29 if (vQ29<77 & Livello==3) [aw=S_A_A_E_con_elite]
sktest vQ29 if (vQ29<77 & Livello==4) [aw=S_A_A_E_con_elite]
sktest vQ29 if vQ29<77 [aw=S_A_A_E_con_elite]
************************************************************************

********************************************
** DIMENSION 1: CONCERNS / THREAT PERCEPTION
********************************************

* RECODE RELEVANT VARIABLES

generate vQ01_01_rec = vQ01_01
recode vQ01_01_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_01_rec "Il riscaldamento globale del pianeta"
label define vQ01_01_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_01_rec vQ01_01_rec

generate vQ01_02_rec = vQ01_02
recode vQ01_02_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_02_rec "La crescita del terrorismo internazionale ispirata da gruppi radicali come Al-Qaeda e ISIS"
label define vQ01_02_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_02_rec vQ01_02_rec

generate vQ01_03_rec = vQ01_03
recode vQ01_03_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_03_rec "La crescente aggressività della Russia di Putin"
label define vQ01_03_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_03_rec vQ01_03_rec

generate vQ01_04_rec = vQ01_04
recode vQ01_04_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_04_rec "La crisi economica con le sue ricadute su occupazione e crescita"
label define vQ01_04_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_04_rec vQ01_04_rec

generate vQ01_05_rec = vQ01_05
recode vQ01_05_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_05_rec "La criminalità organizzata transnazionale"
label define vQ01_05_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_05_rec vQ01_05_rec

generate vQ01_06_rec = vQ01_06
recode vQ01_06_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_06_rec "La immigrazione da stati extra-europei"
label define vQ01_06_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_06_rec vQ01_06_rec

generate vQ01_07_rec = vQ01_07
recode vQ01_07_rec (1=1) (2/4=0) (98/99=.a)
label var vQ01_07_rec "Violazioni gravi e reiterate dei diritti umani in paesi terzi"
label define vQ01_07_rec 0 "Non è una grande minaccia" 1 "E' una grande minaccia" .a "DK/Refusal"
label val vQ01_07_rec vQ01_07_rec

tab vQ01_01_rec vQ01_01, m
tab vQ01_02_rec vQ01_02, m
tab vQ01_03_rec vQ01_03, m
tab vQ01_04_rec vQ01_04, m
tab vQ01_05_rec vQ01_05, m
tab vQ01_06_rec vQ01_06, m
tab vQ01_07_rec vQ01_07, m

tab1 vQ01_01_rec vQ01_02_rec vQ01_03_rec vQ01_04_rec vQ01_05_rec vQ01_06_rec vQ01_07_rec

************************************************************
* FIGURE 2 – Perception of threat by level of action
************************************************************
tab vQ01_01_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_02_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_03_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_04_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_05_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_06_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ01_07_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
************************************************************

/*sum vQ01_01_rec vQ01_02_rec vQ01_03_rec vQ01_04_rec vQ01_05_rec vQ01_06_rec vQ01_07_rec, d*/

*********************************************************************************************
* Figure 3 – Perception of threat by ideology and level of action
*********************************************************************************************
bysort Livello: tab vQ01_01_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_02_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_03_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_04_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_05_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_06_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ01_07_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
*********************************************************************************************

tab Livello, m
tab Livello, m nolabel
tab ideology, m
tab ideology, m nolabel

* Interaction terms

generate ideology_gov = ideology_scale*LivelloDUM1
generate ideology_pol = ideology_scale*LivelloDUM2
generate ideology_orgpub = ideology_scale*LivelloDUM3
generate ideology_masspub = ideology_scale*LivelloDUM4


* Logistic Regressions THREAT

***************************************************************************************************************
* Table 2 – Relative and interactive effects of ideology and level of action on the perception of threat
***************************************************************************************************************
logit vQ01_01_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_01_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or   
fitstat

logit vQ01_02_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_02_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ01_03_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_03_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ01_04_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_04_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ01_05_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_05_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ01_06_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_06_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ01_07_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ01_07_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat
***************************************************************************************************************


********************************************
**  DIMENSION 2: FEELINGS TOWARDS ALLIES AND SUPPORT FOR THE MAIN INSTITUTIONAL MECHANISMIS OF COORDINATION AND COOPERATION
********************************************

* RECODE RELEVANT VARIABLES

generate vQ03_03_rec = vQ03_03
recode vQ03_03_rec (98/99=.a)
label var vQ03_03_rec "FEELING UNITED STATES"
label define vQ03_03_rec 0 "Molto negativo e sfavorevole" 10 "Molto positivo e favorevole" .a "DK/Refusal"
label val vQ03_03_rec vQ03_03_rec

generate vQ03_02_rec = vQ03_02
recode vQ03_02_rec (98/99=.a)
label var vQ03_02_rec "FEELING GERMANY"
label define vQ03_02_rec 0 "Molto negativo e sfavorevole" 10 "Molto positivo e favorevole" .a "DK/Refusal"
label val vQ03_02_rec vQ03_02_rec

generate vQ03_08_rec = vQ03_08
recode vQ03_08_rec (98/99=.a)
label var vQ03_08_rec "FEELING GREECE"
label define vQ03_08_rec 0 "Molto negativo e sfavorevole" 10 "Molto positivo e favorevole" .a "DK/Refusal"
label val vQ03_08_rec vQ03_08_rec

generate vQ14_rec = vQ14
recode vQ14_rec (5=.b) (98/99=.a)
label var vQ14_rec "Quale delle seguenti soluzioni è per lei preferibile nel contesto di una comune politica europea per la difesa e la sicurezza?"
label define vQ14_rec 1 "Un singolo esercito europeo che sostituisca gli eserciti nazionali" 2 "Una forza di intervento rapido europea permanente, che si aggiunga agli eserciti nazionali" 3 "Una forza di intervento rapido europea, da attivare solo in caso di bisogno" 4 "Nessun esercito europeo, e avere solo eserciti nazionali" .a "DK/Refusal" .b "Other"
label val vQ14_rec vQ14_rec

fvset base 4 vQ14_rec

tab vQ14_rec, gen(vQ14_rec_dum)

generate vQ21_rec = vQ21
recode vQ21_rec (1/2=1) (3/4=0) (5=.b) (98/99=.a)
label var vQ21_rec "In linea generale, Lei crede che far parte dell’Eurozona sia stata una buona o una cattiva cosa per l’economia italiana?"
label define vQ21_rec 0 "Cattiva" 1 "Buona" .a "DK/Refusal" .b "Non fa differenza"
label val vQ21_rec vQ21_rec

generate vQ18_rec = vQ18
recode vQ18_rec (98/99=.a)
label var vQ18_rec "Quale affermazione sul Partenariato Transatlantico sul Commercio e Investimenti (TTIP) è più vicina alla Sua opinione?"
label define vQ18_rec 1 "Aiuterà la nostra economia a crescere" 2 "Avrà conseguenze economiche negative" 3 "Non farà differenza" .a "DK/Refusal"
label val vQ18_rec vQ18_rec

fvset base 3 vQ18_rec

tab vQ03_03_rec vQ03_03, m
tab vQ03_02_rec vQ03_02, m
tab vQ03_08_rec vQ03_08, m
tab vQ14_rec vQ14, m
tab vQ21_rec vQ21, m
tab vQ18_rec vQ18, m

tab1 vQ03_03_rec vQ03_02_rec vQ03_08_rec vQ14_rec vQ21_rec vQ18_rec

*********************************************************************************
* FIGURE 4 – Feelings towards the American and European allies by level of action
*********************************************************************************
bysort Livello: sum vQ03_03_rec [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_02_rec [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_08_rec [aw=S_A_A_E_con_elite], d
sum vQ03_03_rec vQ03_02_rec vQ03_08_rec [aw=S_A_A_E_con_elite], d
*********************************************************************************

**********************************************************************************************
* FIGURE 5 – Feelings towards the American and European allies by ideology and level of action
**********************************************************************************************
bysort Livello: sum vQ03_03_rec if ideology==1 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_03_rec if ideology==2 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_03_rec if ideology==3 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_03_rec if ideology==4 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_03_rec [aw=S_A_A_E_con_elite], d

bysort Livello: sum vQ03_02_rec if ideology==1 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_02_rec if ideology==2 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_02_rec if ideology==3 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_02_rec if ideology==4 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_02_rec [aw=S_A_A_E_con_elite], d

bysort Livello: sum vQ03_08_rec if ideology==1 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_08_rec if ideology==2 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_08_rec if ideology==3 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_08_rec if ideology==4 [aw=S_A_A_E_con_elite], d
bysort Livello: sum vQ03_08_rec [aw=S_A_A_E_con_elite], d
**********************************************************************************************

****************************************************************************************
* FIGURE 6 – Support for the institutional mechanisms of cooperation by level of action
****************************************************************************************
tab vQ14_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ21_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ18_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
****************************************************************************************

**************************************************************************************************************************
* FIGURE 7 – Support for the institutional mechanisms of cooperation at the European level by ideology and level of action
**************************************************************************************************************************
bysort Livello: tab vQ14_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ21_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
**************************************************************************************************************************

****************************************************************************************************************
* FIGURE 8 – Support for the institutional mechanisms of cooperation with the US by ideology and level of action
****************************************************************************************************************
bysort Livello: tab vQ18_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
****************************************************************************************************************

* Linear regression Feelings towards the American and European allies

*************************************************************************************************************
* TABLE 3 – Relative and interactive effects of ideology and level of action on feelings towards the allies
*************************************************************************************************************
regress vQ03_03_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
fitstat

regress vQ03_02_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
fitstat

regress vQ03_08_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
fitstat
*************************************************************************************************************

* Multinomial Logistic regression Support for the institutional mechanisms of cooperation by level of action
* Binary Logistic regression Support for the institutional mechanisms of cooperation by level of action

***************************************************************************************************************************************
* TABLE 4 – Relative and interactive effects of ideology and level of action on support for the institutional mechanisms of cooperation
***************************************************************************************************************************************
mlogit vQ14_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
mlogit vQ14_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], rrr /* absence of cases for political elites on DV category 4*/
fitstat

logit vQ14_rec_dum1 ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
logit vQ14_rec_dum2 ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
logit vQ14_rec_dum3 ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
logit vQ14_rec_dum4 ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or

mlogit vQ18_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
mlogit vQ18_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], b(3) rrr
fitstat

logit vQ21_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ21_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or /* absence of cases for elites on DV ref. category*/
fitstat

logit vQ21_rec ideology_scale i.Livello ideology_gov ideology_orgpub [iw=S_A_A_E_con_elite] if Livello!=2
logit vQ21_rec ideology_scale i.Livello ideology_gov ideology_orgpub [iw=S_A_A_E_con_elite] if Livello!=2, or /* without political elites*/
fitstat

logit vQ21_rec ideology_scale i.Livello [iw=S_A_A_E_con_elite]
logit vQ21_rec ideology_scale i.Livello [iw=S_A_A_E_con_elite], or /* without the interaction term*/
fitstat
***************************************************************************************************************************************

******************************
**  DIMENSION 3: USE OF FORCE
******************************
* RECODE RELEVANT VARIABLES

generate vQ15_01_rec = vQ15_01
recode vQ15_01_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_01_rec "Proteggere gli interessi economici italiani all'estero"
label define vQ15_01_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_01_rec vQ15_01_rec

generate vQ15_02_rec = vQ15_02
recode vQ15_02_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_02_rec "Combattere il terrorismo internazionale"
label define vQ15_02_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_02_rec vQ15_02_rec

generate vQ15_03_rec = vQ15_03
recode vQ15_03_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_03_rec "Difendere il nostro paese da un attacco esterno"
label define vQ15_03_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_03_rec vQ15_03_rec

generate vQ15_04_rec = vQ15_04
recode vQ15_04_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_04_rec "Far cadere un regime autoritario"
label define vQ15_04_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_04_rec vQ15_04_rec

generate vQ15_05_rec = vQ15_05
recode vQ15_05_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_05_rec "Far cessare le ostilita' fra due o piu' paesi in guerra"
label define vQ15_05_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_05_rec vQ15_05_rec

generate vQ15_06_rec = vQ15_06
recode vQ15_06_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ15_06_rec "Assicurare la pace ed il rispetto dei diritti umani in un paese investito da una guerra civile"
label define vQ15_06_rec 0 "Poco-Per niente giustificato" 1 "Molto-Abbastanza giustificato" .a "DK/Refusal"
label val vQ15_06_rec vQ15_06_rec

generate vQ9A_rec = vQ9A
recode vQ9A_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ9A_rec "Lei sarebbe favorevole o contrario alla partecipazione italiana ad un intervento militare multilaterale nei territori della Siria e dell'Iraq controllati dall'ISIS?"
label define vQ9A_rec 0 "Abbastanza-Molto contrario" 1 "Molto-Abbastanza favorevole" .a "DK/Refusal"
label val vQ9A_rec vQ9A_rec

generate vQ9B_rec = vQ9B
recode vQ9B_rec (1/2=1) (3/4=0) (98/99=.a)
label var vQ9B_rec "Lei sarebbe favorevole o contrario alla partecipazione italiana ad un intervento militare multilaterale in Libia?"
label define vQ9B_rec 0 "Abbastanza-Molto contrario" 1 "Molto-Abbastanza favorevole" .a "DK/Refusal"
label val vQ9B_rec vQ9B_rec

tab vQ15_01_rec vQ15_01, m
tab vQ15_02_rec vQ15_02, m
tab vQ15_03_rec vQ15_03, m
tab vQ15_04_rec vQ15_04, m
tab vQ15_05_rec vQ15_05, m
tab vQ15_06_rec vQ15_06, m
tab vQ9A_rec vQ9A, m
tab vQ9B_rec vQ9B, m

tab1 vQ15_01_rec vQ15_02_rec vQ15_03_rec vQ15_04_rec vQ15_05_rec vQ15_06_rec vQ9A_rec vQ9B_rec

**************************************************************************************************
* FIGURE 9 – Use of military force (in principle and in specific circumstances) by level of action
**************************************************************************************************
tab vQ15_01_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ15_02_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ15_03_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ15_04_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ15_05_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ15_06_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ9A_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
tab vQ9B_rec Livello [aw=S_A_A_E_con_elite], m col nofreq
**************************************************************************************************

sum vQ15_01_rec vQ15_02_rec vQ15_03_rec vQ15_04_rec vQ15_05_rec vQ15_06_rec vQ9A_rec vQ9B_rec, d

*********************************************************************************************
* FIGURE 10 – Use of military force (in principle) by ideology and level of action
*********************************************************************************************
bysort Livello: tab vQ15_01_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ15_02_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ15_03_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ15_04_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ15_05_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ15_06_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ9A_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq 
bysort Livello: tab vQ9B_rec ideology if ideology!=.a [aw=S_A_A_E_con_elite], m col nofreq
*********************************************************************************************

* Logistic Regressions USE OF FORCE

***************************************************************************************************************
* TABLE 5 - Relative and interactive effects of ideology and level of action on support for the use of force
***************************************************************************************************************
logit vQ15_01_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_01_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ15_02_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_02_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ15_03_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_03_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ15_04_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_04_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ15_05_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_05_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ15_06_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_06_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or /* absence of cases for political elites on the ref cat DV*/
fitstat

logit vQ15_06_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ15_06_rec ideology_scale i.Livello ideology_gov ideology_orgpub [iw=S_A_A_E_con_elite] if Livello!=2, or
fitstat

logit vQ9A_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ9A_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat

logit vQ9B_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite]
logit vQ9B_rec ideology_scale i.Livello ideology_gov ideology_pol ideology_orgpub [iw=S_A_A_E_con_elite], or
fitstat
***************************************************************************************************************
