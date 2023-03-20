close all;
%----------------------------------------------------
%Using the prompt:
%(...)
%----------------------------------------------------

% Define the data
X = [0.5; 0.75; 2.0; 3.0; 4.0];  % inputs
y = [0.2; 0.9; 2.2; 2.5; 3.8];  % outputs

% Set hyperparameters for the GP
sigma_n = 0.01;  % noise variance
sigma_l = 1;     % length scale -- could be considered a part of signal variance
sigma_f = 5;    % signal variance


% Define kernel function
kernel = @(x1, x2, sigma_f, sigma_l) sigma_f^2*exp(-0.5*(x1 - x2)^2/sigma_l^2);

% Compute kernel matrix K
N = length(X);
K = zeros(N, N);
for i = 1:N
    for j = 1:N
        K(i,j) = kernel(X(i), X(j), sigma_f, sigma_l);
    end
end

% Add noise variance to the diagonal of the kernel matrix
K = K + sigma_n^2 * eye(N);

% Compute the mean and covariance of the predictive distribution
X_star = linspace(min(X), max(X), 100);  % test points
K_star = zeros(length(X_star), N);
for i = 1:length(X_star)
    for j = 1:N
        K_star(i,j) = kernel(X_star(i), X(j), sigma_f, sigma_l);
    end
end
K_star_star = zeros(length(X_star), length(X_star));
for i = 1:length(X_star)
    for j = 1:length(X_star)
        K_star_star(i,j) = kernel(X_star(i), X_star(j), sigma_f, sigma_l);
    end
end

%do i really need to add noise here also -- line 28
% mu = K_star * inv(K + sigma_n^2 * eye(N)) * y;
mu = K_star * inv(K) * y;
cov = K_star_star - K_star * inv(K) * K_star';

% Plot the data and the predictive distribution
figure;
hold on;
plot(X, y, 'o', 'MarkerSize', 8, 'LineWidth', 2);
plot(X_star, mu, '-', 'LineWidth', 2);
plot(X_star, mu + 2*sqrt(diag(cov)), '--', 'LineWidth', 2);
plot(X_star, mu - 2*sqrt(diag(cov)), '--', 'LineWidth', 2);
xlabel('x');
ylabel('y');
legend('Data', 'Mean', 'Upper Bound', 'Lower Bound');
