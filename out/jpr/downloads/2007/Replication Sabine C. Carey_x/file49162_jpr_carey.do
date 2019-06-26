* do-file for the article
* 'Violent Dissent and Rebellion in Africa'
* Journal of Peace Research, Sabine C Carey

* SUMMARY STATISTICS FOR TABLE I
logit onset execB execC execD lagexchange lagstep12 lagstep34 inst3l1 laggovcon	///
lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog
tab1 onset noexec execA execB execC execD lagexchange lagstep12 lagstep34 inst3l1 if e(sample)

logit onset xrcomp1 xrcomp2 xrcomp3 lagxrchange lagxrstep12 lagxrstep3 inst3l1 laggovcon		///	
lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog
tab1 onset xrcomp0 xrcomp1 xrcomp2 xrcomp3 lagxrchange lagxrstep12 lagxrstep3 inst3l1 if e(sample)
___________________________________________________________________________________________

* ANALYSIS FOR TABLE II
* MODEL I
logit onset execB execC execD lagexchange lagstep12 lagstep34 inst3l1 laggovcon 	///
lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog

* MODEL II
logit onset xrcomp1 xrcomp2 xrcomp3 lagxrchange lagxrstep12 lagxrstep3 inst3l1 laggovcon 	///
lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog

* MODEL III
logit onset polity2 anoc2 lagpolchange inst3l1 laggovcon lagnguer lrurpopdens 	///
larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog

____________________________________________________________________________________________


** FIGURE 1
quietly logit onset execB execC execD lagexchange lagstep12 lagstep34 inst3l1 	///
laggovcon lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog
	
* Probability for not-elected executive
prvalue, x(execB=0 execC=0 execD=0 lagexchange=0 lagstep12=0 lagstep34=0 inst3l1=0	///
laggovcon=0 Oil=0) rest(mean)

* Probability for single candidate
prvalue, x(execB=1 execC=0 execD=0 lagexchange=0 lagstep12=0 lagstep34=0 inst3l1=0	///
laggovcon=0 Oil=0) rest(mean)

* Probability for single party
prvalue, x(execB=0 execC=1 execD=0 lagexchange=0 lagstep12=0 lagstep34=0 inst3l1=0	///
laggovcon=0 Oil=0) rest(mean)

* Probability for multiparty executive elections
prvalue, x(execB=0 execC=0 execD=1 lagexchange=0 lagstep12=0 lagstep34=0 inst3l1=0	///
laggovcon=0 Oil=0) rest(mean)

* Probability for multiparty executive elections & three steps towards more competitive elections at t-1
prvalue, x(execB=0 execC=0 execD=1 lagexchange=3 lagstep12=0 lagstep34=0 inst3l1=0	///
laggovcon=0 Oil=0) rest(mean)

* Probability for single candidate & political instability at t-1
prvalue, x(execB=1 execC=0 execD=0 lagexchange=0 lagstep12=0 lagstep34=0 inst3l1=1	///
laggovcon=0 Oil=0) rest(mean)

_______________________________________________________________________________________________


* APPENDIX: ESTIMATED CORRELATION MATRIX FOR ESTIMATES FOR MODEL I
logit onset execB execC execD lagexchange lagstep12 lagstep34 inst3l1 laggovcon	///
lagnguer lrurpopdens larea95 mtnest gdpenl grol1 Oil ef second decay, robust nolog
estat vce, corr

		
* POPULATION SIZE instead of larea95 
logit onset execB execC execD lagexchange lagstep12 lagstep34 inst3l1 laggovcon 	///
lagnguer lrurpopdens lpop mtnest gdpenl grol1 Oil ef second decay, robust nolog

