# Fortran Notes

Persistent knowledge for working with Fortran and LAPACK. Update as we learn.

## Compiler (gfortran)

### Common flags
- `-ffixed-form` — Force fixed-form parsing (F77 style)
- `-ffree-form` — Force free-form parsing (F90+ style)
- `-fallow-argument-mismatch` — Allow type mismatches in calls (legacy code)
- `-fdefault-real-8` — Make default REAL 8 bytes (double precision)
- `-Wall` — Enable warnings
- `-g` — Debug symbols
- `-O2` — Optimization

### File extensions
- `.f`, `.for`, `.f77` — Fixed-form (assumed by gfortran)
- `.f90`, `.f95`, `.f03`, `.f08` — Free-form (assumed by gfortran)

## LAPACK

### Linking
```bash
gfortran program.f90 -llapack -lblas -o program
```

### Naming conventions
- First letter: S (single), D (double), C (complex), Z (double complex)
- Examples: DGEMM (double general matrix multiply), DSYEV (double symmetric eigenvalue)

### Workspace queries
1. Call with LWORK = -1
2. Optimal LWORK returned in WORK(1)
3. Allocate WORK, call again with actual LWORK

### Common routines
- DGESV — Solve Ax = B
- DGETRF/DGETRS — LU factorization and solve
- DSYEV/DSYEVD/DSYEVR — Symmetric eigenvalue
- DGESVD — SVD
- DGEMM — Matrix multiply

## Legacy Code Patterns

### COMMON blocks
Shared global data. Watch for implicit typing, alignment, naming collisions.

### Implicit typing
I-N are INTEGER, others REAL. Use `IMPLICIT NONE` in new code.

### Fixed-form layout
- Columns 1-5: label
- Column 6: continuation
- Columns 7-72: code
- Columns 73+: ignored

## Lessons Learned

<!-- [YYYY-MM-DD] Observation -->
