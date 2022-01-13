module load R/3.6.3
module load homer

call="nohup \
Rscript \
--vanilla \
/share/lasallelab/programs/DMRichR/DM.R \
--genome hg38 \
--coverage 1 \
--perGroup '1' \
--minCpGs 5 \
--maxPerms 100 \
--cutoff '0.05' \
--testCovariate Diagnosis \
--adjustCovariate 'Sex;Trophoblasts;Stromal;Hofbauer;Endothelial;nRBC' \
--cores 40 \
> DMRichR.log 2>&1 &"

echo $call
eval $call 
echo $! > save_pid.txt
