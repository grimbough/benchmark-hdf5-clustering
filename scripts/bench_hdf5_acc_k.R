#' @title bench_hdf5_acc
#' @param i monte carlo simulation iteration; keep this for mclapply

bench_hdf5_acc_k <- function(i, n_cells, 
                           n_genes, 
                           k_centers, 
                           batch_size = batch_size, 
                           num_init = num_init, 
                           max_iters = max_iters, 
                           init_fraction = init_fraction, 
                           initializer = initializer, 
                           method, size, sim_center) {
  if (size == "small"){
    set.seed(1234)
    x_mus <- runif(sim_center, min = -10, max = 10)
    set.seed(1234)
    x_sds <- sample(1:10, sim_center, replace = TRUE)/10
    set.seed(12)
    y_mus <- runif(sim_center, min = -10, max = 10)
    set.seed(123)
    y_sds <- sample(1:10, sim_center, replace = TRUE)/10
    rm(.Random.seed, envir=.GlobalEnv)
    prop1 <- rep(1/sim_center, sim_center)
    
    sim_data <- simulate_gauss_mix_k(n_cells = n_cells, n_genes = n_genes, k = sim_center, 
                                     x_mus = x_mus, x_sds = x_sds, y_mus = y_mus, y_sds = y_sds, prop1=prop1)
    
    if (method == "hdf5"){
      sim_data_hdf5 <- writeHDF5Array(as.matrix(sim_data$obs_data), chunkdim=c(1, n_genes))
    }
  }
  
  if(method == "kmeans"){
    cluster_output <- stats::kmeans(sim_data$obs_data, centers=k_centers, iter.max = max_iters, nstart = num_init)
    
    output <- list(true_cluster = sim_data$true_cluster_id, cluster_output = cluster_output$cluster, 
                   cluster_wcss = cluster_output$withinss, ifault = cluster_output$ifault, iteration = cluster_output$iter)
  }
  
  if(method == "mbkmeans"){
    cluster_output <- mbkmeans::mini_batch(
      sim_data$obs_data, clusters = k_centers, 
      batch_size = batch_size, num_init = num_init, 
      max_iters = max_iters, init_fraction = init_fraction,
      initializer = initializer, calc_wcss = TRUE)
    
    output <- list(true_cluster = sim_data$true_cluster_id, cluster_output = cluster_output$Clusters, 
                   cluster_wcss = cluster_output$WCSS_per_cluster, best_init = cluster_output$best_initialization, 
                   iters = cluster_output$iters_per_initialization)
  }
  
  if(method == "hdf5"){
    cluster_output <- mbkmeans::mini_batch(
      sim_data_hdf5, clusters = k_centers, 
      batch_size = batch_size, num_init = num_init, 
      max_iters = max_iters, init_fraction = init_fraction,
      initializer = initializer, calc_wcss = TRUE)
    
    output <- list(true_cluster = sim_data$true_cluster_id, cluster_output = cluster_output$Clusters, 
                   cluster_wcss = cluster_output$WCSS_per_cluster, best_init = cluster_output$best_initialization, 
                   iters = cluster_output$iters_per_initialization)
  }
  return(output)
}