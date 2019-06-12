** Table 1 **
sum transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse ajmajproducer if year==2007

** Table 2: Main Analysis **
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2007 
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2006
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2003
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2002

** Table 4: Exclusing the Geographically-doomed **
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2007 & ajmajproducer==0
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2006 & ajmajproducer==0
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2003 & ajmajproducer==0
logit transit lngdppc lngdp lnarea lnareasq GlobalizationIndex p_polity2 fe_etfra wbgi_cce wbgi_rle wbgi_gee wbgi_pse if year==2002 & ajmajproducer==0
