#!/usr/bin/env bash

DIR=$1
_allSpaces=0
_allTabs=0

for file in $(find "${DIR}" -type f); do
  if [[ -f $file ]]; then
    if [[ $file == *.java || $file == *.xml || $file == *.json || $file == *.yaml || $file == *.yml || $file == *.properties ]]; then
      _spaces=$(cat $file | tr -d -C ' ' | wc -c)
      _tabs=$(cat $file | tr -d -C '\t' | wc -c)
      _allSpaces=$(expr $_allSpaces + $_spaces)
      _allTabs=$(expr $_allTabs + $_tabs)
    fi
  fi
done

_total=$(expr $_allSpaces + $_allTabs)
_ratioSpaces=$(awk -v var1=$_allSpaces -v var2=$_total 'BEGIN { print  ( var1 / var2 ) }')
_ratioTabs=$(awk -v var1=$_allTabs -v var2=$_total 'BEGIN { print  ( var1 / var2 ) }')
echo "Total: $_total, Tabs: $_allTabs r: $_ratioTabs, Spaces: $_allSpaces, r: $_ratioSpaces"