#!/usr/bin/env bash
set -eo pipefail

ghout=$(gh run list -L 1)
read a b c d e f g jobid i j <<<"$ghout"
echo "$jobid"
echo "Wait for gh action..."
gh run watch "$jobid"
rm -fr firmware
echo "Downloading firmware..."
gh run download "$jobid"
if [[ ! -d "firmware" ]]; then
	echo "download failed"
	exit 1
fi

echo "Got firmware"
echo -n "Wait for nice nano..."
while [[ ! -d "/Volumes/NICENANO" ]]; do
	sleep 1
	echo -n "."
done
echo ""
echo -n "Found nice nano, flashing..."
cp ./firmware/corne_left-nice_nano-zmk.uf2 /Volumes/NICENANO
while [[ -d "/Volumes/NICENANO" ]]; do
	sleep 1
	echo -n "."
done
echo ""
rm -fr firmware
echo "Done!"
