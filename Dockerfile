#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/base
RUN wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/execme1st.sh -O /root/execme1st.sh && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/startXMail.sh -O /root/startXMail.sh && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/crontab.txt -O /root/crontab.txt && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/domainadd.sh -O /root/domainadd.sh && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/useradd.sh -O /root/useradd.sh && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/changepassword.sh -O /root/changepassword.sh && \
	wget https://raw.githubusercontent.com/typista/docker-xmail/master/files/services.sh -O /root/services.sh && \
	chmod +x /etc/services.sh && \
	yum update -y && \
	wget http://www.xmailserver.org/xmail-1.27.tar.gz && \
	tar xvzf xmail-1.27.tar.gz && \
	cd xmail-1.27;make -f Makefile.lnx && \
	cp -r MailRoot /var/ && \
	cp xmail /etc/init.d/ && \
	cp sendmail.sh /var/MailRoot/ && \
	chmod +x /var/MailRoot/sendmail.sh && \
	mv /usr/sbin/sendmail{,.org} && \
	ln -s /var/MailRoot/sendmail.sh /usr/sbin/sendmail && \
	ls bin/ | grep -v ".o" | xargs -I{} cp bin/{} /var/MailRoot/bin/ && \
	chmod 700 /var/MailRoot/

VOLUME /root/export
ENTRYPOINT /etc/services.sh

