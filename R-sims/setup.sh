for i in {1..15}; do
	mkdir "rep$i"
	mkdir "rep$i/sim"
done

Rscript sim.R
rb132 sim.Rev

# copy sampling scripts into directories
for d in rep*/; do
	cp -r "sample" "$d"
	cp -r "sample-no-fossils" "$d"
done

# create new taxon lists without fossils for fossil-less analyses
for d in rep*/; do
	cp "$d"/sim/fossils.tsv "$d"/sim/no-fossils.tsv
	awk 'NR==1 || $2 == 0' "$d"/sim/no-fossils.tsv > "$d"/sim/temp.tsv && mv "$d"/sim/temp.tsv "$d"/sim/no-fossils.tsv
done
