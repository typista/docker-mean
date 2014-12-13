#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-nodejs
#FROM typista/nginx-nodejs:0.7
RUN wget https://raw.githubusercontent.com/typista/docker-mean/master/files/entrypoint.sh -O /etc/entrypoint.sh && \
	wget https://raw.githubusercontent.com/typista/docker-mean/master/files/mongodb.repo -O /etc/yum.repos.d/mongodb.repo && \
	yum update -y && \
	yum -y install mongodb-org && \
	wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.1.tar.gz -O /root/glibc-2.14.1.tar.gz && \
	cd /root && \
	tar zvxf glibc-2.14.1.tar.gz && \
	cd glibc-2.14.1 && \
	mkdir build && cd $_ && \
	../configure --prefix=/usr/glibc && \
	make && \
	make install && \
	cd /usr/glibc/lib/ && \
	cp libc-2.14.1.so /lib64/ && \
	ln -nfs libc-2.14.1.so libc.so.6 && \
	ldconfig && \
	chmod +x /etc/entrypoint.sh
#EXPOSE 80
#ENTRYPOINT /etc/entrypoint.sh

