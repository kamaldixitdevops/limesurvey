
FROM tutum/lamp

RUN apt-get update ; \
	apt-get upgrade -q -y ;\
	apt-get install -q -y curl php5-gd php5-ldap php5-imap; apt-get clean ; \
	php5enmod imap

RUN rm -rf /app; \
	mkdir -p /app; \
	mkdir -p /uploadstruct; \
	curl -L -o /app/limesurvey.tar.bz2 https://www.limesurvey.org/stable-release?download=1453:limesurvey250plus-build160204tarbz2 ; \
	tar --strip-components=1 -C /app -xvjf /app/limesurvey.tar.bz2 ; \
	rm  /app/limesurvey.tar.bz2 ; \
	chown -R www-data:www-data /app

RUN cp -r /app/upload/* /uploadstruct ; \
	chown -R www-data:www-data /uploadstruct

RUN chown www-data:www-data /var/lib/php5

ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD start.sh /

RUN chmod +x /start.sh

VOLUME /app/upload

EXPOSE 80 3306
CMD ["/start.sh"]

