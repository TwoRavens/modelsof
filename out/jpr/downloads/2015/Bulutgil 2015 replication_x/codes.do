* "Social cleavages, wartime experience,and ethnic cleansing in Europe," by H. Zeynep Bulutgil, Journal of Peace Research, September 2015. 


* Models in the Article

* Model1:

logit ec logdemogbalance langfam religion ethnicaffwneighbor literacy competition promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust

* Model 2:

logit ec logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust


* Model 3:

logit ec logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if postcomm==0, robust


* Model 4:

logit ec logdemogbalance langfam religion ethnicaffwneighbor literacy familyfarms promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust


* Model 5:
logit ec logdemogbalance langfam religion ethnicaffwneighbor literacy familyfarms promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if communist==0, robust

* Models in the online appendix

* Model 6:
logit ec10 logdemogbalance langfam religion ethnicaffwneighbor literacy competition promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust


* Model 7:
logit ec10 logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if postcomm==0, robust

* Model 8:

logit ec10 logdemogbalance langfam religion ethnicaffwneighbor literacy familyfarms promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust

* Model 9:

logit ec40 logdemogbalance langfam religion ethnicaffwneighbor literacy competition promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, robust

* Model 10:
logit ec40 logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if postcomm==0, robust

* Model 11:
clogit ec logdemogbalance langfam religion ethnicaffwneighbor literacy competition promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, group (countrycode)

* Model 12:
clogit ec logdemogbalance langfam religion ethnicaffwneighbor literacy competition promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100, group (year)

* Model 13:
clogit ec logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if postcomm==0, group (countrycode)

* Model 14:
clogit ec logdemogbalance langfam religion ethnicaffwneighbor literacy leftwingvote promotedgroup defendgroup fifthcolumn spillover percapincimpdiv1000 populationdiv1000 year1to100 if postcomm==0, group (year)
