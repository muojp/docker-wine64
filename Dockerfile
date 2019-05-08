FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libc6-dev-i386 \
    bison \
    flex \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN curl -sS -L http://prdownloads.sourceforge.net/wine/wine-1.6.2.tar.bz2 | tar jx -C /opt
RUN mkdir /opt/wine32-build /opt/wine64-build

RUN cd /opt/wine64-build && \
    ../wine-1.6.2/configure --without-x --without-freetype --enable-win64 && \
    make -j4
RUN cd /opt/wine32-build && ../wine-1.6.2/configure --without-x --without-freetype --with-wine64=../wine64-build && \
    make -j4
RUN cd /opt/wine64-build && \
    make install