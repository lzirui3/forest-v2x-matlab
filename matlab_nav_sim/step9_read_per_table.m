function [sinrVectorOut, PERout, sinr_dB_fromtable, PER_fromtable, sinr_lin_fromtable_interp, PER_interp] = step9_read_per_table(fileName, nInterp)
%STEP9_READ_PER_TABLE Local copy of WiLabV2Xsim PER-table reader.

if ~exist(fileName, 'file')
    error('PER table file does not exist: %s', fileName);
end

PERtable_ori = load(fileName);
[PERtable(:, 2), I] = unique(PERtable_ori(:, 2), 'stable'); %#ok<AGROW>
PERtable(:, 1) = PERtable_ori(I, 1);

sinr_dB_fromtable = PERtable(:, 1);
PER_fromtable = PERtable(:, 2);

if PER_fromtable(1) ~= 1
    PER_fromtable = [1; PER_fromtable];
    sinr_dB_fromtable = [sinr_dB_fromtable(1) - 0.01; sinr_dB_fromtable];
end

if PER_fromtable(end) == 0
    PER_fromtable(end) = 1e-8;
elseif PER_fromtable(end) ~= 0
    PER_fromtable(end + 1) = 1e-8;
    sinr_dB_fromtable(end + 1) = sinr_dB_fromtable(end) + 0.01;
end

PER_step = 1 / nInterp;
PER_interp = PER_step:PER_step:1;

sinr_dB_fromtable_interp = interp1(10 * log10(PER_fromtable), sinr_dB_fromtable, 10 * log10(PER_interp));
sinr_lin_fromtable_interp = 10 .^ (sinr_dB_fromtable_interp / 10);

PERout = PER_interp;
sinrVectorOut = 10 * log10(sinr_lin_fromtable_interp);
end

