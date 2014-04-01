EXECNAME = calc.out
TESTNAME = tests.out

SOURCEDIR = ./sources/
TESTSDIR = ./tests/
INCLUDEDIR = ./includes/
BUILDDIR = ./build/build/
TESTBDIR = ./build/tests/

MAINO = $(BUILDDIR)main.o
OF = $(addprefix $(BUILDDIR), $(addsuffix .o, $(basename $(notdir $(join $(join $(wildcard $(SOURCEDIR)*.c), $(wildcard $(SOURCEDIR)*.s)), $(wildcard $(SOURCEDIR)*.cpp))))))
OFILES = $(filter-out $(MAINO),$(OF))
TFILES = $(addprefix $(TESTBDIR), $(addsuffix .o, $(basename $(notdir $(join $(join $(wildcard $(TESTSDIR)*.c), $(wildcard $(TESTSDIR)*.s)), $(wildcard $(TESTSDIR)*.cpp))))))

CC = gcc
CPP = g++
AS = as
CCFLAGS = -c -O2 -Wall -Wextra -I$(INCLUDEDIR) -lm
CSTD = -std=c99
CPPSTD = -std=c++11

all: $(EXECNAME) $(TESTNAME)

$(EXECNAME): $(OFILES) $(MAINO)
	$(CPP) $^ -o $@

$(TESTNAME): $(TFILES) $(OFILES)
	$(CPP) $^ -o $@

$(BUILDDIR)%.o: $(SOURCEDIR)%.c
	$(CC) $(CCFLAGS) $(CSTD) $< -o $@

$(TESTBDIR)%.o: $(TESTSDIR)%.c
	$(CC) $(CCFLAGS) $(CSTD) $< -o $@

$(BUILDDIR)%.o: $(SOURCEDIR)%.s
	$(AS) $< -o $@

$(TESTBDIR)%.o: $(TESTSDIR)%.s
	$(AS) $< -o $@

$(BUILDDIR)%.o: $(SOURCEDIR)%.cpp
	$(CPP) $(CCFLAGS) $(CPPSTD) $< -o $@

$(TESTBDIR)%.o: $(TESTSDIR)%.cpp
	$(CPP) $(CCFLAGS) $(CPPSTD) $< -o $@

.PHONY: clean
clean:
	rm -f $(BUILDDIR)*.o
	rm -f $(TESTBDIR)*.o

.PHONY: cleanall
cleanall: clean
	rm $(EXECNAME)
	rm $(TESTNAME)

.PHONY: generate
generate:
	python resources/ccwmsetup.py
