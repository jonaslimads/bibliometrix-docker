options(shiny.launch.browser = FALSE)
Sys.setenv(CHROMOTE_CHROME = "/bin/false")

library(bibliometrix)
biblioshiny(host = "0.0.0.0", port = 3838, launch.browser = FALSE)
