-- =========================================================
-- CONSULTAS - perguntas da solucao Acolhe+
-- Rodar depois dos INSERTs e antes do UPDATE/DELETE.
-- =========================================================

-- ---------------------------------------------------------
-- Consulta 01
-- Pergunta: quais consultas tem risco ALTO de falta, da mais
-- proxima para a mais distante?
-- Recursos: WHERE, ORDER BY, INNER JOIN
-- Esperado: 5 linhas (consultas 1, 3, 5, 7 e 8, nessa ordem)
-- ---------------------------------------------------------
SELECT c.id_consulta,
       ci.nm_cidadao,
       u.nm_unidade,
       TO_CHAR(h.dt_horario, 'DD/MM/YYYY HH24:MI') AS data_hora,
       c.ds_status,
       c.vl_prob_falta
  FROM ACM_CONSULTA c
 INNER JOIN ACM_CIDADAO ci ON ci.id_cidadao = c.id_cidadao
 INNER JOIN ACM_HORARIO h  ON h.id_horario  = c.id_horario
 INNER JOIN ACM_UNIDADE u  ON u.id_unidade  = h.id_unidade
 WHERE c.ds_risco_falta = 'ALTO'
 ORDER BY h.dt_horario;


-- ---------------------------------------------------------
-- Consulta 02
-- Pergunta: qual a idade de cada cidadao na data da consulta
-- e a pontuação de risco de falta em porcentagem?
-- Recursos: calculo no SELECT (subtracao de datas, divisao e
-- multiplicacao)
-- No Oracle, data menos data da o numero de dias. Dividindo
-- por 365.25 (media de dias no ano, contando os bissextos),
-- chega-se a idade em anos, arredondada para 1 casa decimal.
-- A idade e calculada na data da consulta, e nao com SYSDATE,
-- para o resultado nao mudar no dia da apresentacao.
-- Esperado: 8 linhas. Ex.: Sebastiana Ramos, 76.9 anos, 82%;
-- Ana Beatriz, 25.5 anos, 76%.
-- ---------------------------------------------------------
SELECT c.id_consulta,
       ci.nm_cidadao,
       ROUND((h.dt_horario - ci.dt_nascimento) / 365.25, 1) AS idade_na_consulta,
       c.vl_prob_falta * 100 AS prob_falta_pct
  FROM ACM_CONSULTA c
 INNER JOIN ACM_CIDADAO ci ON ci.id_cidadao = c.id_cidadao
 INNER JOIN ACM_HORARIO h  ON h.id_horario  = c.id_horario
 ORDER BY c.id_consulta;


-- ---------------------------------------------------------
-- Consulta 03
-- Pergunta: quantas faltas cada UBS teve?
-- Recursos: COUNT, GROUP BY, WHERE, INNER JOIN
-- Esperado: UBS Vila Mariana 2 | UBS Pinheiros 1 |
-- UBS Tatuape 1
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       COUNT(c.id_consulta) AS qtd_faltas
  FROM ACM_CONSULTA c
 INNER JOIN ACM_HORARIO h ON h.id_horario = c.id_horario
 INNER JOIN ACM_UNIDADE u ON u.id_unidade = h.id_unidade
 WHERE c.ds_status = 'FALTA'
 GROUP BY u.nm_unidade
 ORDER BY qtd_faltas DESC, u.nm_unidade;


-- ---------------------------------------------------------
-- Consulta 04
-- Pergunta: qual a media, a maior e a menor pontuação de risco
-- de falta das consultas de cada UBS?
-- Recursos: AVG, MAX, MIN, COUNT, GROUP BY, INNER JOIN
-- Esperado: Pinheiros 2 consultas, media 0,45, max 0,68,
-- min 0,22 | Tatuape 1, 0,62, 0,62, 0,62 |
-- Vila Mariana 5, 0,59, 0,82, 0,3
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       COUNT(c.id_consulta)          AS qtd_consultas,
       ROUND(AVG(c.vl_prob_falta), 2) AS media_prob,
       MAX(c.vl_prob_falta)           AS maior_prob,
       MIN(c.vl_prob_falta)           AS menor_prob
  FROM ACM_CONSULTA c
 INNER JOIN ACM_HORARIO h ON h.id_horario = c.id_horario
 INNER JOIN ACM_UNIDADE u ON u.id_unidade = h.id_unidade
 GROUP BY u.nm_unidade
 ORDER BY u.nm_unidade;


-- ---------------------------------------------------------
-- Consulta 05
-- Pergunta: quantos minutos de atendimento cada UBS perdeu
-- com faltas?
-- Recursos: SUM, GROUP BY, WHERE, INNER JOIN
-- Esperado: Vila Mariana 40 | Pinheiros 20 | Tatuape 20
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       SUM(h.nr_duracao_min) AS minutos_perdidos
  FROM ACM_CONSULTA c
 INNER JOIN ACM_HORARIO h ON h.id_horario = c.id_horario
 INNER JOIN ACM_UNIDADE u ON u.id_unidade = h.id_unidade
 WHERE c.ds_status = 'FALTA'
 GROUP BY u.nm_unidade
 ORDER BY minutos_perdidos DESC, u.nm_unidade;


-- ---------------------------------------------------------
-- Consulta 06
-- Pergunta: quais UBS tiveram mais de uma falta?
-- Recursos: COUNT, GROUP BY, HAVING
-- Esperado: UBS Vila Mariana 2
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       COUNT(c.id_consulta) AS qtd_faltas
  FROM ACM_CONSULTA c
 INNER JOIN ACM_HORARIO h ON h.id_horario = c.id_horario
 INNER JOIN ACM_UNIDADE u ON u.id_unidade = h.id_unidade
 WHERE c.ds_status = 'FALTA'
 GROUP BY u.nm_unidade
HAVING COUNT(c.id_consulta) > 1;


-- ---------------------------------------------------------
-- Consulta 07
-- Pergunta: quais consultas tem pontuação de risco de falta acima
-- da media geral?
-- Recursos: subconsulta (SUBSELECT), ORDER BY
-- Media geral = 0,54875.
-- Esperado: consultas 1 (0,82), 3 (0,76), 8 (0,71),
-- 5 (0,68) e 7 (0,62)
-- ---------------------------------------------------------
SELECT c.id_consulta,
       ci.nm_cidadao,
       c.vl_prob_falta
  FROM ACM_CONSULTA c
 INNER JOIN ACM_CIDADAO ci ON ci.id_cidadao = c.id_cidadao
 WHERE c.vl_prob_falta > (SELECT AVG(vl_prob_falta) FROM ACM_CONSULTA)
 ORDER BY c.vl_prob_falta DESC;


-- ---------------------------------------------------------
-- Consulta 08
-- Pergunta: quais horarios estao livres, sem nenhuma consulta?
-- Recursos: LEFT JOIN, WHERE com IS NULL
-- O LEFT JOIN traz todos os horarios. Os que nao tem consulta
-- ficam com as colunas da consulta vazias.
-- Esperado: horario 8, UBS Vila Mariana, 17/11/2026 09:00
-- ---------------------------------------------------------
SELECT h.id_horario,
       u.nm_unidade,
       TO_CHAR(h.dt_horario, 'DD/MM/YYYY HH24:MI') AS data_hora
  FROM ACM_HORARIO h
  LEFT JOIN ACM_CONSULTA c ON c.id_horario = h.id_horario
 INNER JOIN ACM_UNIDADE u  ON u.id_unidade = h.id_unidade
 WHERE c.id_consulta IS NULL
 ORDER BY h.dt_horario;


-- ---------------------------------------------------------
-- Consulta 09
-- Pergunta: quantas orientacoes cada queixa recebeu,
-- incluindo as que nao tiveram nenhuma?
-- Recursos: RIGHT JOIN, COUNT, GROUP BY
-- O RIGHT JOIN mantem todas as queixas, mesmo sem orientacao.
-- Esperado: Dor de garganta 2 | Diarreia e vomito 1 |
-- Dor de cabeca 1 | Sindrome gripal 1 | Ardencia ao urinar 0
-- ---------------------------------------------------------
SELECT q.nm_queixa,
       COUNT(o.id_orientacao) AS qtd_orientacoes
  FROM ACM_ORIENTACAO o
 RIGHT JOIN ACM_QUEIXA q ON q.id_queixa = o.id_queixa
 GROUP BY q.nm_queixa
 ORDER BY qtd_orientacoes DESC, q.nm_queixa;


-- ---------------------------------------------------------
-- Consulta 10
-- Pergunta: quais foram as respostas de cada orientacao, com
-- o texto da pergunta?
-- Recursos: INNER JOIN entre 4 tabelas, passando pela tabela
-- associativa ACM_RESPOSTA (relacionamento N:N)
-- Esperado: 9 linhas. Ex.: orientacao 2 respondeu SIM a
-- "A dor comecou de repente..." e ficou VERMELHO.
-- ---------------------------------------------------------
SELECT o.id_orientacao,
       q.nm_queixa,
       p.nr_ordem,
       p.ds_pergunta,
       r.ds_resposta,
       o.ds_cor
  FROM ACM_RESPOSTA r
 INNER JOIN ACM_ORIENTACAO o ON o.id_orientacao = r.id_orientacao
 INNER JOIN ACM_PERGUNTA p   ON p.id_pergunta   = r.id_pergunta
 INNER JOIN ACM_QUEIXA q     ON q.id_queixa     = p.id_queixa
 ORDER BY o.id_orientacao, p.nr_ordem;


-- ---------------------------------------------------------
-- Consulta 11
-- Pergunta: quem entrou na lista do dia, na ordem de
-- atendimento de cada dia?
-- Regra da solucao: primeiro quem tem prioridade, depois a
-- cor (VERDE antes de AZUL) e, por fim, a hora de chegada.
-- Em ordem alfabetica decrescente, VERDE vem antes de AZUL.
-- O TO_CHAR com 'YYYY-MM-DD' separa os dias sem a hora, e
-- nesse formato a ordem do texto e a mesma das datas.
-- Recursos: INNER JOIN, ORDER BY com varias colunas
-- Esperado: 4 linhas: Pedro 03/11, Pedro 04/11 (prioridade
-- S, ENCAIXADO), Maria 09/11, Joao 10/11
-- ---------------------------------------------------------
SELECT TO_CHAR(l.dt_entrada, 'DD/MM/YYYY HH24:MI') AS entrada,
       ci.nm_cidadao,
       u.nm_unidade,
       l.fl_prioridade,
       o.ds_cor,
       l.ds_status
  FROM ACM_LISTA_DIA l
 INNER JOIN ACM_CIDADAO ci   ON ci.id_cidadao   = l.id_cidadao
 INNER JOIN ACM_UNIDADE u    ON u.id_unidade    = l.id_unidade
 INNER JOIN ACM_ORIENTACAO o ON o.id_orientacao = l.id_orientacao
 ORDER BY TO_CHAR(l.dt_entrada, 'YYYY-MM-DD'), l.fl_prioridade DESC, o.ds_cor DESC, l.dt_entrada;


-- ---------------------------------------------------------
-- Consulta 12
-- Pergunta: quantas pessoas ficaram sem encaixe por UBS e por
-- dia? (indicador "Pessoas nao encaixadas" da Tabela 4)
-- Recursos: COUNT, GROUP BY com duas colunas, WHERE
-- O TO_CHAR com 'YYYY-MM-DD' agrupa pelo dia, sem a hora.
-- Esperado: UBS Vila Mariana, 2026-11-03, 1 |
-- UBS Vila Mariana, 2026-11-09, 1
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       TO_CHAR(l.dt_entrada, 'YYYY-MM-DD') AS dia,
       COUNT(l.id_lista) AS qtd_nao_encaixados
  FROM ACM_LISTA_DIA l
 INNER JOIN ACM_UNIDADE u ON u.id_unidade = l.id_unidade
 WHERE l.ds_status = 'NAO_ENCAIXADO'
 GROUP BY u.nm_unidade, TO_CHAR(l.dt_entrada, 'YYYY-MM-DD')
 ORDER BY dia;


-- ---------------------------------------------------------
-- Consulta 13
-- Pergunta: quantas orientacoes houve por cor e por destino?
-- Recursos: COUNT, GROUP BY com duas colunas
-- Esperado: VERDE/UBS 2 | AZUL/UBS 1 | AZUL/UPA 1 |
-- VERMELHO/SAMU 1
-- ---------------------------------------------------------
SELECT o.ds_cor,
       o.ds_destino,
       COUNT(o.id_orientacao) AS qtd_orientacoes
  FROM ACM_ORIENTACAO o
 GROUP BY o.ds_cor, o.ds_destino
 ORDER BY qtd_orientacoes DESC, o.ds_cor, o.ds_destino;


-- ---------------------------------------------------------
-- Consulta 14
-- Pergunta: quais cidadaos com consulta marcada nao tem
-- nenhum canal de contato? (excecao da regra: a consulta
-- deles nao e liberada automaticamente)
-- Recursos: WHERE com IS NULL, INNER JOIN
-- Esperado: Sebastiana Ramos, BALCAO, consulta 1, FALTA
-- ---------------------------------------------------------
SELECT ci.nm_cidadao,
       ci.tp_acesso,
       c.id_consulta,
       c.ds_status
  FROM ACM_CIDADAO ci
 INNER JOIN ACM_CONSULTA c ON c.id_cidadao = ci.id_cidadao
 WHERE ci.nr_celular IS NULL
   AND ci.nr_contato_recado IS NULL;


-- ---------------------------------------------------------
-- Consulta 15
-- Pergunta: em quantas orientacoes o modelo de IA elevou o
-- destino para a UPA?
-- Recursos: COUNT, WHERE
-- Esperado: 1
-- ---------------------------------------------------------
SELECT COUNT(*) AS qtd_elevadas_pelo_modelo
  FROM ACM_ORIENTACAO
 WHERE fl_elevada_modelo = 'S';


-- ---------------------------------------------------------
-- Consulta 16
-- Pergunta: quantos horarios cada unidade disponibiliza,
-- incluindo as que nao tem nenhum?
-- Recursos: LEFT JOIN, COUNT, GROUP BY
-- Esperado: UBS Vila Mariana 5 | UBS Pinheiros 2 |
-- UBS Tatuape 1 | UPA Campo Limpo 0 | UPA Santana 0
-- ---------------------------------------------------------
SELECT u.nm_unidade,
       u.tp_unidade,
       COUNT(h.id_horario) AS qtd_horarios
  FROM ACM_UNIDADE u
  LEFT JOIN ACM_HORARIO h ON h.id_unidade = u.id_unidade
 GROUP BY u.nm_unidade, u.tp_unidade
 ORDER BY qtd_horarios DESC, u.nm_unidade;


-- ---------------------------------------------------------
-- Consulta 17
-- Pergunta: quais cidadaos nunca faltaram a uma consulta?
-- Recursos: subconsulta com NOT IN, ORDER BY
-- Esperado: Ana Beatriz | Carlos Nunes | Maria Silva |
-- Pedro Lima
-- ---------------------------------------------------------
SELECT ci.id_cidadao,
       ci.nm_cidadao
  FROM ACM_CIDADAO ci
 WHERE ci.id_cidadao NOT IN (SELECT c.id_cidadao
                               FROM ACM_CONSULTA c
                              WHERE c.ds_status = 'FALTA')
 ORDER BY ci.nm_cidadao;


-- ---------------------------------------------------------
-- Consulta 18
-- Pergunta: quais horarios liberados foram reaproveitados por
-- outro paciente? (indicador "Reaproveitamento de horarios"
-- da Tabela 4)
-- Recursos: subconsulta com IN, INNER JOIN, WHERE
-- Esperado: horario 3, UBS Vila Mariana, 04/11/2026 09:00,
-- Pedro Lima, REALIZADA
-- ---------------------------------------------------------
SELECT h.id_horario,
       u.nm_unidade,
       TO_CHAR(h.dt_horario, 'DD/MM/YYYY HH24:MI') AS data_hora,
       ci.nm_cidadao AS quem_reaproveitou,
       c.ds_status
  FROM ACM_CONSULTA c
 INNER JOIN ACM_HORARIO h  ON h.id_horario  = c.id_horario
 INNER JOIN ACM_UNIDADE u  ON u.id_unidade  = h.id_unidade
 INNER JOIN ACM_CIDADAO ci ON ci.id_cidadao = c.id_cidadao
 WHERE c.ds_status <> 'LIBERADA'
   AND c.id_horario IN (SELECT id_horario
                          FROM ACM_CONSULTA
                         WHERE ds_status = 'LIBERADA');