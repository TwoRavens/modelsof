use UNselection-replication, clear

*Model 1
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both p5col pkexp04lagged if pcw==0estat icpre

*Model 2oprobit level7pt p5contig  oilexp p5defpactany p5crisis1 p5col pkexp04lagged if pcw==1estat ic
pre

*Model 3 oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col pkexp04laggedestat icpre
*Model 4 oprobit level7pt viol cractr lncrisisdur contig pkexp04laggedestat icpre*Model 5 oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig pkexp04laggedestat icpre


*Model 6
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig pkexp04lagged askunp5nw askunothestat icpre

*Model 7
oprobit level7sc p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col pkexp04laggedestat icpre

*Model 8
oprobit level7sc viol cractr lncrisisdur contig pkexp04lagged
estat ic
pre

*Model 9
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig p5aff_min pkexp04laggedestat icpre

*Model 10
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig europe america africa asia pkexp04lagged
estat ic
pre


**Figure 1a
keep year siguninvgen crises=1collapse (sum) siguninv crises, by(year)gen pinv=siguninv/crisesset obs 58replace year=2000 in 58replace siguninv=0 if year==2000replace crises=0 if year==2000replace pinv=. if year==2000tsset yeargen mapinv=(pinv+l.pinv+l2.pinv+l3.pinv+l4.pinv)/5replace mapinv=(pinv+l.pinv+l2.pinv+l3.pinv)/4 if year==1948replace mapinv=(pinv+l.pinv+l2.pinv)/3 if year==1947replace mapinv=(pinv+l.pinv)/2 if year==1946replace mapinv=pinv if year==1945replace mapinv=(l.pinv+l2.pinv+l3.pinv+l4.pinv)/4 if year==2000replace mapinv=(pinv+l2.pinv+l3.pinv+l4.pinv)/4 if year==2001replace mapinv=(pinv+l.pinv+l3.pinv+l4.pinv)/4 if year==2002label variable pinv "Yearly Percentage"label variable mapinv "5-Year Moving Average"twoway (bar pinv year, lcolor(gray) fcolor(gray)) (line mapinv year, lcolor(dknavy)), ytitle(Percent of Crises with Interventions) xtitle(Crisis Trigger Year) xscale(range(1945 2002)) title(Panel A: UN Interventions in International Crises, size(medium) justification(left)) 
