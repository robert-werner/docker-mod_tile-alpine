FROM mapnik

RUN apk add --no-cache apache2 apache2-dev curl iniparser iniparser-dev glib make g++ autoconf automake patch
RUN git clone https://github.com/openstreetmap/mod_tile.git
WORKDIR mod_tile
COPY ./patch .
RUN patch ./src/daemon.c daemon_iniparser.patch
RUN patch ./src/gen_tile.cpp gen_tile_box2d.patch
RUN patch ./src/gen_tile_test.cpp gen_tile_test_box2d.patch
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN make install-mod_tile
COPY a2disconf /usr/bin/a2disconf
COPY a2dismod /usr/bin/a2dismod
COPY a2enconf /usr/bin/a2enconf
COPY a2enmod /usr/bin/a2enmod
RUN mkdir /etc/apache2/conf-available
RUN mkdir /etc/apache2/conf-enabled