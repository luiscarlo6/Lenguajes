division(Num,Den) :- 
                    Cociente is Num // Den,
                    Residuo  is Num mod Den,
                    NuevoValor is Residuo * 10,
%                     Aux2 = Div,
%                     Aux3 = Mod, !,
                    divisionLarga(NuevoValor,Den,[Cociente],[Residuo]).

divisionLarga(Num, Den, Div,Mod) :- Cociente is Num // Den,
                                    Residuo  is Num mod Den,
                                         
                                         NuevoValor is Residuo * 10,
                                         
%                                      Aux1 = Val,
                                     Aux2 = Div,
                                     Aux3 = Mod, !,
                                         
                                     \+ verPatron(Cociente,Residuo,Div,Mod),
                                         
%                                      append(Aux1, Num,Val),
                                     append(Aux2, Cociente,Div),
                                     append(Aux1, Residuo,Mod),
                                     divisionLarga(NuevoValor, Den,Div,Mod).
                                         


verPatron(DivN,ModN,Div,Mod) :- memberchk(DivN,Div),
                                memberchk(ModN,Mod).
