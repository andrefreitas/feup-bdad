drop table Prova cascade constraints;
drop table Cadeira cascade constraints;
drop table Prof cascade constraints;
drop table Aluno cascade constraints;

create table Aluno(
  nr number(4),
  nome nvarchar2(30),
  constraint pk_Aluno primary key (nr)
  );

create table Prof(
  sigla nvarchar2(3),
  nome nvarchar2(30),
  constraint pk_Prof primary key (sigla)
  );
  
create table Cadeira(
  cod nvarchar2(3),
  design nvarchar2(30),
  curso nvarchar2(3),
  regente nvarchar2(3),
  constraint pk_Cadeira primary key (cod),
  constraint fk_Cadeira_regente foreign key (regente) references Prof(sigla)
  );

create table Prova(
  nr number(4),
  cod nvarchar2(3),
  data date,
  nota number(2),
  constraint pk_Prova primary key (nr,cod,data),
  constraint fk_Prova_cod foreign key (cod) references Cadeira(cod)
  );