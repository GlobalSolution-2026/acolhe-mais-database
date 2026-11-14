-- =========================================================
-- UPDATEs
-- =========================================================

-- ---------------------------------------------------------
-- UPDATE 1 - confirmacao de consulta
-- Situacao: Maria Silva confirma pelo app a consulta 8
-- (17/11/2026 08:00, risco ALTO). Para risco ALTO, o pedido de
-- confirmacao sai 3 dias uteis antes (12/11) e o prazo vai ate
-- 1 dia util antes (16/11). A confirmacao em 13/11 esta dentro
-- do prazo.
-- Data e canal sao preenchidos juntos, como exige o
-- CK_ACM_CONSULTA_CONFIRMACAO.
-- ---------------------------------------------------------
SELECT id_consulta, ds_status, dt_confirmacao, ds_canal_confirmacao
  FROM ACM_CONSULTA
 WHERE id_consulta = 8;

UPDATE ACM_CONSULTA
   SET ds_status            = 'CONFIRMADA',
       dt_confirmacao       = TO_DATE('13/11/2026 10:00', 'DD/MM/YYYY HH24:MI'),
       ds_canal_confirmacao = 'APP'
 WHERE id_consulta = 8;

SELECT id_consulta, ds_status, dt_confirmacao, ds_canal_confirmacao
  FROM ACM_CONSULTA
 WHERE id_consulta = 8;


-- ---------------------------------------------------------
-- UPDATE 2 - contato de recado
-- Situacao: na conferencia do cadastro, a recepcao inclui um
-- contato de recado para Sebastiana Ramos, que nao tinha
-- nenhum canal. A partir de agora, a consulta dela pode
-- seguir a regra normal de confirmacao.
-- ---------------------------------------------------------
SELECT id_cidadao, nm_cidadao, nr_celular, nm_contato_recado, nr_contato_recado
  FROM ACM_CIDADAO
 WHERE id_cidadao = 3;

UPDATE ACM_CIDADAO
   SET nm_contato_recado = 'Rosa Ramos (filha)',
       nr_contato_recado = '11977770003'
 WHERE id_cidadao = 3;

SELECT id_cidadao, nm_cidadao, nr_celular, nm_contato_recado, nr_contato_recado
  FROM ACM_CIDADAO
 WHERE id_cidadao = 3;


-- ---------------------------------------------------------
-- UPDATE 3 - criacao de conta no app
-- Situacao: Juliana Santos, cadastrada pela recepcao
-- (BALCAO), cria a propria conta no app. O tipo de acesso
-- passa para SENHA e o hash e gravado no mesmo comando, como
-- exige o CK_ACM_CIDADAO_SENHA.
-- ---------------------------------------------------------
SELECT id_cidadao, nm_cidadao, tp_acesso, ds_senha_hash
  FROM ACM_CIDADAO
 WHERE id_cidadao = 7;

UPDATE ACM_CIDADAO
   SET tp_acesso     = 'SENHA',
       ds_senha_hash = '$2a$10$hashficticio.cidadao07'
 WHERE id_cidadao = 7;

SELECT id_cidadao, nm_cidadao, tp_acesso, ds_senha_hash
  FROM ACM_CIDADAO
 WHERE id_cidadao = 7;


-- ---------------------------------------------------------
-- UPDATE 4 - desativacao de usuario
-- Situacao: a usuaria da gestao deixa a secretaria. Em vez de
-- apagar o registro, o acesso e desativado (fl_ativo = 'N'),
-- para manter o historico de quem usou o sistema.
-- ---------------------------------------------------------
SELECT id_usuario, nm_usuario, ds_perfil, fl_ativo
  FROM ACM_USUARIO
 WHERE id_usuario = 2;

UPDATE ACM_USUARIO
   SET fl_ativo = 'N'
 WHERE id_usuario = 2;

SELECT id_usuario, nm_usuario, ds_perfil, fl_ativo
  FROM ACM_USUARIO
 WHERE id_usuario = 2;


-- =========================================================
-- DELETEs
-- =========================================================

-- ---------------------------------------------------------
-- DELETE 1 - saida da lista do dia
-- Situacao: Joao Souza (entrada 4, ainda AGUARDANDO) desiste
-- de esperar o encaixe e sai da lista da UBS Vila Mariana.
-- Nenhuma tabela aponta para ACM_LISTA_DIA, entao a exclusao
-- nao fere nenhuma chave estrangeira.
-- ---------------------------------------------------------
SELECT id_lista, ds_status, id_cidadao
  FROM ACM_LISTA_DIA
 ORDER BY id_lista;

DELETE FROM ACM_LISTA_DIA
 WHERE id_lista = 4;

SELECT id_lista, ds_status, id_cidadao
  FROM ACM_LISTA_DIA
 ORDER BY id_lista;


-- ---------------------------------------------------------
-- DELETE 2 - horario retirado da agenda
-- Situacao: a UBS Vila Mariana cancela o horario livre de
-- 17/11/2026 09:00 (horario 8) por falta de profissional.
-- So pode ser apagado porque nao tem nenhuma consulta
-- ligada a ele.
-- ---------------------------------------------------------
SELECT id_horario, TO_CHAR(dt_horario, 'DD/MM/YYYY HH24:MI') AS data_hora, id_unidade
  FROM ACM_HORARIO
 WHERE id_unidade = 1
 ORDER BY dt_horario;

DELETE FROM ACM_HORARIO
 WHERE id_horario = 8
   AND id_horario NOT IN (SELECT id_horario FROM ACM_CONSULTA);

SELECT id_horario, TO_CHAR(dt_horario, 'DD/MM/YYYY HH24:MI') AS data_hora, id_unidade
  FROM ACM_HORARIO
 WHERE id_unidade = 1
 ORDER BY dt_horario;


-- ---------------------------------------------------------
-- DELETE 3 - descarte de orientacao anonima (LGPD)
-- Situacao: a orientacao 2 foi feita sem login e nao gerou
-- consulta nem entrada na lista do dia. Pelo principio da
-- necessidade da LGPD, ela e descartada.
-- As respostas (tabela filha) saem primeiro e a orientacao
-- (tabela mae) depois. Na ordem contraria, a FK
-- ACM_RESPOSTA_ACM_ORIENTACAO_FK bloquearia a exclusao.
-- ---------------------------------------------------------
SELECT o.id_orientacao, o.ds_cor, o.ds_destino, COUNT(r.id_pergunta) AS qtd_respostas
  FROM ACM_ORIENTACAO o
  LEFT JOIN ACM_RESPOSTA r ON r.id_orientacao = o.id_orientacao
 GROUP BY o.id_orientacao, o.ds_cor, o.ds_destino
 ORDER BY o.id_orientacao;

DELETE FROM ACM_RESPOSTA
 WHERE id_orientacao = 2;

DELETE FROM ACM_ORIENTACAO
 WHERE id_orientacao = 2
   AND id_cidadao IS NULL;

SELECT o.id_orientacao, o.ds_cor, o.ds_destino, COUNT(r.id_pergunta) AS qtd_respostas
  FROM ACM_ORIENTACAO o
  LEFT JOIN ACM_RESPOSTA r ON r.id_orientacao = o.id_orientacao
 GROUP BY o.id_orientacao, o.ds_cor, o.ds_destino
 ORDER BY o.id_orientacao;

COMMIT;