rhdf5::h5disableFileLocking()

suppressPackageStartupMessages(library(mbkmeans))
suppressPackageStartupMessages(library(rhdf5))
suppressPackageStartupMessages(library(mclust))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(parallel))
suppressPackageStartupMessages(library(HDF5Array))
suppressPackageStartupMessages(library(benchmarkme))
suppressPackageStartupMessages(library(here))

now <- format(Sys.time(), "%b%d%H%M%OS3")

Rprof(filename = here("ongoing_analysis/Mem&Time/data", paste0(now, "_250k_new_disable", ".out")), append = FALSE, memory.profiling = TRUE)
sim_data_hdf5 <- HDF5Array(file = "/users/rliu/benchmark-hdf5-clustering/ongoing_analysis/Mem&Time/data/Aug04124514.099_250000_sim_data.h5",
                           name = "obs")
invisible(mbkmeans::mini_batch(sim_data_hdf5, clusters = 3, 
                     batch_size = 250000*0.005, num_init = 10,
                     max_iters = 100, init_fraction = 0.005,
                     initializer = "random", calc_wcss = FALSE))

Rprof(NULL)

profile <- summaryRprof(filename = here("ongoing_analysis/Mem&Time/data", paste0(now, "_250k_new_disable", ".out")), chunksize = -1L, 
                        memory = "tseries", diff = FALSE)
max_mem <- max(rowSums(profile[,1:3]))*0.00000095367432

temp_table <- data.frame(250000, 1000, 0.005, max_mem, "disable")
write.table(temp_table, file = here("ongoing_analysis/Mem&Time/Output.csv"), sep = ",", 
            append = TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE, eol = "\n")