-- Team table creation
create table Team(
  name nvarchar2(30),
  country nvarchar2(30),
  constraint pk_Team primary key (name));
  
-- Aircraft table creation  
create table Aircraft(
  model nvarchar2(30),
  horsepower number(4),
  topspeed number(4,2),
  width number(5,2),
  height number(5,2),
  weight number(5,2),
  constraint pk_Aircraft primary key (model));
  
-- Pilot table creation
create table Pilot(
  num number(5),
  firstname nvarchar2(30),
  surname nvarchar2(30),
  nationality nvarchar2(30),
  birthday date,
  name nvarchar2(30),
  model nvarchar2(30),
  constraint pk_Pilot primary key (num),
  constraint fk_name foreign key (name) references Team(name),
  constraint fk_model foreign key (model) references Aircraft(model)
  );
  
-- Race table creation
create table Race(
  location nvarchar2(30),
  edition number(2),
  country nvarchar2(30),
  eventDate date,
  gates number(2),
  eliminations number(2),
  constraint pk_Race primary key (location, edition));
  
-- Participation table creation
create table Participation(
  num number(5),
  location nvarchar2(30),
  edition number(2),
  trainingtime number(3,2),
  trainingpos number(3),
  trainingpenalty number(3,2),
  qualificationtime number(3,2),
  qualificationpos number(3),
  qualificationpenalty number(3,2),
  constraint pk_Participation primary key (num, location, edition),
  constraint fk_num foreign key (num) references Pilot(num),
  constraint fk_locationEdition foreign key (location,edition) references Race(location, edition)
  );
  
-- Duel table creation
create table Duel(
  numpilot1 number(5),
  numpilot2 number(5),
  location nvarchar2(30),
  edition number(2),
  dueltype nvarchar2(30),
  timepilot1 number(3,2),
  timepilot2 number(3,2),
  penaltypilot1 number(3,2),
  penaltypilot2 number(3,2),
  constraint pk_Duel primary key (numpilot1,numpilot2,location, edition),
  constraint fk_numpilot1 foreign key (numpilot1) references Pilot(num),
  constraint fk_numpilot2 foreign key (numpilot2) references Pilot(num),
  constraint fk_locationEditionDuel foreign key (location,edition) references Race(location, edition)
  );
  
  
  