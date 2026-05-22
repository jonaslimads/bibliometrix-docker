FROM rocker/shiny-verse:4.6.0

RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libgmp-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpoppler-cpp-dev \
    curl \
    wget \
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages('bibliometrix', repos='https://cloud.r-project.org'); if (!requireNamespace('bibliometrix', quietly=TRUE)) stop('bibliometrix installation failed')"

RUN Rscript -e "install.packages(c( \
    'wordcloud2','ggmap','maps','shinydashboard','fresh','waiter', \
    'shinydashboardPlus','shinyjs','RCurl','shinyWidgets','chromote', \
    'bookdown','servr','pagedown','sparkline','tidygraph','tweenr', \
    'polyclip','gridExtra','RcppArmadillo','ggforce','viridis', \
    'graphlayouts','ggraph','globals','listenv','parallelly','future' \
  ), repos='https://cloud.r-project.org')"

COPY biblioshiny-start.R /usr/local/src/biblioshiny-start.R

EXPOSE 3838

ENV CHROMOTE_CHROME=/usr/bin/google-chrome

CMD ["Rscript", "/usr/local/src/biblioshiny-start.R"]
