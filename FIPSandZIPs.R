# FIPSandZIPs.R : "Federal Information Processing Standard" (FIPS) and "Zone Improvement Plan" (ZIP)
# Combine function for Zip Code Locations to FIPS areas
          
fipszips <- function( stateAbbrev = stateAbbrev ){
  
          stateAbbrev <- as.character(stateAbbrev)

          library(zipcode); data(zipcode); head(zipcode)
          library(data.table)

                  stateTable <- read.table(textConnection(
                    "stateAbbreviation	fips	state
                    AK	2	ALASKA
                    AL	1	ALABAMA
                    AR	5	ARKANSAS
                    AS	60	AMERIICAN SAMOA
                    AZ	4	ARIZONA
                    CA	6	CALIFORNIA
                    CO	8	COLORADO
                    CT	9	CONNECTICUT
                    DC	11	DISTRICT OF COLUMBIA
                    DE	10	DELAWARE
                    FL	12	FLORIDA
                    GA	13	GEORGIA
                    GU	66	GUAM
                    HI	15	HAWAII
                    IA	19	IOWA
                    ID	16	IDAHO
                    IL	17	ILLINOIS
                    IN	18	INDIANA
                    KS	20	KANSAS
                    KY	21	KENTUCKY
                    LA	22	LOUISIANA
                    MA	25	MASSACHUSETTS
                    MD	24	MARYLAND
                    ME	23	MAINE
                    MI	26	MICHIGAN
                    MN	27	MINNESOTA
                    MO	29	MISSOURI
                    MS	28	MISSISSIPPI
                    MT	30	MONTANA
                    NC	37	NORTH CAROLINA
                    ND	38	NORTH DAKOTA
                    NE	31	NEBRASKA
                    NH	33	NEW HAMPSHIRE
                    NJ	34	NEW JERSEY
                    NM	35	NEW MEXICO
                    NV	32	NEVADA
                    NY	36	NEW YORK
                    OH	39	OHIO
                    OK	40	OKLAHOMA
                    OR	41	OREGON
                    PA	42	PENNSYLVANIA
                    PR	72	PUERTO RICO
                    RI	44	RHODE ISLAND
                    SC	45	SOUTH CAROLINA
                    SD	46	SOUTH DAKOTA
                    TN	47	TENNESSEE
                    TX	48	TEXAS
                    UT	49	UTAH
                    VA	51	VIRGINIA
                    VI	78	VIRGIN ISLANDS
                    VT	50	VERMONT
                    WA	53	WASHINGTON
                    WI	55	WISCONSIN
                    WV	54	WEST VIRGINIA
                    WY	56	WYOMING")
                    , sep = "\t", header=T, stringsAsFactors = T)
                  
                  
                  stateTable <<- data.table(stateTable)
                  stateTable$stateAbbreviation <- as.character(gsub("[[:space:]]", "", stateTable$stateAbbreviation))
                  stateFipCode <- stateTable[ which(stateTable$stateAbbreviation==stateAbbrev), ][,"fips"]
                  stateFipsString <- sprintf("%02.0f", stateFipCode) 

                  
          ## County FIP and names data
          # http://www2.census.gov/geo/docs/reference/codes/files/st06_ca_cou.txt
          countyFips <- data.table(read.table(url(paste0("http://www2.census.gov/geo/docs/reference/codes/files/st",stateFipsString, "_",
                                             tolower(stateAbbrev),"_cou.txt")), quote = "", sep = ",", header = F, stringsAsFactors = F)); closeAllConnections()
              # Clean county data per state
              setnames(countyFips, names(countyFips), c("stateAbbreviation", "stateFips", "countyFips", "county","incorpType"))
              countyFips$county <- gsub(" County", "", countyFips$county)
              
              # Clean stateTable
              stateTableNarrow <<- stateTable[ which(stateTable$stateAbbreviation == stateAbbrev),]
              
              stateTableNarrow <- data.table(stateTableNarrow)
              setkeyv(countyFips, "stateAbbreviation")
              setkeyv(stateTableNarrow, "stateAbbreviation")

              fullTable <- merge(stateTableNarrow, countyFips, all = T, allow.cartesian=T)[,fips:=NULL]
              
              
          ## Community and Municipality FIPS data   /st",stateFipCode, "_",
          # http://www2.census.gov/geo/docs/reference/codes/files/st06_ca_places.txt
          placeFips <- data.table(read.table(url(paste0("http://www2.census.gov/geo/docs/reference/codes/files/st",stateFipsString, "_",
                                    tolower(stateAbbrev),"_places.txt")), quote = "", sep = "|", header = F, stringsAsFactors = T)); closeAllConnections()
          
          setnames(placeFips, names(placeFips), c("stateAbbreviation", "stateFips", "placeFips", "place","censusPlaceType","placeSym","county"))
          placeFips <- placeFips[,stateFips:=NULL]
          
          # gsub remove last word " CDP" | " city" | " town"
          placeFips$place <- gsub(" town","", gsub(" CDP","", gsub(" city","",placeFips$place)))
          # placeFips$place # gsub remove " County"
          placeFips$county <- gsub(" County","",placeFips$county)
          placeFips <-  placeFips[, stateAbbreviation:=NULL]
          
          setkeyv(fullTable,"county")
          setkeyv(placeFips, "county")

          # options( datatable.print.topn = 30)
          fullTable <- merge(fullTable, placeFips, all = T, allow.cartesian = T )
          
        
          ## Munge zipcode data
          zipData <- zipcode[ which(zipcode$state==stateAbbrev), ]
          names(zipData)[which( names(zipData) == "state")] <- "stateAbbreviation"
          names(zipData)[which( names(zipData) == "city")] <- "place"
          zipData <- data.table(zipData)
          zipData <- zipData[,stateAbbreviation:=NULL]
      
          setkeyv( zipData , "place" )
          setkeyv( fullTable, "place" )
          
          fullTable <- merge(fullTable, zipData , all = T , allow.cartesian = T)[,incorpType:=NULL] 
                    
                      # # NOTE: Replaces State Census NAs with matched values per state. Zip codes may cross state boundaries
                      # for(i in 1:length(fullTable$state)){
                      #   if(is.na(fullTable$state)[i]){
                      #     as.character(fullTable$state)[i] <- as.character(stateTableNarrow[,"state"])
                      #   }
                      # }
                      # 
                      # 
                      # for(i in 1:length(fullTable$stateFips)){
                      #   if(is.na(fullTable$stateFips)[i]){
                      #     as.integer(fullTable$stateFips)[i] <- as.integer(stateTableNarrow[,"fips"])
                      #   }
                      # }
                      # 
                      # for(i in 1:length(fullTable$stateAbbreviation)){
                      #   if(is.na(fullTable$stateAbbreviation)[i]){
                      #     fullTable$stateAbbreviation[i] <- as.character(stateTableNarrow[,"stateAbbreviation"])
                      #   }
                      # }
          
              fullTable <<- fullTable
          
              censusPlaceTypes <<- table(placeFips$placeType) 
              censusPlaces <<- length(unique(placeFips$place))
            
              uniqueZipPlaces <<- dim( zipcode[which(zipcode$state=="CA"),] )[1]

              # fullTable[ which(fullTable$county=="Los Angeles"),]
              uniqueCensusPlaces <<- unique(placeFips$place)
              #Stats: Counties in State
              countyCount <<- length(unique(countyFips$county))
              
              
              cat("Census Places in", stateAbbrev, ":", censusPlaces, "\n" )
              cat("Zip Places in", stateAbbrev,":", uniqueZipPlaces , "\n")
              cat("Counties in", stateAbbrev,":", countyCount)
              
              closeAllConnections()


              
}

# fipszips("WA") # Or other state abbreviation
# fullTable


