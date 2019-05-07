FROM docker.io/centos:7

#aliyun yum
RUN rm -rf /etc/yum.repos.d/CentOS-Base.repo
ADD src/docker/CentOS-Base.repo /etc/yum.repos.d/

#修改中文支持
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum -y install kde-l10n-Chinese \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
    
ENV LANG en_US.UTF-8
ENV LC_ALL zh_CN.utf8

