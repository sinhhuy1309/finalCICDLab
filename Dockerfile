FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps