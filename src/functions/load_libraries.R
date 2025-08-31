load_libraries <- function(pkgs, load = TRUE) {
  for (pkg in pkgs) {
    # install the library if missing
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg)
    }
    # if wanting to load
    if(load) { library(pkg, character.only = TRUE) }
  }
}

