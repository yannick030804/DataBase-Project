----------------------------
drop table ds1_players;
drop table ds1_match;
drop table ds2_product_sales;
drop table ds2_shop_keepers;
drop table ds3_radios;
drop table ds3_tvs;
drop table ds3_posts;
drop table ds4_ads;
drop table ds4_placement;

----------------------------
CREATE TABLE ds1_players ( name VARCHAR2(26),
Height NUMBER(38),
Weight NUMBER(38),
Footed VARCHAR2(26),
BirthDate DATE,
City VARCHAR2(128),
club VARCHAR2(26),
match_id VARCHAR2(26),
position VARCHAR2(26),
goals NUMBER(38),
assists NUMBER(38),
shots NUMBER(38),
shots_on_target NUMBER(38),
yellow_cards NUMBER(38),
red_cards NUMBER(38));

CREATE TABLE ds1_match ( match_id VARCHAR2(26),
match_date DATE,
home VARCHAR2(26),
away VARCHAR2(26),
home_poss NUMBER(38),
away_poss NUMBER(38),
home_manager VARCHAR2(26),
home_gender VARCHAR2(26),
home_date DATE,
home_manager_city VARCHAR2(128),
home_style VARCHAR2(26),
home_tactics VARCHAR2(26),
away_manager VARCHAR2(26),
away_gender VARCHAR2(26),
away_date DATE,
away_manager_city VARCHAR2(128),
away_style VARCHAR2(26),
away_tactics VARCHAR2(26),
venue VARCHAR2(128),
attendance NUMBER(38),
city VARCHAR2(128),
referee VARCHAR2(128),
ar1 VARCHAR2(128),
ar2 VARCHAR2(128),
fourth VARCHAR2(128),
var VARCHAR2(128),
league VARCHAR2(26),
gender VARCHAR2(26),
season VARCHAR2(26),
referee_cert VARCHAR2(128),
ar1_cert VARCHAR2(128),
ar2_cert VARCHAR2(128),
fourth_cert VARCHAR2(128),
var_cert VARCHAR2(128),
home_city VARCHAR2(128),
away_city VARCHAR2(128)
);

----------------------------

CREATE TABLE ds2_product_sales ( Name VARCHAR2(256),
Team VARCHAR2(26),
Type VARCHAR2(26),
Type_Description VARCHAR2(128),
Cost NUMBER(38,2),
Activity VARCHAR2(128),
Activity_description VARCHAR2(128),
Dimensions VARCHAR2(26),
Official VARCHAR2(26),
Stock NUMBER(38),
Special_feature VARCHAR2(26),
Usage VARCHAR2(26),
Features VARCHAR2(128),
Season VARCHAR2(26),
Property VARCHAR2(26),
Material VARCHAR2(26),
Closure VARCHAR2(26),
Shop VARCHAR2(128),
Shop_description VARCHAR2(256),
CreditCard_provider VARCHAR2(128),
Discount VARCHAR2(126),
City VARCHAR2(128),
Units NUMBER(38),
CreditCard_num VARCHAR2(26),
CreditCard_expiry VARCHAR2(26),
Total_cost NUMBER(38,2),
PurchaseDate VARCHAR2(26));

CREATE TABLE ds2_shop_keepers ( FirstName VARCHAR2(26),
LastName VARCHAR2(26),
birthdate DATE,
Gender VARCHAR2(26),
vacation_days NUMBER(38),
Shop VARCHAR2(128),
role VARCHAR2(128),
shift VARCHAR2(26));


----------------------------

CREATE TABLE ds3_radios ( name_of_media_group VARCHAR2(26),
description_of_media_group VARCHAR2(128),
headquarters_of_the_media_group VARCHAR2(26),
name_of_the_radio_station VARCHAR2(26),
description_of_the_radio_station VARCHAR2(128),
frequency_of_the_radio_station VARCHAR2(26),
programme VARCHAR2(128),
description VARCHAR2(128),
programme_lssl VARCHAR2(128),
schedule VARCHAR2(26),
podcast NUMBER(38),
FirstName VARCHAR2(26),
LastName VARCHAR2(26),
Birthdate DATE,
Gender VARCHAR2(26),
Role VARCHAR2(26),
Specialization VARCHAR2(128),
Username_lssl VARCHAR2(26));

CREATE TABLE ds3_tvs ( name_of_media_group VARCHAR2(26),
description_of_media_group VARCHAR2(128),
headquarters_of_the_media_group VARCHAR2(26),
title_of_the_tv_channel VARCHAR2(26),
video_quality_of_the_tv_channel VARCHAR2(26),
programme VARCHAR2(128),
description VARCHAR2(128),
programme_lssl VARCHAR2(128),
schedule VARCHAR2(26),
production_company VARCHAR2(128),
FirstName VARCHAR2(26),
LastName VARCHAR2(26),
Birthdate DATE,
Gender VARCHAR2(26),
Role VARCHAR2(26),
Specialization VARCHAR2(128),
Username_lssl VARCHAR2(26));


CREATE TABLE ds3_posts ( post_id NUMBER(38),
post VARCHAR2(1024),
post_date DATE,
likes NUMBER(38),
reposts NUMBER(38),
reply_to NUMBER(38),
hashtag VARCHAR2(26),
hashtag_desc VARCHAR2(128),
trending_status VARCHAR2(26),
image VARCHAR2(128),
path VARCHAR2(128),
mime VARCHAR2(26),
nickname VARCHAR2(128),
creation_date DATE,
verified NUMBER(38),
localization VARCHAR2(128));
----------------------------


CREATE TABLE ds4_ads ( num NUMBER(38),
title VARCHAR2(128),
description VARCHAR2(256),
format VARCHAR2(26),
status VARCHAR2(26),
AdDate DATE,
category VARCHAR2(128),
category1 VARCHAR2(26),
category1_desc VARCHAR2(256),
category2 VARCHAR2(26),
category2_desc VARCHAR2(256),
category3 VARCHAR2(26),
category3_desc VARCHAR2(128),
Code VARCHAR2(126),
Campaign VARCHAR2(26),
Objective VARCHAR2(128),
Budget NUMBER(38),
Product VARCHAR2(128),
Start_Date DATE,
End_Date DATE,
Audience_Interest VARCHAR2(128),
Audience_Segment VARCHAR2(26),
Client VARCHAR2(128),
Client_Budget NUMBER(38),
City VARCHAR2(128));

CREATE TABLE ds4_placement ( id NUMBER(38),
cost NUMBER(38),
exclusives NUMBER(38),
PlacementDate DATE,
placement_type VARCHAR2(128),
type_description VARCHAR2(128),
ads NUMBER(38),
building VARCHAR2(128),
programme VARCHAR2(128),
post INTEGER);

----------------------------
select count(*) from ds1_players;
select count(*) from ds1_match;
select count(*) from ds2_product_sales;
select count(*) from ds2_shop_keepers;
select count(*) from ds3_radios;
select count(*) from ds3_tvs;
select count(*) from ds3_posts;
select count(*) from ds4_ads;
select count(*) from ds4_placement;
