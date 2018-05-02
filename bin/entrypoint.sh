#!/bin/sh 
if  [ $SSL_ENABLE = "true" ] # if ssl is enabled
then											
	if  [ ! -f "$KEYSTORE_FILE_PATH" ] # if keystore file !exist then create one 
	then	
		envsubst < assets/conf/elasticsearch_ssl.yml.dist > config/elasticsearch.yml #copy elasticsearch.yml with ssl config and subtitute env variables
		envsubst < assets/conf/readonly_ssl.yml.dist > config/readonlyrest.yml #copy readonlyrest.yml with ssl config subtitute env variables
		#generate a self signed keystore
		keytool -genkey -keyalg RSA -alias selfsigned -keypass $KEY_PASSWORD -keystore $KEYSTORE_FILE_PATH -storepass $KEYSTORE_PASSWORD -validity 360 -keysize 2048  -dname 'CN=www.kshuttle.io, OU=Architecture SI, O=Konvergence,C=France'
	fi

elif [ $SSL_ENABLE = "false" ]
then
	envsubst < assets/conf/elasticsearch.yml.dist > config/elasticsearch.yml #copy elasticsearch.yml config and subtitute env variables
	envsubst < assets/conf/readonly.yml.dist > config/readonlyrest.yml #copy readonlyrest.yml with only basic auth config and subtitute env variables
fi


gosu elasticsearch bin/elasticsearch #start elasticsearch with user "elasticsearch" !!! never run it with root