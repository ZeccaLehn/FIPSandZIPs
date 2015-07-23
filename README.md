# FIPSandZIPs : Function for FIPS and Zip Codes to Zip Code lat/long

The fipszips() function is used to aggregate best available Federal Information 
Processing Standard (FIPS) and Zone Improvement Plan(ZIP) codes, matched by 
State, County, Census Place, and zipcode boundaries. Latitude and Longitude 
is included for all zipcodes. Use at your own risk.

### Objects created in function:

`> fipszips("CA")` #Example with California

#### Census Places in CA : 1506 
#### Zip Places in CA : 2753 
#### Counties in CA : 58


`> fullTable` # Full Table by State


 ```
                place         county stateAbbreviation      state stateFips countyFips placeFips         censusPlaceType placeSym
   1: Acalanes Ridge   Contra Costa                CA CALIFORNIA         6         13       135 Census Designated Place        S
    2:         Acampo    San Joaquin                CA CALIFORNIA          6         77      156  Census Designated Place       S
    3:          Acton    Los Angeles                CA CALIFORNIA         6         37       212 Census Designated Place        S
    4:       Adelanto San Bernardino                CA CALIFORNIA         6         71       296      Incorporated Place        A
    5:       Adelanto San Bernardino                CA CALIFORNIA         6         71       296      Incorporated Place        A
   ---                                                                                                                           
 3351:   Yucca Valley San Bernardino                CA CALIFORNIA         6         71     87056      Incorporated Place        A
 3352:   Yucca Valley San Bernardino                CA CALIFORNIA         6         71     87056      Incorporated Place        A
 3353:         Zamora             NA                NA         NA        NA         NA        NA                      NA       NA
 3354:        Zayante     Santa Cruz                CA CALIFORNIA         6         87     87090 Census Designated Place        S
 3355:          Zenia             NA                NA         NA        NA         NA        NA                      NA       NA
         zip latitude longitude
    1:    NA       NA        NA
    2: 95220 38.20019 -121.2351
    3: 93510 34.49724 -118.1895
    4: 92031 34.58747 -117.4063
    5: 92301 34.64169 -117.5080```



Note: Where some state abbreviations, state names, and county names do not match, 
an NA may signify a zip code boundary which overlaps two distinct 
