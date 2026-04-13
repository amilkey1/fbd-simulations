for i in {1..2}; do
	mkdir "rep$i"
	mkdir "rep$i/sim"
done

Rscript sim.R
rb132 sim.Rev

# copy sampling scripts into directories
for d in rep*/; do
	cp -r "sample" "$d"
	cp -r "sample-no-fossils" "$d"
	cp delete-fossils.sh "$d"
done

# create new taxon lists without fossils for fossil-less analyses
for d in rep*/; do
	cp "$d"/sim/fossils.tsv "$d"/sim/no-fossils.tsv
	awk 'NR==1 || $2 == 0' "$d"/sim/no-fossils.tsv > "$d"/sim/temp.tsv && mv "$d"/sim/temp.tsv "$d"/sim/no-fossils.tsv
done

# create folders with varying numbers of fossils
for d in rep*/; do
	cd "$d"
	. delete-fossils.sh
	cd ..
done

# create list of all directories
find rep* -type d -name "fossil*" > dir_list.txt
