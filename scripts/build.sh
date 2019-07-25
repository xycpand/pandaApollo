#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://192.168.80.236:3309/ZHUZHU_ApolloConfigDB?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=DEFANG#ABOLLO#2019


# apollo portal db info
apollo_portal_db_url=jdbc:mysql://192.168.80.238:3308/New_ApolloPortalDB?characterEncoding=utf8
apollo_portal_db_username=root
apollo_portal_db_password=DEFANG#ABOLLO#2019

# meta server url, different environments should have different meta server addresses
dev_meta=http://192.168.80.235:8081
fat_meta=http://192.168.80.236:8081
pro_meta=http://192.168.80.237:8081,http://192.168.80.238:8081
uat_meta=http://192.168.80.235:8082,http://192.168.80.236:8082
sit_meta=http://192.168.80.236:8083,http://192.168.80.237:8083
cz_meta=http://192.168.80.237:8084,http://192.168.80.238:8084
zhuzhu_meta=http://192.168.80.237:8085

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta -Dzhuzhu_meta=$zhuzhu_meta -Dsit_meta=$sit_meta  -Dcz_meta=$cz_meta"


# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}"

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="