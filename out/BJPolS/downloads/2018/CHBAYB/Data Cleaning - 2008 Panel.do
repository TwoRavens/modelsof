**********************************************************************
**********************************************************************
***********************2008-9 ANES Panel Survey***********************
**********************************************************************
**********************************************************************
**********************************************************************




**********************************************************************
****************************Data Cleaning****************************
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
clear
set more off
use "ANES 2008 Panel.dta"
set more off


		
		************************************
		*********Economic Assessments*******
		************************************

*W1
	*Economy vs. 2001
	recode  W1T1 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=5) (2=4) (3=3) (4=2) (5=1) 	, gen(w1_econ2001)
		
		
	label var w1_econ2001 "Econ Better than 2001?"
	label def bet 1 "Much Worse" 2 "Somewhat Worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better" 
	label values w1_econ2001 bet
	
	recode w1_econ2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w1_econ2001_3)
	label def bet1 1 "Worse" 2 "Same" 3 "Better" 
	label var w1_econ2001_3 "Econ Better than 2001 (W1)?"
	label values w1_econ2001_3 bet1

	tab w1_econ2001
	tab w1_econ2001_3
	
	*Deficit vs. 2001
	recode W1T4 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=5) (2=4) (3=3) (4=2) (5=1) , gen(w1_deficit2001)
	
	label var w1_deficit2001 "Deficit Better than 2001 (W1)?"
	label values w1_deficit2001 bet
	
	recode w1_deficit2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w1_deficit2001_3)
	label var w1_deficit2001_3 "Deficit Better than 2001 (W1)?"
	label values w1_deficit2001_3 bet1
	
	tab w1_deficit2001
	tab w1_deficit2001_3
	
	*Economy vs. 2007
	recode W1U1 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=3) (2=2) (3=1), gen(w1_retro)
	label var w1_retro "Econ Better than 1yr Ago (W1)?"
	label values w1_retro bet1
	
	gen w1_retro5 = .
	replace w1_retro5 = 5 if w1_retro == 3 & W1U2 == 1
	replace w1_retro5 = 4 if w1_retro == 3 & W1U2 == 2
	replace w1_retro5 = 3 if w1_retro == 2
	replace w1_retro5 = 2 if w1_retro == 1 & W1U3 == 2
	replace w1_retro5 = 1 if w1_retro == 1 & W1U3 == 1
	label var w1_retro5 "Econ Better than 1yr Ago (W1)?"
	label values w1_retro5 bet

	tab w1_retro
	tab w1_retro5
	
	*Prospective
	recode W1U4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w1_prosp)
	label var w1_prosp "Econ Worse in 1yr (W1)?"
	label def wor 1 "Better" 2 "Same" 3 "Worse"
	label values w1_prosp wor
		
	gen w1_prosp5 = .
	replace w1_prosp5 = 1  if w1_prosp == 3 & W1U5 == 1
	replace w1_prosp5 = 2  if w1_prosp == 3 & W1U5 == 2
	replace w1_prosp5 = 3  if w1_prosp == 2
	replace w1_prosp5 = 4  if w1_prosp == 1 & W1U6 == 2
	replace w1_prosp5 = 5  if w1_prosp == 1 & W1U6 == 1
	label var w1_prosp5 "Econ Worse in 1yr (W1)?"
	label def mwor 1 "Much Better" 2 "Somewhat Better" 3 "Same" ///
		4 "Somewhat Worse" 5 "Somewhat Worse" 
	label values w1_prosp5 mwor
	
	tab w1_prosp 
	tab w1_prosp5	

*W6
	*Economy vs. 2001
	recode  W6T1 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=5) (2=4) (3=3) (4=2) (5=1), gen(w6_econ2001)
	label var w6_econ2001 "Econ Better than 2001 (W6)?"
	label values w6_econ2001 bet
	
	recode w6_econ2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w6_econ2001_3)
	label var w6_econ2001_3 "Economy Better than 2001? (W6)"
	label values w6_econ2001_3 bet1

	tab w6_econ2001
	tab w6_econ2001_3
	
	*Deficit vs. 2001
	recode W6T4 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=5) (2=4) (3=3) (4=2) (5=1), gen(w6_deficit2001)
	label var w6_deficit2001 "Deficit Better than 2001? (W6)"
	label values w6_deficit2001 bet
	
	recode w6_deficit2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w6_deficit2001_3)
	label var w6_deficit2001_3 "Deficit Better than 2001? (W6)"
	label values w6_deficit2001_3 bet1
	
	tab w6_deficit2001
	tab w6_deficit2001_3
	
	*Economy vs. 2007
	recode W6U1 (-7=.) (-6=.) (-5=.) (-4=.) ///
		(1=3) (2=2) (3=1) , gen(w6_retro)
	label var w6_retro "Econ Better than 1yr Ago (W6)?"
	label values w6_retro bet1
	
	gen w6_retro5 = .
	replace w6_retro5 = 5 if w6_retro == 3 & W6U2 == 1
	replace w6_retro5 = 4 if w6_retro == 3 & W6U2 == 2
	replace w6_retro5 = 3 if w6_retro == 2
	replace w6_retro5 = 2 if w6_retro == 1 & W6U3 == 2
	replace w6_retro5 = 1 if w6_retro == 1 & W6U3 == 1
	label var w6_retro5 "Econ Better than 1yr Ago (W6)?"
	label values w6_retro5 bet

	tab w6_retro
	tab w6_retro5
	
	*Prospective
	recode W6U4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w6_prosp)
	label var w6_prosp "Econ Worse in 1yr (W6)?"
	label values w6_prosp wor
		
	gen w6_prosp5 = .
	replace w6_prosp5 = 1  if w6_prosp == 1 & W6U5 == 1
	replace w6_prosp5 = 2  if w6_prosp == 1 & W6U5 == 2
	replace w6_prosp5 = 3  if w6_prosp == 2
	replace w6_prosp5 = 4  if w6_prosp == 3 & W6U6 == 2
	replace w6_prosp5 = 5  if w6_prosp == 3 & W6U6 == 1
	label var w6_prosp5 "Econ Worse in 1yr (W6)?"
	label values w6_prosp5 mwor
	
	tab w6_prosp 
	tab w6_prosp5	

*W10
	*Economy vs. 2007
	label def reverse 1 "Worse" 2 "Same" 3 "Better" 
	label def reverse5 1 "Much Worse" 2 "Somewhat Worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better" 
	recode W10U1 (-7=.) (-6=.) (-5=.) (-4=.) (1=3) (2=2) (3=1)	, gen(w10_retro)
	label var w10_retro "Econ Better than 1yr Ago (W10)?"
	label values w10_retro reverse
		
	gen w10_retro5 = .
	replace w10_retro5 = 5 if w10_retro == 3 & W10U2 == 1
	replace w10_retro5 = 4 if w10_retro == 3 & W10U2 == 2
	replace w10_retro5 = 3 if w10_retro == 2
	replace w10_retro5 = 2 if w10_retro == 1 & W10U3 == 2
	replace w10_retro5 = 1 if w10_retro == 1 & W10U3 == 1
	label var w10_retro5 "Econ Worse than 1yr Ago (W10)?"
	label values w10_retro5 reverse5
	
	tab w10_retro
	tab w10_retro5
	
	*Prospective
	recode W10U4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w10_prosp)
	label var w10_prosp "Econ Worse in 1yr (W10)?"
	label values w10_prosp wor
		
	gen w10_prosp5 = .
	replace w10_prosp5 = 1  if w10_prosp == 1 & W10U5 == 1
	replace w10_prosp5 = 2  if w10_prosp == 1 & W10U5 == 2
	replace w10_prosp5 = 3  if w10_prosp == 2
	replace w10_prosp5 = 4  if w10_prosp == 3 & W10U6 == 2
	replace w10_prosp5 = 5  if w10_prosp == 3 & W10U6 == 1
	label var w10_prosp5 "Econ Worse in 1yr (W10)?"
	label values w10_prosp5 mwor
	
	tab w10_prosp 
	tab w10_prosp5	

*W11
	*Economy vs. 2001
	recode  W11U1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1)	, gen(w11_econ2001)
	label var w11_econ2001 "Econ Worse than 2001 (W11)?"
	label values w11_econ2001 reverse5
	
	recode w11_econ2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w11_econ2001_3)
	label var w11_econ2001_3 "Econ Worse than 2001 (W11)?"
	label values w11_econ2001_3 reverse

	tab w11_econ2001
	tab w11_econ2001_3

	
	*Deficit vs. 2001
	recode W11U4 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(w11_deficit2001)
	label var w11_deficit2001 "Deficit Worse than 2001 (W11)?"
	label values w11_deficit2001 reverse5
	
	recode w11_deficit2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w11_deficit2001_3)
	label var w11_deficit2001_3 "Deficit Worse than 2001 (W11)?"
	label values w11_deficit2001_3 reverse
	
	tab w11_deficit2001
	tab w11_deficit2001_3

	*Economy vs. 2007
	recode W11V1 (-7=.) (-6=.) (-5=.) (-4=.) (1=3) (2=2) (3=1)	, gen(w11_retro)
	label var w11_retro "Econ Worse than 1yr Ago (W11)?"
	label values w11_retro reverse
	
	gen w11_retro5 = .
	replace w11_retro5 = 1 if w11_retro == 1 & W11V3 == 1
	replace w11_retro5 = 2 if w11_retro == 1 & W11V3 == 2
	replace w11_retro5 = 3 if w11_retro == 2
	replace w11_retro5 = 4 if w11_retro == 3 & W11V2 == 2
	replace w11_retro5 = 5 if w11_retro == 3 & W11V2 == 1
	label var w11_retro5 "Econ Worse than 1yr Ago (W11)?"
	label values w11_retro5 reverse5

	tab w11_retro
	tab w11_retro5

	*Prospective
	recode W11V4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w11_prosp)
	label var w11_prosp "Econ Worse in 1yr (W11)?"
	label values w11_prosp wor
		
	gen w11_prosp5 = .
	replace w11_prosp5 = 1  if w11_prosp == 1 & W11V5 == 1
	replace w11_prosp5 = 2  if w11_prosp == 1 & W11V5 == 2
	replace w11_prosp5 = 3  if w11_prosp == 2
	replace w11_prosp5 = 4  if w11_prosp == 3 & W11V6 == 2
	replace w11_prosp5 = 5  if w11_prosp == 3 & W11V6 == 1
	label var w11_prosp5 "Econ Worse in 1yr (W11)?"
	label values w11_prosp5 mwor
	
	tab w11_prosp 
	tab w11_prosp5	

*W17
	*Deficit vs. 2009
	recode W17U4 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(w17_deficit2001)
	label var w17_deficit2001 "Deficit Worse than Jan. 2009 (W17)?"
	label values w17_deficit2001 reverse5
	
	recode w17_deficit2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w17_deficit2001_3)
	label var w17_deficit2001_3 "Deficit Worse Jan. 2009 (W17)?"
	label values w17_deficit2001_3 reverse
	
	tab w17_deficit2001
	tab w17_deficit2001_3
	
	gen def_knowl17 = .
	replace def_knowl17 = 1 if w17_deficit2001_3 == 1
	replace def_knowl17 = 0 if w17_deficit2001_3 >=2 & w17_deficit2001_3 <=3
	label var def_knowl17 "Deficit Knowledge" 
	label def kno 1 "Correct" 0 "Incorrect" 
	label values def_knowl17 kno
	
	
	*Economy vs. Jan. 2009
	recode W17V1 (-7=.) (-6=.) (-5=.) (-4=.) (1=3) (2=2) (3=1), gen(w17_retro)
	label var w17_retro "Econ Worse than Jan. 2009 (W17)?"
	label values w17_retro reverse
	
	gen w17_retro5 = .
	replace w17_retro5 = 1 if w17_retro == 1 & W17V3 == 1
	replace w17_retro5 = 2 if w17_retro == 1 & W17V3 == 2
	replace w17_retro5 = 3 if w17_retro == 2
	replace w17_retro5 = 4 if w17_retro == 3 & W17V2 == 2
	replace w17_retro5 = 5 if w17_retro == 3 & W17V2 == 1
	label var w17_retro5 "Econ Worse since Jan. 2009 (W17)?"
	label values w17_retro5 reverse5

	tab w17_retro
	tab w17_retro5
	
	*Prospective
	recode W17V4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w17_prosp)
	label var w17_prosp "Econ Worse in 1yr (W17)?"
	label values w17_prosp wor
		
	gen w17_prosp5 = .
	replace w17_prosp5 = 1  if w17_prosp == 1 & W17V5 == 1
	replace w17_prosp5 = 2  if w17_prosp == 1 & W17V5 == 2
	replace w17_prosp5 = 3  if w17_prosp == 2
	replace w17_prosp5 = 4  if w17_prosp == 3 & W17V6 == 2
	replace w17_prosp5 = 5  if w17_prosp == 3 & W17V6 == 1
	label var w17_prosp5 "Econ Worse in 1yr (W17)"
	label values w17_prosp5 mwor
	
	tab w17_prosp 
	tab w17_prosp5	


*W19
	*Deficit vs. 2009
	recode W19U4 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(w19_deficit2001)
	label var w19_deficit2001 "Deficit Worse than Jan. 2009 (W19)?"
	label values w19_deficit2001 reverse5
	
	recode w19_deficit2001 (1=1) (2=1) (3=2) (4=3) (5=3), gen(w19_deficit2001_3)
	label var w19_deficit2001_3 "Deficit Worse Jan. 2009 (W19)?"
	label values w19_deficit2001_3 reverse
	
	tab w19_deficit2001
	tab w19_deficit2001_3
	
	gen def_knowl19 = . 
	replace def_knowl19 = 1 if w19_deficit2001_3 == 1
	replace def_knowl19 = 0 if w19_deficit2001_3 >=2 & w19_deficit2001_3 <=3
	label var def_knowl19 "Deficit Knowledge" 
	label values def_knowl19 kno
	
	
	*Economy vs. Jan. 2009
	recode W19V1 (-7=.) (-6=.) (-5=.) (-4=.) (1=3) (2=2) (3=1)	, gen(w19_retro)
	label var w19_retro "Econ Worse than Jan. 2009 (W19)?"
	label values w19_retro reverse
	
	gen w19_retro5 = .
	replace w19_retro5 = 1 if w19_retro == 1 & W19V3 == 1
	replace w19_retro5 = 2 if w19_retro == 1 & W19V3 == 2
	replace w19_retro5 = 3 if w19_retro == 2
	replace w19_retro5 = 4 if w19_retro == 3 & W19V2 == 2
	replace w19_retro5 = 5 if w19_retro == 3 & W19V2 == 1
	label var w19_retro5 "Econ Worse since Jan. 2009 (W19)?"
	label values w19_retro5 reverse5

	tab w19_retro
	tab w19_retro5
	
	*Prospective
	recode W19V4 (-7=.) (-6=.) (-5=.) (-4=.), gen(w19_prosp)
	label var w19_prosp "Econ Worse in 1yr (W19)?"
	label values w19_prosp wor
		
	gen w19_prosp5 = .
	replace w19_prosp5 = 1  if w19_prosp == 1 & W19V5 == 1
	replace w19_prosp5 = 2  if w19_prosp == 1 & W19V5 == 2
	replace w19_prosp5 = 3  if w19_prosp == 2
	replace w19_prosp5 = 4  if w19_prosp == 3 & W19V6 == 2
	replace w19_prosp5 = 5  if w19_prosp == 3 & W19V6 == 1
	label var w19_prosp5 "Econ Worse in 1yr (W19)"
	label values w19_prosp5 mwor
	
	tab w19_prosp 
	tab w19_prosp5	
	
	recode W19WU13 (1=1) (2=0) (-7=.) (-6=.) (-5=.), gen(obamarecession)
	label var obamarecession "Obama Helped End Recession?"
	label def oba 1 "Obama Helped End Recession" 0 "Obama Has Not Helped End It"
	label values obamarecession oba
	tab obamarecession


*Relationships Over Time*
	pwcorr 	w1_retro5 w6_retro5 w10_retro5 w11_retro5 	w17_retro5 w19_retro5, sig
	pwcorr w1_prosp5 	 w6_prosp5 	 w10_prosp5 	 w11_prosp5  w17_prosp5 	 w19_prosp5, sig
	
	
		************************************
		*********Partisanship***************
		************************************
label def pi1 1 "Strong Democrat" 2 "Not Strong Dem" 3 "Lean Dem" 4 "Ind." 5 "Lean Rep" 6 "Not Strong Rep" 7 "Strong Rep"
label def pi2 1 "Democrat" 2 "Republican" 3 "Independent"
label def pi3 1 "Democrat" 0 "Republican"
label def str 1 "Lean" 2 "Not Strong" 3 "Strong"
label def part 1 "In-Partisan" 0 "Out-Partisan"

		
*W1
	recode DER08W1 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (-7=.) (-6=.) (-5=.) (-4=.), gen(partyid1)
	label var partyid1 "PID (W1)"
	label values partyid1 pi1
	
	gen pid_31 = .
	replace pid_31 = 1 if partyid1 >=1 & partyid1 <= 3
	replace pid_31 = 2 if partyid1 >=5 & partyid1 <= 7
	replace pid_31 = 3 if partyid1 == 4
	label var pid_31 "PID (W1)"
	label values pid_31 pi2
	
	gen pid_21 = .
	replace pid_21 = 1 if pid_31 == 1
	replace pid_21 = 0 if pid_31 == 2
	label var pid_21 "PID (W1)"
	label values pid_21 pi3
	
	gen pid_str1 = .
	replace pid_str1 =  1 if partyid == 3
	replace pid_str1 =  1 if partyid == 5
	replace pid_str1 =  2 if partyid == 2
	replace pid_str1 =  2 if partyid == 6
	replace pid_str1 =  3 if partyid == 1
	replace pid_str1 =  3 if partyid == 7
	label var pid_str1 "PID Str (W1)"
	label values pid_str1 str
	
	tab partyid1
	tab pid_31
	tab pid_21
	tab pid_str1
	
	recode pid_21 (1=0) (0=1), gen(partisan_1)
	label var partisan_1 "Co-Partisan to Pres? (W1)"
	label values partisan_1 part 
	
	
	
*W9
	recode DER08W9 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (-7=.) (-6=.) (-5=.) (-4=.), gen(partyid9)
	label var partyid9 "PID (W9)"
	label values partyid9 pi1
	
	gen pid_39 = .
	replace pid_39 = 1 if partyid9 >=1 & partyid9 <= 3
	replace pid_39 = 2 if partyid9 >=5 & partyid9 <= 7
	replace pid_39 = 3 if partyid9 == 4
	label var pid_39 "PID (W9)"
	label values pid_39 pi2
	
	gen pid_29 = .
	replace pid_29 = 1 if pid_39 == 1
	replace pid_29 = 0 if pid_39 == 2
	label var pid_29 "PID (W9)"
	label values pid_29 pi3
	
	gen pid_str9 = .
	replace pid_str9 =  1 if partyid9 == 3
	replace pid_str9 =  1 if partyid9 == 5
	replace pid_str9 =  2 if partyid9 == 2
	replace pid_str9 =  2 if partyid9 == 6
	replace pid_str9 =  3 if partyid9 == 1
	replace pid_str9 =  3 if partyid9 == 7
	label var pid_str9 "PID Str (W9)"
	label values pid_str9 str
	
	tab partyid9
	tab partyid9 DER08W9
	tab pid_39
	tab pid_29
	tab pid_str9
	
	recode pid_29 (1=0) (0=1), gen(partisan_9)
	label var partisan_9 "Co-Partisan to Pres? (W1)"
	label values partisan_9 part 
	
	gen partisan_9rev = pid_29
	label var partisan_9rev "Co-Paritsan to Pres Obama? (W9)"
	label values partisan_9rev part
	
	
*W10
	recode DER08W10 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (-7=.) (-6=.) (-5=.) (-4=.), gen(partyid10)
	label var partyid10 "PID (W10)"
	label values partyid10 pi1
	
	gen pid_310 = .
	replace pid_310 = 1 if partyid10 >=1 & partyid10 <= 3
	replace pid_310 = 2 if partyid10 >=5 & partyid10 <= 7
	replace pid_310 = 3 if partyid10 == 4
	label var pid_310 "PID (W10)"
	label values pid_310 pi2
	
	gen pid_210 = .
	replace pid_210 = 1 if pid_310 == 1
	replace pid_210 = 0 if pid_310 == 2
	label var pid_210 "PID (W10)"
	label values pid_210 pi3
	
	gen pid_str10 = .
	replace pid_str10 =  1 if partyid10 == 3
	replace pid_str10 =  1 if partyid10 == 5
	replace pid_str10 =  2 if partyid10 == 2
	replace pid_str10 =  2 if partyid10 == 6
	replace pid_str10 =  3 if partyid10 == 1
	replace pid_str10 =  3 if partyid10 == 7
	label var pid_str10 "PID Str (W10)"
	label values pid_str10 str
	
	tab partyid10
	tab partyid10 DER08W10
	tab pid_310
	tab pid_210
	tab pid_str10
	
	recode partyid10 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str10_full)
	label var pid_str10 "PID Str (W10)"
	label def full 1 "Ind" 2 "Lean" 3 "Not Strong" 4 "Strong"
	label values pid_str10 full
	
	
	
	
*W11
	recode DER08W11 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (-7=.) (-6=.) (-5=.) (-4=.), gen(partyid11)
	label var partyid11 "PID (W11)"
	label values partyid11 pi1
	
	gen pid_311 = .
	replace pid_311 = 1 if partyid11 >=1 & partyid11 <= 3
	replace pid_311 = 2 if partyid11 >=5 & partyid11 <= 7
	replace pid_311 = 3 if partyid11 == 4
	label var pid_311 "PID (W11)"
	label values pid_311 pi2
	
	gen pid_211 = .
	replace pid_211 = 1 if pid_311 == 1
	replace pid_211 = 0 if pid_311 == 2
	label var pid_211 "PID (W11)"
	label values pid_211 pi3
	
	gen pid_str11 = .
	replace pid_str11 =  1 if partyid11 == 3
	replace pid_str11 =  1 if partyid11 == 5
	replace pid_str11 =  2 if partyid11 == 2
	replace pid_str11 =  2 if partyid11 == 6
	replace pid_str11 =  3 if partyid11 == 1
	replace pid_str11 =  3 if partyid11 == 7
	label var pid_str11 "PID Str (W9)"
	label values pid_str11 str
	
	tab partyid11
	tab partyid11 DER08W11
	tab pid_311
	tab pid_211
	tab pid_str11

	recode partyid11 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str11_full)
	label var pid_str11 "PID Str (W11)"
	label values pid_str11 full
	
	
	
*W17
	recode DER08W17 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) ///
		(-7=.) (-6=.) (-5=.) (-4=.) (-2=.), gen(partyid17)
	label var partyid17 "PID (W17)"
	label values partyid17 pi1
	
	gen pid_317 = .
	replace pid_317 = 1 if partyid17 >=1 & partyid17 <= 3
	replace pid_317 = 2 if partyid17 >=5 & partyid17 <= 7
	replace pid_317 = 3 if partyid17 == 4
	label var pid_317 "PID (W17)"
	label values pid_317 pi2
	
	gen pid_217 = .
	replace pid_217 = 1 if pid_317 == 1
	replace pid_217 = 0 if pid_317 == 2
	label var pid_217 "PID (W17)"
	label values pid_217 pi3
	
	gen pid_str17 = .
	replace pid_str17 =  1 if partyid17 == 3
	replace pid_str17 =  1 if partyid17 == 5
	replace pid_str17 =  2 if partyid17 == 2
	replace pid_str17 =  2 if partyid17 == 6
	replace pid_str17 =  3 if partyid17 == 1
	replace pid_str17 =  3 if partyid17 == 7
	label var pid_str17 "PID Str (W9)"
	label values pid_str17 str
	
	tab partyid17
	tab partyid17 DER08W17
	tab pid_317
	tab pid_217
	tab pid_str17
	
	gen partisan_17 = pid_217
	label var partisan_17 "Co-Partisan to Pres Obama? (W17)"
	label values partisan_17 part
	
	recode partyid17 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str17_full)
	label var pid_str17 "PID Str (W10)"
	label values pid_str17 full
	
		
*W19
	recode DER08W19 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (-7=.) (-6=.) (-5=.) (-4=.) (-2=.), gen(partyid19)
	label var partyid19 "PID (W19)"
	label values partyid19 pi1
	
	gen pid_319 = .
	replace pid_319 = 1 if partyid19 >=1 & partyid19 <= 3
	replace pid_319 = 2 if partyid19 >=5 & partyid19 <= 7
	replace pid_319 = 3 if partyid19 == 4
	label var pid_319 "PID (W19)"
	label values pid_319 pi2
	
	gen pid_219 = .
	replace pid_219 = 1 if pid_319 == 1
	replace pid_219 = 0 if pid_319 == 2
	label var pid_219 "PID (W19)"
	label values pid_219 pi3
	
	gen pid_str19 = .
	replace pid_str19 =  1 if partyid19 == 3
	replace pid_str19 =  1 if partyid19 == 5
	replace pid_str19 =  2 if partyid19 == 2
	replace pid_str19 =  2 if partyid19 == 6
	replace pid_str19 =  3 if partyid19 == 1
	replace pid_str19 =  3 if partyid19 == 7
	label var pid_str19 "PID Str (W9)"
	label values pid_str19 str
	
	tab partyid19
	tab partyid19 DER08W19
	tab pid_319
	tab pid_219
	tab pid_str19
	
	recode partyid19 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str19_full)
	label var pid_str19 "PID Str (W10)"
	label values pid_str19 full
	
		
*Relationship over time
	pwcorr partyid1 partyid9 partyid10 partyid11 partyid17 partyid19, sig
	pwcorr pid_str1 pid_str9 pid_str10 pid_str11 pid_str17 pid_str19, sig
		
		
	tab w1_retro pid_21, row col chi2
	tab w6_retro pid_21, row col chi2
	tab w10_retro pid_21, row col chi2
	tab w11_retro pid_21, row col chi2
	tab w10_retro pid_29, row col chi2
	tab w11_retro pid_29, row col chi2
	
	tab w17_retro pid_21, row col chi2
	tab w17_retro pid_29, row col chi2
	tab w19_retro pid_21, row col chi2
	tab w19_retro pid_29, row col chi2
		
		
		
		
		*****************************************************
		*********Network Size and Disagreement***************
		*****************************************************

*# Names given/asked about
	tab DER17
	gen numgiven = DER17
	replace numgiven = . if numgiven < 0
	label var numgiven "Number of Listed Discussants"
	tab numgiven 
	summ numgiven, detail
		
	
	gen numgiven1 = numgiven
	replace numgiven1 = 3 if numgiven > 3 & numgiven <=8
	label var numgiven1 "Number of Disc. Asked About"
	tab numgiven1
	tab numgiven numgiven1
	
	summ numgiven1 
	gen numgiven01 = (numgiven1 - r(min))/(r(max)-r(min))
	label var numgiven01 "Network Size"
	
*****Partisan Disagreement
	
	/**half of respondents asked whether the discussant was a republican, 
		half asked if a Democrat**/
	
	foreach var in W9ZD12_1 W9ZD13_1 W9ZD12_2 W9ZD13_2 W9ZD12_3 W9ZD13_3 {
		tab `var'
		}
	
	*For 12_:
		*1 = Dem
		*2 = Republican
		*3 = ind
		*4 = something else
		
	*For 13_: 
		*1: Republican
		*2 = Dem
		*3 = Ind
		*4 = something else
	
	foreach var in W9ZD12_1 W9ZD12_2 W9ZD12_3 W9ZD13_2 W9ZD12_3 W9ZD13_3  {
		tab `var' if `var' >0
		}
		
	*Creating PID Scale, inc. leaners*
		*1 = Democrat, 2 = Republican; 3 = Ind
		
		label def dpid 1 "Democrat" 2 "Republican" 3 "Independent"
		
		
		gen d1_pid = . 
		replace d1_pid = 1 if W9ZD12_1 == 1 
		replace d1_pid = 1 if W9ZD12_1 == 3 & W9ZD16_1 == 1
		replace d1_pid = 1 if W9ZD12_1 == 4 & W9ZD16_1 == 1
		replace d1_pid = 2 if W9ZD12_1 == 2
		replace d1_pid = 2 if W9ZD12_1 == 3 & W9ZD16_1 == 2
		replace d1_pid = 2 if W9ZD12_1 == 4 & W9ZD16_1 == 2
		replace d1_pid = 3 if W9ZD12_1 == 3 & W9ZD16_1 == 3
		replace d1_pid = 3 if W9ZD12_1 == 4 & W9ZD16_1 == 3
		replace d1_pid = 2 if W9ZD13_1 == 1 
		replace d1_pid = 2 if W9ZD13_1 == 3 & W9ZD16_1 == 1
		replace d1_pid = 2 if W9ZD13_1 == 4 & W9ZD16_1 == 1
		replace d1_pid = 1 if W9ZD13_1 == 2
		replace d1_pid = 1 if W9ZD13_1 == 3 & W9ZD16_1 == 2
		replace d1_pid = 1 if W9ZD13_1 == 4 & W9ZD16_1 == 2
		replace d1_pid = 3 if W9ZD13_1 == 3 & W9ZD16_1 == 3
		replace d1_pid = 3 if W9ZD13_1 == 4 & W9ZD16_1 == 3
		
		
		gen d2_pid = . 
		replace d2_pid = 1 if W9ZD12_2 == 1 
		replace d2_pid = 1 if W9ZD12_2 == 3 & W9ZD16_2 == 1
		replace d2_pid = 1 if W9ZD12_2 == 4 & W9ZD16_2 == 1
		
		replace d2_pid = 2 if W9ZD12_2 == 2
		replace d2_pid = 2 if W9ZD12_2 == 3 & W9ZD16_2 == 2
		replace d2_pid = 2 if W9ZD12_2 == 4 & W9ZD16_2 == 2

		replace d2_pid = 3 if W9ZD12_2 == 3 & W9ZD16_2 == 3
		replace d2_pid = 3 if W9ZD12_2 == 4 & W9ZD16_2 == 3

		replace d2_pid = 2 if W9ZD13_2 == 1 
		replace d2_pid = 2 if W9ZD13_2 == 3 & W9ZD16_2 == 1
		replace d2_pid = 2 if W9ZD13_2 == 4 & W9ZD16_2 == 1
		
		replace d2_pid = 1 if W9ZD13_2 == 2
		replace d2_pid = 1 if W9ZD13_2 == 3 & W9ZD16_2 == 2
		replace d2_pid = 1 if W9ZD13_2 == 4 & W9ZD16_2 == 2

		replace d2_pid = 3 if W9ZD13_2 == 3 & W9ZD16_2 == 3
		replace d2_pid = 3 if W9ZD13_2 == 4 & W9ZD16_2 == 3
		
		
		gen d3_pid = . 
		replace d3_pid = 1 if W9ZD12_3 == 1 
		replace d3_pid = 1 if W9ZD12_3 == 3 & W9ZD16_3 == 1
		replace d3_pid = 1 if W9ZD12_3 == 4 & W9ZD16_3 == 1
		
		replace d3_pid = 2 if W9ZD12_3 == 2
		replace d3_pid = 2 if W9ZD12_3 == 3 & W9ZD16_3 == 2
		replace d3_pid = 2 if W9ZD12_3 == 4 & W9ZD16_3 == 2

		replace d3_pid = 3 if W9ZD12_3 == 3 & W9ZD16_3 == 3
		replace d3_pid = 3 if W9ZD12_3 == 4 & W9ZD16_3 == 3

		replace d3_pid = 2 if W9ZD13_3 == 1 
		replace d3_pid = 2 if W9ZD13_3 == 3 & W9ZD16_3 == 1
		replace d3_pid = 2 if W9ZD13_3 == 4 & W9ZD16_3 == 1
		
		replace d3_pid = 1 if W9ZD13_3 == 2
		replace d3_pid = 1 if W9ZD13_3 == 3 & W9ZD16_3 == 2
		replace d3_pid = 1 if W9ZD13_3 == 4 & W9ZD16_3 == 2

		replace d3_pid = 3 if W9ZD13_3 == 3 & W9ZD16_3 == 3
		replace d3_pid = 3 if W9ZD13_3 == 4 & W9ZD16_3 == 3
		
		label values d1_pid d2_pid d3_pid  dpid
		
	*Agreement
		*1 = Dem/Dem, Ind/Ind, Rep/Rep
		*0 = Dem/Rep, Dem/Something Else, Dem/Ind
		*0= Rep/Dem,. Rep/Something Else, rep/Ind
		*0 = Ind/Dem, Ind/Rep
		label def ag 1 "Agree" 0 "Disagree" 
		
		gen d1_agree = . 
		replace d1_agree = 1 if pid_39 == 1 & d1_pid == 1
		replace d1_agree = 1 if pid_39 == 2 & d1_pid == 2
		replace d1_agree = 1 if pid_39 == 3 & d1_pid == 3
		replace d1_agree = 0 if pid_39 == 1 & d1_pid == 2
		replace d1_agree = 0 if pid_39 == 1 & d1_pid == 3
		replace d1_agree = 0 if pid_39 == 2 & d1_pid == 1
		replace d1_agree = 0 if pid_39 == 2 & d1_pid == 3
		replace d1_agree = 0 if pid_39 == 3 & d1_pid == 1
		replace d1_agree = 0 if pid_39 == 3 & d1_pid == 2
		label var d1_agree "D1 Agree?"
		label values d1_agree ag
		

		gen d2_agree = .
		replace d2_agree = 1 if pid_39 == 1 & d2_pid == 1
		replace d2_agree = 1 if pid_39 == 2 & d2_pid == 2
		replace d2_agree = 1 if pid_39 == 3 & d2_pid == 3
		
		replace d2_agree = 0 if pid_39 == 1 & d2_pid == 2
		replace d2_agree = 0 if pid_39 == 1 & d2_pid == 3
		replace d2_agree = 0 if pid_39 == 2 & d2_pid == 1
		replace d2_agree = 0 if pid_39 == 2 & d2_pid == 3
		replace d2_agree = 0 if pid_39 == 3 & d2_pid == 1
		replace d2_agree = 0 if pid_39 == 3 & d2_pid == 2
			
		label var d2_agree "D2 Agree?"
		label values d2_agree ag
		
		
		gen d3_agree = .
		replace d3_agree = 1 if pid_39 == 1 & d3_pid == 1
		replace d3_agree = 1 if pid_39 == 2 & d3_pid == 2
		replace d3_agree = 1 if pid_39 == 3 & d3_pid == 3
		
		replace d3_agree = 0 if pid_39 == 1 & d3_pid == 2
		replace d3_agree = 0 if pid_39 == 1 & d3_pid == 3
		replace d3_agree = 0 if pid_39 == 2 & d3_pid == 1
		replace d3_agree = 0 if pid_39 == 2 & d3_pid == 3
		replace d3_agree = 0 if pid_39 == 3 & d3_pid == 1
		replace d3_agree = 0 if pid_39 == 3 & d3_pid == 2
		label var d3_agree "D3 Agree?"
		label values d3_agree ag
		
		tab d1_agree
		tab d2_agree
		tab d3_agree
		tab d1_agree d2_agree, row col
		tab d1_agree d3_agree, row col
		tab d2_agree d3_agree, row col
	
	*Disagreement
		*0 = Dem/Dem, Ind/Ind, Rep/Rep
		*1 = Dem/Rep, Dem/Something Else, Dem/Ind
		*1= Rep/Dem,. Rep/Something Else, rep/Ind
		*1 = Ind/Dem, Ind/Rep
		
		label def disag1 1 "Disagree" 0 "Aggree" 

		omscore d1_agree
		rename rr_d1_agree d1_disagree
		label var d1_disagree "D1 Agree?"
		label values d1_disagree disag1
		
		omscore d2_agree
		rename rr_d2_agree d2_disagree		
		label var d2_disagree "D2 Agree?"
		label values d2_disagree disag1
		
		omscore d3_agree
		rename rr_d3_agree d3_disagree
		label var d3_disagree "D3 Agree?"
		label values d3_disagree disag1
		
		
		tab d1_agree d1_disagree

		
	*Summary and Average
	*Summary Agreement
		egen pid_agree = rowtotal(d1_agree d2_agree d3_agree), missing
	*Disagreement
		egen pid_disagree = rowtotal(d1_disagree d2_disagree d3_disagree), missing
	
	*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
			gen disagree_total = pid_disagree - pid_agree
			label var disagree_total "Network Disagreement"
		*Divided by network size
			*See Lupton and Thonrton: (D-A)/(D+A)
			gen disagree_avg = [pid_disagree - pid_agree]/[pid_disagree + pid_agree]
			label var disagree_avg "Network Disagreement"
		
		
	*Diversity Measure*
		*From Nir (2005): [(Agree+Disagree)/2] - |A-D|
			gen network_ambiv = [(pid_agree+pid_disagree)/2] - abs(pid_agree - pid_disagree)
			label var network_ambiv "Network Political Diversity"
		
			summ network_ambiv
			gen network_ambiv01=(network_ambiv - r(min))/(r(max)-r(min))
			label var network_ambiv01 "Network Political Diversity"	
		

	
*General Agreement
	label def gendifference 1 "Not Different at All" 2 "Slightly Different" 3 "Moderately Different" 4 "Very Different" 5 "Extremely Different"
	gen gendiff1 = . 
	replace gendiff1 = 1 if W9ZD9_1 == 5
	replace gendiff1 = 2 if W9ZD9_1 == 4
	replace gendiff1 = 3 if W9ZD9_1 == 3
	replace gendiff1 = 4 if W9ZD9_1 == 2
	replace gendiff1 = 5 if W9ZD9_1 == 1
	label var gendiff1 "General Difference with Disc. 1"
	label values gendiff1 gendifference
	tab gendiff1 W9ZD9_1
	
	
	gen gendiff2 = . 
	replace gendiff2 = 1 if W9ZD9_2 == 5
	replace gendiff2 = 2 if W9ZD9_2 == 4
	replace gendiff2 = 3 if W9ZD9_2 == 3
	replace gendiff2 = 4 if W9ZD9_2 == 2
	replace gendiff2 = 5 if W9ZD9_2 == 1
	label var gendiff2 "General Difference with Disc. 2"
	label values gendiff2 gendifference
		tab gendiff2 W9ZD9_2

	
	gen gendiff3 = . 
	replace gendiff3 = 1 if W9ZD9_3 == 5
	replace gendiff3 = 2 if W9ZD9_3 == 4
	replace gendiff3 = 3 if W9ZD9_3 == 3
	replace gendiff3 = 4 if W9ZD9_3 == 2
	replace gendiff3 = 5 if W9ZD9_3 == 1
	label var gendiff3 "General Difference with Disc. 3"
	label values gendiff3 gendifference
	tab gendiff3 W9ZD9_3
	egen gendiff = rowmean(gendiff1 gendiff2 gendiff3)
	label var gendiff "General Disagreement"
	tab gendiff1
	tab gendiff2
	tab gendiff3
	

*Relationship, General and Partisan*
	pwcorr disagree_total disagree_avg gendiff, sig
	ttest gendiff1, by(d1_agree)
	ttest gendiff2, by(d2_agree)
	ttest gendiff3, by(d3_agree)

*Combined (old)
		gen d1_both = d1_disagree + gendiff1
		gen d2_both = d2_disagree + gendiff2
		gen d3_both = d3_disagree + gendiff3
		tab d1_both
		tab d2_both
		tab d3_both
		
		egen dis_both = rowmean(d1_both d2_both d3_both)
		label var dis_both "Index of Network Disagreement"
		summ dis_both, detail
		tab dis_both

		
		*Combined Index (new)
	/**fn. 5 (Lupton and Thornton: 
			A = sum(ai * si) where a = 1 if agree and s = agreement weight
			D = sum(di * si) where d = 1 if disagree and s = disagreement weight
			Disagreement = D - A**/
			
		*Agreement Coding*
			foreach var in gendiff1 gendiff2 gendiff3 {
				recode `var' (1=5) (2=4) (3=3) (4=2) (5=1), gen(`var'_ag)
				}
		*Agree Scale
			gen a1 = d1_agree * gendiff1_ag
			gen a2 = d2_agree * gendiff2_ag
			gen a3 = d3_agree * gendiff3_ag
			egen agree_weight = rowtotal(a1 a2 a3), missing

		
		*Disagree Scale
			gen d1 = d1_disagree * gendiff1
			gen d2 = d2_disagree * gendiff2
			gen d3 = d3_disagree * gendiff3
			egen disagree_weight = rowtotal(d1 d2 d3), missing

		*Exposure to Disagreement
			gen disagree_total_weight = disagree_weight - agree_weight
			gen disagree_avg_weight = disagree_total_weight/(pid_disagree+pid_agree)
		
			foreach var in disagree_total_weight disagree_avg_weight {
				summ `var' 
				gen `var'01 = (`var' - r(min))/(r(max)-r(min))
				tab `var'01
			}
			
			label var disagree_total_weight "Network Disagreement"
			label var disagree_total_weight "Network Disagreement"
		
			label var disagree_avg_weight "Network Disagreement"
			label var disagree_avg_weight "Network Disagreement"
		
		
		***************************************************
		*****************Control Variables*****************
		***************************************************
	
*Education
	recode DER05 (-6=.) (-2=.) (5=4),  gen(educ)
	label var educ "Education"
	label def ed 1 "< HS" 2 "HS" 3 " Some College" 4 "Bachelor+"
	label values educ ed
	
	summ educ 
	gen educ01 = (educ - r(min))/(r(max)-r(min))
	label var educ "Education"
	
*Age
	rename DER02 age
	label var age "Age"
	
	summ age 
	gen age01 = (age - r(min))/(r(max)-r(min))
	label var age01 "Age"
	
	
*Income
	rename DER06 income
	replace income = . if income < 0	
	label var income "Income"
	
	summ income
	gen income01 = (income - r(min))/(r(max)-r(min))
	label var income01 "Income"
	
	
*Race
	rename DER04 race_eth
	label var race_eth "Race/Ethnicity"
	label def rac 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
	label values race_eth rac
	
*Gender
	recode DER01 (1=0) (2=1), gen(gender)
	label var gender "Gender" 
	label def gena 1 "Female" 0 "Male"
	label values gender gena

*Employment
	*CP (Core Profile?) Question
		recode CPQ17 (-7=.) (-6=.) (-5=.) (-4=.) (1=1) (2=1) (3=2) (4=2) (5=3) (6=4) (7=5), gen(empl_cp)
		label var empl_cp "Employment (CP)"
		label def emp 1 "Working" 2 "Unemployed" 3 "Retired" 4 "Disabled" 5 "Not Working: Other" 
		label values empl_cp emp
		
		recode empl_cp (1=1) (2=2) (3=3) (4=4) (5=4) , gen(empl_cp1)
		label def emp2 1 "Working" 2 "Unemployed" 3 "Retired" 4 "Disabled/Not Working/Other"
		label values empl_cp1 emp2
		label var empl_cp1 "Employment"

		
	*Employment (W11)
		recode W11ZG1 (-7=.) (-6=.) (-5=.) (-4=.) (1=1) (2=1) (3=2) (4=2) (5=3) (6=4) (7=5), gen(empl_w11)
		label var empl_w11 "Employment (W11)"
		label values empl_w11 emp
		
		recode empl_w11 (1=1) (2=2) (3=3)(4=4) (5=4) (6=4) (7=4), gen(empl_w11a)
		label values empl_w11a emp2
		label var empl_w11a "Employment (W11)"
		
		
		
	*Relationship
		tab empl_cp empl_w11, row col

*Married Status
	recode DER24 (-6=.) (-2=.) (1=1) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=0) (9=0), gen(marital)
	label var marital "Marriage Status"
	label def mar 1 "Married" 0 "Not Married" 
	label values marital mar
	tab marital

*Interest
	label def inte 1 "Not Interested" 2 "Slightly" 3 "Moderately" 4 "Very" 5 "Extremely"
	*W1
		recode  W1K1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(interest_w1)
		label var interest_w1 "Pol. Interest (W1)"
		label values interest_w1 inte
		tab interest_w1
	*W9
		recode  W9H1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(interest_w9)
		label var interest_w9 "Pol. Interest (W9)"
		label values interest_w9 inte
		tab interest_w9
	*W10
		recode  W10H1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(interest_w10)
		label var interest_w10 "Pol. Interest (W10)"
		label values interest_w10 inte
		tab interest_w10
	*W11
			recode  W11H1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(interest_w11)
		label var interest_w11 "Pol. Interest (W11)"
		label values interest_w11 inte
		tab interest_w11
	*W19
		recode  W19H1 (-7=.) (-6=.) (-5=.) (-4=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(interest_w19)
		label var interest_w19 "Pol. Interest (W19)"
		label values interest_w19 inte
		tab interest_w19
	*Relationship
		pwcorr interest_w1 interest_w9  interest_w10  interest_w11  interest_w19, sig 
	

*Avg. Discussant Interest in Politics
	label def discinterest 1 "Not at all" 2 "Slightly" 3 "Moderately" 4 "Very" 5 "Extremely"
	gen interestd1 = .
	replace interestd1 = 1 if W9ZD17_1 == 5
	replace interestd1 = 2 if W9ZD17_1 == 4
	replace interestd1 = 3 if W9ZD17_1 == 3
	replace interestd1 = 4 if W9ZD17_1 == 2
	replace interestd1 = 5 if W9ZD17_1 == 1		
	label var interestd1 "Disc. 1 Interest Level"
	label values interestd1 discinterest 
	tab interestd1 W9ZD17_1		
				
	gen interestd2 = .
	replace interestd2 = 1 if W9ZD17_2 == 5
	replace interestd2 = 2 if W9ZD17_2 == 4
	replace interestd2 = 3 if W9ZD17_2 == 3
	replace interestd2 = 4 if W9ZD17_2 == 2
	replace interestd2 = 5 if W9ZD17_2 == 1		
	label var interestd2 "Disc. 2 Interest Level"
	label values interestd2 discinterest 			
	tab interestd2 W9ZD17_2		

	gen interestd3 = .
	replace interestd3 = 1 if W9ZD17_3 == 5
	replace interestd3 = 2 if W9ZD17_3 == 4
	replace interestd3 = 3 if W9ZD17_3 == 3
	replace interestd3 = 4 if W9ZD17_3 == 2
	replace interestd3 = 5 if W9ZD17_3 == 1		
	label var interestd3 "Disc. 3 Interest Level"
	label values interestd3 discinterest 
	tab interestd3 W9ZD17_3		
	
	summ interestd1-interestd3
	
	egen network_interest = rowmean(interestd1 interestd2 interestd3)
	label var network_interest "Network Pol. Interest"
	
		*Weighted Scale
		
			*Agree/Weight
			gen a1i = d1_agree * interestd1
			gen a2i = d2_agree * interestd2
			gen a3i = d3_agree * interestd3
			egen agree_int = rowtotal(a1i a2i a3i), missing
		
			*Disagree/Weight
			gen d1i = d1_disagree * interestd1
			gen d2i = d2_disagree * interestd2
			gen d3i = d3_disagree * interestd3
			egen disagree_int = rowtotal(d1i d2i d3i), missing
		
			*Scale
				gen disagree_total_int = disagree_int - agree_int
				gen disagree_avg_int = disagree_total_int/(pid_disagree + pid_agree)
				label var disagree_total_int "Network Disagreement (Interest Weighted)"
				label var disagree_avg_int "Network Disagreement (Interest Weighted)"
				
				foreach var in disagree_total_int disagree_avg_int {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_int01 "Network Disagreement (Interest Weighted)"
				label var disagree_avg_int01 "Network Disagreement (Interest Weighted)"
				

*Network Ties - How close to each other?

recode W9ZD8A W9ZD8B W9ZD8C (-6=.) (-5=.) (-1=.) ///
	(1=6) (2=5) (3=4) (4=3) (5=2) (6=1), gen(tclose1 tclose2 tclose3)

egen network_close = rowmean(tclose1 tclose2 tclose3) 
label var network_close "Avg. Closeness of Ties to Each Other"

*Weighted by Tie Closenes*
	recode  W9ZD4_1  W9ZD4_2  W9ZD4_3 ///
		(-7=.) (-6=.) (-5=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(close1 close2 close3)
	
	*Agree/Weight
			gen a1c = d1_agree * close1
			gen a2c = d2_agree * close2
			gen a3c = d3_agree * close3
			egen agree_close = rowtotal(a1c a2c a3c), missing
		
		*Disagree/Weight
			gen d1c = d1_disagree * close1
			gen d2c = d2_disagree * close2
			gen d3c = d3_disagree * close3
			egen disagree_close = rowtotal(d1c d2c d3c), missing
		
			*Scale
				gen disagree_total_close = disagree_close - agree_close
		
		
				
	
*Personal Economic Situation (W19)
	recode W19WX3 (-7=.) (-6=.) (-5=.) (1=5) (2=4) (3=3) (4=2) (5=1), gen(pers_finance)
	label var pers_finance "Personal Economic Situation, Past 3mos"
	label def pers 1 "Not at all Diff." 2 "Slightly Difficult" 3 "Moderately" 4 "Very" 5 "Extremely"
	label values pers_finance pers
	
	
*Political Knowledge


	*W2
		label def correct 1 "Correct" 0 "Incorrect/NA"
		*Presidential Term Liimit*
			gen term = . 
			replace term = 1 if W2U2 == 2
			replace term = 0 if W2U2 == 1
			replace term = 0 if W2U2 >=3 & W2U2 <= 60
			replace term = 0 if W2U2 == -7
			label var term "Pres. Term Limit" 
			label values term correct
			tab term	
		*Senator Term
			gen sen_term = . 
			replace sen_term = 1 if W2U3 == 6
			replace sen_term = 0 if W2U3 >=0 & W2U3 <= 5
			replace sen_term = 0 if W2U3 >=7 & W2U3 <=66
			replace sen_term = 0 if W2U3 == -7
			label var sen_term "Senator Term Limit"
			label values sen_term correct
			tab sen_term 
			
		*Senator Per State
			gen senators = .
			replace senators = 1 if W2U4 == 2
			replace senators = 0 if W2U4 >=3 & W2U4 <= 1000
			replace senators = 0 if W2U4 >=0 & W2U4 <= 1
			replace senators = 0 if W2U4 == -7
			label var senators "#Senators per State"
			label values senators correct
			tab senators
			
			
		*House Term
			gen house_term = .
			replace house_term = 1 if W2U5 == 2
			replace house_term = 0 if W2U5 >=0 & W2U5 <=1
			replace house_term = 0 if W2U5 >=3 & W2U5 <=100
			replace house_term = 0 if W2U5 == -7
			label var house_term "House Rep Term Limit"
			label values house_term correct
			tab house_term
			
		
		*Who Takes Over if Pres and VP Die
			gen succession = . 
			replace succession = 1 if W2U6 == 3
			replace succession = 0 if W2U6 >=1 & W2U6 <=2
			replace succession = 0 if W2U6 == -7
			label var succession "Pres Succession"
			label values succession correct
			tab succession
		
		*Overriding a Veto
			gen veto = . 
			replace veto = 1 if W2U7 == 2
			replace veto = 0 if W2U7 == 1
			replace veto = 0 if W2U7 >=3 & W2U7 <=4
			replace veto = 0 if W2U7 == -7
			label var veto "Veto Override"
			label values veto correct
			tab veto
		
		alpha term sen_term senators house_term succession veto, item
		egen knowl = rowtotal(term sen_term senators house_term succession veto), missing
		
		summ knowl
		gen knowl01 = (knowl - r(min))/(r(max)-r(min))
		label var knowl01 "Knowledge" 
		
		
	
***Partisan Ambivalence***


	*Wave 2
		*Fav: Dem
			gen dem_fav_w2 = . 
			replace dem_fav_w2 = 0 if W2L2 == 2
			replace dem_fav_w2 = 0.25  if W2L2 == 1 & W2L3 == 4
			replace dem_fav_w2 = 0.50  if W2L2 == 1 & W2L3 == 3
			replace dem_fav_w2 = 0.75  if W2L2 == 1 & W2L3 == 2
			replace dem_fav_w2 = 1  if W2L2 == 1 & W2L3 == 1

		*Unfav: Dem
			gen dem_unfav_w2 = .
			replace dem_unfav_w2 = 0 if W2L4 == 2
			replace dem_unfav_w2 = 0.25  if W2L4 == 1 & W2L5 == 4
			replace dem_unfav_w2 = 0.50  if W2L4 == 1 & W2L5 == 3
			replace dem_unfav_w2 = 0.75  if W2L4 == 1 & W2L5 == 2
			replace dem_unfav_w2 = 1  if W2L4 == 1 & W2L5 == 1
		
		*Rep:Fav
			gen rep_fav_w2 = . 
			replace rep_fav_w2 = 0 if W2L7 == 2
			replace rep_fav_w2 = 0.25  if W2L7 == 1 & W2L8 == 4
			replace rep_fav_w2 = 0.50  if W2L7 == 1 & W2L8 == 3
			replace rep_fav_w2 = 0.75  if W2L7 == 1 & W2L8 == 2
			replace rep_fav_w2 = 1  if W2L7 == 1 & W2L8 == 1
		
		
		*Rep:Unfav
			gen rep_unfav_w2 = .
			replace rep_unfav_w2 = 0 if W2L9 == 2
			replace rep_unfav_w2 = 0.25  if W2L9 == 1 & W2L10 == 4
			replace rep_unfav_w2 = 0.50  if W2L9 == 1 & W2L10 == 3
			replace rep_unfav_w2 = 0.75  if W2L9 == 1 & W2L10 == 2
			replace rep_unfav_w2 = 1  if W2L9 == 1 & W2L10 == 1
		
		*ID Consistent
			gen consistent_w2 = .
			replace consistent_w2 = dem_fav_w2 + rep_unfav_w2 if pid_31 == 1
			replace consistent_w2 = dem_unfav_w2 + rep_fav_w2 if pid_31 == 2
			label var consistent_w2 "Partisan Identity Consistent Likes/Dislikes (W2)"
			
		*ID Conflicting
			gen conflicting_w2 = .
			replace conflicting_w2 = dem_unfav_w2 + rep_fav_w2 if pid_31 == 1
			replace conflicting_w2 = dem_fav_w2 + rep_unfav_w2 if pid_31 == 2
			label var conflicting_w2 "Partisan Identity Conflicting Likes/Dislikes (W2)"
			
		*In vs. out Fav/unfav

			gen in_like_w2 = .
			replace in_like_w2  = dem_fav_w2 if pid_31 == 1
			replace in_like_w2 =  rep_fav_w2 if pid_31 == 2
		
			gen in_dislike_w2 = .
			replace in_dislike_w2 = dem_unfav_w2 if pid_31 == 1
			replace in_dislike_w2 = rep_unfav_w2 if pid_31 == 2
			
			gen out_like_w2 = .
			replace out_like_w2 = rep_fav_w2 if pid_31 == 1
			replace out_like_w2 = dem_fav_w2 if pid_31 == 2
			
			gen out_dislike_w2 = .
			replace out_dislike_w2 = rep_unfav_w2 if pid_31 == 1
			replace out_dislike_w2 = dem_unfav_w2 if pid_31 == 2
			
			recode in_like_w2 in_dislike_w2 out_like_w2 out_dislike_w2 	(0 = 1) (0.25 = 2) (0.5 = 3) (0.75 =4) (1 = 5)
			
			label var in_like_w2 "In-Party: Favorable (W2)"
			label var in_dislike_w2 "In-Party: Unfavorable (W2)"
			label var out_like_w2 "Out_Party: Favorable (W2)"
			label var out_dislike_w2 "Out_Party: Unfavorable (W2)"			
				
			label def fav 1 "No Fav. Thoughts" 2 "Slightly Favorable" 3 "Moderately Favorable" 4 "Very Favorable" 5 "Extremely Favorable"
			label values in_like_w2 out_like_w2 fav
			label def unfav 1 "No Unfav. Thoughts" 2 "Slightly Unfavorable" 3 "Moderately Unfavorable" 4 "Very Unfavorable" 5 "Extremely Unfavorable"
			label values in_dislike_w2 out_dislike_w2 unfav
			
			
			
			
*W11			
		*Fav: Dem
			gen dem_fav_w11 = . 
			replace dem_fav_w11 = 0 if W11LB2 == 2
			replace dem_fav_w11 = 0.25  if W11LB2 == 1 & W11LB4 == 4
			replace dem_fav_w11 = 0.50  if W11LB2 == 1 & W11LB4 == 3
			replace dem_fav_w11 = 0.75  if W11LB2 == 1 & W11LB4 == 2
			replace dem_fav_w11 = 1  if W11LB2 == 1 & W11LB4 == 1

		*Unfav: Dem
			gen dem_unfav_w11 = .
			replace dem_unfav_w11 = 0 if W11LB3 == 2
			replace dem_unfav_w11 = 0.25  if W11LB3 == 1 & W11LB5 == 4
			replace dem_unfav_w11 = 0.50  if W11LB3 == 1 & W11LB5 == 3
			replace dem_unfav_w11 = 0.75  if W11LB3 == 1 & W11LB5 == 2
			replace dem_unfav_w11 = 1  if W11LB3 == 1 & W11LB5 == 1
		
		*Rep:Fav
			gen rep_fav_w11 = . 
			replace rep_fav_w11 = 0 if W11LB7 == 2
			replace rep_fav_w11 = 0.25  if W11LB7 == 1 & W11LB9 == 4
			replace rep_fav_w11 = 0.50  if W11LB7 == 1 & W11LB9 == 3
			replace rep_fav_w11 = 0.75  if W11LB7 == 1 & W11LB9 == 2
			replace rep_fav_w11 = 1  if W11LB7 == 1 & W11LB9 == 1
		
		
		*Rep:Unfav
			gen rep_unfav_w11 = .
			replace rep_unfav_w11 = 0 if W11LB8 == 2
			replace rep_unfav_w11 = 0.25  if W11LB8 == 1 & W11LB10 == 4
			replace rep_unfav_w11 = 0.50  if W11LB8 == 1 & W11LB10 == 3
			replace rep_unfav_w11 = 0.75  if W11LB8 == 1 & W11LB10 == 2
			replace rep_unfav_w11 = 1  if W11LB8 == 1 & W11LB10 == 1
		
		*ID Consistent
			gen consistent_w11 = .
			replace consistent_w11 = dem_fav_w11 + rep_unfav_w11 if pid_39 == 1
			replace consistent_w11 = dem_unfav_w11 + rep_fav_w11 if pid_39 == 2
			label var consistent_w11 "Partisan Identity Consistent Likes/Dislikes (W10)"
			
		*ID Conflicting
			gen conflicting_w11 = .
			replace conflicting_w11 = dem_unfav_w11 + rep_fav_w11 if pid_39 == 1
			replace conflicting_w11 = dem_fav_w11 + rep_unfav_w11 if pid_39 == 2
			label var conflicting_w11 "Partisan Identity Conclifting Likes/Dislikes (W10)"
			
			*Earlier PID 
					*ID Consistent
					gen consistent_w11a = .
					replace consistent_w11a = dem_fav_w11 + rep_unfav_w11 if pid_31 == 1
					replace consistent_w11a = dem_unfav_w11 + rep_fav_w11 if pid_31 == 2
					label var consistent_w11a "Partisan Identity Consistent Likes/Dislikes (W10)"
					
				*ID Conflicting
					gen conflicting_w11a = .
					replace conflicting_w11a = dem_unfav_w11 + rep_fav_w11 if pid_31 == 1
					replace conflicting_w11a = dem_fav_w11 + rep_unfav_w11 if pid_31 == 2
					label var conflicting_w11a "Partisan Identity Conclifting Likes/Dislikes (W10)"
		
				
	
			gen in_like_w11 = .
			replace in_like_w11  = dem_fav_w11 if pid_31 == 1
			replace in_like_w11 =  rep_fav_w11 if pid_31 == 2
		
			gen in_dislike_w11 = .
			replace in_dislike_w11 = dem_unfav_w11 if pid_31 == 1
			replace in_dislike_w11 = rep_unfav_w11 if pid_31 == 2
			
			gen out_like_w11 = .
			replace out_like_w11 = rep_fav_w11 if pid_31 == 1
			replace out_like_w11 = dem_fav_w11 if pid_31 == 2
			
			gen out_dislike_w11 = .
			replace out_dislike_w11 = rep_unfav_w11 if pid_31 == 1
			replace out_dislike_w11 = dem_unfav_w11 if pid_31 == 2
			
			label var in_like_w11 "In-Party: Favorable (W11)"
			label var in_dislike_w11 "In-Party: Unfavorable (W11)"
			label var out_like_w11 "Out_Party: Favorable (W11)"
			label var out_dislike_w11 "Out_Party: Unfavorable (W11)"			
				
			recode in_like_w11 in_dislike_w11 out_like_w11 out_dislike_w11 ///
				(0 = 1) (0.25 = 2) (0.5 = 3) (0.75 =4) (1 = 5)
			
			label values in_like_w11 out_like_w11 fav
			label values in_dislike_w11 out_dislike_w11 unfav
			
			
			
				
			
*Matching

gen black = .
replace black = 1 if race == 2
replace black = 0 if race == 1
replace black = 0 if race >=3 & race <=4

tabulate pid_str1, gen(pstr1_)


recode DER09W1 (-7=.) (-4=.) (-6=.) (-5=.) ///
	(1=4) (2=3) (3=2) (4=1) ///
	(7=4) (6=3) (5=2), gen(ideol_str1)
	
recode DER09W2 (-7=.) (-6=.) (-5=.) ///
	(1=4) (2=3) (3=2) (4=1) ///
	(7=4) (6=3) (5=2), gen(ideol_str2)

summ interest_w9
gen interest_w901 = (interest_w9 - r(min))/(r(max)-r(min))
label var interest_w901 "Political Interest" 


**Need for cognition and need to evaluate***

recode W11ZE1 (1=4) (2=3) (3=2) (4=1) (-5 -6 -7 =.), gen(opinionated)

gen opinion_degree = . 
replace opinion_degree = 1  if W11ZE2 == 1 & W11ZE3B == 1
replace opinion_degree = 2  if W11ZE2 == 1 & W11ZE3B == 2
replace opinion_degree = 3  if W11ZE2 == 2
replace opinion_degree = 4  if W11ZE2 == 3 & W11ZE3A == 2
replace opinion_degree = 5  if W11ZE2 == 3 & W11ZE3A == 1

foreach var in opinionated opinion_degree {
	summ `var'
	gen `var'01 = (`var' - r(min))/(r(max)-r(min))
	}

egen evaluate = rowmean(opinionated01 opinion_degree01)
egen evaluate1 = rowtotal(opinionated01 opinion_degree01), missing

label var evaluate1 "Need to Evaluate"


recode W11ZE6 (1=0) (2=1) (-5 -6 -7 =.), gen(complex)

gen thinking = . 
replace thinking = 1  if W11ZE4 == 2 & W11ZE5B == 1
replace thinking = 2  if W11ZE4 == 2 & W11ZE5B == 2
replace thinking = 3  if W11ZE4 == 3
replace thinking = 4  if W11ZE4 == 1 & W11ZE5A == 2
replace thinking = 5  if W11ZE4 == 1 & W11ZE5A == 1

recode thinking (1=0) (2=0.25) (3=0.5) (4=0.75) (5=1), gen(thinking01)

egen nfc = rowmean(thinking01 complex)
egen nfc1 = rowtotal(thinking01 complex), missing

label var nfc1 "Need for Cognition"



