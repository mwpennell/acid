##' This function provides access to the A-Ci database
##'
##' The data within this lookup table comes from many original sources.
##' For speedy access to the data within R use this function.  For 
##' access to the full meta-data, download the zip file associated with the 
##' Github release.
##'
##'
##' @title A-Ci database
##'
##' @param version Version number.  The default will load the most
##'   recent version on your computer or the most recent version known
##'   to the package if you have never downloaded the data before.
##'   With \code{plant_lookup_del}, specifying \code{version=NULL}
##'   will delete \emph{all} data sets.
##'
##' @param path Path to store the data at.  If not given,
##'   \code{datastorr} will use \code{rappdirs} to find the best place
##'   to put persistent application data on your system.  You can
##'   delete the persistent data at any time by running
##'   \code{mydata_del(NULL)} (or \code{mydata_del(NULL, path)} if you
##'   use a different path).
##'
##' @export
##' @examples
##' #
##' # see the format of the resource
##' #
##' head(acid())
##' #
##' #

acid <- function(version=NULL, path=NULL) {
  d <- acid_get(version, path)
  d
}

## This one is the important part; it defines the three core bits of
## information we need;
##   1. the repository name (traitecoevo/taxonlookup)
##   2. the file to download (plant_lookup.csv)
##   3. the function to read the file, given a filename (read_csv)
acid_info <- function(path) {
  datastorr::github_release_info("mwpennell/acid",
                                 filename="aci_data.csv",
                                 read=read_csv,
                                 path=path)
}

acid_get <- function(version=NULL, path=NULL) {
  datastorr::github_release_get(acid_info(path), version)
}

##' @export
##' @rdname acid
##' @param local Logical indicating if local or github versions should
##'   be polled.  With any luck, \code{local=FALSE} is a superset of
##'   \code{local=TRUE}.  For \code{mydata_version_current}, if
##'   \code{TRUE}, but there are no local versions, then we do check
##'   for the most recent github version.
acid_versions <- function(local=TRUE, path=NULL) {
  datastorr::github_release_versions(acid_info(path), local)
}

##' @export
##' @rdname acid
acid_version_current <- function(local=TRUE, path=NULL) {
  datastorr::github_release_version_current(acid_info(path), local)
}

##' @export
##' @rdname acid
acid_del <- function(version, path=NULL) {
  datastorr::github_release_del(acid_info(path), version)
}

read_csv <- function(...) {
  read.csv(..., stringsAsFactors=FALSE)
}

acid_release <- function(description, path=NULL, ...) {
  datastorr::github_release_create(acid_info(path),
                                   description=description, ...)
}
  