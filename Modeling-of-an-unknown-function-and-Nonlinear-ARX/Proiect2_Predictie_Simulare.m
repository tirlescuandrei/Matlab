close all; clear; clc;
load('iddata-12.mat');

%% Predictie
    %% ID
    uid = id.u; yid = id.y;
    na=1; nb=1; m = 3; % determinate in scriptului Proiect2_Aflare_Ordin_Grad
    uid = [zeros(1,na+nb) uid'];
    yid = [zeros(1,na+nb) yid'];
     
    N = length(uid); Ts = id.Ts;
    % Alegem un inverval mai mic pentru a plota datele si a vedea mai bine graficele
    interval = 400:800;

    for i=1+na+nb:N
        fi(i,:) = Proiect2_creeaza_reg(uid,yid,na,nb,m,i);
    end
    teta = linsolve(fi,yid');
    y_aprox = fi*teta;

    MSE = 1/N*sum((yid-y_aprox').^2);
    plot(yid(interval),'r'); hold on; plot(y_aprox(interval),'b'); 
    xlabel('Time'); ylabel('y');
    legend('yid','y_a_p_r_o_x'); title(['IDENTIFICARE    MSE=',num2str(MSE)]);

    %% VAL

    uval = val.u; yval = val.y;
    uval = [zeros(1,na+nb), uval'];
    yval = [zeros(1,na+nb), yval'];
    N = length(uval);
    
    for i=1+na+nb:N
        fi_val(i,:) = Proiect2_creeaza_reg(uval,yval,na,nb,m,i);
    end
    y_aprox_val = fi_val*teta;
    MSE_val = 1/N*sum((yval-y_aprox_val').^2);
    figure; plot(yval(interval),'r'); hold on; plot(y_aprox_val(interval),'b'); 
    xlabel('Time'); ylabel('y');
    legend('yval','y_a_p_r_o_x'); title(['VALIDARE     MSE=',num2str(MSE_val)]);

    
%% Simulare
    %% ID
    u_sim_id = uid;
    y_sim_id = zeros(1,na+nb);
    N = length(u_sim_id);

    for i=1+na+nb:N
        % la fiecare iteratie se calculeaza y(i) cu valorile aproximate anterior
        y_l = Proiect2_creeaza_reg(u_sim_id,y_sim_id,na,nb,m,i);
        % se actualizeaza vectorul de iesire simulat
        y_sim_id = [y_sim_id y_l*teta];
    end
    
    MSE_sim_id = 1/N*sum((yid-y_sim_id).^2);
    figure; plot(yid(interval),'r'); hold on; plot(y_sim_id(interval),'b'); 
    xlabel('Time'); ylabel('y');
    legend('y_v_a_l','y_s_i_m'); title(['IDENTIFICARE   MSE=',num2str(MSE_sim_id)]);
    
    %% VAL
    u_sim_val = uval;
    y_sim_val = zeros(1,na+nb); % vector initial de valori
    N = length(u_sim_val);
    
    for i=1+na+nb:N
        y_l = Proiect2_creeaza_reg(u_sim_val,y_sim_val,na,nb,m,i);
        y_sim_val = [y_sim_val y_l*teta];
    end
    
    MSE_sim_val = 1/N*sum((yval-y_sim_val).^2);
    figure; plot(yval(interval),'r'); hold on; plot(y_sim_val(interval),'b'); 
    xlabel('Time'); ylabel('y');
    legend('y_v_a_l','y_s_i_m'); title(['VALIDARE   MSE=',num2str(MSE_sim_val)]);