
p=1
./run_jupyter_notebooks \
    -i sibswiss/elixir-sco-spatial-omics:practical_$p \
    -u credentials/input_docker_start_practical_$p.txt \
    -p test123 \
    -n practical_$p \
    -a yes

for p in 3 6
do 
    ./run_jupyter_notebooks \
        -i sibswiss/elixir-sco-spatial-omics:practical_$p \
        -u credentials/input_docker_start_practical_$p.txt \
        -p test123 \
        -n practical_$p \
        -a no
done

p=5
./run_rstudio_server \
    -i sibswiss/elixir-sco-spatial-omics:practical_$p \
    -u credentials/input_docker_start_practical_$p.txt \
    -p test123 \
    -n practical_$p \
    -a no