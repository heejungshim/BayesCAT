CC = g++
CCFLAGS = -O0 -g
OBJS = BayesCAT.o
BayesCAT: BayesCAT.C alignerHJ.cc alignerHJ.h algebrasHJ.cc algebrasHJ.h dptablesHJ.h mybandingHJ.h
	${CC} -o $@ -O0 -g BayesCAT.C alignerHJ.cc algebrasHJ.cc


clean  :
	rm *.o

