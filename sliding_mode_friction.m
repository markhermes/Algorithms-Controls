% Parameters
m = 1; % mass
k = 1; % spring constant
c = 0.5; % damping coefficient
f = 0.3; % friction coefficient
x0 = 1; % initial position
v0 = 0; % initial velocity
tspan = [0 10]; % simulation time interval
h = 0.01; % time step size

% Sliding mode controller parameters
k1 = 1;
k2 = 1;

% Define the system dynamics
f_sys = @(t, x) [x(2); (-k/m)*x(1) - (c/m)*x(2) - (f/m)*sign(x(2))];

% Define the sliding surface and its derivative
s = @(t, x) x(1);
dsdt = @(t, x) x(2);

% Define the sliding mode control law
u = @(t, x) (-k1*sign(s(t, x)) - k2*dsdt(t, x)) / ((-k/m)*sign(s(t, x)) - (c/m)*dsdt(t, x));

% Initialize variables
t = tspan(1);
x = [x0; v0];
X = x;
T = t;

% Simulate the system using the fourth-order Runge-Kutta method
while t < tspan(2)
    % Calculate the control input
    u_t = u(t, x);
    
    % Integrate the system dynamics
    k1 = h * f_sys(t, x);
    k2 = h * f_sys(t + h/2, x + k1/2);
    k3 = h * f_sys(t + h/2, x + k2/2);
    k4 = h * f_sys(t + h, x + k3);
    x = x + (k1 + 2*k2 + 2*k3 + k4) / 6;
    
    % Store the simulation results
    t = t + h;
    T = [T; t];
    X = [X x];
end

% Plot the results
figure;
subplot(2,1,1);
plot(T, X(1,:));
xlabel('Time (s)');
ylabel('Position (m)');
title('Position vs. Time');

subplot(2,1,2);
plot(T, X(2,:));
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity vs. Time');
