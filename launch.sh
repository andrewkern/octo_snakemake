snakemake -j 99 --rerun-incomplete --cluster-config cluster_talapas.json --cluster "sbatch -p {cluster.partition} -t {cluster.time} --mem {cluster.mem} -n 1 -c {threads}  --account={cluster.account}"
