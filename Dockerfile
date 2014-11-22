#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-nodejs
RUN wget https://raw.githubusercontent.com/typista/docker-mean/master/files/etc_init.d_nginx -O /root/etc_init.d_nginx && \
	wget https://raw.githubusercontent.com/typista/docker-mean/master/files/nginx.conf -O /root/nginx.conf && \
	wget https://raw.githubusercontent.com/typista/docker-mean/master/files/services.sh -O /root/services.sh && \
	wget https://raw.githubusercontent.com/typista/docker-mean/master/files/monitor_node.sh -O /root/monitor_node.sh && \
	wget https://raw.githubusercontent.com/typista/docker-mean/master/files/mongodb.repo -O /etc/yum.repos.d/mongodb.repo && \
	echo "/root/monitor_node.sh" >> /root/start.sh && \
	yum update -y && \
	yum -y install mongodb-org && \
	cp /root/etc_init.d_nginx /etc/init.d/nginx && \
	cp /root/services.sh /etc/services.sh && \
	cp /root/nginx.conf /usr/local/nginx/conf/nginx.conf && \
	chmod +x /etc/init.d/nginx && \
	chmod +x /etc/services.sh && \
	chmod +x /root/monitor_node.sh
EXPOSE 80
ENTRYPOINT /etc/services.sh

