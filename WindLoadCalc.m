
%This program will calculate the wind load for different sections
%of the ground station given a wind speed
%the ground station geometry can be seperated into two main categories
%rectangular shaped or cylindrically shaped
%and 4 main parts
%Antenna 1, Antenna 2, Crossboom, and Mast 

%the wind load should be evaluated at 0-360 degrees
%define cd
Cds1 = 0.82; %face towards wind
Cds2 = 1.17; %rounded edge towards wind
Cdc = 1.05; %cubical
Cdr = 2.05; %rectangular

%areas (m^2)
%Mast area (constant regardless of orientation)
Ma = 0.182;

%crossboom area
Mc1 = 0.265; %rounded face
Mc2= 0.002; %flat face

%antenna areas
%432-440 Mhz
%Front/Back(long side perpendicular to wind)
AntArea432FBs2 = 0.146941642;
AntArea432FBs1 = 0.00024903176;
%Right/Left(Short side perpendicular to wind)
AntArea432RLs2 = 0.000506644148;
AntArea432RLs1 = 0.0089290144;

%143-148 MHz
%Front/Back(long side perpendicular to wind)
AntArea143FBs2 = 0.127690067;
AntArea143FBs1 = 0.00014258036;
%Right/Left(Short side perpendicular to wind)
AntArea143RLs2 = 0.030496713;
AntArea143RLs1 = 0.0089290144;



%other constants/variables
pA = 102.22; %kpa(higher bound)
R = 8.314462618; %R constant
Ma = 28.9652; %Molar mass air
v = [0,0];
x = 0;
y = 1;
pD = [0,0];
resultMatrix = zeros;


%calculate air density
T = input('Enter temperature in K: ');
v = input('Enter average wind speed range [low to high, seperated by a comma] in m/s: ');
vmax = input('Enter the max gust wind speed expected, in m/s: ');
x = v(1,2);
vsp = input('Enter a specific wind speed, if desired: ');

p = ((pA*Ma) / (R*T)); %air density(kg / m^3)

%pD = (.5)*(p)*(v^2); %dynamic pressure (kg / m*s^2)

while x > 0
    pD(1,y) = ((0.5* p)* x^2);
    x = x - 0.5;
    y = y + 1;
end

pDsp = ((0.5 * p) * vsp^2);



pdMaxAvg = max(pD);
pDmax = (0.5 * p) * vmax^2;


%0 degrees - 360 degrees for mast(cylindrical)
%F = ApDCd(N)
Fmast = Ma * pdMaxAvg * Cds2;
FmastMax = Ma * pDmax * Cds2;

resultMatrix(1,1) = Fmast;
resultMatrix(2,1) = FmastMax;

%Crossboom front/back
FcbFB = Mc1 * pdMaxAvg * Cds2;
FcbFBmax = Mc1 * pDmax * Cds2;

resultMatrix(1,2) = FcbFB;
resultMatrix(2,2) = FcbFBmax;

%Crossboom right/left
FcbRL = Mc2 * pdMaxAvg * Cds1;
FcbRLmax = Mc2 * pDmax * Cds1;

resultMatrix(1,3) = FcbRL;
resultMatrix(2,3) = FcbRLmax;

%432 Mhz front/back
F432FB = (AntArea432FBs1 *pdMaxAvg * Cds1) + (AntArea432FBs2 *pdMaxAvg * Cds2);
F432FBmax = (AntArea432FBs1 *pDmax * Cds1) + (AntArea432FBs2 *pDmax * Cds2);

resultMatrix(1,4) = F432FB;
resultMatrix(2,4) = F432FBmax;

%432 MHz right/left
F432RL = (AntArea432RLs1 *pdMaxAvg * Cds1) + (AntArea432RLs2 *pdMaxAvg * Cds2);
F432RLmax = (AntArea432RLs1 *pDmax * Cds1) + (AntArea432RLs2 *pDmax * Cds2);

resultMatrix(1,5) = F432RL;
resultMatrix(2,5) = F432RLmax;


%143 Mhz front/back
F143FB = (AntArea143FBs1 *pdMaxAvg * Cds1) + (AntArea143FBs2 *pdMaxAvg * Cds2);
F143FBmax = (AntArea143FBs1 *pDmax * Cds1) + (AntArea143FBs2 *pDmax * Cds2);

resultMatrix(1,6) = F143FB;
resultMatrix(2,6) = F143FBmax;

%143 Mhz right/left
F143RL = (AntArea143RLs1 *pdMaxAvg * Cds1) + (AntArea143RLs2 *pdMaxAvg * Cds2);
F143RLmax = (AntArea143RLs1 *pDmax * Cds1) + (AntArea143RLs2 *pDmax * Cds2);

resultMatrix(1,7) = F143RL;
resultMatrix(2,7) = F143RLmax;

%specfic wind speed
if vsp ~= 0
    Fmastsp = Ma * pDsp * Cds2;
    resultMatrix(3,1) = Fmastsp;
   
    FcbFBsp = Mc1 * pDsp * Cds2;
    FcbRLsp = Mc2 * pDsp * Cds1;

    resultMatrix(3,2) = FcbFBsp;
    resultMatrix(3,3) = FcbRLsp;
  
    F432FBsp = (AntArea432FBs1 *pDsp * Cds1) + (AntArea432FBs2 *pDsp * Cds2);
    F432RLsp = (AntArea432RLs1 *pDsp * Cds1) + (AntArea432RLs2 *pDsp * Cds2);
   
    resultMatrix(3,4) = F432FBsp;
    resultMatrix(3,5) =F432RLsp;

    F143FBsp = (AntArea143FBs1 *pDsp * Cds1) + (AntArea143FBs2 *pDsp * Cds2);
    F143RLsp = (AntArea143RLs1 *pDsp * Cds1) + (AntArea143RLs2 *pDsp * Cds2);

    resultMatrix(3,6) = F143FBsp;
    resultMatrix(3,7) = F143RLsp;
   
end

%output results
fprintf('\n\nALL VALUES ARE in Newtons, in the order [AVERAGE, MAX, SPECIFIC]\n')
fprintf('The results are as follows\n')
fprintf('Mast: [%d , %d , %d]', resultMatrix(1,1), resultMatrix(2,1), resultMatrix(3,1))
fprintf('\nCrossboom Front/Back: [%d , %d , %d]', resultMatrix(1,2), resultMatrix(2,2), resultMatrix(3,2))
fprintf('\nCrossboom Right/Left: [%d , %d , %d]', resultMatrix(1,3), resultMatrix(2,3), resultMatrix(3,3))
fprintf('\n432Mhz Front/Back: [%d , %d , %d]', resultMatrix(1,4), resultMatrix(2,3), resultMatrix(3,4))
fprintf('\n432Mhz Right/Left: [%d , %d , %d]', resultMatrix(1,5), resultMatrix(2,3), resultMatrix(3,5))
fprintf('\n143Mhz Front/Back: [%d , %d , %d]', resultMatrix(1,6), resultMatrix(2,3), resultMatrix(3,6))
fprintf('\n143Mhz Right/Left: [%d , %d , %d]', resultMatrix(1,7), resultMatrix(2,3), resultMatrix(3,7))




