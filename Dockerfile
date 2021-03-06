FROM ubuntu:18.04 as builder
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libc6-dev-i386 \
    libpng-dev \
    bison \
    flex
RUN curl -sS -L https://github.com/wine-mirror/wine/archive/wine-1.6.2.tar.gz | tar zx -C /opt
RUN mkdir /opt/wine32-build /opt/wine64-build
RUN cd /opt/wine64-build && ../wine-wine-1.6.2/configure --without-x --without-freetype --enable-win64 && make -j4
RUN cd /opt/wine32-build && ../wine-wine-1.6.2/configure --without-x --without-freetype --with-wine64=../wine64-build && make -j4 && make install
RUN cd /opt/wine64-build && make install

# Trim GUI-related libraries to reduce final image size because this container doesn't have X integration.
RUN rm /usr/local/lib*/wine/mshtml.dll.so /usr/local/lib*/wine/wined3d.dll.so /usr/local/lib*/wine/opengl32.dll.so /usr/local/lib*/wine/msi.dll.so /usr/local/lib*/wine/quartz.dll.so /usr/local/lib*/wine/actxprxy.dll.so /usr/local/lib*/wine/jscript.dll.so /usr/local/lib*/wine/d3d* /usr/local/lib*/wine/ddraw* /usr/local/lib*/wine/dsound*

FROM ubuntu:18.04
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libc6:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local /usr/local
RUN winecfg
ENTRYPOINT ["/usr/local/bin/wine64"]
