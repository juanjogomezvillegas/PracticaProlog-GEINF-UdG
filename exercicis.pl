%=======================Exercici 1=======================
nombre_desubicats([0,1,2,3],Des).  
%Des = 0
%yes
nombre_desubicats([0,3,1,2],Des).
%Des = 3
%yes
nombre_desubicats([2,7,3,4,5,8,6,9,1,0],Des).
%Des = 9
%yes

%=======================Exercici 2=======================
suma_desplacaments([0,1,2,3],Sum).
%Sum = 0
%yes
suma_desplacaments([1,0,2,3],Sum). 
%Sum = 2
%yes
suma_desplacaments([2,7,3,4,5,8,6,9,1,0],Sum).
%Sum = 32
%yes

%=======================Exercici 3=======================
a_inserir([2,7,3,4,5,8,6,9,1,0],L2,Pas).
%L2 = [2,3,7,4,5,8,6,9,1,0]
%Pas = pas_inserir([2],[7],[3],[4,5,8,6,9,1,0]) ? ;
%L2 = [2,3,4,7,5,8,6,9,1,0]
%Pas = pas_inserir([2],[7],[3,4],[5,8,6,9,1,0]) ? ;
%L2 = [2,3,4,5,7,8,6,9,1,0]
%Pas = pas_inserir([2],[7],[3,4,5],[8,6,9,1,0]) ? ;
%no

%=======================Exercici 4=======================
a_capgirar([2,7,3,4,5,8,6,9,1,0],L2,Pas).
%L2 = [2,3,7,4,5,8,6,9,1,0]
%Pas = pas_capgirar([2],[7,3],[4,5,8,6,9,1,0]) ? ;
%L2 = [2,7,4,3,5,8,6,9,1,0]
%Pas = pas_capgirar([2,7],[3,4],[5,8,6,9,1,0]) ? ;
%L2 = [2,7,5,4,3,8,6,9,1,0]
%Pas = pas_capgirar([2,7],[3,4,5],[8,6,9,1,0]) ? ;
%L2 = [2,7,3,4,5,6,8,9,1,0]
%Pas = pas_capgirar([2,7,3,4,5],[8,6],[9,1,0]) ? ;
%L2 = [2,7,3,4,5,6,8,9,1,0]
%Pas = pas_capgirar([2,7,3,4,5],[8,6],[9,1,0]) ? ;
%L2 = [2,7,3,4,5,8,9,6,1,0]
%Pas = pas_capgirar([2,7,3,4,5,8],[6,9],[1,0]) ? ;
%no

a_capgirar([9,8,7,6,5,4,3,2,1,0],L2,Pas).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%Pas = pas_capgirar([],[9,8,7,6,5,4,3,2,1,0],[]) ? ;
%no

%=======================Exercici 5=======================
a_intercalar([2,7,3,4,5,8,6,9,1,0],L2,Pas).
%L2 = [2,3,5,6,1,7,4,8,9,0]
%Pas = pas_separar_esq([2,3,5,6,1],[7,4,8,9,0]) ? ;
%no

a_intercalar([0,2,4,6,8,1,3,5,7,9],L2,Pas).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%Pas = pas_unir_esq([0,2,4,6,8],[1,3,5,7,9]) ? ;
%L2 = [1,0,3,2,5,4,7,6,9,8]
%Pas = pas_unir_dre([0,2,4,6,8],[1,3,5,7,9]) ? ;
%no

a_intercalar([5,0,6,1,7,2,8,3,9,4],L2,Pas).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%Pas = pas_separar_dre([5,6,7,8,9],[0,1,2,3,4])
%yes

%=======================Exercici 6=======================
ordenacio_minima([2,7,3,4,5,8,6,9,1,0],[a_inserir],L2,Pas,LlistaPassos).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%LlistaPassos = [
%  pas_inserir([2],[7],[3,4,5],[8,6,9,1,0]),
%  pas_inserir([2,3,4,5],[7,8],[6],[9,1,0]),
%  pas_inserir([],[2,3,4,5,6,7,8,9],[1],[0]),
%  pas_inserir([],[1,2,3,4,5,6,7,8,9],[0],[])
%  ]
%Pas = 4
%yes

ordenacio_minima([2,7,3,4,5,8,6,9,1,0],[a_capgirar],L2,Pas,LlistaPassos).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%LlistaPassos = [
%  pas_capgirar([2,7,3,4,5],[8,6],[9,1,0]),
%  pas_capgirar([2,7],[3,4,5,6],[8,9,1,0]),
%  pas_capgirar([2],[7,6,5,4,3],[8,9,1,0]),
%  pas_capgirar([],[2,3,4,5,6,7,8,9],[1,0]),
%  pas_capgirar([],[9,8,7,6,5,4,3,2,1,0],[])
%  ]
%Pas = 5
%yes

ordenacio_minima([0,2,4,6,8,1,3,5,7,9],[a_intercalar],L2,Pas,LlistaPassos).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%LlistaPassos = [pas_unir_esq([0,2,4,6,8],[1,3,5,7,9])]
%Pas = 1

ordenacio_minima([2,4,0,6,8,1,5,3,7,9],[a_intercalar,a_capgirar],L2,Pas,LlistaPassos).          
%L2 = [0,1,2,3,4,5,6,7,8,9]
%LlistaPassos = [
%  pas_capgirar([],[2,4],[0,6,8,1,5,3,7,9]),
%  pas_capgirar([],[4,2,0],[6,8,1,5,3,7,9]),
%  pas_unir_esq([0,2,4,6,8],[1,5,3,7,9]),
%  pas_capgirar([0,1,2],[5,4,3],[6,7,8,9])
%  ]
%Pas = 4
%yes

ordenacio_minima([2,4,0,6,8,1,5,3,7,9],[a_intercalar,a_capgirar,a_inserir],L2,Pas,LlistaPassos).
%L2 = [0,1,2,3,4,5,6,7,8,9]
%LlistaPassos = [
%  pas_capgirar([2,4,0,6,8,1],[5,3],[7,9]),
%  pas_inserir([],[2,4],[0],[6,8,1,3,5,7,9]),
%  pas_unir_esq([0,2,4,6,8],[1,3,5,7,9])]
%Pas = 3
%yes

%=======================Exercici 7=======================
escriure_pas(pas_inserir([2],[7],[3],[4,5,8,6,9,1,0])).
%[2,7,(3),4,5,8,6,9,1,0] == Inserir ==> [2,(3),7,4,5,8,6,9,1,0]
%yes

escriure_pas(pas_inserir([2],[7],[3,4],[5,8,6,9,1,0])).  
%[2,7,(3,4),5,8,6,9,1,0] == Inserir ==> [2,(3,4),7,5,8,6,9,1,0]
%yes

escriure_pas(pas_capgirar([2],[7,3],[4,5,8,6,9,1,0])).
%[2,(7,3),4,5,8,6,9,1,0] ==  Capgirar  ==> [2,(3,7),4,5,8,6,9,1,0]
%yes

escriure_pas(pas_capgirar([],[9,8,7,6,5,4,3,2,1,0],[])).
%[(9,8,7,6,5,4,3,2,1,0)] ==  Capgirar  ==> [(0,1,2,3,4,5,6,7,8,9)]
%yes

escriure_pas(pas_separar_esq([2,3,5,6,1],[7,4,8,9,0])).
%[(2),7,(3),4,(5),8,(6),9,(1),0] ==  Intercalar  ==> [(2,3,5,6,1),7,4,8,9,0]
%yes

escriure_pas(pas_separar_dre([5,6,7,8,9],[0,1,2,3,4])).
%[5,(0),6,(1),7,(2),8,(3),9,(4)] ==  Intercalar  ==> [(0,1,2,3,4),5,6,7,8,9]
%yes

escriure_pas(pas_unir_esq([0,2,4,6,8],[1,3,5,7,9])).
%[(0,2,4,6,8),1,3,5,7,9] ==  Intercalar  ==> [(0),1,(2),3,(4),5,(6),7,(8),9]
%yes

escriure_pas(pas_unir_dre([0,2,4,6,8],[1,3,5,7,9])).
%[(0,2,4,6,8),1,3,5,7,9] ==  Intercalar  ==> [1,(0),3,(2),5,(4),7,(6),9,(8)]
%yes

ordenacio_minima([2,4,0,6,8,1,5,3,7,9],[a_intercalar,a_capgirar,a_inserir],_,_,LlistaPassos),escriure_passos(LlistaPassos). 
%[2,4,0,6,8,1,(5,3),7,9] ==  Capgirar  ==> [2,4,0,6,8,1,(3,5),7,9]
%[2,4,(0),6,8,1,3,5,7,9] == Inserir ==> [(0),2,4,6,8,1,3,5,7,9]
%[(0,2,4,6,8),1,3,5,7,9] ==  Intercalar  ==> [(0),1,(2),3,(4),5,(6),7,(8),9]
%LlistaPassos = [
%  pas_capgirar([2,4,0,6,8,1],[5,3],[7,9]),
%  pas_inserir([],[2,4],[0],[6,8,1,3,5,7,9]),
%  pas_unir_esq([0,2,4,6,8],[1,3,5,7,9])
%  ]
%yes

%=======================Exercici 8=======================
%Fitxers a part, main[N]{inout|in|out}.txt