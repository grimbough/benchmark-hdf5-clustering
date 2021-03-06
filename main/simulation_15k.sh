#$ -l mem_free=10G,h_vmem=10G
#$ -cwd
#$ -m e
#$ -M rliu38@jhu.edu

nC=(100000)
nG=(1000)
sim_center=15
data_path="/fastscratch/myscratch/rliu/Aug_data_15k"

for c in "${nC[@]}"; do 
	for g in "${nG[@]}"; do 
		for i in {3..50}; do
			Rscript simulation_k.R --args $c $g $sim_center $data_path $i
		done
	done
done
