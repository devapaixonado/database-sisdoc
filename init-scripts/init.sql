-- Passo 1
CREATE SCHEMA sisdoc;

-- Passo 2
CREATE TABLE sisdoc.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha CHAR(60),
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP
);

-- Passo 3
CREATE TABLE sisdoc.secao (
    id_secao SERIAL PRIMARY KEY,
    descricao VARCHAR(40) UNIQUE NOT NULL,
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    id_usuario INTEGER NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES sisdoc.usuario(id_usuario) ON DELETE SET NULL
);

CREATE INDEX idx_secao_usuario ON sisdoc.secao(id_usuario);

-- Passo 4
CREATE TABLE sisdoc.topico (
    id_topico SERIAL PRIMARY KEY,
    id_secao INTEGER NOT NULL,
    descricao VARCHAR(40) NOT NULL,
    id_usuario INTEGER NOT NULL,
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    FOREIGN KEY (id_secao) REFERENCES sisdoc.secao(id_secao) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES sisdoc.usuario(id_usuario) ON DELETE SET NULL
);

CREATE INDEX idx_topico_secao ON sisdoc.topico(id_secao);
CREATE INDEX idx_topico_usuario ON sisdoc.topico(id_usuario);

-- Passo 5
CREATE TABLE sisdoc.documento (
    id_documento SERIAL PRIMARY KEY,
    id_topico INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    nome_arquivo VARCHAR(255) NOT NULL,
    descricao TEXT,
    tipo_arquivo VARCHAR(50),
    caminho_arquivo TEXT,
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    FOREIGN KEY (id_topico) REFERENCES sisdoc.topico(id_topico) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES sisdoc.usuario(id_usuario) ON DELETE SET NULL
);

CREATE INDEX idx_documento_topico ON sisdoc.documento(id_topico);
CREATE INDEX idx_documento_usuario ON sisdoc.documento(id_usuario);

-- Passo 6
INSERT INTO sisdoc.usuario (nome, email) VALUES ('Admin', 'gabriel.raraujo@saude.gov.br');
INSERT INTO sisdoc.usuario (nome, email) VALUES ('Filipi Pedro Santos de Jesus', 'filipi.jesus@saude.gov.br');

-- Passo 7
INSERT INTO sisdoc.secao (descricao, id_usuario) VALUES ('Documentos', 1);
INSERT INTO sisdoc.secao (descricao, id_usuario) VALUES ('Seção Teste', 1);

-- Passo 8
INSERT INTO sisdoc.topico (id_secao, id_usuario, descricao) values (1, 1, 'Banco do Brasil');
INSERT INTO sisdoc.topico (id_secao, id_usuario, descricao) values (1, 1, 'Caixa Econômica Federal');

-- Passo 9
INSERT INTO sisdoc.documento (id_topico, id_usuario, nome_arquivo, tipo_arquivo, caminho_arquivo)
VALUES (1, 1, 'Manual de procedimentos para alteração do MFA VPN do Ministério da Saúde.pdf', 'pdf', 'C:\Users\gabriel.raraujo\Documentos');