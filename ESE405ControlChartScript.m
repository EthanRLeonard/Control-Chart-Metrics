clear
close all
print("2")

BiometricDataESE405=readtable('Biometric Data ESE405.xlsx');
Table=BiometricDataESE405;
cholesterol=table2array(Table(2:end,2));
hemoglobin=table2array(Table(2:end,5));
height=table2array(Table(2:end,8));
weight=table2array(Table(2:end,9));
id=table2array(Table(2:end,1));

bmi=703*weight./(height.^2);

%% Making groups

n=4;
d2=2.059;
d3=0.880;

variables=[cholesterol, hemoglobin, bmi];
    ch2=zeros(4,94).';
    he2=zeros(4,94).';
    bm2=zeros(4,94).';
    plc=[ch2,he2,bm2];
    spot=1;
    
for w=1:3
        
    var=variables(1:end,w);
    cols=(((w*n)-(n-1)):(w*n));
    current=plc(:,cols);
for y=1:94
    v=(((y*n)-(n-1)):(y*n));
    current(y,1:n)=var(v);
end

if(w==1)
    figure('Name','Cholesterol Control Chart');
    [Cholesterolstats,Cholesteroldata1] = controlchart(current,'charttype',{'xbar' 'r'});
    fprintf('Parameter estimates:  mu = %g, sigma = %g\n',Cholesterolstats.mu,Cholesterolstats.sigma);
    UCLXCholesterol=Cholesteroldata1(1,1).ucl(1,1);
    UCLRCholesterol=Cholesteroldata1(1,2).ucl(1,1);
    LCLXCholesterol=Cholesteroldata1(1,1).lcl(1,1);
    LCLRCholesterol=Cholesteroldata1(1,2).lcl(1,1);
    
    Ch_Ind=[UCLXCholesterol,LCLXCholesterol,UCLRCholesterol,LCLRCholesterol].';
    
elseif(w==2)
    figure('Name','Glycated Hemoglobin Control Chart');
    [Hemoglobinstats,Hemoglobindata] = controlchart(current,'charttype',{'xbar' 'r'});
    fprintf('Parameter estimates:  mu = %g, sigma = %g\n',Hemoglobinstats.mu,Hemoglobinstats.sigma);
    UCLXHemoglobin=Hemoglobindata(1,1).ucl(1,1);
    UCLRHemoglobin=Hemoglobindata(1,2).ucl(1,1);
    LCLXHemoglobin=Hemoglobindata(1,1).lcl(1,1);
    LCLRHemoglobin=Hemoglobindata(1,2).lcl(1,1);
    
    Hem_Ind=[UCLXHemoglobin,LCLXHemoglobin,UCLRHemoglobin,LCLRHemoglobin].';
else
    figure('Name','BMI Control Chart');
     [BMIstats,BMIdata] = controlchart(current,'charttype',{'xbar' 'r'});
    fprintf('Parameter estimates:  mu = %g, sigma = %g\n',BMIstats.mu,BMIstats.sigma);
    UCLXBMI=BMIdata(1,1).ucl(1,1);
    UCLRBMI=BMIdata(1,2).ucl(1,1);
    LCLXBMI=BMIdata(1,1).lcl(1,1);
    LCLRBMI=BMIdata(1,2).lcl(1,1);
    
    BMI_Indicator=[UCLXBMI,LCLXBMI,UCLRBMI,LCLRBMI].';
end

end
Limits={'XBAR UCL';'XBAR LCL';'R UCL';'R LCL';};
chart=table(Limits,Ch_Ind,Hem_Ind,BMI_Indicator)
orient 'landscape'

%% Alert Patient
%These ids are of patients that lie outside of either 3-sigma chart
alertCholesterolHigh=id(find(cholesterol>UCLXCholesterol | cholesterol>UCLRCholesterol))
alertCholesterolLow=id(find(cholesterol<LCLXCholesterol | cholesterol<LCLRCholesterol))

alertHemoglobinHigh=id(find(hemoglobin>UCLXHemoglobin | hemoglobin>UCLRHemoglobin))
alertHemoglobinLow=id(find(hemoglobin<LCLXHemoglobin | hemoglobin<LCLRHemoglobin))

alertBMIHigh=id(find(bmi>UCLXBMI | bmi>UCLRBMI))
alertBMILow=id(find(bmi<LCLXBMI | bmi<LCLRBMI))



