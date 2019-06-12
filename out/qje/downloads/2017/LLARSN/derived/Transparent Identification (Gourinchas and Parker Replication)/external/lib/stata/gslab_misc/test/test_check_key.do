 /**********************************************************
 *
 *  TEST_CHECK_KEY.DO
 * 
 **********************************************************/ 

 quietly {
    version 11
    set more off
    adopath + ../ado
    preliminaries

    program main
        tempfile valid_2key valid_1keynumeric valid_1keyalpha
        
        quietly { 
            setup_data
            save `valid_2key', replace
            drop if _n==3
            replace alpha="B" if _n==2 
            preserve
            keep numeric
            sort numeric
            save `valid_1keynumeric', replace
            restore
            keep alpha
            sort alpha
            save `valid_1keyalpha', replace
        }
        
        * 1 Key Var
        foreach var in alpha numeric{
            use `valid_1key`var'', clear
            testgood check_key, key(`var')
            testgood check_key, key(`var') sort
            clear
            testgood check_key using `valid_1key`var'', key(`var')
            clear
            testgood check_key using `valid_1key`var'', key(`var') sort
        }

        * 2 Key Vars
        use `valid_2key', clear
        testgood check_key, key(numeric alpha)
        testgood check_key, key(numeric alpha) sort
        clear
        testgood check_key using `valid_2key' , key(numeric alpha)
        clear
        testgood check_key using `valid_2key', key(numeric alpha) sort

        * Check for Missing Error
        use `valid_1keyalpha', clear
        qui replace alpha="" if _n==1
        testbad	check_key, key(alpha) 
        
        use `valid_1keynumeric', clear
        qui replace numeric=. if _n==1
        testbad	check_key, key(numeric)
            
        * Check for Sort Error	
        use `valid_1keyalpha', clear
        gsort -alpha
        testgood check_key, key(alpha) /* No error if option is not specified*/
        testbad check_key, key(alpha) sort /* Error if option is specified*/
        
        use `valid_1keynumeric', clear
        gsort -numeric
        testgood check_key, key(numeric) /* No error if option is not specified*/
        testbad check_key, key(numeric) sort /* Error if option is specified*/
            
        * Check for Invalid Key Error	
        use `valid_2key', clear
        testbad check_key, key(alpha) 
        testbad check_key, key(numeric)
        
        * Help file exists
        testgood type ../ado/check_key.hlp
            
    end
    
    program setup_data
        set obs 3
        generate numeric = 1 in 1
        replace numeric = 2 in 2
        replace numeric = 2 in 3
        generate str alpha = "A" in 1
        replace alpha = "A" in 2
        replace alpha = "B" in 3
        sort numeric alpha
    end
}

* EXECUTE
main



 



	

