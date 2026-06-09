function NLOSv = step9_calculate_nlosv(X, Y)
%STEP9_CALCULATE_NLOSV Simplified local copy of WiLabV2Xsim NLOSv counting logic.

Nvehicles = length(X);
thresholdDistance = 1.5;

X1 = repmat(X', length(X), 1);
X2 = repmat(X, 1, length(X));
Y1 = repmat(Y', length(Y), 1);
Y2 = repmat(Y, 1, length(Y));

m = (Y2 - Y1) ./ (X2 - X1);
q = Y2 - m .* X2;
m_perp = -1 ./ m;

NLOSv = zeros(Nvehicles, Nvehicles);
for i = 1:Nvehicles
    X_obstructing = X(i);
    Y_obstructing = Y(i);
    q_perp = Y_obstructing - m_perp * X_obstructing;
    dist = abs(Y_obstructing - (m .* X_obstructing + q)) ./ sqrt(1 + m .* m);
    dist(isinf(m)) = abs(X_obstructing - X1(isinf(m)));
    dist(i, :) = inf;
    dist(:, i) = inf;

    x_projected = (q_perp - q) ./ (m + 1 ./ m);
    x_projected(m == 0) = X_obstructing;
    y_projected = m .* x_projected + q;
    y_projected(isinf(m)) = Y_obstructing;

    outOfSegment = ((x_projected < X1 & x_projected < X2) | (x_projected > X1 & x_projected > X2)) | ...
        ((y_projected < Y1 & y_projected < Y2) | (y_projected > Y1 & y_projected > Y2));

    itObstructs = (dist < thresholdDistance) .* (~outOfSegment);
    NLOSv = NLOSv + itObstructs;
end
end

