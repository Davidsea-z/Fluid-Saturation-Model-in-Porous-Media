# Fluid Saturation Model in Porous Media

## Project Description
This MATLAB project implements a numerical model for simulating fluid saturation distribution in porous media, considering the effects of interfacial tension and contact angle. The model includes relative permeability calculations and optimization of model parameters using experimental data.

## Features
- Numerical simulation of two-phase flow in porous media
- Parameter optimization using least squares curve fitting
- Relative permeability calculations with exponential functions
- Visualization of experimental vs. fitted results
- Contact angle and interfacial tension effects integration

## Files Description
- `code01.m`: Main implementation with parameter optimization and visualization
- `code02.m`: Alternative implementation with different parameter settings
- `compute_Kro.m`: Calculates relative permeability for oil phase
- `compute_Krw.m`: Calculates relative permeability for water phase
- `error_function_exponential.m`: Error function for optimization
- `main.m`: Main script for running the simulation
- `model_exponential.m`: Core model implementation with exponential functions
- `model_function.m`: Model interface function
- `model.m`: Base model implementation

## Required Data
- `data.xlsx`: Experimental data file containing:
  - Length measurements
  - Saturation data at different time points

## Dependencies
- MATLAB (with Optimization Toolbox)
- Excel file reading capability

## Usage
1. Ensure all MATLAB files are in the same directory
2. Place `data.xlsx` in the working directory
3. Run either `main.m` or `code01.m` to execute the simulation
4. Results will be displayed as plots showing:
   - Comparison between experimental and fitted results
   - Saturation distribution at different time points

## Model Parameters
Key parameters include:
- `Krw0`: Initial water relative permeability
- `Kro0`: Initial oil relative permeability
- `nw`: Water phase exponent
- `no`: Oil phase exponent
- `Swr`: Residual water saturation
- `Sor`: Residual oil saturation
- `B`: Model constant
- `K`: Permeability
- `phi`: Porosity
- `mu_w`: Water viscosity
- `mu_o`: Oil viscosity

## Output
The model generates:
- Optimized parameter values
- Graphical comparisons of experimental and fitted data
- Saturation distribution profiles over time

## License
MIT License

Copyright (c) 2024 Wang Hanwei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Contact
Wang Hanwei
Email: 1155221770@link.cuhk.edu.hk