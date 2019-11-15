q1 = [0,0,0,0; 0,0,0,0; 0,0,0,0];
q2 = [0.0001,0.0001,0.0001, 0.0001; 0,0,0,0; 0,0,0,0];
q3 = [0.0005,0.0005,0.0005, 0.0005; 0,0,0,0; 0,0,0,0];
q4 = [0.0005,0.0005,0.0005, 0.0005; 20,20,20,20; 0,0,0,0];
q5 = [0.0005,0.0005,0.0005, 0.0005; 90,90,90,90; 0,0,0,0];
q6 = [0.0005,0.0005,0.0005, 0.0005; 90,90,90,90; 0.005,0.005,0.005,0.005];

n1 = Notch(0.001, 0.0016, 0.001, 0);
n2 = n1;
n3 = Notch(0.001, 0.0016, 0.001, pi);
n4 = n3;

w1 = Wrist(0.0016, 0.0018, 4, [n1 n2 n3 n4]);
qs = zeros(3,4,6);
qs(:,:,1) = q1;
qs(:,:,2) = q2;
qs(:,:,3) = q3;
qs(:,:,4) = q4;
qs(:,:,5) = q5;
qs(:,:,6) = q6;
qs = qs
finalPositions = zeros(3,1,size(qs,1));

for n = 1:size(qs,3)
    Ts = w1.fkine2(qs(:,:,n));
    
    X = zeros(size(Ts,3),1);
    Y = zeros(size(Ts,3),1);
    Z = zeros(size(Ts,3),1);
    for ni = 1:size(Ts,3)
        X(ni) = Ts(1,4,ni);
        Y(ni) = Ts(2,4,ni);
        Z(ni) = Ts(3,4,ni);
    end
    
    finalPositions(:,:,n) = Ts(1:3,4,size(Ts,3));
    
    subplot(2,3,n)
    view(3)
    plot3(X,Y,Z)
    hold on
        set(gca,'FontSize',24)

    scatter3(X(2:length(X)-1),Y(2:length(X)-1),Z(2:length(X)-1),'filled')
    xlabel('X (m)');
     ylabel('Y (m)');
      zlabel('Z (m)');
  
      title(['Stick plot with q', num2str(n)]);

    
    
    
    
end
finalPositions = finalPositions;
hold off

