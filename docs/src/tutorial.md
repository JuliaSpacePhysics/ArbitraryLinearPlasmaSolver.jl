# Tutorial (Julia)

This is a Julia port of the upstream [ALPS tutorial](https://danielver02.github.io/ALPS/page/tutorial.html), adapted for the ArbitraryLinearPlasmaSolver.jl wrapper. The wrapper exposes the ALPS executables from the JLL artifact so you can drive the Fortran solver from Julia scripts while keeping the ALPS input file format unchanged.

## Setting up input distributions

ALPS uses f0-tables stored in a `distribution` directory. The format is a
three-column ASCII table:

1. `p_perp` normalized to `m_ref v_A`
2. `p_par` normalized to `m_ref v_A`
3. `f0_j(p_perp, p_par)` normalized to `(m_ref v_A)^-3`

The distribution function must integrate to one in cylindrical momentum space. File names follow the pattern:

```
dist_name.N.array
```

with `N` the species number (1=protons, 2=electrons, etc.).

## 3.2 Generate f0-tables (Maxwellian example)

The upstream ALPS repository provides example input files such as
`test_ICW_dist.in`. Place the input file in your working directory
(e.g. `./distribution`) and run the generator from Julia:

```@example tutorial
using ArbitraryLinearPlasmaSolver

cd("examples/distribution") do
    run(`$(ArbitraryLinearPlasmaSolver.generate_distribution()) test_ICW_dist.in`)
end
```

This will create `test_ICW.1.array` and `test_ICW.2.array` in the same folder.

## 4. Run ALPS on f0-tables

The ALPS input file (for example `test_ICW.in`) lives in a `tests` folder in
the upstream ALPS distribution. The solver expects paths like
`distribution/test_ICW.1.array`, so it is simplest to run commands from the
ALPS repository root. The key parameters include:

- `nperp` and `npar`: if your table has X by Y points, use `nperp = X-1` and
  `npar = Y-1`.
- `arrayName`: base name of the f0-table files (e.g. `test_ICW`).
- `nspec`: number of species (must match the number of `*.array` files).

To run the solver from Julia (from the ALPS repo root):

ALPS expects at least 4 MPI ranks and an even number of processes. If you
want to run with MPI, invoke `mpirun` from Julia and point it at the binary
path:

```@example run_mpi
using ArbitraryLinearPlasmaSolver.MPICH_jll
mpirun = MPICH_jll.mpiexec()  # or mpirun()
cd("examples") do
    run(`$mpirun -np 4 $(ArbitraryLinearPlasmaSolver.ALPS().exec) tests/test_ICW.in`)
end
```

## 5. Interpolate distributions to the ALPS grid

ALPS ships an interpolation utility that converts irregular grids into the
uniform ALPS grid. Using the example `test_interp.in` input file:

```@example tutorial
using ArbitraryLinearPlasmaSolver

run(`$(ArbitraryLinearPlasmaSolver.interpolation()) interpolation/test_interp.in`)
```

This writes a new file `test_interp.in.array` in ALPS format under
`interpolation/`.

## 6. Analytical background distributions

The upstream tutorial modifies `distribution_analyt.f90` and recompiles ALPS.
The JLL wrapper ships prebuilt binaries, so editing Fortran sources is not
possible with the stock artifact. If you need custom analytical distributions:

1. Build ALPS from source with your changes.
2. Run your custom binary directly from Julia, e.g.

```julia
run(`/path/to/ALPS ./tests/test_analytical.in`)
```

## 7. Bi-Maxwellian and cold-plasma species

These features are controlled entirely by the ALPS input file. In the species
block, set `use_bM = T` and fill the `bM_spec_*` parameters. For cold-plasma
species, set `bM_betas = 0.d0`. You can use the test inputs from the ALPS
repository (`test_bimax.in` and `test_cold_plasma.in`) and run them the same
way as above:

```julia
run(`$(ArbitraryLinearPlasmaSolver.ALPS()) test_bimax.in`)
```

```julia
run(`$(ArbitraryLinearPlasmaSolver.ALPS()) test_cold_plasma.in`)
```

## 8. Notes on inputs and data layout

ALPS expects the working directory to contain `distribution`, `tests`, and
`interpolation` folders (or equivalent paths in your input files). If you are
following the upstream tutorial, clone the Fortran ALPS repository and run the
Julia wrapper from its root so the relative paths match.

The upstream `tests/run_test.sh` script illustrates the expected flow:

1. Run interpolation with `interpolation/test_interp.in`.
2. Run `generate_distribution` for a test input (e.g. `test_kpar_fast_dist.in`).
3. Execute `mpirun -np <NP> ./src/ALPS tests/<input>.in`.
