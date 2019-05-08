FROM docker.io/centos:7

#aliyun yum
RUN rm -rf /etc/yum.repos.d/CentOS-Base.repo
ADD CentOS-Base.repo /etc/yum.repos.d/
ADD Python-3.7.3.tgz /opt

#Pyhton3.7
RUN yum -y install wget gcc make zlib-devel openssl openssl-devel libffi-devel git \
    && cd /opt/Python-3.7.3 \
    && ./configure prefix=/usr/local/python3 --with-ssl \
    && make && make install \
    && ln -fs /usr/local/python3/bin/python3 /usr/bin/python3 \
    && ln -fs /usr/local/python3/bin/pip3 /usr/bin/pip3 \
    && rm -rf /opt/Python-3.7.3 \
    && rm -rf /opt/Python-3.7.3.tgz \

#修改中文支持
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum -y install kde-l10n-Chinese \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
    
ENV LANG en_US.UTF-8
ENV LC_ALL zh_CN.utf8

