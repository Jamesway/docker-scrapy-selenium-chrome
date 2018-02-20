#FROM debian:stretch-slim
# includes setuptools and wheel
FROM python:3.6-slim-stretch

MAINTAINER JamesR
# based on vimagick/scrapyd and robcherry/docker-chromedriver
# purging wget removes required run time packages including python

# python, scrapy and selenium
RUN BUILD_DEPS='autoconf \
                build-essential \
                git \
                libssl-dev' \
#                python-dev \
#                python3-dev \
#                python-pip \
#                python3-pip' \
#  && RUN_DEPS='python \
#               python3' \

  && apt-get update \
  && apt-get install -yqq $RUN_DEPS $BUILD_DEPS --no-install-recommends \
#  && pip install setuptools \
#  && pip install wheel \
  && pip install git+https://github.com/scrapy/scrapy.git \
  && pip install selenium \
  && apt-get purge -y --auto-remove $BUILD_DEPS \
  && rm -rf /var/lib/apt/lists/*


# chrome
RUN BUILD_DEPS='gnupg unzip' \
  && RUN_DEPS='wget' \
  && apt-get update \
  && apt-get install -yqq $RUN_DEPS $BUILD_DEPS --no-install-recommends \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list \
  && wget https://dl-ssl.google.com/linux/linux_signing_key.pub \
  && apt-key add linux_signing_key.pub \
  && apt-get update \
  && apt-get install -yqq google-chrome-stable --no-install-recommends \
  && rm -rf linux_signing_key.pub \
  && apt-get purge -y --auto-remove $BUILD_DEPS \
  && rm -rf /var/lib/apt/lists/*

# chromedriver
RUN BUILD_DEPS='unzip' \
  && RUN_DEPS='wget' \
  && apt-get update \
  && apt-get install -yqq $RUN_DEPS $BUILD_DEPS --no-install-recommends \
  && wget https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && chmod 755 chromedriver \
  && mv chromedriver /usr/local/bin/chromedriver \
  && rm -rf chromedriver_linux64.zip \
  && apt-get purge -y --auto-remove $BUILD_DEPS \
  && rm -rf /var/lib/apt/lists/*








 ENV DISPLAY :20.0
 ENV SCREEN_GEOMETRY "1440x900x24"
 ENV CHROMEDRIVER_PORT 4444
 ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
 ENV CHROMEDRIVER_URL_BASE ''

 #ENTRYPOINT ["/usr/local/bin/scrapy"]
 #CMD ["--help"]
 CMD ["/bin/bash"]
