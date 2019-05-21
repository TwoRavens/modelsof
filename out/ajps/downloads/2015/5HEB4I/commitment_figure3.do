*DO FILE TO CREATE FIGURE 3 "FIGURE 3: POTENTIAL MOTIVES UNDERLYING THE CONSEQUENCES OF INCONSISTENCY"



clear all
set more off
version 13

*Set to relevant work directory where replication files are saved.
cd "C:\Users\EndUser\Dropbox\Commitment and Consistency\Manuscript\AJPS Submission\Replication Files\AJPS Replication Files\"

*Open data set containing data to generate Figure 3
use "commitment_figure3.dta", clear


*Multiply all point estimates and confidence intervals by 100 so that values in percentages (0, 100)
replace percent = percent*100
replace lowerci = lowerci*100
replace upperci = upperci*100


*Summarize range of values
sum percent lowerci upperci
*Make scale consistent and symmetrical across all sub-figures (-50, +50)


*Each figure will have two sets of values (Main Effect vs. New Information) that will be separated
*Create a separate "group2" variable
gen group2 = group
*Rescale "group2" so that second set of values (New Information) is spaced appropriately from the first set of values (Main Effect)
recode group2 (3=5) (4=6)

*Figure 3(a) Competence
twoway ///
	(rcap lowerci upperci group2 if outcome=="competence", lcolor(gs7)) ///
	(scatter percent group2 if outcome=="competence" & commitment=="positive", msymbol(S) mlcolor(black) msize(medium) mfcolor(black) /* mlwidth(medthick) */ ) ///
	(scatter percent group2 if outcome=="competence" & commitment=="negative", msymbol(C) mlcolor(black) msize(medium) mfcolor(white) mlwidth(medthick)), ///
	yscale(range (-50 50)) ylabel(-40(20)40, grid) ///
	xscale(range (0 7)) ///
	yline(0, lcolor(black)) ///
	ytitle("Change (%)" "President Incompetent") ///
	xtitle("") ///
	legend(label(1 "95% CIs") label(2 "Back Out vs. Stay Out") label(3 "Back In vs. Go In")  /* order so that CI's last */ order(2 3 1) rows(1) size(small)) ///
	scheme(s1mono) ///
	xlabel(1.5 "Main Effect" 5.5 "New Information") ///
	/* note("") */ ///
	name(competence, replace) /* Name graph since will later combine with others*/ ///
	title("(a) Competence", size(medium) position(11))


*Figure 3(b) Reputation
twoway ///
	(rcap lowerci upperci group2 if outcome=="reputation", lcolor(gs7)) ///
	(scatter percent group2 if outcome=="reputation" & commitment=="positive", msymbol(S) mlcolor(black) msize(medium) mfcolor(black) /* mlwidth(medthick) */ ) ///
	(scatter percent group2 if outcome=="reputation" & commitment=="negative", msymbol(C) mlcolor(black) msize(medium) mfcolor(white) mlwidth(medthick)), ///
	yscale(range (-50 50)) ylabel(-40(20)40, grid) ///
	xscale(range (0 7)) ///
	yline(0, lcolor(black)) ///
	ytitle("Change (%)" "Hurt U.S. Reputation") ///
	xtitle("") ///
	legend(label(1 "95% CIs") label(2 "Back Out vs. Stay Out") label(3 "Back In vs. Go In")  /* order so that CI's last */ order(2 3 1) rows(1) size(small)) ///
	scheme(s1mono) ///
	xlabel(1.5 "Main Effect" 5.5 "New Information") ///
	/* note("") */ ///
	name(reputation, replace) /* Name graph since will later combine with others*/ ///
	title("(b) Reputation", size(medium) position(11))


*Figure 3(c) Credibility
twoway ///
	(rcap lowerci upperci group2 if outcome=="credibility", lcolor(gs7)) ///
	(scatter percent group2 if outcome=="credibility" & commitment=="positive", msymbol(S) mlcolor(black) msize(medium) mfcolor(black) /* mlwidth(medthick) */ ) ///
	(scatter percent group2 if outcome=="credibility" & commitment=="negative", msymbol(C) mlcolor(black) msize(medium) mfcolor(white) mlwidth(medthick)), ///
	yscale(range (-50 50)) ylabel(-40(20)40, grid) ///
	xscale(range (0 7)) ///
	yline(0, lcolor(black)) ///
	ytitle("Change (%) Less Likely to" "Believe Future U.S. Promises") ///
	xtitle("") ///
	legend(label(1 "95% CIs") label(2 "Back Out vs. Stay Out") label(3 "Back In vs. Go In")  /* order so that CI's last */ order(2 3 1) rows(1) size(small)) ///
	scheme(s1mono) ///
	xlabel(1.5 "Main Effect" 5.5 "New Information") ///
	/* note("") */ ///
	name(credibility, replace) /* Name graph since will later combine with others*/ ///
	title("(c) Credibility", size(medium) position(11))

	
*Combine the three sub-figures into a single combined figure
*Figure 3: Potential Motives Underlying the Consequences of Inconsistency
*Use the -grc1leg- command, which is similar to -graph combine- but allows for a single common legend.
	*If the ado file is not installed, first enter the command -findit grc1leg-
grc1leg competence reputation credibility, legendfrom(competence)
/*
*Text for note is added afterward rather than in -grc1leg- command because occupies too much space in the overall figure.
"Note: Values display first differences for inconsistency between words and deeds for the relevant type of" ///
	 "commitment, separated by whether or not the president cited new information in justifying his or her behavior." ///
	 "First differences report the change in percent answering the following answer options for each outcome variable:" ///
	 "President's competence (very incompetent / somewhat incompetent); U.S. reputation (hurt a lot / hurt somewhat);" ///
	 "Credibility of other countries believing future U.S. promises (very unlikely / somewhat unlikely). "All alternative ///
	 "outcomes are scaled such that higher values indicate greater negative consequences for the president.") 
*/
*Certain standard graph options are not available with the -grc1leg- command.
	*For final formatting of the figure, open Graph Editor
		*Change Graph Properties -> Margin to Zero.


*Save Figure 3		
graph save "commitment_figure3.gph", replace


