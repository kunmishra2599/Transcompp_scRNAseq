function trans_constr = genSelfTransConstraints(states)
s = length(states);
trans_constr = zeros(s,4);
for i = 1:s
    trans_constr(i,:) = [states(i) states(i) 0.5 1];
end
end