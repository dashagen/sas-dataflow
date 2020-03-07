data a2;
    set a1;
    x=y+z;
run;

data a2;
    set a2;
    g= x+ y;
run;

proc sort data=a2; 
run;

proc sql;
    create table a3 as
    
    select * from a1
    left join a2
    on a1.x=a2.x;
quit;

data p1 p2;
    set a3;
    if g>5 then output p1 else output p2;
run;

