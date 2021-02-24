 PROG = gcp
 OBJS = gcp.o stringmod.o
#--------------------------------------------------------------------------
# Testing for 1. gfortran 2. ifort
FC := $(shell which gfortran 2>> error.dat)
FC := $(shell which ifort 2> error.dat) 
ifndef FC
$(warning ifort not found.)
$(warning gfortran not found.)
$(warning Please adjust FC= yourself!)
$(error aborting...)
endif
#--------------------------------------------------------------------------

#  FC = <your compiler>
#  FC = ifort 
#  FC = gfortran
  FFLAGS = -O3  
  LINKER = $(FC) -static   

.PHONY: all
.PHONY: clean

%.o: %.f90
	@echo "making $@ from $<"
	$(FC) $(FFLAGS) -c $< -o $@


$(PROG):$(OBJS) 
	$(LINKER) $(OBJS) -o $(PROG)

clean:
	rm -f *.o $(PROG) 
	rm -f $(patsubst %.F, %.f, $(wildcard *.F))

gcp.o: stringmod.o
