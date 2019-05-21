** replication for main analysis in Fortunato, Stevenson, and Vonnahme **
	
	*cd "myDirectory/replicationFSV/"
	*use "replication.dta"
 
** this first bit of code produces all of the varous models presented in the appendix **
 
	set more off

	local vars1 "logNormPd numdyads absDiff telephone selfAdmin LRper_avg  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"
 	local vars2 "logNormPd numdyads absDiff telephone selfAdmin avgImpTSElite pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"
	local vars3 "logNormPd numdyads absDiff telephone selfAdmin s_wavgall  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"
	local vars4 "logNormPd numdyads absDiff telephone selfAdmin r_wavgall  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"
	local vars5 "logNormPd numdyads absDiff telephone selfAdmin vardim1  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"

	foreach ii of numlist 1 2 3 4 5 {
		xtmixed logRatCorWrg `vars`ii'' || newmanicountry: || _all: R.studynumid || dyadIdAccrossSurveys:

			eststo hh1_`ii'

		xtmixed logRatDkWrg `vars`ii'' || newmanicountry: || _all: R.studynumid || dyadIdAccrossSurveys:

			eststo hh2_`ii'

	}

** and then writes the results to a csv **
	
	# delimit ;
		esttab hh1_1 hh2_1	hh1_2 hh2_2	hh1_3 hh2_3	hh1_4 hh2_4	hh1_5 hh2_5	
		using dimensionalityComparison.csv, se(a3) b(%9.5f) nostar
		nodepvars nomtitles replace compress plain;

** we will use the weighted Spearman measure as our main analysis **

** now lets get some substantive effects for these results **

	do simUtils.do
	
** this remaining chunk is best executed at once **
	
	set more off
	local vars1 "logNormPd numdyads absDiff telephone selfAdmin s_wavgall  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"

** we can take a look at the cases with missing values that will be listwise deleted with this **
** ... just New Zealand **

	tabstat `vars1', by(studylabel)

** reestimate part 1 **

	xtmixed logRatCorWrg `vars1' || newmanicountry: || _all: R.studynumid || dyadIdAccrossSurveys:

** take posterior draws **

    tempname b V sig dfsig
    matrix `b' = e(b)
    matrix `V' = e(V)
    local N = `e(N)'
			
	capture drop bbt*
    _simp, b(`b') v(`V') s(1000) g(bbt) 

** now reestimate part 2 **

	xtmixed logRatDkWrg `vars1' || newmanicountry: || _all: R.studynumid || dyadIdAccrossSurveys:

** take posterior draws **

	tempname b V sig dfsig
	matrix `b' = e(b)
    matrix `V' = e(V)
    local N = `e(N)'
			
	capture drop bbk*
    _simp, b(`b') v(`V') s(1000) g(bbk) 

** set values for predicted effects **

	local logNormPd=.01
	local absDiff=1
	local telephone=0 
	local selfAdmin=0 
	local s_wavgall=.34
	local pmhistory_avg=.03 
	local cabhistory_avg=.03
	local labelshurt=0 
	local labelshelp=0 
	local pervote_avg=10
	local numdyads=15

	local logNormPdC=.08 
	local absDiffC=4
	local telephoneC=1 
	local selfAdminC=1 
	local s_wavgall=.43
	local pmhistory_avgC=.34 
	local cabhistory_avgC=.19
	local labelshurtC=1 
	local labelshelpC=1 
	local pervote_avgC=27
	local numdyadsC=28

** generate baseline values **	

	# delimit ;
		capture drop predLR_CW;
		gen predLR_CW=
			bbt1*`logNormPd'+
			bbt2*`numdyads'+
			bbt3*`absDiff'+
			bbt4*`telephone '+
			bbt5*`selfAdmin'+
			bbt6*`s_wavgall'+
			bbt7*`pmhistory_avg'+
			bbt8*`cabhistory_avg'+
			bbt9*`labelshurt'+
			bbt10*`labelshelp'+
			bbt11*`pervote_avg'+
			bbt12;
		

		capture drop predLR_DW;
		gen predLR_DW=
			bbk1*`logNormPd'+
			bbk2*`numdyads'+
			bbk3*`absDiff'+
			bbk4*`telephone '+
			bbk5*`selfAdmin'+
			bbk6*`s_wavgall'+
			bbk7*`pmhistory_avg'+
			bbk8*`cabhistory_avg'+
			bbk9*`labelshurt'+
			bbk10*`labelshelp'+
			bbk11*`pervote_avg'+
			bbk12;

	# delimit cr

** conver to proababilities **

	capture drop predcorrect
	capture drop predwrong
	capture drop predDK

	gen predcorrect=exp(predLR_CW)/(1+exp(predLR_DW)+exp(predLR_CW))
	gen predDK=exp(predLR_DW)/(1+exp(predLR_DW)+exp(predLR_CW))
	gen predwrong=1-predcorrect-predDK

** generate differenced values **	

	set more off

	local vars1 "logNormPd numdyads absDiff telephone selfAdmin s_wavgall  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"

	local logNormPd=.01
	local absDiff=1
	local telephone=0 
	local selfAdmin=0 
	local s_wavgall=.34
	local pmhistory_avg=.03 
	local cabhistory_avg=.03
	local labelshurt=0 
	local labelshelp=0 
	local pervote_avg=10
	local numdyads=15

	local logNormPdC=.08 
	local absDiffC=4
	local telephoneC=1 
	local selfAdminC=1 
	local s_wavgallC=.43
	local pmhistory_avgC=.34 
	local cabhistory_avgC=.19
	local labelshurtC=1 
	local labelshelpC=1 
	local pervote_avgC=27
	local numdyadsC=28

** now generate probability changes **
	# delimit ;

	local jj=1;
	set trace off;
	foreach var of varlist `vars1' {;

		capture drop predLR_CW;
		gen predLR_CW=bbt1*`logNormPd'+
			bbt2*`numdyads'+
			bbt3*`absDiff'+
			bbt4*`telephone '+
			bbt5*`selfAdmin'+
			bbt6*`s_wavgall'+
			bbt7*`pmhistory_avg'+
			bbt8*`cabhistory_avg'+
			bbt9*`labelshurt'+
			bbt10*`labelshelp'+
			bbt11*`pervote_avg'+
			bbt12
			-bbt`jj'*``var''
			+bbt`jj'*``var'C';


		capture drop predLR_DW;
		gen predLR_DW=bbt1*`logNormPd'+
			bbk2*`numdyads'+
			bbk3*`absDiff'+
			bbk4*`telephone '+
			bbk5*`selfAdmin'+
			bbk6*`s_wavgall'+
			bbk7*`pmhistory_avg'+
			bbk8*`cabhistory_avg'+
			bbk9*`labelshurt'+
			bbk10*`labelshelp'+
			bbk11*`pervote_avg'+
			bbk12
			-bbk`jj'*``var''
			+bbk`jj'*``var'C';



		capture drop predcorrect_`var';
		capture drop predwrong_`var';
		capture drop predDK_`var';

		gen predcorrect_`var'=(exp(predLR_CW)/(1+exp(predLR_DW)+exp(predLR_CW)));
		gen predDK_`var'=(exp(predLR_DW)/(1+exp(predLR_DW)+exp(predLR_CW)));
		gen predwrong_`var'=(1-predcorrect_`var'-predDK_`var');

		local jj=`jj'+1;

	};

# delimit cr

set trace off
local vars1 "logNormPd numdyads absDiff telephone selfAdmin s_wavgall  pmhistory_avg cabhistory_avg labelshurt labelshelp pervote_avg"
foreach var of varlist `vars1' {

		capture drop chcorrect_`var'
		capture drop chwrong_`var'
		capture drop chDK_`var'

		gen chcorrect_`var'=predcorrect_`var'-predcorrect
		gen chwrong_`var'=predwrong_`var'-predwrong
		gen chDK_`var'=predDK_`var'-predDK

	display "`var'"
	tabstat chcorrect_`var' chDK_`var' chwrong_`var', stats(mean p5 p95)
}
