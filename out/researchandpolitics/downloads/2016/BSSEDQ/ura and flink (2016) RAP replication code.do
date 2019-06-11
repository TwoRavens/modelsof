*====Table 1
*====Replicate WJS relogit model using logit estimator for Burger's tenure.

logit passnew  ideocourt ideocourtsq nobsvalue mwcgrant amiciz freshman newcomplex ///
notcj ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj, cluster(justice)

*====Generate predicted probabilities reported in the text.
*====Replicate WJS predictions for no ideological distance (ideocourt=0) and mean ideological distance (ideocourt=0.129).
*====WJS's relogit estimates are 4.6% and 11.3%, respectively.
*====Our logit estimates are 4.3% and 11.9%, respectively.

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0) 

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0) 

*====Replicate WJS predictions for low preference uncertainty (nobsvalue=129.086) and high preference uncertainty (nobsvalue=397.879).
*====WJS's relogit estimates are 12.5% and 10.3%, respectively.
*====Our logit estimates are 13.1% and 10.7%, respectively.

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)  

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=397.879 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0) 

*====Replicate WJS predictions for low outcome uncertainty (mwcgrant=0) and high outcome uncertainty (mwcgrant=1).
*====WJS's relogit estimates are 11.3% and 12.0%, respectively.
*====Our logit estimates are 11.9% and 12.4%, respectively.

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=1 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)

*====Replicate WJS predictions for low salience (amiciz=-1.759) and high outcome uncertainty (amiciz=5.337).
*====WJS's relogit estimates are 10.6% and 12.4%, respectively.
*====Our logit estimates are 10.9% and 13.9%, respectively.

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=-1.759 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)

*====Table 2
*====Extend WJS relogit model including management variables using logit estimator.

logit passnew  ideocourt ideocourtsq  nobsvalue mwcgrant amiciz freshman  newcomplex ///
notcj  ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj ///
count countnotcj countideocourt countideocourtsq countnobsvalue countmwcgrant countamiciz, cluster(justice)

*====Generate predicted probabilities reported in the text.
*====Replicate WJS predictions for no ideological distance (ideocourt=0) when count is 1 (22.3%), 6 (10.1%), 11 (4.2%), and 16 (1.7%).

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=1 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=263.815 countmwcgrant=0 countamiciz=1.789)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=6 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=1582.890 countmwcgrant=0 countamiciz=10.734)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=11 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=2901.965 countmwcgrant=0 countamiciz=19.679)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=16 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=4221.040 countmwcgrant=0 countamiciz=28.624)

*====Replicate WJS predictions for mean ideological distance (ideocourt=0.129) when count is 1 (14.6%), 6 (12.5%), 11 (10.7%), and 16 (9.0%).

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=1 countnotcj=0 countideocourt=0.129 countideocourtsq=0.017 countnobsvalue=263.815 countmwcgrant=0 countamiciz=1.789)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=6 countnotcj=0 countideocourt=0.774 countideocourtsq=0.102 countnobsvalue=1582.890 countmwcgrant=0 countamiciz=10.734)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=11 countnotcj=0 countideocourt=1.419 countideocourtsq=0.187 countnobsvalue=2901.965 countmwcgrant=0 countamiciz=19.679)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=263.815 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=16 countnotcj=0 countideocourt=2.064 countideocourtsq=.274 countnobsvalue=4221.040 countmwcgrant=0 countamiciz=28.624)

*====Figure 1
*====Predicted probability for "less sensible pass" and "more sensible pass."

*====Less Sensible 
logit passnew  ideocourt ideocourtsq nobsvalue mwcgrant amiciz freshman newcomplex ///
notcj ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj, cluster(justice)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=397.879 mwcgrant=0 amiciz=-1.759 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0) 

logit passnew  ideocourt ideocourtsq  nobsvalue mwcgrant amiciz freshman  newcomplex ///
notcj  ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj ///
count countnotcj countideocourt countideocourtsq countnobsvalue countmwcgrant countamiciz, cluster(justice)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=397.879 mwcgrant=0 amiciz=-1.759 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=1 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=397.879 countmwcgrant=0 countamiciz=-1.759)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=397.879 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=6 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=2387.274 countmwcgrant=0 countamiciz=-10.554)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=397.879 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=11 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=4376.669 countmwcgrant=0 countamiciz=-19.349)

prvalue, x(ideocourt=0 ideocourtsq=0 nobsvalue=397.879 mwcgrant=0 amiciz=1.789 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=16 countnotcj=0 countideocourt=0 countideocourtsq=0 countnobsvalue=6366.064 countmwcgrant=0 countamiciz=-28.144)

*====More sensible
logit passnew  ideocourt ideocourtsq nobsvalue mwcgrant amiciz freshman newcomplex ///
notcj ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj, cluster(justice)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0)

logit passnew  ideocourt ideocourtsq  nobsvalue mwcgrant amiciz freshman  newcomplex ///
notcj  ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj ///
count countnotcj countideocourt countideocourtsq countnobsvalue countmwcgrant countamiciz, cluster(justice)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=1 countnotcj=0 countideocourt=0.129 countideocourtsq=0.017 countnobsvalue=129.086 countmwcgrant=1 countamiciz=5.337)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=6 countnotcj=0 countideocourt=0.774 countideocourtsq=0.102 countnobsvalue=774.516 countmwcgrant=6 countamiciz=32.022)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=11 countnotcj=0 countideocourt=1.419 countideocourtsq=0.187 countnobsvalue=1419.946 countmwcgrant=11 countamiciz=58.707)

prvalue, x(ideocourt=0.129 ideocourtsq=0.017 nobsvalue=129.086 mwcgrant=1 amiciz=5.337 freshman=0 newcomplex=0.182 ///
notcj=0 ideocourtnotcj=0 ideocourtsqnotcj=0 nobsvaluenotcj=0 mwcnotcj=0 amiciznotcj=0 freshman=0 ///
count=16 countnotcj=0 countideocourt=2.064 countideocourtsq=0.274 countnobsvalue=2065.376 countmwcgrant=16 countamiciz=85.392)

*====Appendix
*====Replicate WJS model using relogit estimator for Burger's tenure.

relogit passnew  ideocourt ideocourtsq nobsvalue mwcgrant amiciz freshman newcomplex ///
notcj ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj, cluster(justice)

*====Replicate management tenure model using relogit estimator for Burger's tenure.

logit passnew  ideocourt ideocourtsq  nobsvalue mwcgrant amiciz freshman  newcomplex ///
notcj  ideocourtnotcj ideocourtsqnotcj  nobsvaluenotcj  mwcnotcj amiciznotcj ///
count countnotcj countideocourt countideocourtsq countnobsvalue countmwcgrant countamiciz, cluster(justice)
