#$ -l mem_free=10G,h_vmem=10G
#$ -q shared.q@compute-06[0-9],shared.q@compute-07[2-6]
#$ -cwd
#$ -m e
#$ -M rliu38@jhu.edu
module load R/3.6.1

data_name="hca_bonemarrow"
mode="time"
B_name="1"
method="hdf5"
batch=(0.001 0.01)

for ba in "${batch[@]}"; do
	Rscript --slave ../01-cluster_full.R --args $data_name $mode $B_name $method $ba
done