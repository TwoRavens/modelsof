*This Do-File replicates the results presented in "Reputation and Organizational Politics: Inside the European Commission" by
*Jens Blom-Hansen and Daniel Finke, forthcoming in the Journal of Politics. Corresponding Author: Jens Blom-Hansen, jbh@ps.au.dk.
*The raw data is a report of the activities recorded in the CIS-net data base in 2015 and 2016 (cisnet20152016_jop.dta) which is 
*further described in the article. The replication code is structured in two sections, (1) generation of variables and  
*(2) replication of tables and figures (starting in line 280).*/


*(1) GENERATION OF VARIABLES

* NUMBER OF CONSULTED DGs
gen DG_consulted = AAE+ AGRI+ BUDG+ CLIMA+ CNECT+ COMM+ COMP+ DEVCO+ DGT+ DGTEDIT+ EAC+ ECFIN+ ECHO+ EEAS+ EMPL+ ENER+ ENV+ EPSC+ EPSO+ ESTAT+ FISMA+ FPI+ GROW+ HOME+ HR+ IAS+ JRC+ JUST+ MARE+ MOVE+ NEAR+ OLAF+ OP+ REGIO+ RTD+ SANTE+ SCIC+ SG+ SJ+ TAXUD+ TRADE
lab var DG_consulted "No. Consulted DGs"

* CATEGROICAL VARIABLES INDICATING DIFFERENT TYPES OF DECISIONS

* First create new variable for case titles in lower case
gen title_low = FulltitleTitrecomplet
replace title_low = lower(title_low)

* Secondary acts (legal base: Primary acts - i.e., treaties)
* Proposals for secondary acts: Regulations, directives, decisions (COM-documents)
* Type 1: “Proposal for a regulation” or “Proposal for a Council regulation” (French: “Proposition de règlement”)
gen prop_reg=0
replace prop_reg=1 if regexm( title_low, "proposal for a regulation")
replace prop_reg=1 if regexm( title_low, "proposal for a council regulation")
replace prop_reg=1 if regexm( title_low, "proposition de règlement")
lab var prop_reg "Proposal for a regulation"

* Type 2: “Proposal for a directive” or “Proposal for a Council directive” (French: “Proposition de directive”)
gen prop_dir=0
replace prop_dir=1 if regexm( title_low, "proposal for a directive")
replace prop_dir=1 if regexm( title_low, "proposal for a council directive")
replace prop_dir=1 if regexm( title_low, "proposition de directive")
lab var prop_dir "Proposal for a directive"

* Type 3: “Proposal for a decision” or “Proposal for a Council decision” (French: “Proposition de décision”)
gen prop_dec=0
replace prop_dec=1 if regexm( title_low, "proposal for a decision")
replace prop_dec=1 if regexm( title_low, "proposal for a council decision")
replace prop_dec=1 if regexm( title_low, "proposition de décision")
lab var prop_dec "Proposal for a decision"

* Secondary acts (legal base: Primary acts - i.e., treaties)
* Adoption of secondary acts: Sometimes the Commission can adopt acts directly based on the Treaty, e.g. in the competition area
* NB: These types of secondary acts CANNOT be distinguished from Commission tertiary acts (regulations, directives, decisions),
* which are not implementing acts or delegated acts, but where the legal base specifies control by the pre-Lisbon comitology 
* procedure “regulatory procedure with scrutiny” (RPS))
* Type 1: “Commission Regulation” (French: “Règlement de la Commission”)
* Type 2: ”Commission Directive” (French: “Directive de la Commission”)
* Type 3: ”Commission Decision” (French: “Décision de la Commission”)

* Type 1: ”Commission regulation” (French: “Réglement de la Commission”)
gen COM_reg=0
replace COM_reg=1 if regexm( title_low, "commission regulation")
replace COM_reg=1 if regexm( title_low, "règlement de la commission")
lab var COM_reg "Commission regulation"

* Type 2: ”Commission directive” (French: “Directive de la Commission”)
gen COM_dir=0
replace COM_dir=1 if regexm( title_low, "commission directive")
replace COM_dir=1 if regexm( title_low, "directive de la commission")
lab var COM_dir "Commission directive"

* Type 3: “Commission decision” (French: “Décision de la Commission”)
gen COM_dec=0
replace COM_dec=1 if regexm( title_low, "commission decision")
replace COM_dec=1 if regexm( title_low, "décision de la commission")
lab var COM_dec "Commission decision"

* Tertiary acts (legal base: Secondary acts)
* Adoption of delegated acts: Regulations, directives, decisions. TFEU-article 290, 3: “The adjective ‘delegated’ shall be inserted in the title of delegated acts.” (French: ”L'adjectif "délégué" ou "déléguée" est inséré dans l'intitulé des actes délégués”)
* Type 1: “Commission Delegated Regulation” (French: “Règlement délégué de la Commission”)
gen Del_reg=0
replace Del_reg=1 if regexm( title_low, "commission delegated regulation")
replace Del_reg=1 if regexm( title_low, "règlement délégué de la commission")
lab var Del_reg "Delegated regulation"

* Type 2: “Commission Delegated Directive” (French: “Directive déléguée de la Commission”)
gen Del_dir=0
replace Del_dir=1 if regexm( title_low, "commission delegated directive")
replace Del_dir=1 if regexm( title_low, "directive déléguée de la commission")
lab var Del_dir "Delegated directive"

* Type 3: “Commission Delegated Decision” (French: “Décision déléguée de la Commission”)
gen Del_dec=0
replace Del_dec=1 if regexm( title_low, "commission delegated decision")
replace Del_dec=1 if regexm( title_low, "décision déléguée de la commission")
lab var Del_dec "Delegated decision"

* Adoption of implementing acts: Regulations, directives decisions (TFEU-article 291,4: “The word ‘implementing’ shall be inserted in the title of implementing acts” (French: “Le mot "d'exécution" est inséré dans l'intitulé des actes d'exécution”).
* Type 1: ”Commission Implementing Regulation” (French: “Règlement d'exécution de la Commission”)
gen COM_impl_reg=0
replace COM_impl_reg=1 if regexm( title_low, "commission implementing regulation")
replace COM_impl_reg=1 if regexm( title_low, "règlement d'exécution de la commission")
lab var COM_impl_reg "Commission implementing regulation"

* Type 2:  ”Commission Implementing Directive” (French: “Directive d'exécution de la Commission”)
gen COM_impl_dir=0
replace COM_impl_dir=1 if regexm( title_low, "commission implementing directive")
replace COM_impl_dir=1 if regexm( title_low, "directive d'exécution de la commission")
lab var COM_impl_dir "Commission implementing directive"

* Type 3:  ”Commission Implementing Decision” (French: “Décision d'exécution de la Commission”)
gen COM_impl_dec=0
replace COM_impl_dec=1 if regexm( title_low, "commission implementing decision")
replace COM_impl_dec=1 if regexm( title_low, "décision d'exécution de la commission")
lab var COM_impl_dec "Commission implementing decision"

* Proposals for tertiary Council acts:
* Type 1: “Proposal for a Council implementing regulation” (French: ”Proposition de règlement d'exécution du Conseil”)
gen Counc_impl_reg=0
replace Counc_impl_reg=1 if regexm( title_low, "proposal for a council implementing regulation")
replace Counc_impl_reg=1 if regexm( title_low, "proposition de règlement d'exécution du conseil")
lab var Counc_impl_reg "Proposal for a Council implementing regulation"

* Type 2: “Proposal for a Council implementing directive” (French: “Proposition de directive d'exécution du Conseil”)
gen Counc_impl_dir=0
replace Counc_impl_dir=1 if regexm( title_low, "proposal for a council implementing directive")
replace Counc_impl_dir=1 if regexm( title_low, "proposition de directive d'exécution du conseil")
lab var Counc_impl_dir "Proposal for a Council implementing directive"

* Type 3: “Proposal for a Council implementing decision” (French: “Proposition de décision d'exécution du Conseil”)
gen Counc_impl_dec=0
replace Counc_impl_dec=1 if regexm( title_low, "proposal for a council implementing decision")
replace Counc_impl_dec=1 if regexm( title_low, "proposition de décision d'exécution du conseil")
lab var Counc_impl_dec "Proposal for a Council implementing decision"

* To deal with double-codings a new variable AMBIGUITY is created that sums the dummy variables for the type of decision
gen AMBIGUITY = prop_reg +prop_dir +prop_dec +COM_reg +COM_dir +COM_dec +Del_reg +Del_dir +Del_dec +COM_impl_reg +COM_impl_dir +COM_impl_dec +Counc_impl_reg +Counc_impl_dir +Counc_impl_dec
drop if AMBIGUITY >1

* DUMMY VARIABLES FOR TYPES OF DECISION
* Proposals for legal acts
gen legal_act=0
replace legal_act=1 if prop_reg ==1
replace legal_act=1 if prop_dir ==1
replace legal_act=1 if prop_dec ==1
lab var legal_act "Proposal for a legal act"

* Commission acts
gen COM_act=0
replace COM_act=1 if COM_reg ==1
replace COM_act=1 if COM_dir ==1
replace COM_act=1 if COM_dec ==1
lab var COM_act "Commission act"

* Delegated acts
gen Del_act=0
replace Del_act=1 if Del_reg ==1
replace Del_act=1 if Del_dir ==1
replace Del_act=1 if Del_dec ==1
lab var Del_act "Delegated act"

* Commission implementing acts
gen COM_impl_act=0
replace COM_impl_act=1 if COM_impl_reg ==1
replace COM_impl_act=1 if COM_impl_dir ==1
replace COM_impl_act=1 if COM_impl_dec ==1
lab var COM_impl_act "Commission implementing act"

* Proposals for Council implementing acts
gen Counc_impl_act=0
replace Counc_impl_act=1 if Counc_impl_reg==1
replace Counc_impl_act=1 if Counc_impl_dir==1
replace Counc_impl_act=1 if Counc_impl_dec==1
lab var Counc_impl_act "Proposal for Council implementing act"

* DUMMY VARIABLES FOR TYPES OF LEGAL ACTS
g regulation =0 
replace regulation = 1 if (prop_reg ==1 | COM_reg ==1 | Del_reg ==1 | COM_impl_reg==1 | Counc_impl_reg==1)
lab var regulation "Regulation"

g decision =0 
replace decision = 1 if (prop_dec ==1 | COM_dec ==1 | Del_dec ==1 | COM_impl_dec==1 | Counc_impl_dec==1)
lab var decision "Decision"

g directive =0 
replace directive = 1 if (prop_dir ==1 | COM_dir ==1 | Del_dir ==1 | COM_impl_dir==1 | Counc_impl_dir==1)
lab var directive "Directive"

* DROP ALL CASES NOT PROPOSING EU LAW
drop if regulation ==0 & decision ==0 & directive ==0

*AMENDMENT
g amendment = regexm(title_low, "amending")
replace amendment =1 if regexm(title_low, "amending")
replace amendment =1 if regexm(title_low, "modifying")
replace amendment =1 if regexm(title_low, "supplementing")
lab var amendment "Amendment"

* TITLE LENGTH
g number_of_words = wordcount(title_low)
g ln_number_of_words=ln( number_of_words+1)
lab var ln_number_of_words "Title Length"

* TECHNICALITY
moss title_low, match("([0-9]+)") regex
drop _pos1 _pos2 _pos3 _pos4 _pos5 _pos6 _pos7 _pos8 _pos9 _pos10 _pos11 _pos12 _pos13 _pos14 _pos15 _pos16 _pos17 _pos18 _pos19 _pos20 _pos21 _pos22 _pos23 _pos24 _pos25 _pos26 _pos27 _pos28 _pos29 _pos30 _pos31 _pos32 _pos33 _pos34 _pos35 _pos36 _pos37 _pos38 _pos39 _pos40 _pos41 _pos42 _pos43 _pos44 _pos45 _pos46 _pos47 _pos48 _pos49 _pos50 _pos51 _pos52 _pos53 _pos54 _pos55 _pos56 _pos57 _pos58
destring _match1- _match58, force replace
egen count_of_num = rownonmiss( _match1- _match58)
replace count_of_num = count_of_num+1
g number_ratio_wordlevel = count_of_num/ number_of_words
g ln_num_ratio_wordlevel = ln( number_ratio_wordlevel+1)
lab var ln_num_ratio_wordlevel "Technicality"

*MENTION OF MEMBER STATES
g memberstate = regexm(title_low, "france")
replace memberstate  = 1 if regexm(title_low, "germany")
replace memberstate  = 1 if regexm(title_low, "poland")
replace memberstate  = 1 if regexm(title_low, "denmark")
replace memberstate  = 1 if regexm(title_low, "sweden")
replace memberstate  = 1 if regexm(title_low, "finland")
replace memberstate  = 1 if regexm(title_low, "kingdom")
replace memberstate  = 1 if regexm(title_low, "ireland")
replace memberstate  = 1 if regexm(title_low, "spain")
replace memberstate  = 1 if regexm(title_low, "portugal")
replace memberstate  = 1 if regexm(title_low, "netherland")
replace memberstate  = 1 if regexm(title_low, "belgium")
replace memberstate  = 1 if regexm(title_low, "luxembourg")
replace memberstate  = 1 if regexm(title_low, "austria")
replace memberstate  = 1 if regexm(title_low, "italy")
replace memberstate  = 1 if regexm(title_low, "slovakia")
replace memberstate  = 1 if regexm(title_low, "slovenia")
replace memberstate  = 1 if regexm(title_low, "hungary")
replace memberstate  = 1 if regexm(title_low, "greece")
replace memberstate  = 1 if regexm(title_low, "estonia")
replace memberstate  = 1 if regexm(title_low, "lthuania")
replace memberstate  = 1 if regexm(title_low, "lithuania")
replace memberstate  = 1 if regexm(title_low, "latvia")
replace memberstate  = 1 if regexm(title_low, "serbia")
replace memberstate  = 1 if regexm(title_low, "montenegro")
replace memberstate  = 1 if regexm(title_low, "malta")
replace memberstate  = 1 if regexm(title_low, "romania")
replace memberstate  = 1 if regexm(title_low, "bulgaria")
replace memberstate  = 1 if regexm(title_low, "french")
replace memberstate  = 1 if regexm(title_low, "german")
replace memberstate  = 1 if regexm(title_low, "polish")
replace memberstate  = 1 if regexm(title_low, "danish")
replace memberstate  = 1 if regexm(title_low, "dutch")
replace memberstate  = 1 if regexm(title_low, "spanish")
replace memberstate  = 1 if regexm(title_low, "swedish")
replace memberstate  = 1 if regexm(title_low, "finish")
replace memberstate  = 1 if regexm(title_low, "british")
replace memberstate  = 1 if regexm(title_low, "english")
replace memberstate  = 1 if regexm(title_low, "spanish")
replace memberstate  = 1 if regexm(title_low, "portuguese")
replace memberstate  = 1 if regexm(title_low, "dutch")
replace memberstate  = 1 if regexm(title_low, "belgian")
replace memberstate  = 1 if regexm(title_low, "maltese")
replace memberstate  = 1 if regexm(title_low, "irish")
lab var memberstate "Mention of Member State"

*BUDGET IMPLICATION
gen budg_impl=0
replace budg_impl=1 if regexm(title_low, "fund")
replace budg_impl=1 if regexm(title_low, "payment")
replace budg_impl=1 if regexm(title_low, "expenditure")
replace budg_impl=1 if regexm(title_low, "aid")
replace budg_impl=1 if regexm(title_low, "financ")
replace budg_impl=1 if regexm(title_low, "contribution")
replace budg_impl=1 if regexm(title_low, "budget")
replace budg_impl=1 if regexm(title_low, "fond")
replace budg_impl=1 if regexm(title_low, "paiement")
replace budg_impl=1 if regexm(title_low, "dépense")
lab var budg_impl "Budget Implications"

*YEAR
g bi_year = 0
replace bi_year =1 if year =="2015"
lab var bi_year "Year 2015"

*Note: Both IAS and AAE are outliers, each being responsible for the coordination of only one case
drop if ResponsibleDGDGresponsable== "IAS"
drop if ResponsibleDGDGresponsable== "AAE"

drop title_low AMBIGUITY number_of_words _count- number_ratio_wordlevel
encode ResponsibleDGDGresponsable, g(respdg)


*(2) REPLICATION OF TABLES AND FIGURES

*TABLE 2: Models with Bootstrapped SE and unconditional FE
nbreg DG_consulted bi_year  i.respdg, vce(boot, rep(100))
fitstat
nbreg DG_consulted COM_act Del_act COM_impl_act Counc_impl_act bi_year  i.respdg, vce(boot, rep(100))
fitstat
nbreg DG_consulted ln_num_ratio_wordlevel ln_number_of_words decision regulation amendment memberstate budg_impl bi_year i.respdg, vce(boot, rep(100))
fitstat
nbreg DG_consulted COM_act Del_act COM_impl_act Counc_impl_act ln_num_ratio_wordlevel ln_number_of_words decision regulation amendment memberstate budg_impl bi_year i.respdg, vce(boot, rep(100))
fitstat

*TABLE 3: Full Model with Clustered SE and unconditional FE
nbreg DG_consulted COM_act Del_act COM_impl_act Counc_impl_act ln_num_ratio_wordlevel ln_number_of_words decision regulation amendment memberstate budg_impl bi_year i.respdg , cluster( respdg)
fitstat


*Predicted Values for FIGURE 1, Note: Figure 1 is based on full model with Bootstrapped SE and unconditional FE, Table 2, model 4

margins, at(COM_act=(1) Del_act =(0) COM_impl_act =(0) Counc_impl_act =(0))
margins, at(COM_act=(0) Del_act =(1) COM_impl_act =(0) Counc_impl_act =(0))
margins, at(COM_act=(0) Del_act =(0) COM_impl_act =(1) Counc_impl_act =(0))
margins, at(COM_act=(0) Del_act =(0) COM_impl_act =(0) Counc_impl_act =(1))
margins, at(COM_act=(0) Del_act =(0) COM_impl_act =(0) Counc_impl_act =(0))

*Predicted Values for FIGURE 2, Note: Figure 2 is based on full model with Bootstrapped SE and unconditional FE, Table 2, model 4*
margins, at(decision=(1) regulation=(0))
margins, at(decision=(0) regulation=(1))
margins, at(decision=(0) regulation=(0))

margins, at(budg_impl=(0 1))

margins, at(budg_impl=(0 1))

margins, at(amendment=(0 1))

margins, at(ln_number_of_words =(2.95 4))

margins, at(ln_num_ratio_wordlevel  =(0.035 0.2))



