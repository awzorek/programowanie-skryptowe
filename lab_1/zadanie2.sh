#!/bin/bash

wc -l -w panTadeusz.txt

grep -o 'Litw[[:lower:]]*' panTadeusz.txt | grep -v 'Litwin[[:lower:]]*' | wc -l

grep -oE '\b[[:upper:]]+[[:lower:]]*[[:upper:]]*\b' panTadeusz.txt | sort | uniq -c | sort -nr | head -20

grep -niE 'ojczyz[[:lower:]]*|ojczyź[[:lower:]]*' panTadeusz.txt | sed -E 's/ojczy[[:lower:]]*/\U&\E/g'