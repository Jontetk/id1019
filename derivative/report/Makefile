LATEXMK = latexmk
PDFLATEX = pdflatex

all : report.pdf report.tar.gz

report.tar.gz : Makefile report.tex fib.png fib.pdf fib.p fib.dat fib.ex fib.exs
	tar -czvf report.tar.gz  Makefile report.tex fib.png fib.pdf fib.p fib.dat fib.ex fib.exs


report.pdf : report.tex
	$(LATEXMK) -pdf -pdflatex=$(PDFLATEX) -shell-escape $<

clean:
	$(LATEXMK) -c
	rm -f *.aux *.log *.out *.*~ *~
	rm -f *.nav *.snm *.toc *.vrb
	rm -r -f _minted-assignment
	rm -r -f _minted-report
	rm -f src/*.beam
	rm -f *.beam

realclean: clean
	rm -f *.pdf
	rm report.tar.gz


