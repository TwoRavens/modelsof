
/*------------------------------------------------------------------------*
| This file is called by regs_prep.do.  It creates the variables for 
| rival OPCOST and friend OPCOST using vehicle attributes as 
| weights.
*-------------------------------------------------------------------------*
| Merging with the full file of vehicle attributes. |
*-------------------------------------------------------------------------*/

	/*TEST*/

	set more off

	global WGT ""

	
	keep acode model modelyear date reg msrp man veh oc* mpg trend* segment
	rename segment seg
	sort model modelyear seg date
	*sort acode date
	
	*THE BELOW IS IF YOU WANT WEIGHTS CALCULATED WITH MEANMPG INSTEAD OF MINMSRP
	egen meanmpg=mean(mpg), by(model modelyear date reg)
	egen tagmeanmpg=tag(acode modelyear date reg)
	keep if tagmeanmpg==1
	drop tagmeanmpg mpg
	rename meanmpg mpg

	
	*THE BELOW IS IF YOU WANT WEIGHTS CALCULATED WITH MINMSRP VEHICLES VS MEANMPG
	/* 
	egen minmsrp=min(msrp), by( model modelyear date reg)
	gen tabminmsrp=(msrp==minmsrp)
	keep if tabminmsrp==1
	drop minmsrp tabminmsrp
	*/
	
	duplicates drop model modelyear seg date reg, force
	gen ones=1
	egen test=sum(ones), by(model modelyear date reg)
	tab test
	drop ones test
	save $RES\temp1, replace

	use $RES\gaspricemodels_revised, clear
	
	*AGAIN, FOR MEANMPG INSTEAD OF MINMSRP
	egen meanmpg=mean(mpg), by(model year)
	egen tagmeanmpg=tag(model year)
	keep if tagmeanmpg==1
	drop mpg tagmeanmpg
	rename meanmpg mpg
	
	/*
	egen minmsrp=min(msrp), by(model year)
	gen tabminmsrp=(msrp==minmsrp)
	keep if tabminmsrp==1
	*/
	keep model year numpass wheelbasein hp vehiclesegment
	egen minhp=min(hp), by(model year)
	gen tabminhp=(hp==minhp)
	keep if tabminhp==1
	drop tabminhp minhp
	duplicates drop
	rename year modelyear
	rename numpass pass
	rename wheelbasein base
	rename vehiclesegment seg

	sort model modelyear seg
	merge 1:m model modelyear seg using $RES\temp1
		*tab _merge
		keep if _merge==3
		drop _merge
		sort model modelyear

	label var msrp ""
	label var pass ""
	label var base ""
	label var hp ""
	label var seg ""

	by date, sort: egen sdmsrp = sd(msrp)
	by date, sort: egen sdpass = sd(pass)
	by date, sort: egen sdbase  = sd(base)
	by date, sort: egen sdmpg = sd(mpg)
	by date, sort: egen sdhp    = sd(hp)

	replace msrp = msrp / sdmsrp
	replace pass = pass / sdpass
	replace base = base / sdbase
	replace mpg = mpg / sdmpg
	replace hp   = hp / sdhp

	drop sd*

	forvalues l==1/13 {

	gen roc_r_`l'       = 0
	*gen roc_r_pri_`l'	= 0
	gen roc_n_`l'	= 0

	gen foc_r_`l'       = 0
	*gen foc_r_pri_`l'	= 0
	gen foc_n_`l'	= 0

	gen rtrend1_`l' = 0
	gen rtrend2_`l' = 0
	gen rtrend3_`l' = 0
	gen rtrend4_`l' = 0

	gen ftrend1_`l' = 0
	gen ftrend2_`l' = 0
	gen ftrend3_`l' = 0
	gen ftrend4_`l' = 0
	
	}
	
	gen diffseg = 0
	gen diffveh = 0

	save $ASH\temp1, replace

	/*---------------------------*
	| Ready to weight! |
	*---------------------------*/

	keep in 1
	gen storage=1
	keep storage
	save $RES\regs_weight_output0, replace

	capture program drop loopery0
	program loopery0
		local s = 1
		while `s' <= 5 {
			use $RES\temp1, clear
			keep if reg == `s'
			save $RES\temp2, replace
			loopery1 

			/* Reseting the output file to lower append times */
			save $RES\regs_weight_output_reg`s', replace 
			keep in 1
			keep storage
			save $RES\regs_weight_output0, replace
		local s = `s'+1
		}
	end

	/* mindate = 15711, maxdate = 17160 */
	capture program drop loopery1
	program loopery1
		local r = 15711
		local c = 0
		while `r' <= 17160 {
			use $RES\temp2, clear
			quietly keep if date == `r'
			egen nvehs = count(msrp)
			loopery2
			keep acode model modelyear date reg roc* foc* rtrend* ftrend* seg
			append using $RES\regs_weight_output`c'
			local c = 1-`c'
			save $RES\regs_weight_output`c', replace
		local r=`r'+7
		}
	end

	capture program drop loopery2
	program loopery2
		local q=1
		while `q' <= nvehs {

			quietly replace diffseg = seg!=seg[`q']
			quietly egen sddiffseg = sd(diffseg)
			quietly replace diffseg = diffseg/sddiffseg
			drop sddiffseg
	
			*quietly replace diffveh = veh!=veh[`q']
			*quietly egen sddiffveh = sd(diffveh)
			*quietly replace diffveh = diffveh/sddiffveh
			*drop sddiffveh

			quietly gen rW8_1 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2 + (base[`q']  - base)^2 + (mpg[`q']  - mpg)^2 + (hp[`q']  - hp)^2)
			quietly gen rW8_2 = 1 / (diffseg^2 + (pass[`q']  - pass)^2 + (base[`q']  - base)^2 + (mpg[`q']  - mpg)^2 + (hp[`q']  - hp)^2)
			quietly gen rW8_3 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (base[`q']  - base)^2 + (mpg[`q']  - mpg)^2 + (hp[`q']  - hp)^2)
			quietly gen rW8_4 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2 + (base[`q']  - base)^2 + (hp[`q']  - hp)^2)
			quietly gen rW8_5 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2 + (base[`q']  - base)^2 + (mpg[`q']  - mpg)^2)
			quietly gen rW8_6 = 1 / ((msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2 + (base[`q']  - base)^2 + (mpg[`q']  - mpg)^2 + (hp[`q']  - hp)^2)
			quietly gen rW8_7 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2)
			quietly gen rW8_8 = (seg==seg[`q'])
			quietly gen rW8_9 = (veh==veh[`q'])
			quietly gen rW8_10 = (veh=="SUV" | veh=="Car")
			quietly gen rW8_11 = 1
			quietly gen rW8_12 = (veh=="SUV" | veh=="Car" | veh=="Truck")
			quietly gen rW8_13 = 1 / (diffseg^2 + (msrp[`q']  - msrp)^2 + (pass[`q']  - pass)^2 + (mpg[`q']  - mpg)^2 + (hp[`q']  - hp)^2)

			forvalues l==1/7 {
			
				quietly gen fW8_`l' = rW8_`l'
				quietly replace rW8_`l' = 0 if rW8_`l'==. | man==man[`q']  | veh!=veh[`q']
				quietly replace fW8_`l' = 0 if fW8_`l'==. |  man!=man[`q']  | veh!=veh[`q']
				
				egen rsummer_`l' = sum(rW8_`l')
				egen fsummer_`l' = sum(fW8_`l')

				quietly replace rW8_`l' = rW8_`l' / rsummer_`l'
				quietly replace fW8_`l' = fW8_`l' / fsummer_`l'
				
			}
			
			*quietly gen rW8 = 1
			forvalues l==8/13 {
			
			quietly gen fW8_`l' = rW8_`l'
	
			quietly replace rW8_`l' = 0 if rW8_`l'==. | man==man[`q'] 
			quietly replace fW8_`l' = 0 if fW8_`l'==. |  man!=man[`q'] 

			egen rsummer_`l' = sum(rW8_`l')
			egen fsummer_`l' = sum(fW8_`l')

			quietly replace rW8_`l' = rW8_`l' / rsummer_`l'
			quietly replace fW8_`l' = fW8_`l' / fsummer_`l'
			
			}
			
****************************************
*	Table 3
****************************************			
			
			if date==16439  & reg==1 {

				if model[`q']=="Tacoma" & modelyear[`q']==2005 {
					save $WGT\Tacoma, replace
				}
				if model[`q']=="Tundra" & modelyear[`q']==2005 {
					save $WGT\Tundra, replace
				}
				if model[`q']=="F-150"  & modelyear[`q']==2005 {
					save $WGT\F150, replace
				}
				if model[`q']=="Ranger" & modelyear[`q']==2005 {
					save $WGT\Ranger, replace
				}
				if model[`q']=="Silverado 1500" & modelyear[`q']==2005 {
					save $WGT\Silverado1500, replace
				}
				if model[`q']=="Colorado" & modelyear[`q']==2005 {
					save $WGT\Colorado, replace
				}
				if model[`q']=="Ram 1500" & modelyear[`q']==2005 {
					save $WGT\Ram1500, replace
				}
				if model[`q']=="Dakota" & seg[`q']=="Small Pick-up" & modelyear[`q']==2005 {
					save $WGT\Dakota, replace
				}


												
			}
		
		forvalues l==1/13 {
		
			gen rtemp1_`l' = rW8_`l' * oc_r 
			gen rtemp5_`l' = rW8_`l' * oc_n 			
			gen rtemp10_`l' = rW8_`l' * trend1
			gen rtemp11_`l' = rW8_`l' * trend2
			gen rtemp12_`l' = rW8_`l' * trend3
			gen rtemp13_`l' = rW8_`l' * trend4
		

			gen ftemp1_`l' = fW8_`l' * oc_r 
			gen ftemp5_`l' = fW8_`l' * oc_n 			
			gen ftemp10_`l' = fW8_`l' * trend1
			gen ftemp11_`l' = fW8_`l' * trend2
			gen ftemp12_`l' = fW8_`l' * trend3
			gen ftemp13_`l' = fW8_`l' * trend4

			egen ruser1_`l' = sum(rtemp1_`l')
			egen ruser5_`l' = sum(rtemp5_`l')			
			egen ruser10_`l' = sum(rtemp10_`l')
			egen ruser11_`l' = sum(rtemp11_`l')
			egen ruser12_`l' = sum(rtemp12_`l')
			egen ruser13_`l' = sum(rtemp13_`l')

			egen fuser1_`l' = sum(ftemp1_`l')
			egen fuser5_`l' = sum(ftemp5_`l')			
			egen fuser10_`l' = sum(ftemp10_`l')
			egen fuser11_`l' = sum(ftemp11_`l')
			egen fuser12_`l' = sum(ftemp12_`l')
			egen fuser13_`l' = sum(ftemp13_`l')
			*egen fuser14_`l' = sum(ftemp14_`l')
			*egen fuser15_`l' = sum(ftemp15_`l')

			quietly replace roc_r_`l'      = ruser1_`l' if _n==`q'
			quietly replace roc_n_`l'      = ruser5_`l' if _n==`q'			
			quietly replace rtrend1_`l'     = ruser10_`l' if _n==`q'
			quietly replace rtrend2_`l'     = ruser11_`l' if _n==`q'
			quietly replace rtrend3_`l'     = ruser12_`l' if _n==`q'
			quietly replace rtrend4_`l'     = ruser13_`l' if _n==`q'
			*quietly replace roc_r_pri_`l'   = ruser14_`l' if _n==`q'
			*quietly replace roc_n_pri_`l'   = ruser15_`l' if _n==`q'

			quietly replace foc_r_`l'       = fuser1_`l' if _n==`q'
			quietly replace foc_n_`l'       = fuser5_`l' if _n==`q'
			quietly replace ftrend1_`l'     = fuser10_`l' if _n==`q'
			quietly replace ftrend2_`l'     = fuser11_`l' if _n==`q'
			quietly replace ftrend3_`l'     = fuser12_`l' if _n==`q'
			quietly replace ftrend4_`l'     = fuser13_`l' if _n==`q'
			*quietly replace foc_r_pri_`l'   = fuser14_`l' if _n==`q'
			*quietly replace foc_n_pri_`l'   = fuser15_`l' if _n==`q'
			
		}

			drop rW8* fW8* rsummer* fsummer* rtemp* ftemp* ruser* fuser*  
			*drop rtemp2-rtemp9 ruser2-ruser9 ftemp2-ftemp9 fuser2-fuser9  


		local q=`q'+1
		}
	end 

	loopery0

	use $RES\regs_weight_output_reg1, clear
	append using $RES\regs_weight_output_reg2
	append using $RES\regs_weight_output_reg3
	append using $RES\regs_weight_output_reg4
	append using $RES\regs_weight_output_reg5

	drop storage	
	
	forvalues l==1/13 {
	rename roc_r_`l' roc_r_model_`l'
	rename roc_n_`l' roc_n_model_`l'
	rename foc_r_`l' foc_r_model_`l'
	rename foc_n_`l' foc_n_model_`l'
	rename rtrend1_`l' rtrend1_model_`l'
	rename ftrend1_`l' ftrend1_model_`l'
	rename rtrend2_`l' rtrend2_model_`l'
	rename ftrend2_`l' ftrend2_model_`l'
	rename rtrend3_`l' rtrend3_model_`l'
	rename ftrend3_`l' ftrend3_model_`l'
	rename rtrend4_`l' rtrend4_model_`l'
	rename ftrend4_`l' ftrend4_model_`l'
	}
	
	drop if reg==.
	rename seg segment
	sort model modelyear segment date reg

	save $RES\regs_weight_output_segment_model, replace

	erase $RES\regs_weight_output0.dta
	erase $RES\regs_weight_output1.dta
	erase $RES\regs_weight_output_reg1.dta
	erase $RES\regs_weight_output_reg2.dta
	erase $RES\regs_weight_output_reg3.dta
	erase $RES\regs_weight_output_reg4.dta
	erase $RES\regs_weight_output_reg5.dta

	erase $RES\temp1.dta
	erase $RES\temp2.dta

