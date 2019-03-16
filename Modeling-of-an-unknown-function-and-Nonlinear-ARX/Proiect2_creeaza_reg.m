function [fi_l] = Proiect2_creeaza_reg(u,y,na,nb,m,index)
    y_aux = []; u_aux = []; 
    % iesirile si intrarile intarziate cu na, nb
    for k1=1:na
        y_aux = [y_aux y(index-k1)];
    end
    for k2=1:nb
        u_aux = [u_aux u(index-k2)];
    end
    % vectorul de intrari si iesiri intarziate
    var = [u_aux y_aux];
    grad = m; dim_var = length(var); reg = 1;
    
    for k=2:dim_var
        C = nchoosek(var,k);
        L_col = length(C(:,1));
        L_lin = length(C(1,:));
        q = 2; % puterea pentru combinatiile de variabile care inmultite dau gradul <= gradul impus
        v = ones(1,L_lin); % vectorul de puteri
        poz = 1; % pozitia in vectorul de puteri
        
        if(L_lin <= grad)
            if(L_lin == dim_var)
                % toate puterile
                for i=1:grad
                    reg = [reg C(1,:).^i];
                end
            end
            % Combinatii cu aceleasi puteri
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
    fi_l = reg;
end