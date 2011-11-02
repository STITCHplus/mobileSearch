clear
ant clean 2>&1 > /dev/null
ant compile && \
ant clean; ant dist  

cp ./dist/mobileSearch-0.1-dev.war /var/lib/tomcat6/webapps/
sleep 10;
ln -s /var/lib/tomcat6/webapps/mobileSearch-0.1-dev /var/lib/tomcat6/webapps/mobileSearch
cp *.xsl /var/lib/tomcat6/webapps/mobileSearch
chown tomcat6 /var/lib/tomcat6/webapps/mobileSearch/*.xsl



