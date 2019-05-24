#!/bin/bash

fiolize () {
    fio2gnuplot -p "*1m*.log" -g -d 1m
    fio2gnuplot -p "*128k*.log" -g -d 128k
    fio2gnuplot -p "*64k*.log" -g -d 64k
    fio2gnuplot -p "*4k*.log" -g -d 4k
}

move_types () {
    mv *randMix*.log randMix/
    mv *randWrite*.log randWrite/
    mv *randRead*.log randRead/
    mv *seqMix*.log seqMix/
    mv *seqWrite*.log seqWrite/
    mv *seqRead*.log seqRead/
}

moove_size () {
    printf "\t\t---- randMix"
    cd randMix/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..

    printf "\t\t---- randRead"
    cd randRead/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..

    printf "\t\t---- randWrite"
    cd randWrite/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..

    printf "\t\t---- seqMix"
    cd seqMix/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..

    printf "\t\t---- seqRead"
    cd seqRead/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..

    printf "\t\t---- seqWrite"
    cd seqWrite/
    fiolize
    sleep 1
    printf "\t\t[ OK ]\n"
    cd ..
}



printf "create directory tree.."
mkdir -p logs/{iops,bw,lat}/{randMix,randWrite,randRead,seqMix,seqWrite,seqRead}/{1m,128k,64k,4k,none}
mkdir -p logs/none
sleep 1
printf "\t\t\t[ OK ]\n"

printf "rename logs to bcache.logs.."
cd logs-erasure-bcache
for bcache in *
do
    mv $bcache bcache.$bcache
done

cd ..
sleep 1
printf "\t\t[ OK ]\n"

printf "rename logs to hdd.logs.."
cd logs-erasure-hdd
for hdd in *
do
    mv $hdd hdd.$hdd
done

cd ..
sleep 1
printf "\t\t[ OK ]\n"

printf "move all logs to logs directory.."
mv logs-erasure-hdd/* logs/
mv logs-erasure-bcache/* logs/

cd logs/
sleep 1
printf "\t[ OK ]\n"

printf "move logs to each io types.."
mv *_lat*.log lat/
mv *_bw*.log bw/
mv *_iops*.log iops/
mv *.log none/

sleep 1
printf "\t\t[ OK ]\n"

printf "move logs to each types..\n"
sleep 1

printf "\t---- lat"
cd lat/
move_types
sleep 1
printf "\t\t\t[ OK ]\n"

cd ..

printf "\t---- bw"
cd bw/
move_types
sleep 1
printf "\t\t\t\t[ OK ]\n"

cd ..

printf "\t---- iops"
cd iops
move_types
sleep 1
printf "\t\t\t[ OK ]\n"

cd ..

printf "move logs to each size..\n"
sleep 1

printf "\t---- lat\n"
cd lat/
moove_size
sleep 1

cd ..

printf "\t---- bw\n"
cd bw/
moove_size
sleep 1

cd ..

printf "\t---- iops\n"
cd iops/
moove_size
sleep 1

echo "----- done"
