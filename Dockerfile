#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-nodejs
RUN yum update -y

ADD files/mongodb.repo /etc/yum.repos.d/mongodb.repo

# install mongodb
RUN yum -y install mongodb-org
# http://blog.simtter.com/yeomanを使ってmeanmongodbexpressangularjsnode-jsを作成しよう/
#RUN npm install -g yo grunt-cli bower
#RUN npm update -g
#RUN npm update -g yo
#RUN npm install -g generator-angular-fullstack
#RUN npm install -g node-inspector
#RUN npm install -g express && npm link express
#RUN npm install -g body-parser && npm link body-parser
#RUN npm install -g mongodb && npm link mongodb

ADD files/etc_init.d_nginx /etc/init.d/nginx
ADD files/nginx.conf /usr/local/nginx/conf/
ADD files/html/app.js /tmp/
ADD files/html/front/index.html /tmp/
ADD files/html/front/list.html /tmp/
ADD files/html/front/edit.html /tmp/
ADD files/html/dist/js/angular/angular.js /tmp/
ADD files/html/dist/js/angular/angular.min.js /tmp/
ADD files/html/dist/js/angular/angular-resource.js /tmp/
ADD files/html/dist/js/angular/angular-resource.min.js /tmp/
ADD files/html/dist/js/angular/angular-route.js /tmp/
ADD files/html/dist/js/angular/angular-route.min.js /tmp/
ADD files/services.sh /etc/services.sh
RUN chmod +x /etc/services.sh
RUN chmod +x /etc/init.d/nginx
EXPOSE 80
ENTRYPOINT /etc/services.sh

