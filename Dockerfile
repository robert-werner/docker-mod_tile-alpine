FROM mapnik

RUN apk update
RUN apk add --no-cache apache2 apache2-dev curl iniparser iniparser-dev glib make g++ autoconf automake patch apr apr-dev apr-util-dev openssl 
RUN git clone https://github.com/openstreetmap/mod_tile.git
WORKDIR mod_tile
COPY ./patch .
RUN patch ./src/daemon.c daemon_iniparser.patch
RUN patch ./src/gen_tile.cpp gen_tile_box2d.patch
RUN patch ./src/gen_tile_test.cpp gen_tile_test_box2d.patch
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install
RUN make install-mod_tile
RUN mkdir /etc/apache2/conf-available
RUN mkdir /etc/apache2/conf-enabled