
********************************************
** Are Coups Good for Democracy?		  **
** A Response to Miller (2016)			  **
** George Derpanopoulos   			      **
** Erica Frantz						      **
** Barbara Geddes						  **
** Joseph Wright						  **
**										  **
** Using files: temp2015.dta			  **
**										  **
** Author: JW (joseph.g.wright@gmail.com  **
** Date 1/26/2017						  **
********************************************
		
		** Get data **
		*cd "C:\Users\jwright\Dropbox\Research\Coups\DFGW\Data files"
		set more off
		use temp2015, clear
		
		** Keep only post-1989 **
		qui: reg gdem ld gtime gtime2 gtime3 coupMS if year>1989
		keep if e(sample)==1
		tsset cow year
		
		** Generate means **
		egen tag_case = tag(caseid)
		egen tag_country= tag(cow)
		local c = "coupMS"
		foreach i of local c {
			egen m_`i' = mean(`i'), by(caseid)
			egen cm_`i' = mean(`i'), by(cow)
		}
		
		** Means distributions **
		twoway (hist m_coupMS , freq bin(40) lcolor(gs16) fcolor(gs11)) /*
		*/ (hist cm_coupMS, freq bin(40) lcolor(red) fcolor(none)  /*
		*/ xtitle(Mean coups) ytitle(Number of observations) lcolor(blue) scheme(lean2) ylabel(,glcolor(gs15)) /*
		*/ legend(lab(1  "regime-case X{sub:i}'s") lab(2 "country X{sub:i}'s") ring(0) pos(1) col(1)) /*
		*/ title(All regimes) saving(s1, replace))	
		twoway (hist m_coupMS  if m_coupMS>0, freq bin(40) lcolor(gs16) fcolor(gs11)) /*
		*/ (hist cm_coupMS  if cm_coupMS>0, freq bin(40) lcolor(red) fcolor(none)  /*
		*/ xtitle(Mean coups) ytitle(Number of observations) lcolor(blue) scheme(lean2) ylabel(,glcolor(gs15)) /*
		*/ legend(lab(1  "regime-case X{sub:i}'s") lab(2 "country X{sub:i}'s") ring(0) pos(1) col(1)) /*
		*/ title(Regimes with at least 1 coup) saving(s2, replace))
		graph combine s1.gph s2.gph,  xsize(4) ysize(2)  xcommon col(2) graphregion(color(white))
		*graph export "C:\Users\jwright\Dropbox\Research\Coups response\Post-Cold-War-means.pdf", as(pdf) replace
		erase s1.gph
		erase s2.gph
 
		** Post-1989 coups with no variation in regime-case coup mean: b/c of short dictatorship duration *
		tab m_coupMS coupMS
		egen tag=tag(gwf_case)
		egen mdem  =max(gdem),by(gwf_case)
		sort gwf_country year
        list cow gwf_case year mdem cm_coupMS m_coupMS if m_coupMS==1 & coupMS==1 , noobs clean
		/*
		listtex gwf_case year mdem cm_coupMS m_coupMS if m_coupMS==1 & coupMS==1 & tag==1 using T1.tex, /*
		*/ rstyle(tabular) head("\begin{tabular}{l c c c c c c}" "\textit{Regime-case name}&\textit{Year}&\textit{Any regime failure}&\textit{Democratize}&\textit{Country-mean}&\textit{Case-mean}\\\\") /*
		*/ foot("\end{tabular}") replace
		*/
		
		** The end **
		
