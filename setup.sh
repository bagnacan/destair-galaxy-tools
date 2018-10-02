#! /usr/bin/env bash
shopt -s extglob

echo 'channels: [iuc, bioconda, conda-forge, defaults]' > $GALAXY_ROOT/database/dependencies/_condarc

dir=$(cd $(dirname $0) && pwd)
for i in $(ls -d $dir/*/); do
	ln -sfn $i $GALAXY_ROOT/tools/$(basename $i)
	ln -sfn $i $GALAXY_ROOT/test-data/$(basename $i)
done

cfg=$(ls $GALAXY_ROOT/config/galaxy.+(yml|ini) 2> /dev/null | head -1)
sample=$GALAXY_ROOT/config/galaxy.+(yml|ini).sample
[[ ! $cfg ]] && cfg=$(dirname $sample)/$(basename $sample .sample) && cp $sample $cfg
sed -i -r 's/(^\s*)#+(\s*webhooks_dir.+)/\1\2/' $cfg
sed -i -r 's/(^\s*)#+(\s*tour_config_dir.+)/\1\2/' $cfg
sed -i -r 's/(^\s*)#+(\s*tool_path.+)/\1\2/' $cfg
sed -i -r 's/(^\s*)#+(\s*conda_auto_install\s*=).*/\1\2 True/' $cfg
sed -i -r 's/(^\s*)#+(\s*conda_auto_init\s*=).*/\1\2 True/' $cfg
sed -i -r 's/(^\s*)#+(\s*conda_ensure_channels\s*=).*/\1\2 iuc,bioconda,conda-forge,defaults/' $cfg

unset cfg
cfg=$(ls $GALAXY_ROOT/config/tool_conf.xml 2> /dev/null)
sample=$GALAXY_ROOT/config/tool_conf.xml.sample
[[ ! $cfg ]] && cfg=$(dirname $sample)/$(basename $sample .sample) && cp $sample $cfg
if [[ $(grep destair_scripts $cfg) ]]; then
	sta=$(grep -m 1 -n -F 'deSTAIR_visualization' $cfg | cut -d ':' -f 1)
	sto=$(grep -m 1 -n -F '</section' $cfg | cut -d ':' -f 1)
	sed -i "$sta,$sto{/./d}" $cfg
fi
echo '  <section id="deSTAIR_visualization" name="deSTAIR_visualization">' > tmp
for i in $(ls -d $dir/*/); do
	echo '    <tool file="'$(basename $i)/$(basename $i).xml'" />'
done >> tmp
echo '  </section>' >> tmp
sed -i '2 r tmp' $cfg
rm -f tmp
