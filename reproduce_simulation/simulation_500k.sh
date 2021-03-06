#$ -l mem_free=20G,h_vmem=20G
#$ -cwd
#$ -m e
#$ -M rliu38@jhu.edu

nC=(500000)
nG=(1000)
sim_center=3
data_path="/fastscratch/myscratch/rliu/Aug_data"

for c in "${nC[@]}"; do 
	for g in "${nG[@]}"; do 
		for i in {1..10}; do
			Rscript simulation.R --args $c $g $sim_center $data_path $i
		done
	done
done