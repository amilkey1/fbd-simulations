# simulate
rb132 revbayes-sim.Rev

# copy sampling scripts into directories
for d in output*/; do
	cp -r "sample" "$d"
	cp -r "sample-no-fossils" "$d"
done

# start runs
#for d in */; do
#	cd "$d"
#	cd sample
#       rb-new mcmc_CEFBDP_Specimens.Rev
#	cd ../..
#done
