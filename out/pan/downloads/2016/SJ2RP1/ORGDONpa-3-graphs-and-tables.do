/*tex

Stata/SE 13.1; required packages: estout, estwrite, erepost, coefplot

\subsection{Graphs for comparative validation}

tex*/

texdoc stlog

set scheme s1mono
program swapnames // rename nl estimates
    qui est restore `0'
    tempname b
    mat `b' = e(b)
    mata: st_matrixcolstripe("`b'", st_matrixcolstripe("`b'")[., (2,1)])
    erepost b=`b', rename
    qui est store `0'
end
program addbox
    args est w
    qui est restore `est'
    local h = `w'/2         // character halfwidth
    local m = `w'/2 * .25   // outer margin
    mata: st_matrix("e(box)", ///
          (st_matrix("e(b)") :- `m' :- ///
              (strlen(strofreal(st_matrix("e(b)")*100,"%9.0f"))*`h'))  ///
        \ (st_matrix("e(b)") :+ `m' :+ ///
              (strlen(strofreal(st_matrix("e(b)")*100,"%9.0f"))*`h')))
    qui est sto `est'
end
program mlrrt_pr
    tempname b ci V
    qui est restore `0'
    mata: mlrrt_dif("`b'", "`ci'")
    qui est restore `0'_d
    qui estadd matrix ci = `ci'
    mat `V' = `b'' * `b' * 0
    erepost b=`b' V=`V'
    qui est sto `0'_d
    qui est restore `0'
    mata: mlrrt_levels("`b'", "`ci'")
    qui estadd matrix ci = `ci'
    mat `V' = `b'' * `b' * 0
    erepost b=`b' V=`V'
    qui est sto `0'
end
mata
void mlrrt_levels(string scalar b0, string scalar ci) {
    b = st_matrix("e(b)")
    se = sqrt(diagonal(st_matrix("e(V)")))'
    st_matrix(b0, invlogit(b))
    st_matrix(ci, (invlogit(b - invnormal(0.975):*se) \ 
                   invlogit(b + invnormal(0.975):*se)))
    st_matrixcolstripe(b0, st_matrixcolstripe("e(b)"))
}
void mlrrt_dif(string scalar b0, string scalar ci) {
    b = st_matrix("e(b)")
    se = sqrt(diagonal(st_matrix("e(V)")))'
    st_matrix(b0, (invlogit(b[|2 \ .|]):-invlogit(b[1])))
    r = 100000
    st_matrix(ci, mm_quantile((invlogit(rnormal(r,1,b[|2 \ .|],se[|2 \ .|])) :- 
        invlogit(rnormal(r,1,b[1],se[1]))),1,(0.025,0.975)'))
    st_matrixcolstripe(b0, st_matrixcolstripe("e(b)")[|2,1 \ .,2|])
}
end

local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
local drinks	"Excessive drinking"
forv i = 0/1 {  // 0: all obs 1: good language 
    // graph by implementation
    est clear
    qui estread log/comparative`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
		mlrrt_pr `v'_ml
    }
    local ci 95
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_ml" local ci "ci"
        foreach v in blood organ drinks recipient chagas {
            addbox `v'`e'   0.016
            addbox `v'`e'_d 0.009
        }
        coefplot (blood`e', aseq(blood) ///
                \ organ`e', aseq(organ) ///
                \ drinks`e', aseq(drinks) ///
                \ recipient`e', aseq(recipient) ///
                \ chagas`e', aseq(chagas)), bylabel(Prevalence estimate in %) ///
            ||   (blood`e'_d, aseq(blood) ///
                \ organ`e'_d, aseq(organ) ///
                \ drinks`e'_d, aseq(drinks) ///
                \ recipient`e'_d, aseq(recipient) ///
                \ chagas`e'_d, aseq(chagas)), bylabel(Difference) ///
            ||  , if(!(@ll<1 & @ul>25)) ///
                byopts(xrescale graphregion(margin(l=-5 b=0 t=0 r=2))) ///
                xline(0, lstyle(grid)) rescale(100) xlabel(#7) ///
                mlab msymbol(i) mlabpos(0) format(%9.0f) ///
				aspectratio(1.2) ylab(, labsize(small)) ///
                ci(`ci' box) ciopts(recast(. rbar) barwidth(. 0.6) color(. white)) ///
				eqlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'" ///
				, angle(hor) labsize(medsmall))
        qui graph export log/comparative`i'`e'.pdf, replace
    }
}


texdoc stlog close
/*tex

\subsection{Graphs for individual-level validation}

tex*/
texdoc stlog

forv i = 0/1 {  // 0: all obs 1: good language 
    // graph by implementation
    est clear
    qui estread log/individual`i'
        *swapnames falserate_nl
	foreach est in aggreg_ml falneg_ml falpos_ml  {
		mlrrt_pr `est'
	}
    local ci 95
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_ml" local ci "ci"
		addbox aggreg`e'   0.003
		addbox aggreg`e'_d 0.004
		addbox falneg`e'   0.012
		addbox falneg`e'_d 0.008
		addbox falpos`e'   0.004
		addbox falpos`e'_d 0.004		
	    coefplot  ///
            aggreg`e',   bylab("Aggregate prevalence (%)")   ///
		||  aggreg`e'_d, bylab("Difference CM - DQ")     ///
        ||  falneg`e',   bylab("False negative rate (%)")    ///
		||  falneg`e'_d, bylab("Difference CM - DQ")   ///
		||  falpos`e',   bylab("False positive rate (%)")      ///	
        ||  falpos`e'_d, bylab("Difference CM - DQ")   ///		
        ||, if(!(@ll<1 & @ul>25)) ///
		byopts(xrescale cols(2)) ///
		rescale(100) xlabel(#6) drop(_cons) xlab(, grid)  ///
		mlab msymbol(i) mlabpos(0) format(%9.0f) ///
		ci(`ci' box) ciopts(recast(. rbar) barwidth(. 0.6) color(. white)) ///
		aspectratio(.2) /// 
		name(temp`e', replace)
		addplot 2 3 5: , xline(0) norescaling
		addplot 1: scatteri 1 25.76, ms(Dh) msize(medlarge)
		addplot 1: scatteri 2 24.97, ms(Dh) msize(medlarge)
		addplot 1: , ylab(1 "DQ" 2 "CM")	
			
        qui graph export log/individual`i'`e'.pdf, replace
    }
}
*Validation values are 25.76 for DQ, and 24.97 for the CM.


texdoc stlog close
/*tex

\subsection{Graphs for quality criteria}

tex*/
texdoc stlog

forv i = 0/1 { // 0: all obs 1: good language
    qui estread log/eval`i'
    coefplot  ///
            breakoff,   bylab("Break-off (%)")                       ///
		||  nonresp,    bylab("Item nonresponse""(excluding don't know, %)")                ///
		||  dkresp,     bylab("Don't know response (%)")             ///	
        ||  time,       bylab("Answering time with""practice question (seconds)") rescale(1) ///		
        ||  time2,      bylab("Answering time without""practice question (seconds)") rescale(1) ///
        ||, byopts(xrescale cols(3) graphregion(margin(l=-5 b=0 t=1 r=1))) ///
        ms(d) rescale(100) xlabel(#6) ///
        coeflab(CM = "CM")
    qui graph export log/eval`i'.pdf, replace
}

texdoc stlog close
/*tex

\subsection{Tables for comparative validation}

tex*/
texdoc stlog

program eappend
    args m1 eq1 m2 eq2
    tempname b1 V1 b2 V2
    qui est restore `m2'
    mat `b2' = e(b)
    mat `V2' = e(V)
    mat coleq `b2' = `"`eq2'"'
    qui est restore `m1'
    mat `b1' = e(b)
    mat `V1' = e(V)
    mat coleq `b1' = `"`eq1'"'
    mat `b1' = `b1', `b2'
    mat `V1' = (`V1', J(rowsof(`V1'), colsof(`V2'), 0)) \ ///
              (J(rowsof(`V2'), colsof(`V1'), 0), `V2')
    erepost b = `b1' V = `V1', rename
    est sto `m1'
end
local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local drinks	"Excessive drinking"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
forv i = 0/1 { // 0: all obs 1: good language
    // table by implementation
    est clear
    qui estread log/comparative`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
    }
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_nl"         local eopt "transform(@*100 100) b(2)"
        else if "`e'"=="_ml"    local eopt "b(3)"
        else                    local eopt "transform(@*100 100) b(2)"
        foreach v in blood organ drinks recipient chagas {
            eappend `v'`e' "l" `v'`e'_d "d"
        }
        qui esttab blood`e' organ`e' drinks`e' recipient`e' chagas`e' ///
            using log/comparative`i'`e'.tex ///
            , replace booktabs `eopt' se nostar nonum ///
              mlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'", ///
                  prefix("\multicolumn{1}{v}{") suffix("}")) nonote ///
              eqlab("\textit{Levels}" "\textit{Difference}") ///
              coeflabels(l:DQ "Direct questioning (DQ)" ///
                         l:CM  "Crosswise Model (CM)" ///
                         d:CM  "CM -- DQ")
    }
}


texdoc stlog close
/*tex

\subsection{Tables for correlates of false positives}

tex*/
texdoc stlog

forv i = 0/1 { // 0: all obs 1: good language
    qui estread log/falsepos`i'
   
   qui esttab exp exp_nl exp_ml ///
        using log/falsepos_exp`i'.tex ///
        , replace booktabs star(* 0.05) ///
          transform(@*100 100) b(2) nocons se nonum eqlab(none) ///
		 mlab( ///
			 "Percentage points change" /// "least squares"
			 "Non-linear least squares" ///
			 "Maximum-likelihood" ///
		 , prefix("\multicolumn{1}{v}{") suffix("}")) ///
         coeflabels( ///
			 sensdk 	"With 'don't know' response option" ///
			 diffsame 	"Response order different - identical (vs. inverse)" ///
			 uq_father 	"Unrelated question on father (vs. mother)" ///
			 uq_acquaint "Unrelated question on acquaintance (vs. mother)" ///
			 uq_day 	"Unrelated question on birthday (vs. birth month)" ///
			 uq_phigh 	"Yes-probability unrelated question .82 (vs. .18)" ///
			 sq_pos 	"Item position (linear)" ///
			 pos12 		"Item position 1st or 2nd (vs. 4th or 5th)" ///
		 )
	
    qui esttab cov cov_nl cov_ml ///
        using log/falsepos_cov`i'.tex ///
        , replace booktabs star(* 0.05) ///
          transform(@*100 100) b(2) nocons se nonum eqlab(none) ///
		 mlab( ///
			 "Percentage points change" /// "least squares"
			 "Non-linear least squares" ///
			 "Maximum-likelihood" ///
		 , prefix("\multicolumn{1}{v}{") suffix("}")) ///
         coeflabels( ///
			  fastintro10 "Among fastest 10\% on CM introduction screen" ///
			  fastsq10 	"Among fastest 10\% answering sensitive items (without intro)" ///
			  q9link 	"Clicked button referring to RRT Wikipedia link" ///
			  q23 		"Social desirability (Crown-Marlowe scale)" ///
		   	  abitur 	"Accomplished the university entrance qualification" ///
			  age 		"Age" ///
			  female 	"Female" ///
		 )
}


texdoc stlog close
/*tex

\subsection{Tables for quality criteria}

tex*/
texdoc stlog

forv i = 0/1 { // 0: all obs 1: good language
    qui estread log/eval`i'
    qui esttab breakoff nonresp dkresp time time2 ///
        using log/eval`i'.tex ///
        , replace eqlab(none) booktabs ///
          transform(@*100 100, pattern(1 1 1 0 0)) b(2) se nostar nonum ///
          mlab("Break-off (\%)" ///
               "Item nonresponse (excluding don't know, \%)" ///
               "Don't know response (\%)" ///
               "Answering time with practice question (seconds)" ///
               "Answering time without practice question (seconds)", ///
               prefix("\multicolumn{1}{v}{") suffix("}")) nonote ///
          coeflabels(DQ "Direct questioning" ///
                     CM  "CM")
}

texdoc stlog close
/*tex

\subsection{Table for comparison of elicited and theoretical “yes”-prevalence to unrelated questions used in CM}

tex*/
texdoc stlog

forv i = 0/1 { // 0: all obs 1: good language
    qui estread log/testuq`i'
    qui esttab uq pyes diff using log/testuq`i'.tex ///
        , replace booktabs eqlab(none) ///
          transform(@*100 100) b(2) se star(* 0.05) nonum ///
          mlab("Yes-prevalence in test" ///
               "Theoretical yes-prevalence" ///
			   "Difference", ///
                prefix("\multicolumn{1}{v}{") suffix("}")) nonote ///
          coeflabels(1 "Mother's birthday Jan-Feb" ///
					2 "Mother's birthday 1st-6th" ///
					3 "Father's birthday Jan-Feb" ///
					4 "Father's birthday 1st-6th" ///
					5 "Acquaintance's birthday Jan-Feb" ///
					6 "Acquaintance's birthday 1st-6th" ///
					7 "Mother's birthday Mar-Dec" ///
					8 "Mother's birthday 7th-31st" ///
					9 "Father's birthday Mar-Dec" ///
					10 "Father's birthday 7th-31st" ///
					11 "Acquaintance's birthday Mar-Dec" ///
					12 "Acquaintance's birthday 7th-31st")	
}


texdoc stlog close
/*tex

\subsection{Graphs for comparative validation without fastest 10\% in sq introduction}

tex*/
texdoc stlog

local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local drinks	"Excessive drinking"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
forv i = 0/1 {  // 0: all obs 1: good language 
    // graph by implementation
    est clear
    qui estread log/comparative_selecteduq`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
        *if "`v'" == "recipient" {
		*
		*}
		*else mlrrt_pr `v'_ml
		mlrrt_pr `v'_ml
    }
    local ci 95
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_ml" local ci "ci"
        foreach v in blood organ drinks recipient chagas {
            addbox `v'`e'   0.016
            addbox `v'`e'_d 0.009
        }
        coefplot (blood`e', aseq(blood) ///
                \ organ`e', aseq(organ) ///
                \ drinks`e', aseq(drinks) ///
                \ recipient`e', aseq(recipient) ///
                \ chagas`e', aseq(chagas)), bylabel(Prevalence estimate in %) ///
            ||   (blood`e'_d, aseq(blood) ///
                \ organ`e'_d, aseq(organ) ///
                \ drinks`e'_d, aseq(drinks) ///
                \ recipient`e'_d, aseq(recipient) ///
                \ chagas`e'_d, aseq(chagas)), bylabel(Difference) ///
            ||  , if(!(@ll<1 & @ul>25)) ///
                byopts(xrescale graphregion(margin(l=-5 b=0 t=2 r=2))) ///
                xline(0, lstyle(grid)) rescale(100) xlabel(#7) ///
                mlab msymbol(i) mlabpos(0) format(%9.0f) ///
				aspectratio(1.2) ylab(, labsize(small)) ///				
                ci(`ci' box) ciopts(recast(. rbar) barwidth(. 0.6) color(. white)) ///
                eqlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'" ///
				, angle(hor) labsize(medsmall)) ///
                coeflab(CM = "CM", labsize(*0.8)) 
        qui graph export log/comparative_selecteduq`i'`e'.pdf, replace
    }
}


texdoc stlog close
/*tex

\subsection{Graphs for comparative validation without fastest 10\% in sq introduction}

tex*/
texdoc stlog

local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local drinks	"Excessive drinking"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
forv i = 0/1 {  // 0: all obs 1: good language 
    // graph by implementation
    est clear
    qui estread log/comparative_nofastintro`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
        *if "`v'" == "recipient" {
		*
		*}
		*else mlrrt_pr `v'_ml
		mlrrt_pr `v'_ml
    }
    local ci 95
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_ml" local ci "ci"
        foreach v in blood organ drinks recipient chagas {
            addbox `v'`e'   0.016
            addbox `v'`e'_d 0.009
        }
        coefplot (blood`e', aseq(blood) ///
                \ organ`e', aseq(organ) ///
                \ drinks`e', aseq(drinks) ///
                \ recipient`e', aseq(recipient) ///
                \ chagas`e', aseq(chagas)), bylabel(Prevalence estimate in %) ///
            ||   (blood`e'_d, aseq(blood) ///
                \ organ`e'_d, aseq(organ) ///
                \ drinks`e'_d, aseq(drinks) ///
                \ recipient`e'_d, aseq(recipient) ///
                \ chagas`e'_d, aseq(chagas)), bylabel(Difference) ///
            ||  , if(!(@ll<1 & @ul>25)) ///
                byopts(xrescale graphregion(margin(l=-5 b=0 t=2 r=2))) ///
                xline(0, lstyle(grid)) rescale(100) xlabel(#7) ///
                mlab msymbol(i) mlabpos(0) format(%9.0f) ///
				aspectratio(1.2) ylab(, labsize(small)) ///						
                ci(`ci' box) ciopts(recast(. rbar) barwidth(. 0.6) color(. white)) ///
                eqlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'" ///
				, angle(hor) labsize(medsmall)) ///
                coeflab(CM = "CM", labsize(*0.8)) 
        qui graph export log/comparative_nofastintro`i'`e'.pdf, replace
    }
}


texdoc stlog close
/*tex

\subsection{Tables for comparative validation without problematic unrel. questions}

tex*/
texdoc stlog

local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
local drinks	"Excessive drinking"
forv i = 0/1 { // 0: all obs 1: good language
    // table by implementation
    est clear
    qui estread log/comparative_selecteduq`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
    }
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_nl"         local eopt "transform(@*100 100) b(2)"
        else if "`e'"=="_ml"    local eopt "b(3)"
        else                    local eopt "transform(@*100 100) b(2)"
        foreach v in blood organ drinks recipient chagas {
            eappend `v'`e' "l" `v'`e'_d "d"
        }
        qui esttab blood`e' organ`e' drinks`e' recipient`e' chagas`e' ///
            using log/comparative_selecteduq`i'`e'.tex ///
            , replace booktabs `eopt' se nostar nonum ///
              mlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'", ///
                  prefix("\multicolumn{1}{v}{") suffix("}")) nonote ///
              eqlab("\textit{Levels}" "\textit{Difference}") ///
              coeflabels(l:DQ "Direct questioning (DQ)" ///
                         l:CM "CM" ///
                         d:CM "CM -- DQ")
    }
}

texdoc stlog close
/*tex

\subsection{Tables for comparative validation without fastest 10\% in sq introduction}

tex*/
texdoc stlog

local blood  	"Never donated blood"
local organ 	"Unwilling to donate organs"
local recipient	"Received a donated organ"
local chagas 	"Suffered from Chagas disease"
local drinks	"Excessive drinking"
forv i = 0/1 { // 0: all obs 1: good language
    // table by implementation
    est clear
    qui estread log/comparative_nofastintro`i'
    foreach v in blood organ drinks recipient chagas {
        swapnames `v'_nl
    }
    foreach e in "" "_nl" "_ml" {
        if "`e'"=="_nl"         local eopt "transform(@*100 100) b(2)"
        else if "`e'"=="_ml"    local eopt "b(3)"
        else                    local eopt "transform(@*100 100) b(2)"
        foreach v in blood organ drinks recipient chagas {
            eappend `v'`e' "l" `v'`e'_d "d"
        }
        qui esttab blood`e' organ`e' drinks`e' recipient`e' chagas`e' ///
            using log/comparative_nofastintro`i'`e'.tex ///
            , replace booktabs `eopt' se nostar nonum ///
              mlab("`blood'" "`organ'" "`drinks'" "`recipient'" "`chagas'", ///
                  prefix("\multicolumn{1}{v}{") suffix("}")) nonote ///
              eqlab("\textit{Levels}" "\textit{Difference}") ///
              coeflabels(l:DQ "Direct questioning (DQ)" ///
                         l:CM "CM" ///
                         d:CM "CM -- DQ")
    }
}

texdoc stlog close
exit
