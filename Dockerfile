FROM rocker/verse:3.4.2
MAINTAINER "Brooks Ambrose" brooksambrose@berkeley.edu

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
   software-properties-common \
   curl dos2unix dnsutils

# add hub from https://hub.github.com
RUN cd ~ && wget https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz \
&& tar -zxvf hub-linux-amd64-2.2.9.tgz \
&& ./hub-linux-amd64-2.2.9/install \
&& rm -rf hub* \
&& hub version

# install R packages
RUN . etc/environment \
&& r -e 'devtools::install_github(c("rstudio/bookdown","1beb/RGoogleDrive"))' \
&& r -e 'warnings()'

RUN . etc/environment \
&& install2.r --repos $MRAN --deps TRUE \
	stargazer \
	httr \
	kableExtra \
&& r -e 'warnings()'

# add caddy web server
RUN curl https://getcaddy.com | bash
# \
#&& echo '#!/bin/bash' >> runcaddy.sh \
#&& echo "mkdir /home/oski/_book/ ; cd /home/oski/_book/ && caddy" >> runcaddy.sh \
#&& echo '#!/bin/bash' >> start.sh \
#&& echo "(/init) & sleep 10 && /runcaddy.sh" >> start.sh \
#&& chmod u+x /runcaddy.sh /start.sh

# fun with line endings
RUN git config --global core.autocrlf input

EXPOSE 80 443 2015

CMD ["/init"]

USER root
COPY . /home/rstudio/
RUN chown -R rstudio:rstudio * .*
USER rstudio

## run any install.R script we find
RUN if [ -f install.R ]; then R --quiet -f install.R; fi


