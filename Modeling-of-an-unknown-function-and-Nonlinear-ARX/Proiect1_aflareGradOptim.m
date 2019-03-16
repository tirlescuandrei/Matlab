close all; clear; clc;
load('proj_fit_03.mat');
%% Date ID
x1 = id.X{1,1};
x2 = id.X{2,1};
N = length(x1);
y = id.Y; yflat = reshape(y,N*N,1); % yflat -> vector coloana, pentru a facilita calculul lui teta si implitic lui g_aprox_val
m = 1:30; % grad polinom
MSE_val_min = 1;
%% Date VAL
x1_val = val.X{1,1};
x2_val = val.X{2,1};
N_val = length(x1_val);
y_val = val.Y; y_val_flat = reshape(y_val,N_val*N_val,1);
%% Calculul matricei de regresori pentru identificare- Fi
for i=1:length(m)
    fi = [];
    for k1=1:N
          for k2=1:N
             fi = [fi;Proiect1_creaza_pol(m(i),k1,k2,x1,x2)];
          end
    end
    %% Calcul vectorului de parametrii - teta
    teta = linsolve(fi,yflat);
    %% Calculul functie aproximate - g
    gflat = fi*teta;
    g = reshape(gflat,[N,N]); % transformam matricea coloana g in matrice patratica
    %% Calculul erorii medii patratice - ID
    e = sum((y-g).^2);
    MSE(i) = 1/(N^2)*sum(e);
    %% Calculul matricei de regresori pentru validare - fi_val
    fi_val = [];
    for k1=1:N_val
          for k2=1:N_val
              fi_val = [fi_val;Proiect1_creaza_pol(m(i),k1,k2,x1_val,x2_val)];
          end
    end
    %% Calculul functiei aproximate folosind vectorul teta din datele de identificare - g_val
    g_val_flat = fi_val*teta;
    g_val = reshape(g_val_flat,[N_val,N_val]);
    %% Calculul erorii medii patratice - VAL
    e_val = sum((y_val-g_val).^2);
    MSE_val(i) = 1/(N_val^2)*sum(e_val);
    clear fi_val; clear fi;
end
% Vector creat pentru a compara MSE-ul
Valori_MSE = [MSE;MSE_val]';

% Aflarea gradului m pentru care MSE este minim
for i=1:length(MSE_val)
    if(MSE_val(i) < MSE_val_min)
        MSE_val_min = MSE_val(i);
        index = i;
    end
end
fprintf('MSE_val(min) = %d\n',min(MSE_val));
fprintf('m = %d\n',index);

%% Plotam graficele erorilor medii patratice pentru datele de ID si VAL -> alegem gradum m minim
figure; plot(m,MSE); hold on; plot(m,MSE_val,'r'); hold on; plot(index,MSE_val_min,'g*'); xlabel('m'); ylabel('MSE');
title('Grafic MSE'); legend('ID','VAL');