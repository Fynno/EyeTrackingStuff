%%Kinematics of Arm

syms theta1
syms theta2
syms theta3

syms d1
syms d2
syms d3

a_i = 0;
a_3 = d3;
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

        
     