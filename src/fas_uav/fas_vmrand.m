function th = fas_vmrand(mu, kappa, N)
%FAS_VMRAND Draw von-Mises-like angular samples.
if kappa < 1e-8
    th = mu + (rand(N, 1) * 2 - 1) * pi;
    return;
end

a = 1 + sqrt(1 + 4 * kappa^2);
b = (a - sqrt(2 * a)) / (2 * kappa);
r = (1 + b^2) / (2 * b);
th = zeros(N, 1);
for i = 1:N
    while true
        u = rand(3, 1);
        z = cos(pi * u(1));
        f = (1 + r * z) / (r + z);
        c = kappa * (r - f);
        if u(2) < c * (2 - c) || log(c / u(2)) + 1 - c >= 0
            break;
        end
    end
    th(i) = sign(u(3) - 0.5) * acos(f) + mu;
end
end
