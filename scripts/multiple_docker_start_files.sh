
for p in $(seq 1 6)
do
    sed "s/^10/1$p/g" input_docker_start.txt > input_docker_start_practical_$p.txt
done
