-- Tabela Aluno
delete * from aluno;
insert into aluno(nr,nome) values (100,'João');
insert into aluno(nr,nome) values (110,'Manuel');
insert into aluno(nr,nome) values (120,'Rui');
insert into aluno(nr,nome) values (130,'Abel');
insert into aluno(nr,nome) values (140,'Fernando');
insert into aluno(nr,nome) values (150,'Ismael');
  
-- Tabela Prof
delete * from prof;
insert into prof(sigla,nome) values ('ECO','Eugénio');
insert into prof(sigla,nome) values ('FNF','Fernando');
insert into prof(sigla,nome) values ('JLS','João');

-- Tabela Cadeira
alter table cadeira
modify design nvarchar2(50);
delete from cadeira;
insert into cadeira(cod,design,curso,regente) values
('TS1','Teoria dos Sistemas 1','IS','FNF');
insert into cadeira(cod,design,curso,regente) values
('BD','Bases de Dados','IS','ECO');
insert into cadeira(cod,design,curso,regente) values
('EIA','Estruturas de Informação e Algoritmos 1','IS','ECO');
insert into cadeira(cod,design,curso,regente) values
('EP','Elestrónica de Potência','AC','JLS');
insert into cadeira(cod,design,curso,regente) values
('IE','Instalações Eléctricas','AC','JLS');

-- Tabela prova
delete from prova;
insert into prova(nr,cod,data,nota) values
(100,'TS1','92-02-11',8);
insert into prova(nr,cod,data,nota) values
(100,'TS1','93-02-02',11);
insert into prova(nr,cod,data,nota) values
(100,'BD','93-02-04',17);
insert into prova(nr,cod,data,nota) values
(100,'EIA','92-01-29',16);
insert into prova(nr,cod,data,nota) values
(100,'EIA','93-02-02',13);
insert into prova(nr,cod,data,nota) values
(110,'EP','92-01-30',12);
insert into prova(nr,cod,data,nota) values
(110,'IE','92-02-05',10);
insert into prova(nr,cod,data,nota) values
(110,'IE','93-02-01',14);
insert into prova(nr,cod,data,nota) values
(120,'TS1','93-01-31',15);
insert into prova(nr,cod,data,nota) values
(120,'EP','93-02-04',13);
insert into prova(nr,cod,data,nota) values
(130,'BD','93-02-04',12);
insert into prova(nr,cod,data,nota) values
(130,'EIA','93-02-02',7);
insert into prova(nr,cod,data,nota) values
(130,'TS1','92-02-11',8);
insert into prova(nr,cod,data,nota) values
(140,'TS1','93-01-31',10);
insert into prova(nr,cod,data,nota) values
(140,'TS1','92-02-02',13);
insert into prova(nr,cod,data,nota) values
(140,'EIA','93-02-04',11);
insert into prova(nr,cod,data,nota) values
(150,'TS1','92-02-11',10);
insert into prova(nr,cod,data,nota) values
(150,'EP','93-02-21',11);
insert into prova(nr,cod,data,nota) values
(150,'BD','93-02-06',17);
insert into prova(nr,cod,data,nota) values
(150,'EIA','92-01-01',16);
insert into prova(nr,cod,data,nota) values
(150,'IE','93-02-11',13);

-- Add check
alter table prova
add constraint ck_prova_nota check (nota>=0 and nota<=20);