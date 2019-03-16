close all; clear; clc;

syms y1 u1 % y1 = y(i-1), u1 = u(i-1)
var = [y1 u1];

grad = 3; reg = 1; dim_var = length(var);

for k=2:dim_var
    C = nchoosek(var,k);
    L_col = length(C(:,1));
    L_lin = length(C(1,:));
    q = 2; v = ones(1,L_lin); poz = 1;
    
    if(L_lin <= grad)
        if(L_lin == dim_var)
            % toate puteriil
            for i=1:grad
                reg = [reg C(1,:).^i];
            end
        end
        % Combinatii cu acelesi puteri
        if(L_lin <= grad/L_lin)
            while(L_lin*q <= grad)
                C_aux = C;
                for i=1:L_lin
                    C_aux(:,i) = C(:,i).^q; % ridicam toate coloanele la puterea q
                end
                for i=1:L_col
                    reg = [reg prod(C_aux(i,:))]; % inmultim toate liniile
                end
                q = q+1;
            end
        end
        % Combinatii puteri diferite
        while(poz+length(v)-1 <= grad && poz <= L_lin)
            v_aux = v;
            if(poz > 1) % sa nu luam iara vectorul ones
                v_aux(poz) = v_aux(poz)+1;
            end
            while(sum(v_aux) <= grad)
                C_aux = C;
                for j=1:L_col
                    % ridicam toata linia la vectorul de puteri v
                    C_aux(j,:) = C_aux(j,:).^v_aux; 
                    reg = [reg prod(C_aux(j,:))];
                end
                v_aux(poz) = v_aux(poz)+1;
            end
            poz = poz+1;
        end
    end
end
fprintf('%s,',reg);