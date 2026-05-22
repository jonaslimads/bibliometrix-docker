FROM rocker/shiny-verse:4.6.0

RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libgmp-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpoppler-cpp-dev \
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

# patch biblioshiny server.R to suppress Chrome initialization errors
RUN Rscript -e " \
  path <- system.file('biblioshiny/server.R', package='bibliometrix'); \
  code <- readLines(path); \
  start <- grep('chromote::set_default_chromote_object', code)[1]; \
  depth <- 0L; end <- start; \
  for (i in start:length(code)) { \
    depth <- depth + nchar(gsub('[^(]','',code[i])) - nchar(gsub('[^)]','',code[i])); \
    if (i >= start && depth <= 0L) { end <- i; break } \
  }; \
  code[start] <- paste0('try({', code[start]); \
  code[end]   <- paste0(code[end], '}, silent=TRUE)'); \
  writeLines(code, path) \
"

RUN apt-get update && apt-get install -y chromium && rm -rf /var/lib/apt/lists/*

ENV CHROMOTE_CHROME=/usr/bin/chromium

COPY biblioshiny-start.R /usr/local/src/biblioshiny-start.R

EXPOSE 3838

CMD ["Rscript", "/usr/local/src/biblioshiny-start.R"]
