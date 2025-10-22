#!/bin/bash

csplit -s -f ksiega_ -b "%d.txt" panTadeusz.txt "/^Księga [[:lower:]]*$/" "{*}"
rm -f ksiega_0.txt