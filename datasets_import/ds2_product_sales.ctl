load data 
CHARACTERSET UTF8
infile 'ds2_product_sales.csv' "str '\r\n'"
append
into table ds2_product_sales
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( Name CHAR(4000),
             Team CHAR(4000),
             Type CHAR(4000),
             Type_Description CHAR(4000),
             Cost "translate(:Cost, '.', ',' ) " ,
             Activity CHAR(4000),
             Activity_description CHAR(4000),
             Dimensions CHAR(4000),
             Official CHAR(4000),
             Stock "translate(:Stock, '.', ',' ) " ,
             Special_feature CHAR(4000),
             Usage CHAR(4000),
             Features CHAR(4000),
             Season CHAR(4000),
             Property CHAR(4000),
             Material CHAR(4000),
             Closure CHAR(4000),
             Shop CHAR(4000),
             Shop_description CHAR(4000),
             CreditCard_provider CHAR(4000),
             Discount CHAR(4000),
             City CHAR(4000),
			 Units ,
             CreditCard_num CHAR(4000),
			 CreditCard_expiry CHAR(4000),
             Total_cost "translate(:Total_cost, '.', ',' ) ",
			 PurchaseDate CHAR(4000)
           )
