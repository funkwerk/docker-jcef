FROM ubuntu:14.04
MAINTAINER info@funkwerk-itk.com

ENV VERSION=8 UPDATE=91 BUILD=14
ENV JAVA_HOME=/usr/lib/jvm/java-${VERSION}-oracle

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:george-edison55/cmake-3.x -y

RUN apt-get update && apt-get install -y \
  git \
  cmake \
  build-essential \
  libgtk2.0-dev \
  libnss3-dev \
  libgconf-2-4 \
  libxss-dev \
  libasound2-dev \
  libxtst-dev \
  libgl1-mesa-dev


RUN curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
         --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
         http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"u"${UPDATE}"-b"${BUILD}"/jdk-"${VERSION}"u"${UPDATE}"-linux-x64.tar.gz \
    | tar xz -C /tmp && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk1.${VERSION}.0_${UPDATE} "${JAVA_HOME}"

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javaws "${JAVA_HOME}/bin/javaws" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"

RUN mkdir -p jcef \
    && cd jcef \
    && git clone https://bitbucket.org/chromiumembedded/java-cef.git src \
    && cd src \
    && mkdir -p jcef_build \
    && cd jcef_build \
    && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug .. \
    && make -j4 \
    && ln -s /jcef/src/third_party/cef/cef_binary_3.2743.1442.ge29124d_linux64/Resources/icudtl.dat /usr/lib/jvm/java-8-oracle/bin/icudtl.dat \
    && ln -s /jcef/src/third_party/cef/cef_binary_3.2743.1442.ge29124d_linux64/Debug/natives_blob.bin /usr/lib/jvm/java-8-oracle/bin/natives_blob.bin \
    && ln -s /jcef/src/third_party/cef/cef_binary_3.2743.1442.ge29124d_linux64/Debug/snapshot_blob.bin /usr/lib/jvm/java-8-oracle/bin/snapshot_blob.bin \
    && cd ../tools \
    && ./compile.sh linux64

WORKDIR "/jcef/src/tools/"
ENTRYPOINT ["./run.sh", "linux64", "Debug", "simple"]
