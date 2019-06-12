use "dataset for dataverse vers.13.dta" 


** Figure 7 **

histogram yearslegsent if legislature !=8 & legislature !=17, bin(88) start (0) percent

histogram yearslegsent if legislature !=8 & legislature !=17, bin(88) start (0) percent by(rep)

histogram yearslegsent if legislature !=8 & legislature !=17 & major_topic==1, bin(88) start (0) percent 

histogram yearslegsent if legislature !=8 & legislature !=17 & major_topic==5, bin(88) start (0) percent

histogram yearslegsent if legislature !=8 & legislature !=17 & major_topic==12, bin(88) start (0) percent 

histogram yearslegsent if legislature !=8 & legislature !=17 & major_topic==16, bin(88) start (0) percent

histogram yearslegsent if legislature !=8 & legislature !=17 & major_topic==20, bin(88) start (0) percent


** Median ** 

summarize yearslegsent if legislature !=8 & legislature !=17, detail
summarize yearslegsent if legislature !=8 & legislature !=17 & rep==1, detail
summarize yearslegsent if legislature !=8 & legislature !=17 & rep==2, detail

summarize yearslegsent if major_topic==1 & legislature !=8 & legislature !=17, detail
summarize yearslegsent if major_topic==5 & legislature !=8 & legislature !=17, detail
summarize yearslegsent if major_topic==12 & legislature !=8 & legislature !=17, detail
summarize yearslegsent if major_topic==16 & legislature !=8 & legislature !=17, detail
summarize yearslegsent if major_topic==20 & legislature !=8 & legislature !=17, detail


** Table 3 Predictors of decisions saliency


fracreg logit  saliency c.alternation midrange president_origin i.grouped_policies if legislature !=8 & legislature !=17, vce(cluster yearnum)

fracreg logit  saliency i.republic midrange president_origin i.grouped_policies if legislature !=8 & legislature !=17, vce(cluster yearnum)

fracreg logit  saliency c.alternation i.republic midrange president_origin i.grouped_policies if legislature !=8 & legislature !=17, vce(cluster yearnum)



