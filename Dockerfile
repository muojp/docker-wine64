FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libc6-dev-i386 \
    libpng-dev \
    bison \
    flex \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && curl -sS -L https://github.com/wine-mirror/wine/archive/wine-1.6.2.tar.gz | tar zx -C /opt \
 && mkdir /opt/wine32-build /opt/wine64-build \
 && cd /opt/wine64-build && ../wine-wine-1.6.2/configure --without-x --without-freetype --enable-win64 && make -j4 \
 && cd /opt/wine32-build && ../wine-wine-1.6.2/configure --without-x --without-freetype --with-wine64=../wine64-build && make -j4 && make install \
 && cd /opt/wine64-build && make install \
 && rm -rf /opt/wine-wine-1.6.2 /opt/wine32-build /opt/wine64-build
RUN winecfg
