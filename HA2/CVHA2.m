%  Gruppennummer:
%  Gruppenmitglieder:

%% Hausaufgabe 2
%  Bestimmung von Punktkorrespondenzen zwischen Merkmalspunkten einer Stereo
%  Aufnahme.

%  Für die letztendliche Abgabe bitte die Kommentare in den folgenden Zeilen
%  enfernen und sicherstellen, dass alle optionalen Parameter über den
%  entsprechenden Funktionsaufruf fun('var',value) modifiziert werden können.
close all; clear; clc;

%% Bilder laden
Image1 = imread('szeneL.jpg');
IGray1 = rgb_to_gray(Image1);

Image2 = imread('szeneR.jpg');
IGray2 = rgb_to_gray(Image2);

%% Harris-Merkmale berechnen
 Merkmale1 = harris_detektor(IGray1,'segment_length',9,'k',0.05,'min_dist',50,'N',20,'do_plot',false);
Merkmale2 = harris_detektor(IGray2,'segment_length',9,'k',0.05,'min_dist',50,'N',20,'do_plot',false);
% subplot(121)
% imshow(Image1);
% hold on;
% plot(Merkmale1(1,:), Merkmale1(2,:),'gs');
% subplot(122)
% imshow(Image2);
% hold on;
% plot(Merkmale2(1,:), Merkmale2(2,:),'gs');


%% Korrespondenzschätzung
% Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,25,0.95,1);
daan(IGray1,IGray2,Merkmale1,Merkmale2,25,0.95,true);