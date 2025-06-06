#' Interaction_from_correlation
#' 
#' Compute correlation between two dataframe X and Y (or list of data.frame).
#' An incidence graph is returned. A link between two features is produced 
#' if their correlation (absolute value) is above the threshold.
#' 
#' @param  X  a data.frame or list of data.frame (with a similar number of row).
#' @param Y  a data.frame or list of data.frame (with a similar number of row).
#' @param threshold a threshold to cut the correlation matrix above which a link
#'                  is created between a feature from X and a feature from Y.
#' 
#' @return an 'igraph' object



#' @examples
#' X <- matrix(rexp(200, rate=.1), ncol=20)
#' Y <- matrix(rexp(200, rate=.1), ncol=20)
#' get_interaction_from_correlation(X,Y)
#' 
#' X <- list(matrix(rexp(200, rate=.1), ncol=20), 
#'           matrix(rexp(200, rate=.1), ncol=20))
#' Y <- matrix(rexp(200, rate=.1), ncol=20)
#' get_interaction_from_correlation(X,Y)
#' 
#' @importFrom igraph graph_from_biadjacency_matrix simplify
#' @importFrom stats cor

#' @export
get_interaction_from_correlation <- function(X, 
                                             Y, 
                                             threshold = 0.5) {
    
    # check X
    if (is(X, "list")) {
        X <- validate_list_matrix_X(X)
        if (length(unique(unlist(lapply(X, nrow)))) > 1) {
            stop("'X' must have the same number of rows")
        }
        X <- do.call(X, what = "cbind")
    } else {
        X <- validate_matrix_X(X)
    }
    
    # check Y
    if (is(Y, "list")) {
        # X and Y can have a different length
        Y <- validate_list_matrix_X(Y, var.name = "'Y' ")
        if (length(unique(unlist(lapply(Y, nrow)))) > 1) {
            stop("'Y' must have the same number of rows")
        }
        Y <- do.call(Y, what = "cbind")
    } else {
        Y <- validate_matrix_X(Y, var.name = "'Y' ")
    }
    
    # check threshold
    threshold <- check_single_numeric_value(threshold,
                                            min = 0, 
                                            max = 1, 
                                            var.name = "'threshold' ")
    
    # corr between X and Y
    res.corr <- cor(x = X, y = Y, method = "spearman", use = "complete.obs")
    corr.graph <- abs(res.corr) >=
        threshold
    
    # graph
    res.graph <- igraph::graph_from_biadjacency_matrix(corr.graph, 
                                                     directed = FALSE)
    res.graph <- igraph::simplify(res.graph)
    
    return(res.graph)
}



