close all; clear; clc;
load('proj_fit_03.mat');
%% Date ID
x1 = id.X{1,1};
x2 = id.X{2,1};
N = length(x1);
y = id.Y; yflat = reshape(y,N*N,1); 
mesh(x1,x2,y); title('y_I_d'); xlabel('x1'); ylabel('x2'); zlabel('y');
m = 14;
%% Date VAL
x1_val = val.X{1,1};
x2_val = val.X{2,1};
N_val = length(x1_val);
y_val = val.Y; y_val_flat = reshape(y_val,N_val*N_val,1);
figure; mesh(x1_val,x2_val,y_val); title('y_V_a_l'); xlabel('x1'); ylabel('x2'); zlabel('y');

%% Calculul vectorului teta pentru un m dat
fi = [];
for k1=1:N
    for k2=1:N
        fi = [fi;Proiect1_creaza_pol(m,k1,k2,x1,x2)];
    end
end
teta = linsolve(fi,yflat);
gflat = fi*teta;
g = reshape(gflat,[N,N]);
e = sum((y-g).^2);
MSE = 1/(N^2)*sum(e);
figure; mesh(x1,x2,g); title(['g_I_D_-_m_=_',num2str(m),'    MSE=',num2str(MSE)]); 
xlabel('x1'); ylabel('x2'); zlabel('y');

%% Calcul functiei g_val pentru un m folosind vectorul teta
fi_val = [];
for k1=1:N_val
    for k2=1:N_val
        fi_val = [fi_val;Proiect1_creaza_pol(m,k1,k2,x1_val,x2_val)];
    end
end

g_val_flat = fi_val*teta;
g_val = reshape(g_val_flat,[N_val,N_val]);

e_val = sum((y_val-g_val).^2);
MSE_val = 1/(N_val^2)*sum(e_val);
figure; mesh(x1_val,x2_val,g_val); title(['g_V_A_L_-_m_=_',num2str(m),'     MSE=',num2str(MSE_val)]); 
xlabel('x1'); ylabel('x2'); zlabel('y');