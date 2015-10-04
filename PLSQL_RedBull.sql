-- Alinea 1
create table rb_season_points(
  num number(20),
  firstname nvarchar2(30),
  surname nvarchar2(30),
  points number(5),
  constraint pk_rb_season_points primary key (num)
);

-- Alinea 2
create table rb_race_pos(
  num number(20),
  location nvarchar2(30),
  edition number(4),
  pos number(4),
  constraint pk_rb_race_pos primary key (num)
);

-- Alinea 3
create or replace function RB_GET_POINTS(position in integer) 
return integer as
begin
  if position < 7
  then return (7-position);
  else return 0;
  end if;
end;

-- Alinea 4
/* Dicas:
  .quartos -> 5,6,7,8
  .meias
  .minor -> 3,4
  .final -> 1,2
*/
create or replace function RB_GET_PILOT_POS_IN_RACE(loc in varchar,ed in number, position in number) 
return integer as
positionT integer;
pilot1Time integer;
pilot2Time integer;
pilot1ID integer;
pilot2ID integer;
codePilot integer;
begin

  /* Final */
  if position =1 or position=2
  then
    -- get pilot1 id
    select numpilot1 into pilot1ID
    from duel
    where edition=ed and location=loc and dueltype='Final';
  
    -- get pilot2 id
    select numpilot2 into pilot2ID
    from duel
    where edition=ed and location=loc and dueltype='Final';
    
    -- get pilot1 time
    select (timepilot1+penaltypilot1) into pilot1Time
    from duel
    where edition=ed and location=loc and dueltype='Final';
    
    -- get pilot2 time
    select (timepilot2+penaltypilot2) into pilot2Time
    from duel
    where edition=ed and location=loc and dueltype='Final';
    
    -- evaluate
    codePilot:=pilot1id;
    
    if (pilot2time < pilot1time)
    then codePilot:=pilot2id;
    end if;
  end if;
  
  /* Quarters-finals */
  
  if (position>=5 and position<=8)
  then
    select numpilot into codePilot
    from(
        select numpilot, t, rownum+4 as pos
        from
        (
        (select numpilot1 as numPilot, (timepilot1+penaltypilot1) as t
        from duel
        where edition=ed and location=loc and dueltype='QuarterFinal'
        and (timepilot1+penaltypilot1)>(timepilot2+penaltypilot2))
        union
        (select numpilot2 as numPilot, (timepilot2+penaltypilot2) as t
        from duel
        where edition=ed and location=loc and dueltype='QuarterFinal'
        and (timepilot2+penaltypilot2)>(timepilot1+penaltypilot1))
    )
    order by t
    )
    where pos=position;   
  end if;
  
  
    /* Minor-finals */
  
  if (position=3 or position=4)
  then
    select numpilot into codePilot
    from(
        select numpilot, t, rownum+2 as pos
        from
        (
        (select numpilot1 as numPilot, (timepilot1+penaltypilot1) as t
        from duel
        where edition=ed and location=loc and dueltype='MinorFinal'
        and (timepilot1+penaltypilot1)>(timepilot2+penaltypilot2))
        union
        (select numpilot2 as numPilot, (timepilot2+penaltypilot2) as t
        from duel
        where edition=ed and location=loc and dueltype='MinorFinal'
        and (timepilot2+penaltypilot2)>(timepilot1+penaltypilot1))
    )
    order by t
    )
    where pos=position;   
  end if;
  
  return codePilot;
end;


create or replace procedure  RB_BUILD_RACE_POS as
positionT integer;
location varchar2(30);
edition number(5);
pilotNum integer;
i number(5);
cursor locAndEdition is (select  distinct location,edition from duel);
begin
  open locAndEdition;
  -- For each location edition
  loop
     fetch locAndEdition into location, edition;
     -- For each position
     i:=0;
     loop
      i:=i+1;
      pilotNum:=RB_GET_PILOT_POS_IN_RACE(location, edition,i);
      insert into RB_RACE_POS(num, location, edition, pos) values (pilotNum,location, edition, i);
      exit when i=8;
     end loop;
     
     exit when locAndEdition%NOTFOUND;
  end loop;
  close locAndEdition;
end;