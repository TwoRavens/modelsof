*DESCRIPTIVE STATISTICS
 sum sign ratify nvcamp_p nvsize2 nvsuccess_p vcamp_a vsize2 latentmean commonlaw polity2 newdemocracy2 numsign numrat timecount if year < 2007
 
**MAIN RESULTS
*Sign
logit F.sign nvcamp_p vcamp_a  latentmean commonlaw polity2 newdemocracy2 numsign timecount if year < 2007, r cluster(ccode)
logit F.sign nvsize2 vsize2  latentmean commonlaw polity2 newdemocracy2 numsign timecount if year < 2007, r cluster(ccode)

*Ratify
logit F.ratify nvcamp_p vcamp_a latentmean commonlaw polity2 newdemocracy2 numratif timecount if year < 2007, r cluster(ccode)
logit F.ratify nvsize2 vsize2 latentmean commonlaw polity2 newdemocracy2 numratif timecount if year < 2007, r cluster(ccode)

**EXTENSION: Success of the Movement
*sign
logit F.sign nvsuccess_p latentmean commonlaw polity2 newdemocracy2 numsign timecount if year < 2007, r cluster(ccode)
logit F.sign nvsuccess_p nvnosucc latentmean commonlaw polity2 newdemocracy2 numsign timecount if year < 2007, r cluster(ccode)

*Ratify
logit F.ratify nvsuccess_p latentmean commonlaw polity2 newdemocracy2 numratified timecount if year < 2007, r cluster(ccode)
logit F.ratify nvsuccess_p nvnosucc latentmean commonlaw polity2 newdemocracy2 numratified timecount if year < 2007, r cluster(ccode)


**ONLINE APPENDIX

*Additional time functions: Cubic splines
*Sign
logit F.sign nvcamp_p vcamp_a  latentmean commonlaw polity2 newdemocracy numsign spline* if year < 2007, r cluster(ccode)
logit F.sign nvsize2 vsize2  latentmean commonlaw polity2 newdemocracy numsign spline* if year < 2007, r cluster(ccode)

*Ratify
logit F.ratify nvcamp_p vcamp_a latentmean commonlaw polity2 newdemocracy numratif spline* if year < 2007, r cluster(ccode)
logit F.ratify nvsize2 vsize2 latentmean commonlaw polity2 newdemocracy numratif spline* if year < 2007, r cluster(ccode)


*INDIVIDUAL TREATIES and Cox Models
*CERD
*Sign 
quietly stset failtimes_cerdr, id(ccode) failure(cerds)
stcox nvcamp_p vcamp_a regcerd_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cerd_sign_nvcamp
stcox nvsize2 vsize2 regcerd_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cerd_sign_nvsize
*Ratify
quietly stset failtimer_cerd, id(ccode) failure(cerdr)
stcox nvcamp_p vcamp_a regcerd_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cerd_ratify_nvcamp
stcox nvsize2 vsize2 regcerd_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cerd_ratify_nvsize

*ICESCR
*Sign 
quietly stset failtimes_icescr, id(ccode) failure(icescrs)
stcox nvcamp_p vcamp_a regicescr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store icescr_sign_nvcamp
stcox nvsize2 vsize2 regicescr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store icescr_sign_nvsize
*Ratify
quietly stset failtimer_icescr, id(ccode) failure(icescrr)
stcox nvcamp_p vcamp_a regicescr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store icescr_ratify_nvcamp
stcox nvsize2 vsize2 regicescr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store icescr_ratify_nvsize

*ICCPR
*Sign
quietly stset failtimes_iccpr, id(ccode) failure(iccprs)
stcox nvcamp_p vcamp_a regiccpr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store iccpr_sign_nvcamp
stcox nvsize2 vsize2 regiccpr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store iccpr_sign_nvsize
*Ratify
quietly stset failtimer_iccpr, id(ccode) failure(iccprr)
stcox nvcamp_p vcamp_a regiccpr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store iccpr_ratify_nvcamp
stcox nvsize2 vsize2 regiccpr_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store iccpr_ratify_nvsize

*CEDAW
*Sign
quietly stset failtimes_cedaw, id(ccode) failure(cedaws)
stcox nvcamp_p vcamp_a regcedaw_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cedaw_sign_nvcamp
stcox nvsize2 vsize2 regcedaw_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cedaw_sign_nvsize
*Ratify
quietly stset failtimer_cedaw, id(ccode) failure(cedawr)
stcox nvcamp_p vcamp_a regcedaw_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cedaw_ratify_nvcamp
stcox nvsize2 vsize2 regcedaw_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cedaw_ratify_nvsize

*CAT
*Sign 
quietly stset failtimes_cat, id(ccode) failure(cats)
stcox nvcamp_p vcamp_a regcat_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cat_sign_nvcamp
stcox nvsize2 vsize2 regcat_pct latentmean commonlaw  polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cat_sign_nvsize
*Ratify
quietly stset failtimer_cat, id(ccode) failure(catr)
stcox nvcamp_p vcamp_a regcat_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cat_ratify_nvcamp
stcox nvsize2 vsize2 regcat_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store cat_ratify_nvsize

*CRC
*Sign 
quietly stset failtimes_crc, id(ccode) failure(crcs)
stcox nvcamp_p vcamp_a regcrc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store crc_sign_nvcamp
stcox nvsize2 vsize2 regcrc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store crc_sign_nvsize
*Ratify
quietly stset failtimer_crc, id(ccode) failure(crcr)
stcox nvcamp_p vcamp_a regcrc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store crc_ratify_nvcamp
stcox nvsize2 vsize2 regcrc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store crc_ratify_nvsize

*MWC
*Sign 
quietly stset failtimes_mwc, id(ccode) failure(mwcs)
stcox nvcamp_p vcamp_a regmwc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store mwc_sign_nvcamp
stcox nvsize2 vsize2 regmwc_pct latentmean commonlaw  polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store mwc_sign_nvsize
*Ratify
quietly stset failtimer_mwc, id(ccode) failure(mwcr)
stcox nvcamp_p vcamp_a regmwc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store mwc_ratify_nvcamp
stcox nvsize2 vsize2 regmwc_pct latentmean commonlaw polity2 newdemocracy2 if year < 2007, r cluster(ccode)
estimates store mwc_ratify_nvsize

*Coefficient Plots (Main Paper)
coefplot cerd_sign_nvcamp || icescr_sign_nvcamp ||  iccpr_sign_nvcamp ||  cedaw_sign_nvcamp ||  cat_sign_nvcamp || crc_sign_nvcamp || mwc_sign_nvcamp , drop(vcamp_antig vsize2 regicescr_pct latentmean commonlaw polity2 newdemocracy2 regcerd_pct regiccpr_pct regcedaw_pct regcat_pct regcrc_pct regmwc_pct) xline(0) bycoefs levels(95)
coefplot cerd_sign_nvsize || icescr_sign_nvsize ||  iccpr_sign_nvsize ||  cedaw_sign_nvsize ||  cat_sign_nvsize || crc_sign_nvsize || mwc_sign_nvsize , drop(vsize2 regicescr_pct latentmean commonlaw polity2 newdemocracy2 regcerd_pct regiccpr_pct regcedaw_pct regcat_pct regcrc_pct regmwc_pct) xline(0) bycoefs levels(95)

coefplot cerd_ratify_nvcamp || icescr_ratify_nvcamp ||  iccpr_ratify_nvcamp ||  cedaw_ratify_nvcamp ||  cat_ratify_nvcamp || crc_ratify_nvcamp || mwc_ratify_nvcamp , drop(vcamp_antig vsize2ntig regicescr_pct latentmean commonlaw polity2 newdemocracy2 regcerd_pct regiccpr_pct regcedaw_pct regcat_pct regcrc_pct regmwc_pct) xline(0) bycoefs levels(95)
coefplot icescr_ratify_nvsize ||  iccpr_ratify_nvsize ||  cedaw_ratify_nvsize ||  cat_ratify_nvsize || crc_ratify_nvsize || mwc_ratify_nvsize , drop(vsize2 regicescr_pct latentmean commonlaw polity2 newdemocracy2 regcerd_pct regiccpr_pct regcedaw_pct regcat_pct regcrc_pct regmwc_pct) xline(0) bycoefs levels(95)
