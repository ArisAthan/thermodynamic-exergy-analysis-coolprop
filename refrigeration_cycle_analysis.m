%Παράμετροι (Ομάδα 5)
fluid='R600'; %Εργαζόμενο μέσο
Tm=34+273.15; %Τ μέση σε Kelvin
Tair_out=20+273.15; %Θερμοκρασία αέρα στην έξοδο ατμοποιητή
Tair_in=26+273.15; %Θερμοκρασία αέρα δωματίου
Dt_air=5; %Διαφορά θερμοκρασίας αέρα στο συμπυκνωτή
DR=8; %ημερήσια διακύμανση θερμοκρασίας
Qe=6000; %Ψυκτική ισχύς (evaporator) σε W
Tlow=273.15+12; %Θερμοκρασία ατμοποίησης
t=2:25; 
real_hour = t - 1;
Tamb = Tm + (DR/2) * cos(2*pi*(t-1-14)/24);
Thigh = Tamb + 10;

%Σημείο 1
p1=py.CoolProp.CoolProp.PropsSI('P','T',Tlow,'Q',1,fluid); %(πίεση σε Pa)
h1=py.CoolProp.CoolProp.PropsSI('H','T',Tlow,'Q',1,fluid); %(ειδική ενθαλπία σε j/kg)
s1=py.CoolProp.CoolProp.PropsSI('S','T',Tlow,'Q',1,fluid);

%Σημείο 3
p3 = arrayfun(@(T) py.CoolProp.CoolProp.PropsSI('P','T',T,'Q',0,fluid), Thigh);
h3 = arrayfun(@(T) py.CoolProp.CoolProp.PropsSI('H','T',T,'Q',0,fluid), Thigh);
s3 = arrayfun(@(T) py.CoolProp.CoolProp.PropsSI('S','T',T,'Q',0,fluid), Thigh);

%Σημείο 2is
p2is=p3;
h2is = arrayfun(@(P) py.CoolProp.CoolProp.PropsSI('H','S',s1,'P',P,fluid), p3);
nis_c = 0.874 - 0.0642 * (p3 / p1);

%Σημείο 2
p2=p3;
h2 = h1 + (h2is - h1) ./ nis_c;
s2 = arrayfun(@(P,H) py.CoolProp.CoolProp.PropsSI('S','P',P,'H',H,fluid), p2, h2);

%Σημείο 4
p4=p1;
h4=h3;
s4 = arrayfun(@(h) py.CoolProp.CoolProp.PropsSI('S','P',p4,'H',h,fluid), h4);

%Ερώτημα 2
w_c = h2 - h1; %ειδικό έργο συμπιεστή (j/kg)
n_el=0.95; %βαθμός απόδοσης ηλεκτρομηχανής
w_el=w_c/n_el; %ειδικό έργο ηλεκτρομηχανής (j/kg)
cp_air = 1005; %Ειδική θερμοχωρητικότητα αέρα (j/kgK)
qe = h1-h4; %Ειδική ψυκτική ισχύς (j/kg)
cop = qe ./ w_el; %Πραγματικός συντελεστής συμπεριφοράς COP
%Plot
figure
plot(real_hour, cop, 'c-o', 'LineWidth', 1.5);
xlabel('Ώρα');
ylabel('COP');
title('COP σε συνάρτηση του χρόνου');
grid on;

%Ερώτημα 3
m_cool= Qe./qe; 
P_el=w_el.*m_cool; %Ισχύς ηλεκτρομηχανής σε W
figure
plot(real_hour, P_el, 'r-o', 'LineWidth', 1.5); 
xlabel('Ώρα');
ylabel('P_el [W]');
title('Ενεργειακή κατανάλωση σε συνάρτηση του χρόνου');
grid on;

%Ερώτημα 4
mc_air= (m_cool.*(h2-h3)) / (cp_air*Dt_air); %Ισολογισμός ενέργειας στο συμπυκνωτή
T_hotair= Dt_air+Tamb; %Θερμοκρασία εξόδου αέρα από συμπυκνωτή

%Ερώτημα 5
cop_mean=mean(cop,"all"); %Μέση τιμή cop επαληθευμένη και αριθμητικά

%Ερώτημα 6
cost=0.2; %$/kWh
P_el_day= sum(P_el,"all"); %Ημερήσια ισχύς ηλεκτρομηχανής σε W, ίση με το έργο σε Wh
cost_day=cost*P_el_day*0.001; %ημερήσιο κόστος και μετατροπή μονάδων(Wh σε kWh)

%Ερώτημα 7
index_12 = find(t == 13);  %ώρα 12:00 αντιστοιχεί σε t=13
%Εξαγωγή τιμών για τη συγκεκριμένη ώρα και μετατροπή σε Bar-Kj/kg
P = 0.00001*[double(p1), double(p2(index_12)), double(p3(index_12)), double(p4),double(p1)];
H = 0.001*[double(h1), double(h2(index_12)), double(h3(index_12)), double(h4(index_12)),double(h1)];

%Διάγραμμα P-h
figure
plot(H, P, 'b-o', 'LineWidth', 1.5);
xlabel('h [kJ/kg]');
ylabel('P [bar]');
title('Διάγραμμα P-h του κύκλου στις 12:00');
grid on;
labels = {'1', '2', '3', '4'};
for i = 1:4
    text(H(i), P(i), ['  ' labels{i}], 'FontSize', 12, 'FontWeight', 'bold');
end

%Ερώτημα 8
me_air= -Qe/(cp_air*(Tair_out-Tair_in)); %Ισολογισμός ενέργειας στον ατμοποιητή
Ex_u= me_air*cp_air*((Tair_out-Tair_in)-Tamb*log(Tair_out/Tair_in)); %Ωφέλιμη εξέργεια
Ex_in= P_el; %Εξέργεια που εισέρχεται
n_ex= Ex_u./Ex_in; %Βαθμός απόδοσης εξέργειας

%Ερώτημα 9
%Ισολογισμός εξέργειας στον ατμοποιητή
Ex_lossevap=0;
Ex_inevap=m_cool.*(h4-h1-Tamb.*(s4-s1));
Ex_devap=Ex_inevap-Ex_u;

%Ισολογισμός εξέργειας στον συμπυκνωτή
Ex_lossc=mc_air*cp_air.*(Dt_air-Tamb.*log(T_hotair./Tamb));
Ex_dc=m_cool.*(h2-h3-Tamb.*(s2-s3))-Ex_lossc;
