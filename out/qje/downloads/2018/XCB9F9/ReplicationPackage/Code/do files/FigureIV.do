
#delimit cr

***** FIGURE IV *****

label var ELA_Fertil_D   "Fertilizer"
label var ELA_Insect_D   "Insecticides"
label var invest_toolD "Tools"

label var ELA_Fertil_V_tr "Fertilizer" 
label var ELA_Insect_V_tr "Insecticides" 
label var hha_tools_tr "Tools"

label var labor_hrs_ELA  "Own Labour"
label var worker_dys_ELA "Other Labour"
label var wd_paid_ELA 	  "Other Labour: Paid"
label var wd_unpaid_ELA    "Other Labour: Unpaid"

local outcomevariables ///
		labor_hrs_ELA worker_dys_ELA wd_paid_ELA wd_unpaid_ELA ///
		ELA_Fertil_D ELA_Insect_D invest_toolD ///
		ELA_Fertil_V_tr ELA_Insect_V_tr hha_tools_tr

local n: word count `outcomevariables'
local varlabels "" 

matrix graph_input1 = J(`n',3,0)
matrix graph_input2 = J(`n',3,0)

local i = 0
foreach yvar in `outcomevariables' {
    local i = `i' + 1 
	local varlabel: variable label `yvar' 
	local varlabels = `"`varlabels'"' + " r" + "`i'" + `" = ""' + "`varlabel'" + `"""'
	
	areg `yvar' i.tt_r if attrition == 0, a(superstrata) cluster(club_id)
	margins r.tt_r, contrast level(90)
	matrix output = r(table)
	
	sum `yvar' if tt_r == 1 
	local sd_yvar = 1
	if r(sd) != 0 {
		local sd_yvar = r(sd)
	}	
	matrix output = output' / `sd_yvar'
	
	matrix graph_input1[`i',1] = (output[1,1], output[1,5], output[1,6])
	matrix graph_input2[`i',1] = (output[2,1], output[2,5], output[2,6])
}	

coefplot (matrix(graph_input1[,1]), ci((graph_input1[,2] graph_input1[,3])) m(S))  ///
         (matrix(graph_input2[,1]), ci((graph_input2[,2] graph_input2[,3])) m(Sh))  ///
		 , coeflabels(`varlabels') headings(r1 = "{bf:Labour Input}" r5 = "{bf:Capital Input - Extensive}" r8 = "{bf:Capital Input - Intensive}" ,labs(small))  ///
		   graphregion(color(white)) legend(off) xline(0, lc(black)) grid(none) ///
		   m(s) ciopts(lw(thin) lc(gs10)) ylabel(,labs(small))  xlabel(,labs(small)) xtitle("Standardized Effect Size",size(small))
graph export "Output/FigureIV.pdf", as(pdf) replace
graph export "Output/FigureIV.tif", as(tif) replace

#delimit ;
