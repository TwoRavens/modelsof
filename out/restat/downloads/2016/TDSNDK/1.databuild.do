*name of msa; data delivered by msa
local j = "denver"
insheet using /altos/`j'-2014-05-01.csv,clear

*get listing data variable names consistent with DQ for merge
rename street_number sa_site_house_nbr
rename street_name sa_site_street_name
rename zip sa_site_zip
rename data_capture_date date
rename property_id mlsproperty_id

*timeid
sort date 
egen timeid=group(date)


*get date in listing data
gen yearl=substr(date,1,4)
gen monthl=substr(date,6,2)
gen dayl=substr(date,9,2)
destring yearl,replace
destring monthl,replace
destring dayl,replace
gen numdatel=mdy(monthl,dayl,yearl)


*clean address variable
gen temp=strpos(sa_site_street_name," UNIT")
replace unit_number=substr(sa_site_street_name,temp,.) if unit_number==""
replace unit_number=subinstr(unit_number,"UNIT","",.) 
replace unit_number=subinstr(unit_number,":","",.) 
replace unit_number=subinstr(unit_number," ","",.) 
replace sa_site_street_name=substr(sa_site_street_name,1,temp-1) if temp>0
gen unitnumber=unit_number
drop temp
gen temp2=length(sa_site_street_name)
replace sa_site_street_name=lower(sa_site_street_name)
gen t1=0
gen t2=substr(sa_site_street_name,-3,.)
replace t1=1 if t2=="aav"
replace t1=1 if t2=="bav"
replace t1=1 if t2=="cav"
replace t1=1 if t2=="dav"
replace t1=1 if t2=="eav"
replace t1=1 if t2=="fav"
replace t1=1 if t2=="gav"
replace t1=1 if t2=="hav"
replace t1=1 if t2=="iav"
replace t1=1 if t2=="jav"
replace t1=1 if t2=="kav"
replace t1=1 if t2=="lav"
replace t1=1 if t2=="mav"
replace t1=1 if t2=="nav"
replace t1=1 if t2=="oav"
replace t1=1 if t2=="pav"
replace t1=1 if t2=="qav"
replace t1=1 if t2=="rav"
replace t1=1 if t2=="sav"
replace t1=1 if t2=="tav"
replace t1=1 if t2=="uav"
replace t1=1 if t2=="vav"
replace t1=1 if t2=="wav"
replace t1=1 if t2=="xav"
replace t1=1 if t2=="yav"
replace t1=1 if t2=="zav"

drop temp*
gen temp=word(sa_site_street_name,-1)
replace sa_site_street_name=subinstr(sa_site_street_name," av"," ave",.) if temp=="av"
replace sa_site_street_name=subinstr(sa_site_street_name," bl"," blvd",.) if temp=="bl"
replace sa_site_street_name=subinstr(sa_site_street_name," ci"," cir",.) if temp=="ci"
replace sa_site_street_name=subinstr(sa_site_street_name," plaza"," plz",.) if temp=="plaza"
replace sa_site_street_name=subinstr(sa_site_street_name," te"," terrace",.) if temp=="te"
replace sa_site_street_name=subinstr(sa_site_street_name," ter"," terrace",.) if temp=="ter"
replace sa_site_street_name=subinstr(sa_site_street_name," hw"," hwy",.) if temp=="hw"
replace sa_site_street_name=subinstr(sa_site_street_name," cove"," cv",.) if temp=="cove"
replace sa_site_street_name=subinstr(sa_site_street_name," glen"," gln",.) if temp=="glen"
replace sa_site_street_name=subinstr(sa_site_street_name," creek"," crk",.) if temp=="creek"
replace sa_site_street_name=subinstr(sa_site_street_name," point"," pt",.) if temp=="point"
replace sa_site_street_name=subinstr(sa_site_street_name," valley"," vly",.) if temp=="valley"
replace sa_site_street_name=subinstr(sa_site_street_name," trail"," trl",.) if temp=="trail"
replace sa_site_street_name=subinstr(sa_site_street_name," vista"," vis",.) if temp=="vista"
replace sa_site_street_name=subinstr(sa_site_street_name," canyon"," cyn",.) if temp=="canyon"
replace sa_site_street_name=subinstr(sa_site_street_name," grove"," grv",.) if temp=="grove"
replace sa_site_street_name=subinstr(sa_site_street_name," ridge"," rdg",.) if temp=="ridge"
replace sa_site_street_name=subinstr(sa_site_street_name," hill"," hl",.) if temp=="hill"
drop temp*
replace sa_site_street_name=subinstr(sa_site_street_name,"wy","way",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"road","rd",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"street","st",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"place","pl",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"drive","dr",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"drdr","dr",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"lane","ln",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"terrace","terr",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"court","ct",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"circle","cir",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"boulevard","blvd",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"highway","hwy",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"parkway","pkwy",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"cm","cmn",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"lp","loop",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"aav","aave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"bav","bave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"cav","cave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"dav","dave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"eav","eave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"fav","fave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"gav","gave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"hav","have",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"iav","iave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"jav","jave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"kav","kave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"lav","lave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"mav","mave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"nav","nave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"oav","oave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"pav","pave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"qav","qave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"rav","rave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"sav","save",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"tav","tave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"uav","uave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"vav","vave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"wav","wave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"xav","xave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"yav","yave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,"zav","zave",.) if t1==1
replace sa_site_street_name=subinstr(sa_site_street_name,".","",.)
replace sa_site_street_name=subinstr(sa_site_street_name," ","",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"aveave","ave",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"drdr","dr",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"rdrd","rd",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"plpl","pl",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"lnln","ln",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"terrterr","terr",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"circir","cir",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"stst","st",.)
replace sa_site_street_name=subinstr(sa_site_street_name,"ctct","ct",.)
drop t1 t2



**create a unique propertyid

egen longid=group(longitude)
egen latid=group(latitude)
gen threestreet=substr(sa_site_street_name,1,3)
tostring longid latid sa_site_zip,replace
gen houseid=sa_site_house_nbr+"X"+ longid +"Y"+latid+"Z" +sa_site_zip
**need to have the same house number and the same altos property id
gen mlsid_ext=mlsproperty_id+"!"+sa_site_house_nbr
*take care of missing house numbers
sort mlsproperty_id -sa_site_house_nbr
by mlsproperty_id: replace mlsid_ext=mlsid_ext[1] if sa_site_house_nbr==""
drop mlsproperty_id
rename mlsid_ext mlsproperty_id 
*mode function will not consider missing values
replace houseid="" if latitude==. | longitude==. | sa_site_house_nbr=="" | strpos(houseid,".")==1
by mlsproperty_id,sort: egen temp=mode(houseid),minmode
replace houseid=temp
replace houseid=mlsproperty_id if houseid==""
drop temp mlsproperty_id
rename houseid mlsproperty_id
gen lowaddress=lower(sa_site_house_nbr+"X"+sa_site_street_name+"X"+sa_site_zip+"X"+unitnumber)


*standardize addresses within mlspropertyid; use the shortest string
gen t1=length(lowaddress)
replace t1=0 if t1<=8
replace t1=0 if sa_site_house_nbr=="" | sa_site_street_name=="" | sa_site_zip==""
gsort mlsproperty_id -t1
by mlsproperty: gen t2=lowaddress[1]
replace lowaddress=t2
drop t2


**replace missing street names and house numbers if possible
gsort lowaddress -sa_site_street_name - sa_site_house_nbr
replace sa_site_street_name=sa_site_street_name[_n-1] if lowaddress==lowaddress[_n-1] & sa_site_street_name==""
replace sa_site_house_nbr=sa_site_house_nbr[_n-1] if lowaddress==lowaddress[_n-1] & sa_site_house_nbr==""
drop t1


*drop where house is listed at 2 different prices on the same day, and one of prices is less than 50000--hardly drops any
sort date lowaddress price 
drop if date==date[_n-1] & lowaddress==lowaddress[_n-1] & city==city[_n-1] & price<50000


*2 list price on same day -- take the mean
*also need to drop one of the observations
by date lowaddress: egen temp1=mean(price)
count if price!=temp1
gen temp2=price/temp1
sum temp2 if price!=temp1,d
gen temp3=(temp2<=.8 | temp2>=1.2)
by lowaddress,sort: egen temp4=sum(temp3)
drop if temp4>=1
replace price=temp1
sort lowaddress date
by lowaddress date: gen temp5=_n
keep if temp5==1
drop temp*


*drop duplicate listings 
merge m:1 numdatel using baddatetemp`j'
forvalues q= 1/10{
sort lowaddress timeid
drop if timeid!=timeid[_n-1]+1 & lowaddress==lowaddress[_n-1] & _merge==3
}



drop geocode_accuracy  street_direction street_type unit_number yearl monthl dayl state street_address_raw

**identify homes that are delisted and then relisted 
sort lowaddress timeid
gen temp=1 if lowaddress==lowaddress[_n-1] & timeid-timeid[_n-1]>1
by lowaddress: egen appear=sum(temp)
gen temptid=string(timeid)
sort lowaddress numdatel
by lowaddress: gen temp3=_n
replace temp3=. if temp!=1
by lowaddress: gen temp5=_n
*create a uniqueid for listing episodes, the first appearance will have nothing on end
gen lowaddress2=lowaddress
gen var1="0"
forvalues q=1/30{
replace var1="`q'"
by lowaddress: egen temp4=min(temp3)
replace lowaddress2=lowaddress+"ZZZ"+var1 if temp5>=temp4 & appear>=1
replace temp3=. if temp3==temp4
drop temp4
}


drop temp


**compute some variables of interest
sort lowaddress2 numdatel
by lowaddress2: gen ratio=price/price[1]
by lowaddress2: gen TOM=numdatel-numdatel[1]

sort lowaddress2 numdatel
gen temp=price
replace temp=. if price==price[_n-1] & lowaddress2==lowaddress2[_n-1]
by lowaddress2: egen lpchng=count(temp)

sort lowaddress2 timeid
gen finallist=0
replace finallist=1 if timeid!=timeid[_n+1] -1
drop if temp==. & finallist==0
gen lptime=numdatel-numdatel[_n-1] if lowaddress2==lowaddress2[_n-1]
drop temp


sort lowaddress numdatel
gen length_new=timeid[_n+1]-timeid if lowaddress==lowaddress[_n+1]  

drop  _merge
keep if finallist==1

save temp11a_`j'_update_r2,replace


