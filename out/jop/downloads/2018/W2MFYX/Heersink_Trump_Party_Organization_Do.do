clear
set more off

*Work Desktop
cd "INSERT APPROPRIATE FILE LOCATION"
set scheme s1mono
capture log close

*IMPORT DATA
use Heersink_Trump_Party_Organization_Data.dta


*NOTES
	*start = starting day of interval (0 for new chairs)
	*end = end of interval (either lost chair or time-varying covariate changed)
	*id = identifies a chairmanship spell.  In all cases except O'Brien, this uniquely identifies a chair, but O'Brien has two separate spells as chair

*GENERATE ID VARIABLE FOR CHAIRS
gen temp_id = 0
replace temp_id = 1 if chair == "Lawrence F. O’Brien" & start == "8/31/1968"
egen id = group(chair temp_id)

*DETERMINE FIRST OBS FOR EACH CHAIR
split start, parse("/") gen(start_)
rename start_3 start_year
rename start_2 start_day
rename start_1 start_month
sort id start_year start_month start_day
bysort id: gen obs_counter = _n

*FIRST OBS ALWAYS STARTS AT 0
gen new_start = 0 if obs_counter == 1
gen new_end = days if obs_counter == 1

*ADJUST START TIME OF SECOND/THIRD INTERVALS
replace new_start = days[_n-1] if obs_counter == 2
replace new_start = days[_n-1] + days[_n-2] if obs_counter == 3

*ADJUST END TIME OF SECOND/THIRD INTERVALS
	*Now captures total days since start of chairmanship spell
replace new_end = days + days[_n-1] if obs_counter == 2
replace new_end = days + days[_n-1] + days[_n-2] if obs_counter == 3
rename days interval_days

*CLEAN UP
rename start start_date
rename stop stop_date
rename new_start start
rename new_end spell_days

*CREATE ST DATASET (Figure 1)
stset spell_days, failure(ended) id(id)
sts graph
graph save Figure 1, replace
//graph export Figure1.pdf, replace
//graph export Figure1.tif, replace

*CHECK HAZARD FUNCTION (Figure A-1)
sts graph, hazard
graph save FigurA1, replace
//graph export FigureA1.pdf, replace
//graph export FigureA1.tif, replace

*MODEL PRESENTED IN PAPER
streg inparty dem presidentialelectionloss midtermelectionloss interim governmentjob personalreasons runforoffice lostreelection, distribution (lognormal)

*MARGINAL EFFECTS (Figure 2)
margins, at(inparty=(0 1))
margins, dydx(inparty)
stcurve, survival at1(inparty=0) at2(inparty=1)
graph save Figure2, replace
//graph export Figure2.pdf, replace
//graph export Figure2.tif, replace

*SUPPLEMENTAL APPENDIX MODELS 

*LOGGED MODELS
streg inparty, distribution (lognormal)
streg inparty dem presidentialelectionloss midtermelectionloss, distribution (lognormal)
streg inparty dem presidentialelectionloss midtermelectionloss interim, distribution (lognormal)
streg inparty dem presidentialelectionloss midtermelectionloss interim governmentjob personalreasons runforoffice, distribution (lognormal)
streg inparty dem presidentialelectionloss midtermelectionloss ip_presloss ip_midloss interim governmentjob personalreasons runforoffice lostreelection, distribution (lognormal)

*WEIBULL MODEL (Figure A-2)
streg inparty dem presidentialelectionloss midtermelectionloss interim governmentjob personalreasons runforoffice lostreelection, distribution (weibull)
stcurve, survival at1(inparty=0) at2(inparty=1)
graph save FigureA2, replace
//graph export FigureA2.pdf, replace
//graph export FigureA2.tif, replace

*COX MODEL (Figure A-3)
stcox inparty dem presidentialelectionloss midtermelectionloss interim governmentjob personalreasons runforoffice lostreelection
stcurve, survival at1(inparty=0) at2(inparty=1)
graph save FigureA3, replace
//graph export FigureA3.pdf, replace
//graph export FigureA3.tif, replace


*SAVE UPDATED DATA
save Heersink_Trump_Party_Organization_Data_update.dta, replace
