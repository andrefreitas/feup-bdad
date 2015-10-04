-- a. Quais as peças com custo unitário inferior a 10€ e cujo código contém ‘98’?
select *
from peca
where custounitario<10 and codigo like '%98%';

-- b. Quais as matrículas dos carros que foram reparados  no mês de Setembro de 2010?
select matricula
from carro
where idcarro in
( select idcarro
  from reparacao
  where datainicio>='10-09-01' and datainicio<='10-09-30' 
  and datafim>='10-09-01' and datafim<='10-09-30'
  );
  
-- ou 
select matricula
from  carro natural join 
( select idcarro
  from reparacao
  where datainicio>='10-09-01' and datainicio<='10-09-30' 
  and datafim>='10-09-01' and datafim<='10-09-30'
  );
  
-- c. Quais os nomes dos clientes proprietários de carros que utilizaram peças com custo unitário superior a 10€? Apresente o resultado ordenado por ordem descendente do custo unitário. 
select nome
from cliente
where idcliente in
(
  select idcliente
  from reparacao
  where idreparacao in
  (
    select idreparacao
    from reparacaopeca
    where idpeca in
    (
      select idpeca
      from peca
      where custounitario>10
      order by custounitario DESC
      )
  )
);

-- d. Quais os nomes dos clientes que não têm (tanto quanto se saiba) carro?
select nome
from cliente
where idcliente not in
(select idcliente
from carro);

-- e. Qual o número de reparações feitas a cada carro? 
select matricula, count(*) as "Número de Reparações"
from reparacao,carro
where reparacao.idcarro=carro.idcarro
group by matricula;

-- f. Qual o número de dias em que cada carro esteve em reparação?
select matricula, totaldias
from carro natural join (
select idCarro, sum(dias) as totaldias
from (
select idCarro, (datafim-datainicio) as dias
from reparacao)
group by idCarro);

-- g. Qual o custo unitário médio, o valor total e o número de unidades das peças, bem como o valor da peça mais cara e da mais barata? 
select avg(custounitario) as "Custo médio", count(*) as "Total de Peças", sum(custounitario) as "Custo total das Peças", max(custounitario) as "Peça mais cara", min(custounitario) as "Peça mais barata"
from peca;

--h. Qual a especialidade que foi utilizada mais vezes nas reparações dos carros de cada marca? 
create or replace view totalEspecialidades as
  select nome, count(*) as total
  from especialidade natural join
  (
    select idespecialidade
    from funcionario natural join
      (
        select idfuncionario
        from funcionarioreparacao
      )
  )
  group by nome;
  
select nome
from totalespecialidades
where total=(select max(total) from totalespecialidades);

-- i. Qual o preço total de cada reparação?

create or replace view custoReparacoes as(
select idReparacao, sum(custo) as custo
from(
-- Reparações com o custo total das peças
(select reparacaopeca.idreparacao, sum(reparacaopeca.quantidade*peca.custounitario) as custo
from peca, reparacaopeca
where peca.idpeca=reparacaopeca.idpeca
group by reparacaopeca.idreparacao)

union 

-- Reparações com o custo total das mãos-de-obras
(
SELECT funcionarioreparacao.idreparacao, sum(especialidade.custohorario*funcionarioreparacao.numhoras) as total
from funcionarioreparacao,funcionario,especialidade
where funcionarioreparacao.idfuncionario=funcionario.idfuncionario and funcionario.idespecialidade=especialidade.idespecialidade
group by funcionarioreparacao.idreparacao)
)
group by idreparacao
)

select * from custoReparacoes;

-- j. Qual o preço total das reparações com custo total superior a 60€?
select * from custoReparacoes
where custo>60;

-- k. Qual o proprietário do carro que teve a reparação mais cara?
select nome
from cliente
where idcliente in
(
  select idcliente
  from carro
  where idcarro in
  (
    select idcarro
    from reparacao
    where idreparacao in
    (
      select idreparacao from custoreparacoes
      where custo =(select max(custo) from custoreparacoes)
    )
  
  )
);

--  l. Qual a matrícula do carro com a segunda reparação mais cara?
select matricula
from carro 
where idcarro=(
  select idcarro
  from reparacao natural join
  (
    select idreparacao from custoreparacoes
    where custo=
    (
      select max(custo) 
      from
      (
      select * from custoreparacoes
      where custo!= (select max(custo) from custoreparacoes)
      )
    )
  )
);

-- m. Quais são as três reparações mais caras (ordenadas por ordem decrescente de preço)?
select * from( select * from custoreparacoes order by custo DESC)
where rownum<=3;

--n. Quais os nomes dos clientes responsáveis por reparações de carros e respectivos proprietários (só para os casos em que não são coincidentes)? 
select c1.nome as "Proprietário", c2.nome as "Cliente"
from cliente c1, cliente c2, carro, reparacao
where reparacao.idcarro=carro.idcarro
and reparacao.idcliente=c2.idcliente
and carro.idcliente=c1.idcliente;

-- o. Quais as localidades onde mora alguém, seja ele cliente ou funcionário?
(select codpostal.localidade
from codpostal, cliente
where codpostal.codpostal1=cliente.codpostal1)
union
(select codpostal.localidade
from codpostal, funcionario
where codpostal.codpostal1=funcionario.codpostal1);

-- p. Quais as localidades onde moram clientes e funcionários? 

(select codpostal.localidade
from codpostal, cliente
where codpostal.codpostal1=cliente.codpostal1)
intersect
(select codpostal.localidade
from codpostal, funcionario
where codpostal.codpostal1=funcionario.codpostal1);


--q. Quais as peças compatíveis com modelos da Volvo cujo preço é maior do que o de qualquer peça compatível com modelos da Renault?
create or replace view pecasMarcas as
(
  select marca.idmarca, marca.nome, idpeca
  from marca,modelo, pecamodelo
  where marca.idmarca=modelo.idmarca
  and pecamodelo.idmodelo=modelo.idmodelo
);
-- Peças mais caras da volvo

select codigo
from peca
where idpeca in(
  select idpeca
  from pecasMarcas
  where nome='Volvo'
)
and custounitario > all
(
  select custounitario
  from peca
  where idpeca in(
    select idpeca
    from pecasMarcas
    where nome='Renault'
  )
);

-- r.Quais as peças compatíveis com modelos da Volvo cujo preço é maior do  que o de alguma peça compatível com modelos da Renault?  
select codigo
from peca
where idpeca in(
  select idpeca
  from pecasMarcas
  where nome='Volvo'
)
and custounitario > some
(
  select custounitario
  from peca
  where idpeca in(
    select idpeca
    from pecasMarcas
    where nome='Renault'
   )
);

-- s. Quais as matriculas dos carros que foram reparados mais do que uma vez?
create or replace view matriculasReparacoes as
(select carro.matricula,count(*) as totalReparacoes
from reparacao, carro
where carro.idcarro=reparacao.idcarro
group by carro.matricula);

select matricula from matriculasreparacoes
where totalReparacoes>1;

--t. Quais as datas de início e de fim e nome do proprietário das reparações feitas por carros que foram reparados mais do que uma vez?
select reparacao.datainicio, reparacao.datafim,cliente.nome
from reparacao, matriculasReparacoes,carro,cliente
where reparacao.idcarro=carro.idcarro 
and cliente.idcliente =carro.idcliente
and carro.matricula=matriculasReparacoes.matricula
and matriculasreparacoes.totalreparacoes>1;

-- u. Quais as reparações que envolveram todas as especialidades? 
select idreparacao from (
select distinct reparacao.idreparacao, count(*)
from reparacao,funcionarioreparacao,funcionario, especialidade
where reparacao.idreparacao=funcionarioreparacao.idreparacao
and funcionarioreparacao.idfuncionario=funcionario.idfuncionario
and funcionario.idespecialidade=especialidade.idespecialidade
having count(*)= (select count(*) from especialidade)
group by reparacao.idreparacao
);

-- v. Qual o número de reparações feitas por cada carro?
select carro.matricula, count(*) as "Número de reparações"
from carro, reparacao
where carro.idcarro=reparacao.idcarro
group by carro.matricula;

--w. Calcule as durações de cada reparação, contabilizando até à data actual os não entregues. 
insert into reparacao values(5,'10-09-17',null, 1,3);
(select idreparacao, (datafim-datainicio) || ' dias' as "Duração"
from reparacao
where datafim is not null)
union
(select idreparacao, (sysdate-datainicio) || ' dias até hoje' as "Duração"
from reparacao
where datafim is null);

-- ou mais simples
select idreparacao, NVL(datafim, sysdate)-datainicio || ' dias '  as "Duração"
from reparacao;

delete from reparacao
where idReparacao=5;

-- x. Substitua Renault por Top, Volvo por Down e os restantes por NoWay

select * from marca;

select decode(nome,'Renault','Top',
              'Volvo','Down',
              'NoWay')
from marca;
