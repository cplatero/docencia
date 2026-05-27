function E = edges4connectedEDistSelect(height,width,mask_nlink)

N = height*width;
I = []; J = [];

% connect vertically (down, then up)
zona1 = mask_nlink(mod(mask_nlink,height)==1);
zona2 = mask_nlink(mod(mask_nlink,height)>1);
zona3 = mask_nlink(mod(mask_nlink,height)==0);
is = zona1;
js = is+1;
I = [I;is];
J = [J;js];
is = [zona2;zona2];
js = [zona2-1;zona2+1];
I = [I;is];
J = [J;js];
is = zona3;
js = is-1;
I = [I;is];
J = [J;js];

% connect horizontally (right, then left)
zona1 = mask_nlink(mask_nlink<=height);
zona2 = mask_nlink(mask_nlink>height & mask_nlink<=N-height);
zona3 = mask_nlink(mask_nlink>N-height);
is = zona1;
js = is+height;
I = [I;is];
J = [J;js];
is = [zona2;zona2];
js = [zona2-height;zona2+height];
I = [I;is];
J = [J;js];
is = zona3;
js = is-height;
I = [I;is];
J = [J;js];

E = [I,J];

end