FROM docker.io/centos:7

#aliyun yum
RUN rm -rf /etc/yum.repos.d/CentOS-Base.repo
ADD src/docker/CentOS-Base.repo /etc/yum.repos.d/
ADD src/docker/Python-3.7.3.tgz /opt
ADD src/docker/jre-8u121-linux-x64.rpm /opt

#Pyhton3.7&jdk
RUN yum -y install wget gcc make zlib-devel openssl openssl-devel libffi-devel git \
    && cd /opt/Python-3.7.3 \
    && ./configure prefix=/usr/local/python3 --with-ssl \
    && make && make install \
    && ln -fs /usr/local/python3/bin/python3 /usr/bin/python3 \
    && ln -fs /usr/local/python3/bin/pip3 /usr/bin/pip3 \
    && rm -rf /opt/Python-3.7.3 \
    && rm -rf /opt/Python-3.7.3.tgz \
    && rpm -ivh /opt/jre-8u121-linux-x64.rpm \
    && rm -rf /opt/jre-8u121-linux-x64.rpm
#修改中文支持
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum -y install kde-l10n-Chinese \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

#dmshttp
RUN mkdir -p /opt/dmshttp
ADD . /opt/dmshttp
RUN cd /opt/dmshttp \
    && pip3 install -r /opt/dmshttp/requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple/ \
    && sed -i "178s/^/#/" /usr/local/python3/lib/python3.7/site-packages/mybatis_mapper2sql/convert.py \
    && ln -fs /usr/local/python3/bin/supervisord /usr/bin/supervisord \
    && ln -fs /usr/local/python3/bin/supervisorctl /usr/bin/supervisorctl


ENV LANG en_US.UTF-8
ENV LC_ALL zh_CN.utf8

#port
EXPOSE 8868

#start service
ENTRYPOINT ["supervisord", "-c" ,"/opt/dmshttp/supervisord.conf"]
