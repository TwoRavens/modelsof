/***********************************************
 CREATE COUNTRY DUMMIES and country goups
************************************************/

* EUROPE *
gen byte Belgie_geb = (geb_land == 5010)
gen byte Duitsland_geb = (geb_land == 9089 | geb_land == 7085 | ///
                      geb_land == 6029| geb_land == 7073 )
gen byte UK_geb = ( geb_land == 6039|geb_land ==6055| geb_land == 8034| geb_land == 8035)
gen byte Frankrijk_geb = (geb_land == 5002|geb_land == 5032)
gen byte Griek_geb = (geb_land ==6003)
gen byte Por_geb = (geb_land ==7050|geb_land ==5056| geb_land == 7087)
gen byte Spanje_geb = (geb_land ==6037|geb_land ==6053|geb_land ==7005)
gen byte Ital_geb = (geb_land ==7044 |geb_land ==6028)
gen byte Deen_geb=   (geb_land ==5015)
gen byte Fin_geb= (geb_land ==6002)
gen byte Zwed_geb= (geb_land ==5039)
gen byte Lux_geb= (geb_land ==6018)
gen byte Oos_geb= (geb_land ==5009| geb_land == 9071)
gen byte Ier_geb= (geb_land ==6007)

gen byte EU = Belg + Duits + UK + Frank + Griek + Por ///
              + Spanje+ Ital+ Deen+Fin+Zwed+ Lux + Oos + Ier

gen byte Bulg_geb = (geb_land ==7024)
gen byte Rom_geb = (geb_land ==7047)
gen byte Polen_geb = (geb_land ==7028)
gen byte Hong_geb = (geb_land ==5017)
gen byte TsjSlo_geb = (geb_land ==7048|geb_land ==6066|geb_land ==6067)
gen byte Est_geb = (geb_land ==7065)
gen byte Let_geb = (geb_land ==7064)
gen byte Lit_geb = (geb_land ==7066)
gen byte Malt_geb = (geb_land ==7003)
gen byte Cyp_geb = (geb_land ==5040)

gen byte nieuwEU04 = (geb_land == 5017 |geb_land == 5040 |geb_land == 5049 ///
                      | geb_land == 6066 |geb_land == 6067 |geb_land == 7003 /// 
                      | geb_land == 7028 |geb_land == 7048 |geb_land == 7064 /// 
                      | geb_land == 7065 |geb_land == 7066 )
gen byte newEU = nieuwEU04+Bulg_geb + Rom_geb

gen byte Joegoslavie_geb = (geb_land == 6045 |geb_land == 6065 |geb_land == 6068 ///
                       | geb_land == 5051 |geb_land == 5100 )
gen byte formerSU_geb = (geb_land==9049|geb_land==5053|geb_land==5054|geb_land==5097| ///
                geb_land==5098|geb_land==5099|geb_land==6000|geb_land==6021| ///
                geb_land==6038|geb_land==6050|geb_land==6057|geb_land==6063| ///
                geb_land==6064|geb_land==7029)
gen byte Turkije_geb = (geb_land == 6043)

/*** Non-European countries ***/
gen byte Japan_geb = (geb_land == 7035)
gen byte Can_geb = (geb_land ==5001)
gen byte USA_geb = (geb_land ==6014)
gen byte Aus_geb = (geb_land ==6016)
gen byte NZ_geb = (geb_land ==5013)
gen byte Korea_geb = (geb_land == 6036| geb_land==9068)
gen byte EFTA_geb = (geb_land==5003|geb_land==6027|geb_land==6011)

gen byte DC = USA_geb+Can_geb+Aus_geb+NZ_geb+Japan_geb + Korea_geb + EFTA_geb
gen byte LDC = (EU15==0 & newEU==0 & DC==0 & Joegoslavie_geb==0 & formerSU==0)