% Clear workspace and initialize parameters
clear;
clc;

% Define global parameters
global Krw0 Kro0 nw no Swr Sor B K a;

% Set initial global parameter values
Krw0 = 0.356;
Kro0 = 0.902;
nw = 1.673; 
no = 1.482;
Swr = 0.294;
Sor = 0.396;
B = -13.96;
K = 0.00025;
a = 1e-5;

% Load experimental data
data = xlsread('data.xlsx');
lengths = data(:, 1); % Length data
S_exp = data(:, 2:end); % Experimental saturation data
time = linspace(0, max(lengths), size(S_exp, 2)); % Assume time is uniformly distributed

% Check the dimensions of the data
fprintf('S_exp size: %d x %d\n', size(S_exp));
fprintf('lengths size: %d x %d\n', size(lengths));
fprintf('time size: %d x %d\n', size(time));

% Read experimental parameters
initial_interfacial_tension = 20.15;
final_interfacial_tension = 0.52; % Final interfacial tension after the experiment
initial_contact_angle = 120; % degrees
final_contact_angle = 30; % degrees

% Initial guess for the parameters to be optimized
initial_params = [Krw0, Kro0, nw, no, Swr, Sor, B, K, a];

% Optimization process: minimize the error function
options = optimset('Display', 'iter');
opt_params = fminsearch(@(params) error_function_exponential(params, S_exp, lengths, time, ...
    initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle), initial_params, options);

% Print the optimized parameters
fprintf('Optimized parameters are: \n');
fprintf('Krw0 = %f\n', opt_params(1));
fprintf('Kro0 = %f\n', opt_params(2));
fprintf('nw = %f\n', opt_params(3));
fprintf('no = %f\n', opt_params(4));
fprintf('Swr = %f\n', opt_params(5));
fprintf('Sor = %f\n', opt_params(6));
fprintf('B = %f\n', opt_params(7));
fprintf('K = %f\n', opt_params(8));
fprintf('a = %e\n', opt_params(9));

% Use the optimized parameters
Krw0 = opt_params(1);
Kro0 = opt_params(2);
nw = opt_params(3);
no = opt_params(4);
Swr = opt_params(5);
Sor = opt_params(6);
B = opt_params(7);
K = opt_params(8);
a = opt_params(9);
% Compute the fitted saturation distribution based on the optimized parameters
S_fitted = model_exponential(opt_params, lengths, time, initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle);

% Plot the experimental data and the fitted results
figure;
hold on;
plot(lengths, S_exp, 'o'); % Experimental data
plot(lengths, S_fitted, '-'); % Fitted data
xlabel('Length (cm)');
ylabel('Water Saturation');
legend('Experimental Data', 'Fitted Data');
title('Comparison of Experimental Data and Fitted Results');
hold off;