-- =========================================================
-- Acolhe+ | Global Solution 2026/2 - CitizenTech
-- Building Relational Database - Script DDL (Oracle 11g)
-- =========================================================

-- =========================================================
-- Tabela ACM_UNIDADE
-- Unidades de saude atendidas pelo Acolhe+ (UBS ou UPA),
-- com endereco e telefone de contato.
-- =========================================================
CREATE TABLE ACM_UNIDADE
    (
     id_unidade  NUMBER (10)    NOT NULL ,
     nm_unidade  VARCHAR2 (100) NOT NULL ,
     tp_unidade  VARCHAR2 (3)   NOT NULL ,
     ds_endereco VARCHAR2 (150) NOT NULL ,
     nr_cep      VARCHAR2 (8) ,
     nr_telefone VARCHAR2 (11)
    )
;

ALTER TABLE ACM_UNIDADE
    ADD CONSTRAINT CK_ACM_UNIDADE_TIPO
    CHECK (tp_unidade IN ('UBS', 'UPA'))
;

ALTER TABLE ACM_UNIDADE
    ADD CONSTRAINT ACM_UNIDADE_PK PRIMARY KEY ( id_unidade ) ;


-- =========================================================
-- Tabela ACM_QUEIXA
-- Queixas principais que o cidadao pode escolher ao pedir
-- orientacao de atendimento (inspirada em Manchester).
-- =========================================================
CREATE TABLE ACM_QUEIXA
    (
     id_queixa NUMBER (10)   NOT NULL ,
     nm_queixa VARCHAR2 (60) NOT NULL
    )
;

ALTER TABLE ACM_QUEIXA
    ADD CONSTRAINT ACM_QUEIXA_PK PRIMARY KEY ( id_queixa ) ;

ALTER TABLE ACM_QUEIXA
    ADD CONSTRAINT UQ_ACM_QUEIXA_NOME UNIQUE ( nm_queixa ) ;


-- =========================================================
-- Tabela ACM_CIDADAO
-- Cidadaos cadastrados no Acolhe+, identificados pelo CNS.
-- Acesso por senha propria, gov.br ou pelo balcao da UBS
-- (cadastro feito pela recepcao, sem senha).
-- =========================================================
CREATE TABLE ACM_CIDADAO
    (
     id_cidadao        NUMBER (10)    NOT NULL ,
     nm_cidadao        VARCHAR2 (100) NOT NULL ,
     nr_cns            VARCHAR2 (15)  NOT NULL ,
     nr_cpf            VARCHAR2 (11) ,
     dt_nascimento     DATE           NOT NULL ,
     ds_sexo           CHAR (1)       NOT NULL ,
     nr_celular        VARCHAR2 (11) ,
     nm_contato_recado VARCHAR2 (100) ,
     nr_contato_recado VARCHAR2 (11) ,
     nr_cep            VARCHAR2 (8) ,
     tp_acesso         VARCHAR2 (6) DEFAULT 'SENHA' NOT NULL ,
     ds_senha_hash     VARCHAR2 (100)
    )
;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT CK_ACM_CIDADAO_SEXO
    CHECK (ds_sexo IN ('F', 'M'))
;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT CK_ACM_CIDADAO_ACESSO
    CHECK (tp_acesso IN ('BALCAO', 'GOVBR', 'SENHA'))
;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT CK_ACM_CIDADAO_SENHA
    CHECK (tp_acesso IN ('BALCAO', 'GOVBR') OR ds_senha_hash IS NOT NULL)
;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT ACM_CIDADAO_PK PRIMARY KEY ( id_cidadao ) ;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT UQ_ACM_CIDADAO_CNS UNIQUE ( nr_cns ) ;

ALTER TABLE ACM_CIDADAO
    ADD CONSTRAINT UQ_ACM_CIDADAO_CPF UNIQUE ( nr_cpf ) ;


-- =========================================================
-- Tabela ACM_USUARIO
-- Profissionais que acessam o sistema: recepcao da UBS
-- (vinculada a uma unidade) ou gestao da secretaria.
-- =========================================================
CREATE TABLE ACM_USUARIO
    (
     id_usuario    NUMBER (10)    NOT NULL ,
     nm_usuario    VARCHAR2 (100) NOT NULL ,
     ds_email      VARCHAR2 (120) NOT NULL ,
     ds_senha_hash VARCHAR2 (100) NOT NULL ,
     ds_perfil     VARCHAR2 (8)   NOT NULL ,
     fl_ativo      CHAR (1) DEFAULT 'S' NOT NULL ,
     id_unidade    NUMBER (10)
    )
;

ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT CK_ACM_USUARIO_PERFIL
    CHECK (ds_perfil IN ('GESTAO', 'RECEPCAO'))
;

ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT CK_ACM_USUARIO_ATIVO
    CHECK (fl_ativo IN ('N', 'S'))
;

ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT CK_ACM_USUARIO_UNIDADE
    CHECK (ds_perfil = 'GESTAO' OR id_unidade IS NOT NULL)
;

ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT ACM_USUARIO_PK PRIMARY KEY ( id_usuario ) ;

ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT UQ_ACM_USUARIO_EMAIL UNIQUE ( ds_email ) ;


-- =========================================================
-- Tabela ACM_PERGUNTA
-- Perguntas de triagem de cada queixa, em ordem, com a cor
-- de classificacao aplicada quando a resposta e SIM.
-- =========================================================
CREATE TABLE ACM_PERGUNTA
    (
     id_pergunta   NUMBER (10)    NOT NULL ,
     ds_pergunta   VARCHAR2 (200) NOT NULL ,
     nr_ordem      NUMBER (2)     NOT NULL ,
     ds_cor_se_sim VARCHAR2 (8) ,
     id_queixa     NUMBER (10)    NOT NULL
    )
;

ALTER TABLE ACM_PERGUNTA
    ADD CONSTRAINT CK_ACM_PERGUNTA_ORDEM
    CHECK (nr_ordem BETWEEN 1 AND 99)
;

ALTER TABLE ACM_PERGUNTA
    ADD CONSTRAINT CK_ACM_PERGUNTA_COR
    CHECK (ds_cor_se_sim IN ('AMARELO', 'AZUL', 'LARANJA', 'VERDE', 'VERMELHO'))
;

ALTER TABLE ACM_PERGUNTA
    ADD CONSTRAINT ACM_PERGUNTA_PK PRIMARY KEY ( id_pergunta ) ;


-- =========================================================
-- Tabela ACM_HORARIO
-- Horarios de atendimento disponibilizados por cada
-- unidade, com data, hora e duracao em minutos.
-- =========================================================
CREATE TABLE ACM_HORARIO
    (
     id_horario     NUMBER (10) NOT NULL ,
     dt_horario     DATE        NOT NULL ,
     nr_duracao_min NUMBER (3)  NOT NULL ,
     id_unidade     NUMBER (10) NOT NULL
    )
;

ALTER TABLE ACM_HORARIO
    ADD CONSTRAINT CK_ACM_HORARIO_DURACAO
    CHECK (nr_duracao_min BETWEEN 1 AND 240)
;

ALTER TABLE ACM_HORARIO
    ADD CONSTRAINT ACM_HORARIO_PK PRIMARY KEY ( id_horario ) ;

ALTER TABLE ACM_HORARIO
    ADD CONSTRAINT UQ_ACM_HORARIO_UNIDADE_DATA UNIQUE ( dt_horario , id_unidade ) ;


-- =========================================================
-- Tabela ACM_ORIENTACAO
-- Resultado da orientacao de atendimento: cor de
-- classificacao, nota de dor (vazia se o fluxo termina
-- antes dessa pergunta), destino indicado (UBS, UPA,
-- pronto-socorro ou SAMU) e unidade sugerida.
-- =========================================================
CREATE TABLE ACM_ORIENTACAO
    (
     id_orientacao       NUMBER (10)   NOT NULL ,
     dt_orientacao       DATE          NOT NULL ,
     ds_cor              VARCHAR2 (8)  NOT NULL ,
     ds_destino          VARCHAR2 (14) NOT NULL ,
     nr_dor              NUMBER (2) ,
     fl_elevada_modelo   CHAR (1) DEFAULT 'N' NOT NULL ,
     id_queixa           NUMBER (10)   NOT NULL ,
     id_cidadao          NUMBER (10) ,
     id_unidade_indicada NUMBER (10)
    )
;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT CK_ACM_ORIENTACAO_COR
    CHECK (ds_cor IN ('AMARELO', 'AZUL', 'LARANJA', 'VERDE', 'VERMELHO'))
;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT CK_ACM_ORIENTACAO_DESTINO
    CHECK (ds_destino IN ('PRONTO_SOCORRO', 'SAMU', 'UBS', 'UPA'))
;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT CK_ACM_ORIENTACAO_DOR
    CHECK (nr_dor BETWEEN 0 AND 10)
;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT CK_ACM_ORIENTACAO_ELEVADA
    CHECK (fl_elevada_modelo IN ('N', 'S'))
;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT ACM_ORIENTACAO_PK PRIMARY KEY ( id_orientacao ) ;


-- =========================================================
-- Tabela ACM_RESPOSTA
-- Tabela associativa (N:N) entre orientacao e pergunta.
-- Guarda a resposta do cidadao a cada pergunta de triagem.
-- =========================================================
CREATE TABLE ACM_RESPOSTA
    (
     ds_resposta   VARCHAR2 (7) NOT NULL ,
     id_orientacao NUMBER (10)  NOT NULL ,
     id_pergunta   NUMBER (10)  NOT NULL
    )
;

ALTER TABLE ACM_RESPOSTA
    ADD CONSTRAINT CK_ACM_RESPOSTA_VALOR
    CHECK (ds_resposta IN ('NAO', 'NAO_SEI', 'SIM'))
;

ALTER TABLE ACM_RESPOSTA
    ADD CONSTRAINT ACM_RESPOSTA_PK PRIMARY KEY ( id_orientacao, id_pergunta ) ;


-- =========================================================
-- Tabela ACM_LISTA_DIA
-- Lista do dia: cidadaos que aguardam encaixe em vagas
-- liberadas por falta ou cancelamento na unidade. Quem nao
-- foi encaixado no dia anterior entra com prioridade.
-- =========================================================
CREATE TABLE ACM_LISTA_DIA
    (
     id_lista      NUMBER (10) NOT NULL ,
     dt_entrada    DATE        NOT NULL ,
     ds_status     VARCHAR2 (13) DEFAULT 'AGUARDANDO' NOT NULL ,
     fl_prioridade CHAR (1) DEFAULT 'N' NOT NULL ,
     id_cidadao    NUMBER (10) NOT NULL ,
     id_unidade    NUMBER (10) NOT NULL ,
     id_orientacao NUMBER (10) NOT NULL
    )
;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT CK_ACM_LISTA_STATUS
    CHECK (ds_status IN ('AGUARDANDO', 'ENCAIXADO', 'NAO_ENCAIXADO', 'OFERTADO'))
;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT CK_ACM_LISTA_PRIORIDADE
    CHECK (fl_prioridade IN ('N', 'S'))
;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT ACM_LISTA_DIA_PK PRIMARY KEY ( id_lista ) ;


-- =========================================================
-- Tabela ACM_CONSULTA
-- Consultas agendadas pelo cidadao em um horario da UBS.
-- Guarda o status (agendada, confirmada, falta, liberada,
-- realizada), a data e o canal da confirmacao (app,
-- telefone ou presencial) e a probabilidade de falta
-- estimada pela IA.
-- =========================================================
CREATE TABLE ACM_CONSULTA
    (
     id_consulta          NUMBER (10) NOT NULL ,
     dt_agendamento       DATE        NOT NULL ,
     dt_confirmacao       DATE ,
     ds_canal_confirmacao VARCHAR2 (10) ,
     ds_status            VARCHAR2 (10) DEFAULT 'AGENDADA' NOT NULL ,
     vl_prob_falta        NUMBER (3,2) ,
     ds_risco_falta       VARCHAR2 (5) ,
     id_horario           NUMBER (10) NOT NULL ,
     id_cidadao           NUMBER (10) NOT NULL ,
     id_orientacao        NUMBER (10)
    )
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT CK_ACM_CONSULTA_CANAL
    CHECK (ds_canal_confirmacao IN ('APP', 'PRESENCIAL', 'TELEFONE'))
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT CK_ACM_CONSULTA_STATUS
    CHECK (ds_status IN ('AGENDADA', 'CONFIRMADA', 'FALTA', 'LIBERADA', 'REALIZADA'))
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT CK_ACM_CONSULTA_PROB
    CHECK (vl_prob_falta BETWEEN 0 AND 1)
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT CK_ACM_CONSULTA_RISCO
    CHECK (ds_risco_falta IN ('ALTO', 'BAIXO'))
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT CK_ACM_CONSULTA_CONFIRMACAO
    CHECK ((dt_confirmacao IS NULL AND ds_canal_confirmacao IS NULL)
        OR (dt_confirmacao IS NOT NULL AND ds_canal_confirmacao IS NOT NULL))
;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT ACM_CONSULTA_PK PRIMARY KEY ( id_consulta ) ;


-- =========================================================
-- Chaves estrangeiras
-- =========================================================
ALTER TABLE ACM_USUARIO
    ADD CONSTRAINT ACM_USUARIO_ACM_UNIDADE_FK FOREIGN KEY ( id_unidade )
    REFERENCES ACM_UNIDADE ( id_unidade ) ;

ALTER TABLE ACM_PERGUNTA
    ADD CONSTRAINT ACM_PERGUNTA_ACM_QUEIXA_FK FOREIGN KEY ( id_queixa )
    REFERENCES ACM_QUEIXA ( id_queixa ) ;

ALTER TABLE ACM_HORARIO
    ADD CONSTRAINT ACM_HORARIO_ACM_UNIDADE_FK FOREIGN KEY ( id_unidade )
    REFERENCES ACM_UNIDADE ( id_unidade ) ;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT ACM_ORIENTACAO_ACM_QUEIXA_FK FOREIGN KEY ( id_queixa )
    REFERENCES ACM_QUEIXA ( id_queixa ) ;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT ACM_ORIENTACAO_ACM_CIDADAO_FK FOREIGN KEY ( id_cidadao )
    REFERENCES ACM_CIDADAO ( id_cidadao ) ;

ALTER TABLE ACM_ORIENTACAO
    ADD CONSTRAINT ACM_ORIENTACAO_ACM_UNIDADE_FK FOREIGN KEY ( id_unidade_indicada )
    REFERENCES ACM_UNIDADE ( id_unidade ) ;

ALTER TABLE ACM_RESPOSTA
    ADD CONSTRAINT ACM_RESPOSTA_ACM_ORIENTACAO_FK FOREIGN KEY ( id_orientacao )
    REFERENCES ACM_ORIENTACAO ( id_orientacao ) ;

ALTER TABLE ACM_RESPOSTA
    ADD CONSTRAINT ACM_RESPOSTA_ACM_PERGUNTA_FK FOREIGN KEY ( id_pergunta )
    REFERENCES ACM_PERGUNTA ( id_pergunta ) ;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT ACM_LISTA_DIA_ACM_CIDADAO_FK FOREIGN KEY ( id_cidadao )
    REFERENCES ACM_CIDADAO ( id_cidadao ) ;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT ACM_LISTA_DIA_ACM_UNIDADE_FK FOREIGN KEY ( id_unidade )
    REFERENCES ACM_UNIDADE ( id_unidade ) ;

ALTER TABLE ACM_LISTA_DIA
    ADD CONSTRAINT ACM_LISTA_ORIENTACAO_FK FOREIGN KEY ( id_orientacao )
    REFERENCES ACM_ORIENTACAO ( id_orientacao ) ;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT ACM_CONSULTA_ACM_HORARIO_FK FOREIGN KEY ( id_horario )
    REFERENCES ACM_HORARIO ( id_horario ) ;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT ACM_CONSULTA_ACM_CIDADAO_FK FOREIGN KEY ( id_cidadao )
    REFERENCES ACM_CIDADAO ( id_cidadao ) ;

ALTER TABLE ACM_CONSULTA
    ADD CONSTRAINT ACM_CONSULTA_ACM_ORIENTACAO_FK FOREIGN KEY ( id_orientacao )
    REFERENCES ACM_ORIENTACAO ( id_orientacao ) ;

-- =========================================================
-- Sequences
-- Geram o ID de cada tabela com PK numerica. A API Java usa
-- o mesmo NEXTVAL ao gravar. NOCACHE evita saltos na
-- numeracao. ACM_RESPOSTA nao precisa: a PK e composta
-- pelas duas FKs.
-- =========================================================
CREATE SEQUENCE SEQ_ACM_UNIDADE    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_QUEIXA     START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_CIDADAO    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_USUARIO    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_PERGUNTA   START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_HORARIO    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_ORIENTACAO START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_LISTA_DIA  START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_ACM_CONSULTA   START WITH 1 INCREMENT BY 1 NOCACHE;