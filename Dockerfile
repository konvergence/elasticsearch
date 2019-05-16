FROM elasticsearch:5.4.3

# Image Label
LABEL maintainer="kshuttle.io" \
      website="https://kshuttle.io" \
      description="elasticsearch 5.4 with ReadonlyREST plugin" \
      release="5.4.3" 
	  


#install envsubst from gettext-base package then clear cache
RUN apt-get update \
    && apt-get install -y gettext-base \
    && echo "#### clean " \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

	
	
#set working directory to elaticsearch home
WORKDIR /usr/share/elasticsearch/ 
#copy conf and plugings files 
COPY /assets/ assets/ 

# Env variables 
ENV SSL_ENABLE=true \
	ES_PORT=9243 \
	KEYSTORE_FILE_PATH=config/keystore.jks \
	KEYSTORE_PASSWORD=changeit \
	KEY_PASSWORD=changeit \
	CLUSTER_ADMIN=es_admin \
	ADMIN_PASS=passwadmin \
	RO_USER=es_ro \
	RO_PASS=password \
	GRAFANA_USER=grafana \
	GRAFANA_PASS=grafana \
	LOGSTASH_USER=logstash \
	LOGSTASH_PASS=logstash
# install readonlyrest plugin . see https://readonlyrest.com
RUN bin/elasticsearch-plugin install file:///usr/share/elasticsearch/assets/plugins/readonlyrest-1.16.18_es5.4.3.zip # NOTICE : can't use WORKDIR as variable in path like file:///WORKDIR/assets..
	
COPY /bin/entrypoint.sh bin/entrypoint.sh
ENTRYPOINT ["bin/entrypoint.sh"]