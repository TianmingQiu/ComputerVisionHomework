%  Gruppennummer:M06
%  Gruppenmitglieder:Hao, Wenhan & Qiu, Tianming & Shen, Fengyi & Xu, Hao & Xu, Jiachen

%% Hausaufgabe 1
%  Einlesen und Konvertieren von Bildern sowie Bestimmung von 
%  Merkmalen mittels Harris-Detektor. 

%  F?r die letztendliche Abgabe bitte die Kommentare in den folgenden Zeilen
%  enfernen und sicherstellen, dass alle optionalen Parameter ?ber den
%  entsprechenden Funktionsaufruf fun('var',value) modifiziert werden k?nnen.

clear ;
clc ;
close all ;
%% Bild laden
  Image = imread('szene.jpg');
  IGray = rgb_to_gray(Image);

%% Harris-Merkmale berechnen
  tic;
  %Merkmale = harris_detektor(IGray,'do_plot',true,15 ,0.05 , 9e7);% L?sung f?r Problem 2.(1)

  Merkmale_advanved = harris_detektor_advanced(IGray,'do_plot',true,15 ,0.05 , 9e5,20 ,5 ,200,200);% L?sung f?r Problem 2.(1)

  % Input argument order: image ,'do_plot', true or false , segment_length , k , tau ,min_dist , N ,tile_size 
  % Otherwise default setting: image ,'do_plot', true , 15 , 0.05 , 9e5 ,20 , 5 ,200(square) or 200,100(rectangle);


  toc;
