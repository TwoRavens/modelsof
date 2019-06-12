log using "bits/results/4b_bit robustness opt1.smcl", replace
cd "bits/madedata"


set more off

** BIT -- opt1

** Matching
  ** treaty members
    ** Original specification
	pwd
    use "mahmatches_opt1bit_Ratifiers.dta", clear
    xtset dyad year

	local lags ///
      l2jchgdplag2 l3jchgdplag2 l4jchgdplag2 l5jchgdplag2 /// *host GDP growth: jchgdplag2
      l2jfdilag l3jfdilag l4jfdilag l5jfdilag /// *host net FDI inflows (% of GDP) t-1: jfdilag  l2jca_gdp l3jca_gdp l4jca_gdp l5jca_gdp /// *host capital account/gdp: jca_gdp
      l2tradgdp l3tradgdp l4tradgdp l5tradgdp /// *dyadic trade (% of hosts GDP): tradgdp 

    capture noisily  logit bit012345 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1* `lags', cluster(dyad) l(90) iter(200)
	

    ** L1 controls only
    capture noisily  logit bit012345 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1*, cluster(dyad) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1bit treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit f2bit treated l1* `lags', cluster(dyad) l(90) iter(200)
	
  ** all
    ** Original specification
    use "mahmatches_opt1bit.dta", clear
    xtset dyad year

    capture noisily  logit bit012345 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1* `lags', cluster(dyad) l(90) iter(200)
	
    ** L1 controls only
    capture noisily  logit bit012345 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1*, cluster(dyad) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1bit treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit f2bit treated l1* `lags', cluster(dyad) l(90) iter(200)

	
** Without Matching
  ** treaty members
    ** Original specification
    use "opt1RatEpisodeDat.dta", clear
	
	capture noisily  logit bit012345 treated l1* `lags' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1* `lags' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1* `lags' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
	
    ** L1 controls only
	capture noisily  logit bit012345 treated l1* if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1* if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1* if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
	
    ** Random Effects
    capture noisily  xtlogit bit012345 treated l1* `lags' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit bit012345 treated l1* `lags' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1bit treated l1* `lags' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit f2bit treated l1* `lags' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
	
  ** all
    ** Original specification
    use "mahmatches_opt1bit.dta", clear
    xtset dyad year

    capture noisily  logit bit012345 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1* `lags', cluster(dyad) l(90) iter(200)
	
    ** L1 controls only
    capture noisily  logit bit012345 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit012 treated l1*, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit123 treated l1*, cluster(dyad) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit bit012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit bit123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1bit treated l1* `lags', cluster(dyad) l(90) iter(200)
    capture noisily  logit f2bit treated l1* `lags', cluster(dyad) l(90) iter(200)

	
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "tmpBITs.dta", clear
    xtset dyad year
	
	gen treat012345 = opt1_host_treat3
	gen treat012 = opt1_host_treat==1 | opt1_host_treat2==1 | (opt1_host_treat[_n-1]==1 & opt1_host_treat3==1)
	gen treat123 = opt1_host_treat==1 | (opt1_host_treat[_n-1]==1 & opt1_host_treat3==1) | (opt1_host_treat[_n-2]==1 & opt1_host_treat3==1)
	
	local ctrls physint jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount

    capture noisily  logit bit treat012345 `ctrls' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit treat012 `ctrls' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
    capture noisily  logit bit treat123 `ctrls' if opt1_home==1 & opt1_host==0, cluster(dyad) l(90) iter(200)
	
    ** L1 controls only
    ** NA
   
    ** Random Effects
    capture noisily  xtlogit bit treat012345 `ctrls' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
    capture noisily  xtlogit bit treat012 `ctrls' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
    capture noisily  xtlogit bit treat123 `ctrls' if opt1_home==1 & opt1_host==0, re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit bit treat012345 `ctrls' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)
    capture noisily  xtlogit bit treat012 `ctrls' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)
    capture noisily  xtlogit bit treat123 `ctrls' if opt1_home==1 & opt1_host==0, fe l(90) iter(200)
	
    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    ** NA
	
  ** all
    ** Original specification
    capture noisily  logit bit treat012345 `ctrls', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit treat012 `ctrls', cluster(dyad) l(90) iter(200)
    capture noisily  logit bit treat123 `ctrls', cluster(dyad) l(90) iter(200) 
	
    ** L1 controls only
    ** NA
   
    ** Random Effects
    capture noisily  xtlogit bit treat012345 `ctrls', re l(90) iter(200)
    capture noisily  xtlogit bit treat012 `ctrls', re l(90) iter(200)
    capture noisily  xtlogit bit treat123 `ctrls', re l(90) iter(200)

	
    ** Fixed Effects
    capture noisily  xtlogit bit treat012345 `ctrls', fe l(90) iter(200)
    capture noisily  xtlogit bit treat012 `ctrls', fe l(90) iter(200)
    capture noisily  xtlogit bit treat123 `ctrls', fe l(90) iter(200)

	
    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    ** NA
	
*****************************************************************************

cd "../.."

log close
