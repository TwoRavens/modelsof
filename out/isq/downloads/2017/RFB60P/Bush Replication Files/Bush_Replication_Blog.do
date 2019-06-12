*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      Bush_Replication_Blog.do			 	   		*;
*       Date:           4/21/2014		                                *;
*       Author:         Sarah Bush                                      *;
*       Purpose:        Do-file for ISQ Replication Blog Post			*;
*     ****************************************************************  *;
*     ****************************************************************  *;

***********************Load Data

***********************Replicate Table 3

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model1

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model2

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1  , corr(ar1) robust
est store model3

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model4

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model5

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 if psept11==1 , corr(ar1) robust
est store model6

esttab model1 model2 model3 model4 model5 model6, se star (+ .1 * .05 ** .005   ) title (xtgee: selection results)

***********************Add first measure of corruption to Table 3

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1 , corr(ar1) robust
est store model1ra

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1 , corr(ar1) robust
est store model2ra

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1  , corr(ar1) robust
est store model3ra

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1 , corr(ar1) robust
est store model4ra

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1 , corr(ar1) robust
est store model5ra

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 wgi_corruption if psept11==1 , corr(ar1) robust
est store model6ra

esttab model1ra model2ra model3ra model4ra model5ra model6ra, se star (+ .1 * .05 ** .005   ) title (xtgee: selection results)

***********************Add second measure of corruption to Table 3

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1 , corr(ar1) robust
est store model1rb

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1 , corr(ar1) robust
est store model2rb

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  logimrl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1  , corr(ar1) robust
est store model3rb

xtgee ofdaselect  polity4l  s2un4608iL  loglouvtotdaml logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1 , corr(ar1) robust
est store model4rb

xtgee ofdaselect  polity4l  s2un4608iL  loglouvdeadl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1 , corr(ar1) robust
est store model5rb

xtgee ofdaselect  polity4l  s2un4608iL  loglouvnumberl logtotbilatl  gdpcapconl cdum1-cdum135 aidyears logbattdeathsl _spline1 _spline2 _spline3 transparency if psept11==1 , corr(ar1) robust
est store model6rb

esttab model1rb model2rb model3rb model4rb model5rb model6rb, se star (+ .1 * .05 ** .005   ) title (xtgee: selection results)

***********************Replicate Table 5

xtregar ofdacongdp_d  loglouvtotdaml  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model8

xtregar ofdacongdp_d  loglouvdeadl  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model9

xtregar ofdacongdp_d loglouvnumberl s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model10

xtregar ofdacongdp_d  lloutot_ctl    s2un4608iL polity4l logimrl_ct  imrtot_ctl   logtotbilatl  logbattdeathsl if psept11==1, fe
est store model11

xtregar ofdacongdp_d lloudead_ctl  s2un4608iL  polity4l logimrl_ct imrdead_ctl   logtotbilatl logbattdeathsl if psept11==1, fe
est store model12

xtregar ofdacongdp_d llounum_ctl s2un4608iL  polity4l logimrl_ct  imrnum_ctl  logtotbilatl logbattdeathsl if psept11==1, fe
est store model13

esttab model8 model9 model10 model11 model12 model13, se star (+ .1 * .05 ** .005   ) title (xtregar: main outcome results with logimrl)

***********************Add first measure of corruption to Table 5

xtregar ofdacongdp_d  loglouvtotdaml  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl wgi_corruption if psept11==1, fe
est store model8ra

xtregar ofdacongdp_d  loglouvdeadl  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl wgi_corruption if psept11==1, fe
est store model9ra

xtregar ofdacongdp_d loglouvnumberl s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl wgi_corruption if psept11==1, fe
est store model10ra

xtregar ofdacongdp_d  lloutot_ctl    s2un4608iL polity4l logimrl_ct  imrtot_ctl   logtotbilatl  logbattdeathsl wgi_corruption if psept11==1, fe
est store model11ra

xtregar ofdacongdp_d lloudead_ctl  s2un4608iL  polity4l logimrl_ct imrdead_ctl   logtotbilatl logbattdeathsl wgi_corruption if psept11==1, fe
est store model12ra

xtregar ofdacongdp_d llounum_ctl s2un4608iL  polity4l logimrl_ct  imrnum_ctl  logtotbilatl logbattdeathsl wgi_corruption if psept11==1, fe
est store model13ra

esttab model8ra model9ra model10ra model11ra model12ra model13ra, se star (+ .1 * .05 ** .005   ) title (xtregar: main outcome results with logimrl)

***********************Add second measure of corruption to Table 5

xtregar ofdacongdp_d  loglouvtotdaml  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model8rb

xtregar ofdacongdp_d  loglouvdeadl  s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model9rb

xtregar ofdacongdp_d loglouvnumberl s2un4608iL polity4l logimrl  logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model10rb

xtregar ofdacongdp_d  lloutot_ctl    s2un4608iL polity4l logimrl_ct  imrtot_ctl logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model11rb

xtregar ofdacongdp_d lloudead_ctl  s2un4608iL  polity4l logimrl_ct imrdead_ctl   logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model12rb

xtregar ofdacongdp_d llounum_ctl s2un4608iL  polity4l logimrl_ct  imrnum_ctl  logtotbilatl logbattdeathsl transparency if psept11==1, fe
est store model13rb

esttab model8rb model9rb model10rb model11rb model12rb model13rb, se star (+ .1 * .05 ** .005   ) title (xtregar: main outcome results with logimrl)
