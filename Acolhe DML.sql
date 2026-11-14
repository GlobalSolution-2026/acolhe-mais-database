-- =========================================================
-- INSERTs - 62 registros (mesmas unidades e pessoas do MVP)
-- ---------------------------------------------------------
-- A PK vem da sequence (NEXTVAL). Como cada sequence comeca
-- em 1 e os INSERTs seguem a ordem, os IDs saem 1, 2, 3... e
-- as FKs usam esses numeros.
-- Historia dos dados (segue as regras do texto da GS):
-- * 3 UBS e 2 UPA em SP. As UPA nao tem horarios agendados.
-- * 5 queixas do escopo; "Ardencia ao urinar" ainda nao teve
--   orientacao (aparece no RIGHT JOIN).
-- * O fluxo de perguntas para no primeiro sinal de alarme.
-- * Consulta nao confirmada ate 1 dia util antes e liberada,
--   exceto de quem nao tem nenhum canal de contato.
-- * Datas fixas em dias uteis de novembro/2026 (02/11 e
--   20/11 sao feriados), para o resultado nao mudar.
-- * Textos sem acento, para evitar erro de codificacao.
-- =========================================================


-- ---------------------------------------------------------
-- ACM_UNIDADE (5 registros) - as mesmas do MVP
-- As UBS (1 a 3) recebem agendamentos. As UPA (4 e 5) sao
-- indicadas nos casos amarelos ou quando o modelo eleva a
-- orientacao.
-- ---------------------------------------------------------
INSERT INTO ACM_UNIDADE VALUES (SEQ_ACM_UNIDADE.NEXTVAL, 'UBS Vila Mariana', 'UBS', 'Rua Domingos de Morais, 1200 - Vila Mariana', '04010100', '1150841100');
INSERT INTO ACM_UNIDADE VALUES (SEQ_ACM_UNIDADE.NEXTVAL, 'UBS Pinheiros', 'UBS', 'Rua Teodoro Sampaio, 850 - Pinheiros', '05405000', '1130622200');
INSERT INTO ACM_UNIDADE VALUES (SEQ_ACM_UNIDADE.NEXTVAL, 'UBS Tatuape', 'UBS', 'Rua Tuiuti, 1500 - Tatuape', '03081000', '1120913300');
INSERT INTO ACM_UNIDADE VALUES (SEQ_ACM_UNIDADE.NEXTVAL, 'UPA Santana', 'UPA', 'Av. Voluntarios da Patria, 2400 - Santana', '02010000', '1129714400');
INSERT INTO ACM_UNIDADE VALUES (SEQ_ACM_UNIDADE.NEXTVAL, 'UPA Campo Limpo', 'UPA', 'Estrada do Campo Limpo, 3000 - Campo Limpo', '05777000', '1158415500');


-- ---------------------------------------------------------
-- ACM_QUEIXA (5 registros)
-- As 5 queixas do escopo (Cadernos de Atencao Basica n. 28).
-- ---------------------------------------------------------
INSERT INTO ACM_QUEIXA VALUES (SEQ_ACM_QUEIXA.NEXTVAL, 'Sindrome gripal');
INSERT INTO ACM_QUEIXA VALUES (SEQ_ACM_QUEIXA.NEXTVAL, 'Dor de garganta');
INSERT INTO ACM_QUEIXA VALUES (SEQ_ACM_QUEIXA.NEXTVAL, 'Diarreia e vomito');
INSERT INTO ACM_QUEIXA VALUES (SEQ_ACM_QUEIXA.NEXTVAL, 'Dor de cabeca');
INSERT INTO ACM_QUEIXA VALUES (SEQ_ACM_QUEIXA.NEXTVAL, 'Ardencia ao urinar');


-- ---------------------------------------------------------
-- ACM_CIDADAO (8 registros) - os mesmos do MVP
-- * SENHA: conta propria no app (Maria Silva e a conta demo).
-- * GOVBR: entra pelo gov.br, por isso tem CPF e nao tem senha.
-- * BALCAO: cadastrada pela recepcao, sem senha.
-- Sebastiana (3) nao tem nenhum canal de contato. Juliana (7)
-- so tem contato de recado. Hash, CPF e CNS sao ficticios.
-- ---------------------------------------------------------
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Maria Silva', '111222233334444', NULL, TO_DATE('12/03/1958', 'DD/MM/YYYY'), 'F', '11988880001', NULL, NULL, '04010100', 'SENHA', '$2a$10$hashficticio.cidadao01');
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Joao Souza', '222333344445555', '10000000002', TO_DATE('01/07/1990', 'DD/MM/YYYY'), 'M', '11988880002', NULL, NULL, '05405000', 'GOVBR', NULL);
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Sebastiana Ramos', '333444455556666', NULL, TO_DATE('25/11/1949', 'DD/MM/YYYY'), 'F', NULL, NULL, NULL, '03081000', 'BALCAO', NULL);
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Pedro Lima', '444555566667777', NULL, TO_DATE('30/01/1985', 'DD/MM/YYYY'), 'M', '11988880004', NULL, NULL, '04010100', 'SENHA', '$2a$10$hashficticio.cidadao04');
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Ana Beatriz', '555666677778888', '10000000005', TO_DATE('14/05/2001', 'DD/MM/YYYY'), 'F', '11988880005', 'Contato da familia', '11977770005', '05405000', 'GOVBR', NULL);
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Carlos Nunes', '666777788889999', NULL, TO_DATE('08/09/1976', 'DD/MM/YYYY'), 'M', '11988880006', NULL, NULL, '03081000', 'SENHA', '$2a$10$hashficticio.cidadao06');
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Juliana Santos', '700000000000006', NULL, TO_DATE('22/04/1993', 'DD/MM/YYYY'), 'F', NULL, 'Contato da familia', '11977770007', '04010100', 'BALCAO', NULL);
INSERT INTO ACM_CIDADAO VALUES (SEQ_ACM_CIDADAO.NEXTVAL, 'Jose Oliveira', '700000000000007', '10000000008', TO_DATE('03/10/1968', 'DD/MM/YYYY'), 'M', '11988880008', NULL, NULL, '05405000', 'GOVBR', NULL);


-- ---------------------------------------------------------
-- ACM_USUARIO (2 registros)
-- Recepcionista da UBS Vila Mariana e um usuario da gestao,
-- que nao precisa de unidade (CK_ACM_USUARIO_UNIDADE).
-- ---------------------------------------------------------
INSERT INTO ACM_USUARIO VALUES (SEQ_ACM_USUARIO.NEXTVAL, 'Beatriz Ramos', 'beatriz.ramos@acolhemais.com.br', '$2a$10$hashficticio.usuario01', 'RECEPCAO', 'S', 1);
INSERT INTO ACM_USUARIO VALUES (SEQ_ACM_USUARIO.NEXTVAL, 'Fernanda Duarte', 'fernanda.duarte@acolhemais.com.br', '$2a$10$hashficticio.usuario02', 'GESTAO', 'S', NULL);


-- ---------------------------------------------------------
-- ACM_PERGUNTA (8 registros) - textos tirados do MVP
-- Duas perguntas para cada queixa ja usada. A cor e aplicada
-- quando a resposta e SIM: VERMELHO = SAMU; LARANJA =
-- pronto-socorro; AMARELO = UPA; VERDE = muda de azul para
-- verde.
-- ---------------------------------------------------------
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Tem falta de ar ou cansaco para respirar, mesmo parado?', 1, 'VERMELHO', 1);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Tem febre ha mais de 3 dias, ou a febre voltou depois de 2 dias sem febre?', 2, 'AMARELO', 1);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Tem dificuldade para abrir a boca?', 1, 'LARANJA', 2);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Esta com febre?', 2, 'VERDE', 2);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Vomita tudo o que bebe?', 1, 'AMARELO', 3);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'A diarreia dura 14 dias ou mais?', 2, 'VERDE', 3);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'A dor comecou de repente, muito forte, como a pior da vida?', 1, 'VERMELHO', 4);
INSERT INTO ACM_PERGUNTA VALUES (SEQ_ACM_PERGUNTA.NEXTVAL, 'Tem vomitos em jato, sem enjoo antes?', 2, 'AMARELO', 4);


-- ---------------------------------------------------------
-- ACM_HORARIO (8 registros)
-- Consultas de 20 minutos, como no MVP, em dias uteis. O
-- horario 8 fica sem consulta: e a vaga livre que aparece no
-- LEFT JOIN.
-- ---------------------------------------------------------
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('03/11/2026 08:00', 'DD/MM/YYYY HH24:MI'), 20, 1);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('03/11/2026 09:00', 'DD/MM/YYYY HH24:MI'), 20, 1);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('04/11/2026 09:00', 'DD/MM/YYYY HH24:MI'), 20, 1);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('04/11/2026 10:00', 'DD/MM/YYYY HH24:MI'), 20, 2);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('05/11/2026 14:00', 'DD/MM/YYYY HH24:MI'), 20, 2);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('05/11/2026 08:00', 'DD/MM/YYYY HH24:MI'), 20, 3);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('17/11/2026 08:00', 'DD/MM/YYYY HH24:MI'), 20, 1);
INSERT INTO ACM_HORARIO VALUES (SEQ_ACM_HORARIO.NEXTVAL, TO_DATE('17/11/2026 09:00', 'DD/MM/YYYY HH24:MI'), 20, 1);


-- ---------------------------------------------------------
-- ACM_ORIENTACAO (5 registros)
-- * 2: anonima (sem cidadao). Disse SIM a dor subita, a
--   pior da vida: VERMELHO, SAMU.
-- * 3: as regras deram AZUL, mas o modelo indicou urgencia.
--   A cor continua AZUL e o destino passa a ser a UPA
--   (fl_elevada_modelo = 'S'). O modelo nunca reduz a cor.
-- ---------------------------------------------------------
INSERT INTO ACM_ORIENTACAO VALUES (SEQ_ACM_ORIENTACAO.NEXTVAL, TO_DATE('03/11/2026 07:10', 'DD/MM/YYYY HH24:MI'), 'VERDE', 'UBS', 3, 'N', 1, 4, 1);
INSERT INTO ACM_ORIENTACAO VALUES (SEQ_ACM_ORIENTACAO.NEXTVAL, TO_DATE('04/11/2026 22:40', 'DD/MM/YYYY HH24:MI'), 'VERMELHO', 'SAMU', 9, 'N', 4, NULL, NULL);
INSERT INTO ACM_ORIENTACAO VALUES (SEQ_ACM_ORIENTACAO.NEXTVAL, TO_DATE('05/11/2026 19:15', 'DD/MM/YYYY HH24:MI'), 'AZUL', 'UPA', 4, 'S', 3, 5, 4);
INSERT INTO ACM_ORIENTACAO VALUES (SEQ_ACM_ORIENTACAO.NEXTVAL, TO_DATE('09/11/2026 07:45', 'DD/MM/YYYY HH24:MI'), 'AZUL', 'UBS', 2, 'N', 2, 1, 1);
INSERT INTO ACM_ORIENTACAO VALUES (SEQ_ACM_ORIENTACAO.NEXTVAL, TO_DATE('10/11/2026 07:30', 'DD/MM/YYYY HH24:MI'), 'VERDE', 'UBS', 3, 'N', 2, 2, 1);


-- ---------------------------------------------------------
-- ACM_RESPOSTA (9 registros) - tabela associativa N:N
-- Cada orientacao responde as perguntas da propria queixa.
-- A orientacao 2 tem uma unica resposta porque o fluxo para
-- no primeiro sinal de alarme. Na 5, a febre mudou a cor de
-- AZUL para VERDE.
-- ---------------------------------------------------------
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 1, 1);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 1, 2);
INSERT INTO ACM_RESPOSTA VALUES ('SIM', 2, 7);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 3, 5);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 3, 6);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 4, 3);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 4, 4);
INSERT INTO ACM_RESPOSTA VALUES ('NAO', 5, 3);
INSERT INTO ACM_RESPOSTA VALUES ('SIM', 5, 4);


-- ---------------------------------------------------------
-- ACM_LISTA_DIA (4 registros)
-- * Pedro (4) nao e encaixado em 03/11. Volta em 04/11 com
--   prioridade (fl_prioridade = 'S') e e encaixado na vaga
--   liberada do horario 3.
-- * Maria (1) nao e encaixada em 09/11 e recebe o proximo
--   horario livre da agenda (consulta 8).
-- * Joao (2) ainda aguarda na lista.
-- ---------------------------------------------------------
INSERT INTO ACM_LISTA_DIA VALUES (SEQ_ACM_LISTA_DIA.NEXTVAL, TO_DATE('03/11/2026 07:20', 'DD/MM/YYYY HH24:MI'), 'NAO_ENCAIXADO', 'N', 4, 1, 1);
INSERT INTO ACM_LISTA_DIA VALUES (SEQ_ACM_LISTA_DIA.NEXTVAL, TO_DATE('04/11/2026 07:35', 'DD/MM/YYYY HH24:MI'), 'ENCAIXADO', 'S', 4, 1, 1);
INSERT INTO ACM_LISTA_DIA VALUES (SEQ_ACM_LISTA_DIA.NEXTVAL, TO_DATE('09/11/2026 08:10', 'DD/MM/YYYY HH24:MI'), 'NAO_ENCAIXADO', 'N', 1, 1, 4);
INSERT INTO ACM_LISTA_DIA VALUES (SEQ_ACM_LISTA_DIA.NEXTVAL, TO_DATE('10/11/2026 07:50', 'DD/MM/YYYY HH24:MI'), 'AGUARDANDO', 'N', 2, 1, 5);


-- ---------------------------------------------------------
-- ACM_CONSULTA (8 registros)
-- Risco ALTO quando a probabilidade de falta e >= 0,60.
-- * 1: FALTA sem confirmacao. Sebastiana nao tem canal de
--   contato, entao a consulta dela nao pode ser liberada.
-- * 2, 5 e 7: confirmaram (app, telefone pelo recado e
--   presencial), mas faltaram. A 2 tinha risco BAIXO,
--   mostrando que o modelo pode errar.
-- * 3: nao confirmada ate 03/11, vaga LIBERADA. A 4 e o
--   encaixe do Pedro no mesmo horario; marcada a menos de 1
--   dia util, dispensa confirmacao.
-- * 8: Maria, AGENDADA no proximo horario livre.
-- Data e canal de confirmacao andam juntos
-- (CK_ACM_CONSULTA_CONFIRMACAO).
-- ---------------------------------------------------------
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('20/10/2026 10:15', 'DD/MM/YYYY HH24:MI'), NULL, NULL, 'FALTA', 0.82, 'ALTO', 1, 3, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('21/10/2026 11:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('30/10/2026 09:00', 'DD/MM/YYYY HH24:MI'), 'APP', 'FALTA', 0.35, 'BAIXO', 2, 2, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('22/10/2026 14:30', 'DD/MM/YYYY HH24:MI'), NULL, NULL, 'LIBERADA', 0.76, 'ALTO', 3, 5, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('04/11/2026 07:40', 'DD/MM/YYYY HH24:MI'), NULL, NULL, 'REALIZADA', 0.30, 'BAIXO', 3, 4, 1);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('23/10/2026 09:20', 'DD/MM/YYYY HH24:MI'), TO_DATE('30/10/2026 10:00', 'DD/MM/YYYY HH24:MI'), 'TELEFONE', 'FALTA', 0.68, 'ALTO', 4, 7, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('26/10/2026 16:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('03/11/2026 10:00', 'DD/MM/YYYY HH24:MI'), 'APP', 'REALIZADA', 0.22, 'BAIXO', 5, 6, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('27/10/2026 08:45', 'DD/MM/YYYY HH24:MI'), TO_DATE('03/11/2026 15:00', 'DD/MM/YYYY HH24:MI'), 'PRESENCIAL', 'FALTA', 0.62, 'ALTO', 6, 8, NULL);
INSERT INTO ACM_CONSULTA VALUES (SEQ_ACM_CONSULTA.NEXTVAL, TO_DATE('09/11/2026 17:30', 'DD/MM/YYYY HH24:MI'), NULL, NULL, 'AGENDADA', 0.71, 'ALTO', 7, 1, 4);

COMMIT;