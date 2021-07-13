close all;
clc;
disp('PHASE CORRECTION IN DIRECT-FED REFLECTARRAY ANTENNA ');
frequency=input('Enter the Desired Frequency:(in Giga Hertz)  ');
c=3*10^8;
lambda=c/(frequency*10^9);
disp(lambda);

rel_permitivity=input('Enter the value of Relative Permitivity  ');
 
wavelength_guided=lambda/sqrt(rel_permitivity);
patch_size=0.5*lambda*1000;
row=input('Enter the no. of ROWs of array elements  ');
column=input('Enter the no. of COLUMNs of array elements ');
focalpt=row*patch_size;
disp('Focal point is ');
disp(focalpt);
disp('Generating phase shift of Array Elements as Zeros  ');
A=zeros(row,column);
disp(A);
psx= zeros(row,column);
psy=zeros(row,column);
check = mod(row,2);
if check == 0
    centerx=floor(row/2);
else
    centerx = floor(row/2)+1;
end
 
if check == 0
    centery=floor(column/2);
else
    centery=floor(column/2)+1;
end
 
posx(centerx,centerx) = 0;
%posx(:,centerx)=0;
posy(centery,centery) = 0;
        disp('PSX  w.r.t CENTRE ROW');
        val=0;
        for x=centery+1:column
        val=val+patch_size;
            for y=1:row
            psx(y,x)=val;
            end
        end
        val=0;
        for x=centery-1:-1:1
            val=val+patch_size;
            for y=1:row
                psx(y,x)=(-val);
            end
        end
 
        val=0;
 
        disp(psx);
        disp('PSY  w.r.t CENTRE COLUMN');
 
        for i=centerx-1:-1:1
        val=val+patch_size;
            for j=1:column
            psy(i,j)=val;
            end
        end
        val=0;
        i=centerx;
        for i=centerx+1:row
        val=val+patch_size;
            for j=1:column
            psy(i,j)=(-val);
            end
        end
        val=0;
 
        disp(psy);
dz = focalpt;
dy = input('Enter the angle of offset beam(Elevation) : ');
theta=dy;
if dy~=0
    theta = theta*pi/180;
    disp(theta);
    dx = input ('Enter the angle of offset beam (Azimuth ');
    azimuth=dx;
    azimuth=azimuth*pi/180;
    disp(azimuth);
else if dy == 0
        dx = input ('Enter the angle of offset beam (Azimuth : ');
        azimuth=dx;
    if dx~=0
        azimuth=azimuth*pi/180;
    else
        azimuth =0;
    end
    end
end
 
distance_feed=sqrt((((psx(centerx,centery)-dx)^2)+((psy(centerx,centery)-dy)^2)+((-dz)^2)));
 %dist0=sqrt((((posx(centerx,centery)-d0x)^2)+((posy(centerx,centery)-d0y)^2)+((-d0z)^2)));
%disp('Distance between Centre and Feed Element '+distance_feed);
phase_difference=zeros(row,column);
distance_ele=zeros(row,column);
path_difference=zeros(row,column);
angul_wave_no=2*pi/lambda;
disp(angul_wave_no);
 disp('distance_feed');
 disp(distance_feed);
for i=1:1:row
    for j=1:1:column
        distance_ele(i,j)=(sqrt((((psx(i,j)-dx)^2)+((psy(i,j)-dy)^2)+((dz)^2))));
        %dist(i,j)=(sqrt((((posx(i,j)-d0x)^2)+((posy(i,j)-d0y)^2)+((d0z)^2))));
        phase_difference(i,j)=( angul_wave_no*((distance_ele(i,j)*(1e-3))-sin(theta)*(1e-3)*((psx(i,j)*cos(azimuth))+(psy(i,j)*sin(azimuth)))))*180/pi;
        
        
         %phi(i,j)=pk*((dist(i,j).*1e-3)-sin(theta)*(1e-3)*((posx(i,j)*cos(azimuth))+(posy(i,j)*sin(azimuth))))*180/pi;
             if phase_difference (i,j)>360
                
                 reminder = rem(phase_difference(i,j),360);
                 integer = (phase_difference(i,j)-reminder)/360;
                 phase_difference(i,j)= phase_difference(i,j)-integer*360;
                 
             end
             path_difference(i,j) = distance_ele(i,j)- distance_feed;
    end
end
 disp('path_difference:');
 disp(path_difference);
disp('Amount of Phase Shift required at each element');
phasecorrected=phase_difference-phase_difference(centerx,centery);
disp(phasecorrected);

 %The elements that are not considered are eliminated.
figure;
 
imagesc(phasecorrected);
colorbar;
title('Phase difference at each Unit Cell');
xlabel('Row Elements');
ylabel('Column Elements');
zlabel('Phase Difference in degree');
figure;
surf(path_difference);
colorbar;
title('Path difference at Unit Cell');
xlabel('Row Elements');
ylabel('Column Elements');
zlabel('Path Difference in mm');
