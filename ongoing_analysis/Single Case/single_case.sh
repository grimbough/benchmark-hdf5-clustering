#$ -l mem_free=5G,h_vmem=5G
#$ -cwd
#$ -m e
#$ -M rliu38@jhu.edu

R -e "rmarkdown::render('Memory_Benchmark.Rmd')"