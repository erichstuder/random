pkg load control

close all

R = 1;
C = 1;

s = tf('s');
Xc = 1/(s*C);

g1 = Xc / (R+Xc);


u = 0.5;
i = 0;
for n=0:1
	i = i + u/Xc;
	u = i * (0.25*R + Xc);
end

g_tot = 1/u;
g_tot
bode(g_tot, g1)
