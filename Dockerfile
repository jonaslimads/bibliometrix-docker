FROM rocker/shiny-verse:4.6.0

RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libgmp-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpoppler-cpp-dev \
    chromium \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages('bibliometrix', repos='https://cloud.r-project.org'); if (!requireNamespace('bibliometrix', quietly=TRUE)) stop('bibliometrix installation failed')"

# runtime deps that biblioshiny installs on first launch — bake them into the image
RUN Rscript -e "install.packages(c( \
    'wordcloud2','ggmap','maps','shinydashboard','fresh','waiter', \
    'shinydashboardPlus','shinyjs','RCurl','shinyWidgets','chromote', \
    'bookdown','servr','pagedown','sparkline','tidygraph','tweenr', \
    'polyclip','gridExtra','RcppArmadillo','ggforce','viridis', \
    'graphlayouts','ggraph','globals','listenv','parallelly','future' \
  ), repos='https://cloud.r-project.org')"

COPY biblioshiny-start.R /usr/local/src/biblioshiny-start.R

EXPOSE 3838

ENV CHROMOTE_CHROME=/usr/bin/chromium

CMD ["Rscript", "/usr/local/src/biblioshiny-start.R"]
