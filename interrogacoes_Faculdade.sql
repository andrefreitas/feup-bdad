-- 1. Quais os números dos alunos?
select nr from aluno;

-- 2. Quais as cadeiras (código e designação) do curso 'AC'?
select cod,design
from cadeira
where curso='AC';

-- 3. Existem nomes comuns a alunos e profs? Quais?
select nome
from aluno
where nome in (select nome from prof);
-- ou --
(select nome from aluno)
intersect
(select nome from prof);

-- 4 Quais os nomes dos alunos que nenhum professor tem?
select nome
from aluno
where nome not in (select nome from prof);

-- 5. Quais os nomes das pessoas relacionadas com a faculdade?
(select nome from aluno)
union
(select nome from prof);

-- 6. Quais os nomes dos alunos que fizeram alguma prova de 'ts1'?
select nome
from aluno
where nr in (select nr from prova where cod='TS1');
-- ou
select distinct nome
from aluno join prova on aluno.nr = prova.nr
where cod='TS1';

-- 7. Quais os nomes dos alunos com inscrição no curso 'IS'?
select nome
from aluno
where nr in(
select nr
from prova join cadeira on prova.cod=cadeira.cod
where cadeira.curso='IS');
--ou
select nome
from aluno
where nr in
(select nr
from prova
where cod in (select cod from cadeira where curso='IS'));

-- 8. Qual a relação dos nomes dos alunos que concluíram o curso 'IS'.
select nome from
(
  select nome,count(*) as totalExamesFeitos
  from
  (
    select distinct aluno.nr, aluno.nome, prova.cod
    from aluno,prova
    where prova.cod in (select cod from cadeira where curso='IS') and prova.nota>=10 and aluno.nr=prova.nr
  )
  having count(*)=(select count(*) from cadeira where curso='IS')
  group by nome
);

-- 9. Qual a nota máxima existente nas provas?
select max(nota)
from prova;

-- 10. Qual a nota média nas provas de BD?
select avg(nota)
from prova
where cod='BD';

-- 11. Qual o número de alunos?
select count(*) as numeroAlunos
from aluno;

-- 12. Qual o número de cadeiras de cada curso?
select curso, count(*) as numeroDeCadeiras
from cadeira
group by curso;

-- 13. Qual o número de provas de cada aluno?
select nr, nome, count(*)
from
(
  select *
  from aluno natural join prova
)
group by nr,nome;

-- 14. Qual o número de provas médio por aluno?
select avg(totalProvas) as mediaProvasporAluno
from (
  select nr, nome, count(*) as totalProvas
  from
  (
    select *
    from aluno natural join prova
  )
  group by nr,nome
);

-- 15.Qual o nome e respectiva média actual (cadeiras feitas, em qualquer curso) de cada aluno?
select nome, avg(nota)||' valores' as media
from 
(
  select *
  from aluno natural join prova
  where prova.nota>=10)
group by nome;

-- 16. Qual a nota máxima de cada cadeira e qual o aluno que a obteve?

select nome as melhorAluno, cod as Cadeira,nota
from aluno natural join (select cod,nr,nota
from prova natural join (
  select cod,max(nota) as notaMaxima
  from prova
  group by cod
  )
where nota=notaMaxima);

-- 17. Obtenha a relação ordenada dos nomes dos alunos do curso IS
select nome
from aluno
where nr in
(
  select nr 
  from prova
  where prova.cod in (select cod from cadeira where curso='IS')
)
order by nome ASC;

