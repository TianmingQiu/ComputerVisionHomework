%  Gruppennummer:M06
%  Gruppenmitglieder:Hao, Wenhan & Qiu, Tianming & Shen, Fengyi & Xu, Hao & Xu, Jiachen

%% Hausaufgabe 1
%  Einlesen und Konvertieren von Bildern sowie Bestimmung von 
%  Merkmalen mittels Harris-Detektor. 

%  F�r die letztendliche Abgabe bitte die Kommentare in den folgenden Zeilen
%  enfernen und sicherstellen, dass alle optionalen Parameter �ber den
%  entsprechenden Funktionsaufruf fun('var',value) modifiziert werden k�nnen.


%% Bild laden
  Image = imread('szene.jpg');
  IGray = rgb_to_gray(Image);




%% Harris-Merkmale berechnen
  tic;
  %Merkmale = harris_detektor(IGray,'do_plot',true);
  Merkmale = harris_detektor(IGray);
  toc;
