import java.util.*
%czyszczenie
clear;
clc;
clf;
%zmienne do funkcji subplot
vh=1;
vc=2;
ind=1;

%%%%%%%%%%%%% przygotowanie gradientu %%%%%%%%%%%%%%%%%%%%%%%
I=imread('monety.jpg');
I = rgb2gray(I);
 
se = strel('disk', 17);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);


G = imdilate(Iobrcbr, se) - imerode(Iobrcbr, se);
zdjecie = G;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% przygotowanie danych do algorytmu %%%%%%%%%%%%%%%
[h,w] = size(zdjecie);
INIT = -1;
MASK = -2;
WASHED = 0;
fictitious = -3;
curlab = 0;

lab = zeros(h,w);
dist = zeros(h,w);

for i = 1:h
    for j = 1:w
        lab(i,j) = INIT;
        dist(i,j) = 0;
    end
end

H = [];

for i = 1:h
    for j = 1:w
        H = [H,zdjecie(i,j)];
            
    end
end

Hn = unique(H);
Hn = sort(Hn);

fifo_x = LinkedList();
fifo_y = LinkedList();

%%%%%%%%%%%%%%%%%% Segmentacja wododzialowa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for szarosc = Hn % poczatek petli iterujacej po odcieniach szarosci
        for x = 1:h % poczatek petli iterujacej po wsp poziomych pikseli
            for y = 1:w % poczatek petli iterujacej po wsp pionowych pikseli
                if zdjecie(x,y) == szarosc 
                    lab(x,y) = MASK;
					%%%%%%%%%% poczatek sprawdzania sasiadow %%%%%%%%%%%%%%%%
					%Srodek bez krawedzi
                    if x~=1 && x~=h && y~=1 && y~=w
                        if lab(x+1,y-1)>0 || lab(x+1,y-1)==WASHED || lab(x-1,y-1)>0 || lab(x-1,y-1)==WASHED || lab(x-1,y+1)>0 || lab(x-1,y+1)==WASHED || lab(x+1,y+1)>0 || lab(x+1,y+1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED || lab(x,y+1)>0 || lab(x,y+1)==WASHED || lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% gorna krawedz
                    if x==1 && x~=h && y~=1 && y~=w
                        if lab(x+1,y+1)>0 || lab(x+1,y+1)==WASHED || lab(x+1,y-1)>0 || lab(x+1,y-1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED || lab(x,y+1)>0 || lab(x,y+1)==WASHED || lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% dolna krawedz
                    if x~=1 && x==h && y~=1 && y~=w
                        if lab(x-1,y+1)>0 || lab(x-1,y+1)==WASHED || lab(x-1,y-1)>0 || lab(x-1,y-1)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED || lab(x,y+1)>0 || lab(x,y+1)==WASHED || lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					%lewa krawedz
                    if x~=1 && x~=h && y==1 && y~=w
                        if lab(x+1,y+1)>0 || lab(x+1,y+1)==WASHED || lab(x-1,y+1)>0 || lab(x-1,y+1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED || lab(x,y+1)>0 || lab(x,y+1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					%prawa krawedz
                    if x~=1 && x~=h && y~=1 && y==w
                        if lab(x+1,y-1)>0 || lab(x+1,y-1)==WASHED || lab(x-1,y-1)>0 || lab(x-1,y-1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED || lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% gorny lewy wierzcholek
                    if x == 1 && y ==1
                        if lab(x+1,y+1)>0 || lab(x+1,y+1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED ||  lab(x,y+1)>0 || lab(x,y+1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% gorny prawy wierzcholek
                    if x == 1 && y ==w
                        if lab(x+1,y-1)>0 || lab(x+1,y-1)==WASHED || lab(x+1,y)>0 || lab(x+1,y)==WASHED ||  lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% dolny lewy  wierzcholek
                     if x == h && y ==1
                        if lab(x-1,y+1)>0 || lab(x-1,y+1)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED ||  lab(x,y+1)>0 || lab(x,y+1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					% dolny prawy  wierzcholek
                    if x == h && y ==w
                        if lab(x-1,y-1)>0 || lab(x-1,y-1)==WASHED || lab(x-1,y)>0 || lab(x-1,y)==WASHED ||  lab(x,y-1)>0 || lab(x,y-1)==WASHED 
                            dist(x,y) = 1;
                            fifo_x.add(x);
                            fifo_y.add(y);
                        end
                    end
					%%%%%% koniec sprawdzania sasiadow %%%%%%
                end % endif (czy piksel znajduje sie w danym minimum)
            end % koniec iterowania po wsp pionowych
        end % koniec iterowania po wsp poziomych
        
        curdist = 1;
        fifo_x.add(fictitious);
        fifo_y.add(fictitious);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% while 1 %%%%%%%%%%%%%%%
        k = 0;
        while 1 
            k = k+1;
            p_x = fifo_x.remove();
            p_y = fifo_y.remove();
            
            if p_x==fictitious && p_y==fictitious
                if fifo_x.size == 0 % warunek przerwania petli while
                    break
                else
                    fifo_x.add(fictitious);
                    fifo_y.add(fictitious);
                    curdist = curdist+1;
                    p_x = fifo_x.remove();
                    p_y = fifo_y.remove();
                end
            end
         
		 %%%%%%%%%%%%%% sprawdzanie sasiadow %%%%%%%%%%%%%%%%%%%%%5
          %srodek bez brzegow
           if p_x~=1 && p_x~=h && p_y~=1 && p_y~=w 
            if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end
           %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
           %gorny lewy rog
           if dist(p_x-1,p_y-1)<curdist && (lab(p_x-1,p_y-1)>0 || lab(p_x-1,p_y-1)==WASHED)
                if lab(p_x-1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y-1)==MASK && dist(p_x-1,p_y-1)==0
               dist(p_x-1,p_y-1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y-1);
           else
           end
           %gorny prawy rog
           if dist(p_x+1,p_y-1)<curdist && (lab(p_x+1,p_y-1)>0 || lab(p_x+1,p_y-1)==WASHED)
                if lab(p_x+1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y-1)==MASK && dist(p_x+1,p_y-1)==0
               dist(p_x+1,p_y-1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y-1);
           else
           end
           %dolny prawy rog
           if dist(p_x+1,p_y+1)<curdist && (lab(p_x+1,p_y+1)>0 || lab(p_x+1,p_y+1)==WASHED)
                if lab(p_x+1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y+1)==MASK && dist(p_x+1,p_y+1)==0
               dist(p_x+1,p_y+1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y+1);
           else
           end
            %dolny lewy rog
           if dist(p_x-1,p_y+1)<curdist && (lab(p_x-1,p_y+1)>0 || lab(p_x-1,p_y+1)==WASHED)
                if lab(p_x-1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y+1)==MASK && dist(p_x-1,p_y+1)==0
               dist(p_x-1,p_y+1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y+1);
           else
           end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % x = 1
           if p_x==1 && p_x~=h && p_y~=1 && p_y~=w 
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end
           %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
          
           %gorny prawy rog
           if dist(p_x+1,p_y-1)<curdist && (lab(p_x+1,p_y-1)>0 || lab(p_x+1,p_y-1)==WASHED)
                if lab(p_x+1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y-1)==MASK && dist(p_x+1,p_y-1)==0
               dist(p_x+1,p_y-1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y-1);
           else
           end
           %dolny prawy rog
           if dist(p_x+1,p_y+1)<curdist && (lab(p_x+1,p_y+1)>0 || lab(p_x+1,p_y+1)==WASHED)
                if lab(p_x+1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y+1)==MASK && dist(p_x+1,p_y+1)==0
               dist(p_x+1,p_y+1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y+1);
           else
           end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% x = h %%%%%%%%%%%%%%%%
           if p_x~=1 && p_x==h && p_y~=1 && p_y~=w 
                if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end
           %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
           %gorny lewy rog
           if dist(p_x-1,p_y-1)<curdist && (lab(p_x-1,p_y-1)>0 || lab(p_x-1,p_y-1)==WASHED)
                if lab(p_x-1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y-1)==MASK && dist(p_x-1,p_y-1)==0
               dist(p_x-1,p_y-1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y-1);
           else
           end  
            %dolny lewy rog
           if dist(p_x-1,p_y+1)<curdist && (lab(p_x-1,p_y+1)>0 || lab(p_x-1,p_y+1)==WASHED)
                if lab(p_x-1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y+1)==MASK && dist(p_x-1,p_y+1)==0
               dist(p_x-1,p_y+1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y+1);
           else
           end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%% y = 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           if p_x~=1 && p_x~=h && p_y==1 && p_y~=w 
                if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end
          %dolny prawy rog
           if dist(p_x+1,p_y+1)<curdist && (lab(p_x+1,p_y+1)>0 || lab(p_x+1,p_y+1)==WASHED)
                if lab(p_x+1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y+1)==MASK && dist(p_x+1,p_y+1)==0
               dist(p_x+1,p_y+1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y+1);
           else
           end
            %dolny lewy rog
           if dist(p_x-1,p_y+1)<curdist && (lab(p_x-1,p_y+1)>0 || lab(p_x-1,p_y+1)==WASHED)
                if lab(p_x-1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y+1)==MASK && dist(p_x-1,p_y+1)==0
               dist(p_x-1,p_y+1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y+1);
           else
           end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%% y = w 
           if p_x~=1 && p_x~=h && p_y~=1 && p_y==w 
           if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
            %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
           %gorny lewy rog
           if dist(p_x-1,p_y-1)<curdist && (lab(p_x-1,p_y-1)>0 || lab(p_x-1,p_y-1)==WASHED)
                if lab(p_x-1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y-1)==MASK && dist(p_x-1,p_y-1)==0
               dist(p_x-1,p_y-1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y-1);
           else
           end
           %gorny prawy rog
           if dist(p_x+1,p_y-1)<curdist && (lab(p_x+1,p_y-1)>0 || lab(p_x+1,p_y-1)==WASHED)
                if lab(p_x+1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y-1)==MASK && dist(p_x+1,p_y-1)==0
               dist(p_x+1,p_y-1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y-1);
           else
           end
            end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%% x = 1 y = 1 %%%%%%%%%%%%%
           if p_x==1 && p_y==1      
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end   
          
           %dolny prawy rog
           if dist(p_x+1,p_y+1)<curdist && (lab(p_x+1,p_y+1)>0 || lab(p_x+1,p_y+1)==WASHED)
                if lab(p_x+1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y+1)==MASK && dist(p_x+1,p_y+1)==0
               dist(p_x+1,p_y+1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y+1);
           else
           end           
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%% x = h y = 1 %%%%%%%
           if  p_x==h && p_y==1
            if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
           %gorny sasiad
           if dist(p_x,p_y+1)<curdist && (lab(p_x,p_y+1)>0 || lab(p_x,p_y+1)==WASHED)
                if lab(p_x,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y+1)==MASK && dist(p_x,p_y+1)==0
               dist(p_x,p_y+1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y+1);
           else
           end
          %dolny lewy rog
           if dist(p_x-1,p_y+1)<curdist && (lab(p_x-1,p_y+1)>0 || lab(p_x-1,p_y+1)==WASHED)
                if lab(p_x-1,p_y+1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y+1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y+1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y+1)==MASK && dist(p_x-1,p_y+1)==0
               dist(p_x-1,p_y+1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y+1);
           else
           end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%% x = 1 y = w %%%%%%%%%%%%%%%%%%%%5
           if p_x==1 &&  p_y==w  
           %prawy sasiad
           if dist(p_x+1,p_y)<curdist && (lab(p_x+1,p_y)>0 || lab(p_x+1,p_y)==WASHED)
                if lab(p_x+1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y)==MASK && dist(p_x+1,p_y)==0
               dist(p_x+1,p_y)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y);
           else
           end
          %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
           %gorny prawy rog
           if dist(p_x+1,p_y-1)<curdist && (lab(p_x+1,p_y-1)>0 || lab(p_x+1,p_y-1)==WASHED)
                if lab(p_x+1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x+1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x+1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x+1,p_y-1)==MASK && dist(p_x+1,p_y-1)==0
               dist(p_x+1,p_y-1)=curdist+1;
               fifo_x.add(p_x+1);
               fifo_y.add(p_y-1);
           else
           end      
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%% x = h y = w %%%%%%%
           if  p_x==h &&  p_y==w 
                if dist(p_x-1,p_y)<curdist && ( lab(p_x-1,p_y)>0 || lab(p_x-1,p_y)==WASHED)
                if lab(p_x-1,p_y)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y)==MASK && dist(p_x-1,p_y)==0
               dist(p_x-1,p_y)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y);
           else
           end
          %dolny sasiad
           if dist(p_x,p_y-1)<curdist && (lab(p_x,p_y-1)>0 || lab(p_x,p_y-1)==WASHED)
                if lab(p_x,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x,p_y-1)==MASK && dist(p_x,p_y-1)==0
               dist(p_x,p_y-1)=curdist+1;
               fifo_x.add(p_x);
               fifo_y.add(p_y-1);
           else
           end
           %gorny lewy rog
           if dist(p_x-1,p_y-1)<curdist && (lab(p_x-1,p_y-1)>0 || lab(p_x-1,p_y-1)==WASHED)
                if lab(p_x-1,p_y-1)>0
                    if lab(p_x,p_y)==MASK || lab(p_x,p_y)==WASHED
                        lab(p_x,p_y)=lab(p_x-1,p_y-1);
                    elseif lab(p_x,p_y)~=lab(p_x-1,p_y-1)
                        lab(p_x,p_y)=WASHED;
                    else
                    end
                elseif lab(p_x,p_y)==MASK
                    lab(p_x,p_y)=WASHED;
                else
                end
           elseif lab(p_x-1,p_y-1)==MASK && dist(p_x-1,p_y-1)==0
               dist(p_x-1,p_y-1)=curdist+1;
               fifo_x.add(p_x-1);
               fifo_y.add(p_y-1);
           else
           end
           end
           %%%%%%%%%%%%%%% koniec sprawdzanie sasiadow %%%%%%%%%%%%%%%%%555

        end
		
        for x = 1:h % petla iterujaca po wsp poziomych pikseli
            for y = 1:w % petla iterujaca po wsp pionowych pikseli
                if zdjecie(x,y)==szarosc
                    dist(x,y)=0;
                    if lab(x,y)==MASK
                        curlab=curlab+1;
                        fifo_x.add(x);
                        fifo_y.add(y);
                        lab(x,y)=curlab;
                        while fifo_x.size~=0  % poczatek petli while
                            q_x=fifo_x.remove();
                            q_y=fifo_y.remove();

                            %%%%%%%%%%%%%%%% srodek %%%%%%%%%%%%%%%%%%
                            if q_x~=1 && q_x~=h && q_y~=1 && q_y~=w
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end
								if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								 if lab(q_x+1,q_y+1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y+1);
									lab(q_x+1,q_y+1)=curlab;
								 end
								 if lab(q_x-1,q_y+1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y+1);
									lab(q_x-1,q_y+1)=curlab;
								 end
								 if lab(q_x-1,q_y-1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y-1);
									lab(q_x-1,q_y-1)=curlab;
								 end
								 if lab(q_x+1,q_y-1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y-1);
									lab(q_x+1,q_y-1)=curlab;
								 end 
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% x = 1 %%%%%%%%
                            %lewy brzeg
                            if q_x==1 && q_x~=h && q_y~=1 && q_y~=w
								if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								 if lab(q_x+1,q_y+1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y+1);
									lab(q_x+1,q_y+1)=curlab;
								 end
								 if lab(q_x+1,q_y-1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y-1);
									lab(q_x+1,q_y-1)=curlab;
								 end 
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%% x = h %%%%%%%%%
                            %prawy brzeg
                             if q_x~=1 && q_x==h && q_y~=1 && q_y~=w
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end                           
								if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								 if lab(q_x-1,q_y+1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y+1);
									lab(q_x-1,q_y+1)=curlab;
								 end
								 if lab(q_x-1,q_y-1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y-1);
									lab(q_x-1,q_y-1)=curlab;
								 end
                             end
                             %%%%%%%%%%%%%%% y = 1 %%%%%%%%
                             %gorny brzeg
                             if q_x~=1 && q_x~=h && q_y==1 && q_y~=w
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end
								if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								 if lab(q_x+1,q_y+1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y+1);
									lab(q_x+1,q_y+1)=curlab;
								 end
								 if lab(q_x-1,q_y+1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y+1);
									lab(q_x-1,q_y+1)=curlab;
								 end
                             end
                             %%%%%%%%%%%%%%%% y = w %%%%%%%%%%%%%%%%%%
                             %dolny brzeg
                            if q_x~=1 && q_x~=h && q_y~=1 && q_y==w
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end
								if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x-1,q_y-1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y-1);
									lab(q_x-1,q_y-1)=curlab;
								 end
								 if lab(q_x+1,q_y-1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y-1);
									lab(q_x+1,q_y-1)=curlab;
								 end 
                            end
                            %%%%%%%%%%%%%% x = 1 x = 1
                            %%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%
                            %lewy gorny rog
                            if q_x==1 && q_y==1 
								if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								 if lab(q_x+1,q_y+1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y+1);
									lab(q_x+1,q_y+1)=curlab;
								 end
                            end
                            %%%%%%%%%%%%%%%%% x = h y = 1 %%%%%%%%%%
                            %lewy dolny rog
                            if q_x==h && q_y==1
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end
							   if lab(q_x,q_y+1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y+1);
									lab(q_x,q_y+1)=curlab;
								end
								if lab(q_x-1,q_y+1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y+1);
									lab(q_x-1,q_y+1)=curlab;
								end
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%%%%%%%%%%%% x = 1 y = w %%%%%%%%%%%%%%%%%%
                            %prawy  gorny rog
                             if q_x==1 && q_y==w
							   if lab(q_x+1,q_y)==MASK
									fifo_x.add(q_x+1);
									fifo_y.add(q_y);
									lab(q_x+1,q_y)=curlab;
								end
								if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x+1,q_y-1)==MASK 
									fifo_x.add(q_x+1);
									fifo_y.add(q_y-1);
									lab(q_x+1,q_y-1)=curlab;
								 end 
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%% x = h y = w %%%%%%%%%
                            %prawy dolny rog
                            if q_x==h && q_y==w
								if lab(q_x-1,q_y)==MASK
									fifo_x.add(q_x-1);
									fifo_y.add(q_y);
									lab(q_x-1,q_y)=curlab;
								end
							   if lab(q_x,q_y-1)==MASK 
									fifo_x.add(q_x);
									fifo_y.add(q_y-1);
									lab(q_x,q_y-1)=curlab;
								end
								if lab(q_x-1,q_y-1)==MASK 
									fifo_x.add(q_x-1);
									fifo_y.add(q_y-1);
									lab(q_x-1,q_y-1)=curlab;
								end 
                            end
                            %%%%%% koniec sprawdzania sasiadow %%%%%%%
                        end %koniec petli while
                    end % endif (czy etykieta rowna jest MASK)
                end % endif (czy piksel posiada dany odcien szarosci)
            end % koniec iterowania po wsp pionowych
        end % koniec iterowania po wsp poziomych
end % koniec iterowania po odcieniach szarosci

%%%%%%%%%%%%%%%%%%%%%%%%%%% wyswietlanie wynikow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zdjecie11 = label2rgb(lab);
subplot(vh,vc,ind);
imshow(zdjecie11)
ind = ind +1;
   


subplot(vh,vc,ind);
imshow(I)
%imshow(lab)
ind = ind +1;


