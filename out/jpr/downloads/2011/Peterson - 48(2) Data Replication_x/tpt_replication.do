{\rtf1\ansi\ansicpg1252\cocoartf1038\cocoasubrtf320
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww21280\viewh15340\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\ql\qnatural\pardirnatural

\f0\fs24 \cf0 *****Replication do file for "Third Party Trade, Political Similarity, and Dyadic Conflict*****\
*****please contact Timothy M. Peterson at petersontm@missouri.edu with any questions or comments*****\
\
****Baseline modes - table 1\
****NOTE: rather than lag almost all IVs, I take the future (t+1) DV and peace years****\
***M1: Baseline\
relogit fcwinit lnotrade1 lnotrade2  s_wt_glo lnot1xswtglo lnot2xswtglo dep1_i dep2_i interdep_i polity1_adj polity2_adj polity_int caprat lndist lngdppc1 lngdppc2 fpy fpy2 fpy3, cluster(dyadid)\
\
***M2: GLEDITCH DATA\
relogit fcwinit lnotrade1_gled lnotrade2_gled s_wt_glo lnotrade1_gledxs lnotrade2_gledxs dep1_g dep2_g interdep_g polity1_adj polity2_adj polity_int caprat lndist lngdppc1_gled lngdppc2_gled fpy fpy2 fpy3, cluster(dyadid)\
\
***M3: GLEDITCH DATA with D&W controls\
relogit fcwinit lnotrade1_gled lnotrade2_gled s_wt_glo lnotrade1_gledxs lnotrade2_gledxs dep1_g dep2_g interdep_g polity1_adj polity2_adj polity_int caprat lndist lngdppc1_g lngdppc2_g fpy fpy2 fpy3 maxflowtrade100_index lntradelinks3_index, cluster(dyadid)\
\
\
****table 2\
****Mitigating dyad models\
***M4: High dyad trade:\
relogit fcwinit lnotrade1 lnotrade2  s_wt_glo lnot1xswtglo lnot2xswtglo dep1_i dep2_i interdep_i polity1_adj polity2_adj polity_int caprat lndist lngdppc1 lngdppc2 fpy fpy2 fpy3 if lndtrad>=4.4, cluster(dyadid)\
\
***M5: High IGO membership:\
relogit fcwinit lnotrade1_gled lnotrade2_gled s_wt_glo lnotrade1_gledxs lnotrade2_gledxs dep1_g dep2_g interdep_g polity1_adj polity2_adj polity_int lndist caprat lngdppc1_g lngdppc2_g fpy fpy2 fpy3 if IGO>=32, cluster(dyadid)\
\
***M6 High D&W:\
relogit fcwinit lnotrade1_gled lnotrade2_gled s_wt_glo lnotrade1_gledxs lnotrade2_gledxs dep1_g dep2_g interdep_g polity1_adj polity2_adj polity_int lndist caprat lngdppc1_g lngdppc2_g fpy fpy2 fpy3 if  lntradelink>=.94 & maxflowtrade100_index >=.39, cluster(dyadid)\
\
\
****Exacerbating models\
\
***M7: Recent MID (2 years)\
relogit fcwinit lnotrade1 lnotrade2  s_wt_glo lnot1xswtglo lnot2xswtglo dep1_i dep2_i interdep_i polity1_adj polity2_adj polity_int caprat lndist lngdppc1 lngdppc2 fpy fpy2 fpy3 if recmid==1, cluster(dyadid)\
\
***M8: Rivalry\
relogit fcwinit lnotrade1 lnotrade2  s_wt_glo lnot1xswtglo lnot2xswtglo dep1_i dep2_i interdep_i polity1_adj polity2_adj polity_int caprat lndist lngdppc1 lngdppc2 fpy fpy2 fpy3 if strival==1, cluster(dyadid)\
\
***M9: Opposing PTAs\
relogit fcwinit lnotrade1_gled lnotrade2_gled s_wt_glo lnotrade1_gledxs lnotrade2_gledxs dep1_g dep2_g interdep_g polity1_adj polity2_adj polity_int caprat lndist lngdppc1_g lngdppc2_g fpy fpy2 fpy3 if pta_dum ==0 & oPTA1_dum==1 & oPTA2_dum ==1, cluster(dyadid)\
\
\
\
***Probability changes using clarify***\
****NOTE: third party trade variables are rescaled such that the mean is set to 0 in order to make substantive probability calculations much easier - coefficients and impacts are identical except that an interpretation of the S score coefficient, which is its effect when third party trade variable = 0, represents its effect at mean, rather than at 0 third party trade****\
***For OR/COW models\
setx mean\
setx lnotrade1 0 lnotrade2 0 s_wt_glo -.56654 lnot1x 0 lnot2x 0\
relogitq\
relogitq, fd(pr) change(lnotrade1 0 2 lnot1x 0 (2*-.56654 ))\
setx mean\
setx lnotrade1 0 lnotrade2 0 s_wt_glo 0 lnot1x 0 lnot2x 0\
relogitq\
relogitq, fd(pr) change(lnotrade1 0 2)\
setx mean\
setx lnotrade1 0 lnotrade2 0 s_wt_glo 1 lnot1x 0 lnot2x 0\
relogitq\
relogitq, fd(pr) change(lnotrade1 0 2 lnot1x 0 2)\
setx mean\
setx lnotrade1 0 lnotrade2 0 s_wt_glo -.56654 lnot1x 0 lnot2x 0\
relogitq, fd(pr) change(lnotrade2 0 2 lnot2x 0 (2*-.56654 ))\
\
setx lnotrade1 0 lnotrade2 0 s_wt_glo 0 lnot1x 0 lnot2x 0\
relogitq, fd(pr) change(lnotrade2 0 2)\
setx lnotrade1 0 lnotrade2 0 s_wt_glo 1 lnot1x 0 lnot2x 0\
relogitq, fd(pr) change(lnotrade2 0 2 lnot2x 0 2)\
\
***for GLED models\
setx mean\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo -.56654 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq\
relogitq, fd(pr) change(lnotrade1_gled 0 2 lnotrade1_gledxs 0 (2*-.56654 ))\
setx mean\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo 0 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq\
relogitq, fd(pr) change(lnotrade1_gled 0 2)\
setx mean\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo 1 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq\
relogitq, fd(pr) change(lnotrade1_gled 0 2 lnotrade1_gledxs 0 2)\
setx mean\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo -.56654 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq, fd(pr) change(lnotrade2_gled 0 2 lnotrade2_gledxs 0 (2*-.56654 ))\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo 0 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq, fd(pr) change(lnotrade2_gled 0 2)\
setx lnotrade1_gled 0 lnotrade2_gled 0 s_wt_glo 1 lnotrade1_gledxs 0 lnotrade2_gledxs 0\
relogitq, fd(pr) change(lnotrade2_gled 0 2 lnotrade2_gledxs 0 2)\
\
\
***For figure\
setx lnotrade1 2 lnotrade2 0 s_wt_glo -.6 lnot1x (2* -.6) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo -.4 lnot1x (2* -.4) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo -.2 lnot1x (2* -.2) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 0 lnot1x (2* 0) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 0.2 lnot1x (2* 0.2) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 0.4 lnot1x (2* 0.4) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 0.6 lnot1x (2* 0.6) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 0.8 lnot1x (2* 0.8) lnot2x 0\
relogitq\
setx lnotrade1 2 lnotrade2 0 s_wt_glo 1 lnot1x (2* 1) lnot2x 0\
relogitq\
\
setx lnotrade2 2 lnotrade1 0 s_wt_glo -.6 lnot2x (2* -.6) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo -.4 lnot2x (2* -.4) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo -.2 lnot2x (2* -.2) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 0 lnot2x (2* 0) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 0.2 lnot2x (2* 0.2) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 0.4 lnot2x (2* 0.4) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 0.6 lnot2x (2* 0.6) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 0.8 lnot2x (2* 0.8) lnot1x 0\
relogitq\
setx lnotrade2 2 lnotrade1 0 s_wt_glo 1 lnot2x (2* 1) lnot1x 0\
relogitq\
\
***graph commands using dataset (manually entered) with probability and confidence bounds generated from relogitq command***\
graph twoway (rarea lb1 ub1 outside_lev ) (connected p1 outside_lev), scheme(s2manual) name(A)\
graph twoway (rarea lb2 ub2 outside_lev ) (connected p2 outside_lev), scheme(s2manual) name(B)\
graph combine A B, imargin(small)\
\
\
}