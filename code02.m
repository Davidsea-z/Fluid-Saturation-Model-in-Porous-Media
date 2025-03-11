% Clear workspace and initialize parameters
clear;
clc;

% Define global parameters
global Krw0 Kro0 nw no Swr Sor B K phi mu_w mu_o;

% Set global parameter values
Krw0 = 0.256;
Kro0 = 0.902;
nw = 1.973; 
no = 1.482;
Swr = 0.694;
Sor = 0.396;
B = 13.96;
K = 0.25;
phi = 0.089;
mu_w = 1000;
mu_o = 10;

% Define experimental parameters
initial_interfacial_tension = 100.15; % Initial interfacial tension
final_interfacial_tension = 90.52;    % Final interfacial tension
initial_contact_angle = 130;          % Initial contact angle (degrees)
final_contact_angle = 100;            % Final contact angle (degrees)

% Read data
data = xlsread('data.xlsx');
lengths = data(:, 1);
S_exp = data(:, 2:end);
time = linspace(0, max(lengths), size(S_exp, 2)); % Assume time is uniformly distributed

% Initial saturation
S_init = S_exp(:, 1);

% Define initial guess (only optimize parameter a)
initial_a = 1e-5;

% Optimize parameter a using nonlinear optimization with lsqcurvefit
options = optimoptions('lsqcurvefit', 'Display', 'iter', 'Algorithm', 'trust-region-reflective');
opt_a = lsqcurvefit(@(a, time) model_function(a, S_init, lengths, time, ...
    initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle), initial_a, time, S_exp, [], [], options);

% Print the optimized value of parameter a
fprintf('Optimized value of parameter a: %e\n', opt_a);

% Initialize the fitted results matrix
S_fitted = zeros(size(S_exp));

% Compute the fitted saturation distribution using the optimized parameter a
params = [opt_a, K, phi, mu_w, mu_o];
S_fitted = model(params, S_init, lengths, time, initial_interfacial_tension, final_interfacial_tension, initial_contact_angle, final_contact_angle);

% Smooth the fitted results
S_fitted_smooth = smooth(S_fitted(:), 0.1, 'loess');
S_fitted_smooth = reshape(S_fitted_smooth, size(S_fitted));

   % Fit the experimental data column by column
   for i = 1:size(S_exp, 2)
       
       %ft = fittype('a*exp(b*x)');
       ft = fittype(@(a, b, x) ...
       a.* (Krw0 * Kro0 / (mu_w * mu_o)) .* exp(b .* x .* ((nw + no) / (Swr + Sor)) .* (K + phi) .* B), ...
       'independent', 'x', 'coefficients', {'a', 'b'});
   
       % Perform the fitting and return the fit object
       fit_result = fit(lengths, S_exp(:, i), ft);
       
       % Compute the fitted values
      S_fitted(:, i) = fit_result(lengths);
   end

% Plot the comparison between experimental data and the fitted results
figure;
hold on;
plot(lengths, S_exp, 'o', 'DisplayName', 'Experimental Data'); % Experimental data
plot(lengths, S_fitted, '-', 'DisplayName', 'Fitted Results'); % Fitted results
xlabel('Length (cm)');
ylabel('Water Saturation');
legend('Location', 'Best');
title('Comparison Between Experimental Data and Fitted Results');
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
