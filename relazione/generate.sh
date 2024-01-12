#!/usr/bin/env bash

pandoc -o doc.tex -t latex -s doc.md
pdflatex doc.tex
pdflatex doc.tex # 2 volte per generare correttamente il documento
