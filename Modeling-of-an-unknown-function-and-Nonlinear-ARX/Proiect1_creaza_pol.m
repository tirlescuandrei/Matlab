function x = Proiect1_creaza_pol(m,k1,k2,x1,x2)
x = [1];
    for i=1:m
        for j=1:m
            if((i==j) && (i+j)<=m)
                x = [x (x1(k1).^i)*(x2(k2).^i) x1(k1).^i x2(k2).^i];
            elseif((i==j) && (i+j)>m)
                x = [x x1(k1).^i x2(k2).^i];
            elseif((i<m)&&(j<m))
                x = [x x1(k1).^i*x2(k2).^j];
            end
        end
    end
end