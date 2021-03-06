% function results_analysis_SA(filedate,EOA)
% Action: This file produces the figures 1 & 2 for the paper
%         example: >>results_analysis_SA('20-Jul-2011','O')
% INPUT:
% filedate: is the date at which the result files have been
% generated. Look in the directory Results/ if unsure. In this version, the
% results file are directly generated by main_experts and main_SDP.
% EOA: takes values 'E' (experts performance), 'O' (optimal
% performance), or 'A' (both experts and optimal performace)
%
% OUTPUT: main figures in paper chades et al (2011) representing the
% "stable" abalone density and number of prey eaten/sea otter/day for each
% FR considered under different management scenarios (expert 1-4, optimal)
%
% SIDE EFFECT:
% 'A': Make sure the results files have been generated on the same
% day or change name of each results file.
% 'E': Requires 4 experts.
%
% AUTHOR: Iadine Chades iadine.chades@csiro.au 18 of june 2011

function results_analysis_SA(filedate,EOA)

global PARAM_SIG_FR PARAM_HYP_FR PARAM_LINEAR_FR DIR_results
% EOA= Experts only, Optimal only, All.
DIR_results='Results\';
if EOA=='O' || EOA==2
    EOA=2;
    M=dlmread([DIR_results,...
        filedate,'_results_SA_VI.txt'],'',[0,0, 0, 4]);
    isAPoachEfficient=M(1); maxKAba = M(2);maxrAba=M(3);KSO = M(4); rSO=M(5);
end
% set defaults for optional inputs
load_param(isAPoachEfficient,maxKAba,maxrAba,KSO,rSO);

% A represents the map color for different expert/strategies
A=[
    0 1 0.2;
    0.1 0.1 0.1;
    0.5 0.5 0;
    0.5 0.5 0.5;
    0.0 0.5 1;
    ];

% Black and white figures.
Abw=[
    0 0 0;
    0.5 0.5 0.5;
    0 0 0;
    0.5 0.5 0.5;
    0.5 0.5 0.5;
    ];
% Initialise the parameters
v=length(PARAM_LINEAR_FR);      % v is the number of linear FR
new_k=[3.34-0.2,3.34 , 3.34+0.2];
new_r=[1.6-0.05, 1.6, 1.6+0.05];

nSA=length(new_k)*length(new_r);
res_SA=zeros(nSA,v,8);   % v linear FR + 2 sig + 2 hyp
X=get_results([DIR_results,filedate,'_results_SA_VI.txt']);
for i=1:nSA
    for ifr=1:v
        res_SA(i,ifr,:)=X(v*(i-1)+ifr,:);
    end
end
% In addition we would like to calculate the corresponding "stable" number
% of prey eaten for each FR/expert strategy
Eaten_exp=zeros(nSA,v);
Aba_exp=zeros(nSA,v);         % Mean density of Abalone
Aba_std_exp=zeros(nSA,v);     % Standard deviation
Aba100_exp=zeros(nSA,v);      % Mean density of >100mm Abalone
Aba100_std_exp=zeros(nSA,v);  % Standard deviation

for i=1:nSA
    Aba_exp(i,:)=res_SA(i,:,3);
    Aba_std_exp(i,:)=res_SA(i,:,4);
    Aba100_exp(i,:)=res_SA(i,:,5);
    Aba100_std_exp(i,:)=res_SA(i,:,6);
end

% Begin figure 1
figure('color','white','name','Performance of optimal and expert strategies');
iFR=3;

for iFRnum=1:v
    d_max=PARAM_LINEAR_FR(iFRnum,1);
    Pemax=PARAM_LINEAR_FR(iFRnum,2);
    for iSA=1:nSA
        Eaten_exp(iSA,iFRnum)=Pemax*...
            Aba_exp(iSA,iFRnum)/d_max;
    end
    show_FR(iFR,iFRnum) % Plot FR

end

iSA=1;
h(iSA)=plot(Aba_exp(iSA,:),Eaten_exp(iSA,:),'-^','MarkerFaceColor',Abw(1,:),'linewidth',1,'MarkerEdgeColor',Abw(2,:), ...
        'color',Abw(1,:));
hold on
iSA=5;
h(iSA)=plot(Aba_exp(iSA,:),Eaten_exp(iSA,:),'-s','MarkerFaceColor',Abw(2,:),'linewidth',1,'MarkerEdgeColor',Abw(3,:), ...
        'color',Abw(2,:));
hold on
iSA=9;
h(iSA)=plot(Aba_exp(iSA,:),Eaten_exp(iSA,:),'-o','MarkerFaceColor',Abw(3,:),'linewidth',1,'MarkerEdgeColor',Abw(4,:),...
        'color',A(3,:));
hold on
legend([h(1),h(5),h(9)],'r_{VG}=1.55, K_{VG}=3.14 abalone/m^2','r_{VG}=1.6, K_{VG}=3.34 abalone/m^2','r_{VG}=1.65, K_{VG}=3.54 abalone/m^2','Location','Best')
legend('boxoff')

% end figure 1

% Begin figure 2A
figure('color','white','name','> 100mm Abalone')

h(1)=errorbar(0.85:1:v,Aba100_exp(1,:),Aba100_std_exp(1,:),'^',...
        'MarkerFaceColor',Abw(1,:),'linewidth',1,'MarkerEdgeColor',Abw(2,:), ...
        'color',Abw(1,:)); hold on
h(2)=errorbar(1.:v,Aba100_exp(5,:),Aba100_std_exp(5,:),'s',...
        'MarkerFaceColor',Abw(2,:),'linewidth',1,'MarkerEdgeColor',Abw(3,:), ...
        'color',Abw(2,:)); hold on
h(3)=errorbar(1.15:v+.15,Aba100_exp(9,:),Aba100_std_exp(9,:),'o',...
        'MarkerFaceColor',Abw(3,:),'linewidth',1,'MarkerEdgeColor',Abw(4,:),...
        'color',A(3,:)); hold on
hold on
legend([h(1),h(5),h(9)],'r_{VG}=1.55, K_{VG}=3.14 abalone/m^2','r_{VG}=1.6, K_{VG}=3.34 abalone/m^2','r_{VG}=1.65, K_{VG}=3.54 abalone/m^2','Location','Best')
legend('boxoff')
box off
ylim([0 0.4]);
xlim([0 v+0.75]);
ylabel('Adult abalone density (m^{-2})')
xlabel('Functional responses');
set(gca,'XTick',[0:1:v+0.75])
set(gca, 'xticklabel',{'','L1','L2','L3',...
    'L4',''});


% End figure 2A

% Begin figure 2B errorbar
figure('color','white','name','Whole abalone population')


h(1)=errorbar(0.85:1:v,Aba_exp(1,:),Aba_std_exp(1,:),'^','MarkerFaceColor',...
    Abw(1,:),'linewidth',1,'MarkerEdgeColor',Abw(1,:), 'color',Abw(1,:)); hold on
h(2)=errorbar(1.:v,Aba_exp(5,:),Aba_std_exp(5,:),'s','MarkerFaceColor',...
    Abw(2,:),'linewidth',1,'MarkerEdgeColor',Abw(2,:), 'color',Abw(2,:)); hold on
h(3)=errorbar(1.15:v+.15,Aba_exp(9,:),Aba_std_exp(9,:),'o','MarkerFaceColor',...
    Abw(3,:),'linewidth',1,'MarkerEdgeColor',Abw(3,:), 'color',Abw(3,:)); hold on

box off
ylim([0 1.4]);
xlim([0 v+0.75]);
set(gca,'XTick',[0:1:v+0.75])
ylabel('Abalone density (m^{-2})');
xlabel('Functional responses');
set(gca, 'xticklabel',{'','L1','L2','L3',...
    'L4',''});
hold on
legend([h(1),h(5),h(9)],'r_{VG}=1.55, K_{VG}=3.14 abalone/m^2','r_{VG}=1.6, K_{VG}=3.34 abalone/m^2','r_{VG}=1.65, K_{VG}=3.54 abalone/m^2','Location','Best')
legend('boxoff')

% End figure 2B
end



