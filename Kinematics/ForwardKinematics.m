%%Kinematics of Arm (Variables)
syms theta1 theta2 theta3
syms d1 d2 d3

a_i = 0;
syms a_3
alpha1 = 90;
alpha2 = -90;
alpha3 = 0;

T_1 =[cos(theta1),-sin(theta1)*cosd(alpha1),sin(theta1)*sind(alpha1),a_i*cos(theta1);
    sin(theta1),cos(theta1)*cosd(alpha1),-cos(theta1)*sind(alpha1),a_i*sin(theta1);
    0,sind(alpha1), cosd(alpha1), d1;
    0, 0, 0, 1];

T_2 =[cos(theta2),-sin(theta2)*cosd(alpha2),sin(theta2)*sind(alpha2),a_i*cos(theta2);
    sin(theta2),cos(theta2)*cosd(alpha2),-cos(theta2)*sind(alpha2),a_i*sin(theta2);
    0,sind(alpha2), cosd(alpha2), d2;
    0, 0, 0, 1];

T_3 =[cos(theta3),-sin(theta3)*cosd(alpha3),sin(theta3)*sind(alpha3),a_3*cos(theta3);
    sin(theta3),cos(theta3)*cosd(alpha3),-cos(theta3)*sind(alpha3),a_3*sin(theta3);
    0,sind(alpha3), cosd(alpha3), 0;
    0, 0, 0, 1];

T_3_to_0 = T_1*T_2*T_3
%% Plot 
%%Kinematics of Arm
fixPara = struct('d1',0.25,'d2',0.3,'d3',0,'a1',0,'a2',0,'a3',0.35,'alpha1',90,'alpha2',-90,'alpha3',0);

theta1 = 50;
theta2 = 60;
theta3 = 20;
q_soll = [theta1,theta2,theta3];

T_1 =calcRotMatr(q_soll(1),fixPara.d1,fixPara.a1,fixPara.alpha1);
T_2 =calcRotMatr(q_soll(2),fixPara.d2,fixPara.a2,fixPara.alpha2);
T_3 =calcRotMatr(q_soll(3),fixPara.d3,fixPara.a3,fixPara.alpha3);

T3to0 = T_1*T_2*T_3;

T1Origin=T_1*[0; 0;0;1];
T2Origin=T_1*T_2*[0; 0;0;1];
T3Origin=T3to0*[0; 0;0;1]

q_soll
q = calcJointCord(T3Origin(1:3),fixPara)

x = [0;T1Origin(1);T2Origin(1);T3Origin(1)];
y = [0;T1Origin(2);T2Origin(2);T3Origin(2)];
z = [0;T1Origin(3);T2Origin(3);T3Origin(3)];

line(x,y,z)
        
     