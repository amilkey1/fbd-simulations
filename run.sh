# simulate
rb132 revbayes-sim.Rev

# copy sampling scripts into directories
for d in output*/; do
	cp -r "sample" "$d"
	cp -r "sample-no-fossils" "$d"
done

# create new taxon lists without fossils for fossil-less analyses
for d in output*/; do
	cp "$d"/sim/fossils.tsv "$d"/sim/no-fossils.tsv
	sed -i '/^Fossil/d' "$d"/sim/no-fossils.tsv
done
