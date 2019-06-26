
////////////////////////////////////////////////////////////////////////////////////////////////////////
// REPLICATION DATA FOR THE LEGACY OF FOREIGN PATRONS: EXTERNAL STATE SUPPORT AND CONFLICT RECURRENCE //
////////////////////////////////////////////////////////////////////////////////////////////////////////

//// DESCRIPTION OF VARIABLES ///
// For a more detailed description of variables, see article //

//dyadid = unique identifier of each conflict dyad
//year = year after conflict termination
//sidea = name of government in conflict
//sideb = name of rebel group in conflict
//time = time count for each conflict episode
//recuryear = conflict recurrence (failure event)
//reb_decay2 = rebel support with decay-function (half-time 2y)
//reb_decay2c = number of rebel supporters with decay-function (half-time 2y)
//reby_decay2c = years of rebel support with decay-function (half-time 2y)
//gov_decay2 = government support with decay-function (half-time 2y)
//gov_decay2c = number of government supporters with decay-function (half-time 2y)
//govy_decay2c = years of government support with decay-function (half-time 2y)
//intensity = dummy variable for whether previous conflict episode reached 1000 battle-related deaths
//conep_dur = how many years the previous conflict episode lasted
//ethnic = rebels in last conflict episode mobilized along ethnic lines
//pko2 = if peacekeeping operation was present
//territory = dummy variable that denotes whether incompatibility concerns territory
//victory = last conflict episode ended in victory 
//peaceag = last conflict episode ended with peace agreement 
//frozen = last conflict episode ended with a frozen conflict
//intensitytvc3 = intensity*ln(time), required to address PH-assumption
//ethnictvc3 = intensity*ln(time), required to address PH-assumption

// SETUP DATA FOR SURVIVAL ANALYSIS //
sort dyadid year

stset time, id(dyadid) failure(recuryear==1) exit(time .) enter(time0)

// REPLICATE TABLES //

// Table I. Summary statistics of variables //

sum recuryear time reb_decay2 gov_decay2 reb_decay2c gov_decay2c reby_decay2c govy_decay2c intensity conep_dur ethnic victory peaceag frozen pko2 territory

// Table II. Effect of external support on conflict recurrence //

// Model 1 (dummies)

stcox gov_decay2 reb_decay2 intensity conep_dur ethnic ethnictvc3 pko2 territory territorytvc3 victory peaceag frozen, efron cluster(dyadid)
est store m1

// Model 2 (number of supporters)

stcox gov_decay2c reb_decay2c intensity conep_dur ethnic ethnictvc3 pko2 territory territorytvc3 victory peaceag frozen, efron cluster(dyadid)
est store m2

// Model 3 (proportion of years with support)

stcox govy_decay2c reby_decay2c intensity conep_dur ethnic ethnictvc3 pko2 territory territorytvc3 victory peaceag frozen, efron cluster(dyadid)
est store m3

esttab m1 m2 m3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)
