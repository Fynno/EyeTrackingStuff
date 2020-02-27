%% Possible Parameters
d1 = 0.25;  %Length center of body to shoulder
d2 = 0.3;   %Length upper arm
d3 = 0;
a3 = 0.35;  %Length lower arm
a_12 = 0;

alpha1 = 90;
alpha2 = -90;
alpha3 = 0;

%%

P_world = [0.35;-0.3;0.25]

t3 = 90 - acosd((norm(P_world-[0;0;d1])^2-d2^2-a3^2)/-2*d2*a3); %% zwei lösungen
t2 = asind((P_world(3)-d1)/a3*cosd(t3));
P_t1_0 = calcRotMatr(0,d1,a_12,alpha1)*calcRotMatr(t2,d2,a_12,alpha2)*calcRotMatr(t3,d3,a3,alpha3)*[0;0;0;1];
t1 = atan2d(P_world(2),P_world(1))-atan2d(P_t1_0(2),P_t1_0(1));
q = [t1 t2 t3]