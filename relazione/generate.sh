#!/usr/bin/env bash

pdflatex -interaction=nonstopmode -halt-on-error doc.tex &&
pdflatex doc.tex && # 2 volte per generare correttamente il documento
echo "OK"
