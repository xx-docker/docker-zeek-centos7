FROM centos:centos7.6.1810 as build

USER root

# TODO Set the time and lang
ENV LANG en_US.UTF-8
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo && \
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
RUN yum makecache
RUN yum -y install wget cmake3
WORKDIR /root

RUN yum install cmake make gcc gcc-c++ flex bison libpcap-devel \
  openssl-devel python-devel swig zlib-devel -y
RUN yum install centos-release-scl -y && \
  yum install devtoolset-7 -y && \
  scl enable devtoolset-7 bash
RUN wget -c -N https://code.aliyun.com/rapidinstant/ids-tools/raw/master/datas/zeek-322.tar.gz && \
	tar xf zeek-322.tar.gz && \
    cd zeek && ./configure && make && make install


FROM centos:centos7.6.1810
LABEL maintainer="actanble@gmail.com"

COPY --from=build /usr/local/zeek  /usr/local/zeek

