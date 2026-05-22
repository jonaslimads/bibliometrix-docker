options(shiny.launch.browser = FALSE)
options(chromote.chrome.args = c("--no-sandbox", "--disable-dev-shm-usage"))

library(bibliometrix)
biblioshiny(host = "0.0.0.0", port = 3838, launch.browser = FALSE)
