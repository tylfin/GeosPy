cdef struct LMstat:
  int verbose
  int max_it
  double init_lambda
  double up_factor
  double down_factor
  double target_derr
  int final_it
  double final_err
  double final_derr

cdef extern from "levmarq.c":
  void levmarq_init(LMstat *lmstat);
