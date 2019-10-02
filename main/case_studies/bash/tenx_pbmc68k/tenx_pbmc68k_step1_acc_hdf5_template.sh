data_name="tenx_pbmc68k"
mode="acc"
B_name="1"
method="hdf5"
batch=(0.001 0.01)
k=(10 23)

for ba in "${batch[@]}"; do
	Rscript --slave ../../01-cluster_full.R --args $data_name $mode $B_name $method $ba $run_id
done
