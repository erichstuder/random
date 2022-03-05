FROM gcc:11.2.0

WORKDIR /home/cpputest

RUN git clone --depth 1 --branch v4.0 https://github.com/cpputest/cpputest.git .
RUN autoreconf . -i
RUN ./configure
RUN make install

ENV CPPUTEST_HOME=/home/cpputest

WORKDIR /home/project/test
