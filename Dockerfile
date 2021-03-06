# Use the latest RStudio
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# ---------- Core Development ----------

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils \
		default-jdk \
		libbz2-dev \
		libcairo2-dev \
		libcurl4-openssl-dev \
		libglu1-mesa-dev \
		libgsl0-dev \
		libhunspell-dev \
		libicu-dev \
		liblzma-dev \
		libmagick++-dev \
		libmariadb-client-lgpl-dev \
		libmariadbd-dev \
		libnlopt-dev \
		libomp-dev \
		libpq-dev \
		libsqlite3-dev \
		libssh2-1-dev \
		libssl-dev \
		libxml2-dev \
		mesa-common-dev \
		ssh \
		tk \
		unixodbc-dev \
		&& R -e "source('https://bioconductor.org/biocLite.R')"

# ---------- RStan Configuration ----------

# Global site-wide config for building packages
RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs \n" >> $HOME/.R/Makevars

# Install ggplot extensions like ggstance and ggrepel
# Install ed, since nloptr needs it to compile
# Install all the dependencies needed by rstanarm and friends
RUN apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    && install2.r --error \
        ggstance ggrepel \
        miniUI PKI RCurl RJSONIO packrat minqa nloptr matrixStats inline \
        colourpicker DT dygraphs gtools rsconnect shinyjs shinythemes threejs \
        xts bayesplot lme4 loo rstantools StanHeaders RcppEigen \
        rstan shinystan rstanarm broom

# ---------- Various R Packages ----------

# Breaking this up in sections due to high chance of packages failing
RUN install2.r --error --deps TRUE devtools formatR selectr caTools remotes DataExplorer
RUN install2.r --error --deps TRUE tidyverse caret GGally outliers hrbrthemes reprex
RUN install2.r --error --deps TRUE lime quantmod zoo h2o lintr skimr profvis aws.s3
RUN install2.r --error --deps TRUE lubridate xgboost syuzhet tidytext sparklyr
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# ---------- Keras and Tensorflow ----------

# Add the Keras and Tensorflow packages with Python dependencies
# Not working as intended right now; setup manually in RStudio terminal after install
#RUN apt-get install python-pip python-virtualenv -y
#RUN pip install virtualenv
#RUN R -e "devtools::install_github('rstudio/tensorflow')"
#RUN R -e "devtools::install_github('rstudio/keras')"
#RUN R -e "devtools::install_github('rstudio/tfestimators')"
#RUN R -e "keras::install_keras(tensorflow = 'gpu')"
