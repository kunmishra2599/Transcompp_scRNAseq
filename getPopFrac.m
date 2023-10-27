function pop_frac = getPopFrac(scStateDef,data)

ineq_vals = {'<','<=','==','>','>='};
numStates = size(scStateDef,1);
pop_frac = zeros(1,numStates);
for s = 1:numStates
    stateDef = scStateDef{s,1};
    l = size(stateDef,1);
    state_str = '';
    for i = 1:l
        coeff = stateDef{i,1};
        ineq = stateDef{i,2};
        thres = stateDef{i,3};
        chain = stateDef{i,4};
        if ~isempty(chain)
            chain = strrep(chain,'and',' & ');
            chain = strrep(chain,'or',' | ');
        end
        var_id = ['val',num2str(i)];
        eval([var_id,' = coeff*data;']);
        to_add = [var_id,' ',ineq_vals{ineq},' ',num2str(thres),' ',chain];
        state_str = [state_str,to_add];
    end
    eval(['test = sum(',state_str,');']);
    pop_frac(1,s) = test;
end
pop_frac = pop_frac/sum(pop_frac);
end