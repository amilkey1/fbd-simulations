nfossils=$(cut -f1 sim/fossils.tsv | grep -c "\.")

for ((i=1; i <= nfossils-1; i++))
do
	mkdir "fossil_${i}"
	cp -r sample/* "fossil_${i}"
	sed -i "s|taxa <- readTaxonData(\"../sim/fossils.tsv\")|taxa <- readTaxonData(\"../sim/fossils_${i}.tsv\")|g" "fossil_${i}/mcmc_CEFBDP_Specimens.Rev"
	cp -r sim/fossils.tsv sim/"fossils_${i}.tsv"

	input=sim/"fossils_${i}.tsv"
	awk -F'\t' 'NR > 1 && $2 > 0 {print NR}' "$input" | shuf -n $i > sim/to_delete.txt

	if [ -s sim/to_delete.txt ]; then
		awk 'NR==FNR {a[$1]; next} !(FNR in a)' sim/to_delete.txt "$input" > sim/temp.tsv
		mv sim/temp.tsv "$input"
		echo "Done! Deleted $(wc -l < sim/to_delete.txt) rows."
	else
		echo "No rows found with age > 0."
	fi
done

