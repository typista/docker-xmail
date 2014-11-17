#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/base
RUN yum update -y
RUN wget http://www.xmailserver.org/xmail-1.27.tar.gz && \
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

ADD files/execme1st.sh /root/
ADD files/startXMail.sh /root/
ADD files/crontab.txt /root/
ADD files/domainadd.sh /root/
ADD files/useradd.sh /root/
ADD files/changepassword.sh /root/
ADD files/services.sh /etc/services.sh
RUN chmod +x /etc/services.sh
VOLUME /root/export
ENTRYPOINT /etc/services.sh

