v2_start = [1 0];
p2_start = [0 1];
p1 = [0 0];
r_start = 1e6;
m2 = 1;
m1 = 1e10;

G = 2*6.67408e-11// [m^3 / (kg * s^2)] gravitationskonstante

nMax = 20;
dt = 0.1;

v2 = v2_start;
p2 = p2_start;
t=0;

plot(p1(1),p1(2),'x')

for n=1:nMax
//    n=1
    //disp(p2)
    //plot(t, sqrt(r(1)^2 + r(2)^2),'x')
    r = p1 - p2($,:);
    a2 = - G * m1 * 1/r^2;
    a2=a2';
    //plot(a2(:,1),a2(:,2),'x')  
        
    //plot(v2(1),v2(2),'x')
    v2 = v2 + a2 * dt;
    //plot(t, sqrt(a2(1)^2 + a2(2)^2),'x')
    //disp(sqrt(a2(1)^2 + a2(2)^2))
    
    //p2 = [ p2 ; p2($,:) + v2 * dt];
    //plot(p2($,1),p2($,2),'x')
    
    p2 = p2($,:) + v2 * dt;
    plot(p2(1),p2(2),'.')
    
    t=t+dt;
end

//plot(p2(1,:),p2(2,:))
