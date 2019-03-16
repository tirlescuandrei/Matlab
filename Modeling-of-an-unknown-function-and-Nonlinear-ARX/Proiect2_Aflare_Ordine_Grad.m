close all; clear; clc;
load('iddata-12.mat');

%% Date de lucru
grad_maxim = 3; MSE_id = []; MSE_val = []; i=1;
MSE_val_min = 1;

%% Determinare model sistem pentru MSE minim
for m=1:grad_maxim
    for na=1:grad_maxim
        for nb=1:grad_maxim
            %% ID
            % Date initiale
            uid = id.u; yid = id.y;
            uid = [zeros(1,na+nb) uid']; % adaugam zerouri pentru a putea parcurge intarzirile la inceput ale vectorilor u si y
            yid = [zeros(1,na+nb) yid'];
            N = length(yid);
            % Calculul matricii fi
            for j=1+na+nb:N
                fi(j,:) = Proiect2_creeaza_reg(uid,yid,na,nb,m,j);
            end
            % Calculul vectorului de parametrii prin rezolvarea sistemului liniar
            teta = linsolve(fi,yid');
            % Calculul iesiri aproximate
            y_aprox = fi*teta;
            % Calculul erorii medii patratice
            MSE_id(i) = 1/N*sum((yid-y_aprox').^2);
            % Vectori pentru a retine ordinele sistemului in vectorul MSE
            Na(i) = na; Nb(i) = nb; M(i) = m;
       
            %% VAL
            % Date initiale
            uval = val.u; yval = val.y;
            uval = [zeros(1,na+nb), uval'];
            yval = [zeros(1,na+nb), yval'];
            N = length(yval);
            % Calculul matricii fi
            for j=1+na+nb:N
                fi_val(j,:) = Proiect2_creeaza_reg(uval,yval,na,nb,m,j);
            end
            % Calculul iesiri aproximate
            y_aprox_val = fi_val*teta;
            % Calculul erorii medii patratice
            MSE_val(i) = 1/N*sum((yval-y_aprox_val').^2);
            % Aflarea ordinelor sistemului na si nb si gradului m pentru cel mai mic MSE
            if(MSE_val(i) < MSE_val_min)
                MSE_val_min = MSE_val(i);
                na_min_val = na;
                nb_min_val = nb;
                m_min_val = m;
            end
            % Index de retinere a pozitiei vectorului MSE
            i = i+1;
            clear fi fi_val;
        end
    end
end
% Vectorul asociat MSE-ului si ordinelor sistemului
Ordin = [MSE_id; MSE_val; Na; Nb; M]';
fprintf('na_min=%d, nb_min=%d, m_min=%d\n',na_min_val,nb_min_val,m_min_val);