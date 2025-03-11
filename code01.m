% Clear workspace and initialize parameters
clear;
clc;

% Define global parameters (initial guesses)
global Krw0 Kro0 nw no Swr Sor B K phi mu_w mu_o;

Krw0 = 0.256;
Kro0 = 0.902;
nw = 1.973; 
no = 1.482;
Swr = 0.294;
Sor = 0.396;
B = 13.96;
K = 0.00025;
phi = 0.0089;
mu_w = 1;
mu_o = 10;

% Define experimental parameters
initial_interfacial_tension = 100.15; % Initial interfacial tension
final_interfacial_tension = 90.52;    % Final interfacial tension
initial_contact_angle = 130;          % Initial contact angle (degrees)
final_contact_angle = 100;            % Final contact angle (degrees)

% Load data
data = xlsread('data.xlsx');
lengths = data(:, 1);
S_exp = data(:, 2:end);
time = linspace(0, max(lengths), size(S_exp, 2)); % Assume time is uniformly distributed

% Initial saturation
S_init = S_exp(:, 1);

% Define initial guesses for all parameters to be optimized
initial_params = [Krw0, Kro0, nw, no, Swr, Sor, B, K, phi, mu_w, mu_o];

% Optimize all parameters using lsqcurvefit
options = optimoptions('lsqcurvefit', 'Display', 'iter', 'Algorithm', 'trust-region-reflective');
opt_params = lsqcurvefit(@(params, time) model_function(params, S_init, lengths, time, ...
    initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle), initial_params, time, S_exp, [], [], options);

% Print optimized parameters
fprintf('Optimized parameters:\n');
disp(opt_params);

% Use the optimized parameters to calculate the fitted saturation distribution
S_fitted = model(opt_params, S_init, lengths, time, initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle);

% Plot the comparison between experimental data and fitted results
figure;
hold on;
plot(lengths, S_exp, 'o', 'DisplayName', 'Experimental Data'); % Experimental data
plot(lengths, S_fitted, '-', 'DisplayName', 'Fitted Results'); % Fitted results
xlabel('Length (cm)');
ylabel('Water Saturation');
legend('Location', 'Best');
title('Comparison of Experimental Data and Fitted Results');
hold off;

% Plot the saturation distribution at different time points
figure;
hold on;
for i = 1:size(S_exp, 2)
    plot(lengths, S_fitted(:, i), 'DisplayName', ['Time Point ', num2str(i)]);
end
xlabel('Length (cm)');
ylabel('Water Saturation');
legend('Location', 'Best');
title('Saturation Distribution at Different Time Points');
hold off;
