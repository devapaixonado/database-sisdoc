-- ===============================
-- Criar schema
-- ===============================
CREATE SCHEMA IF NOT EXISTS sisdoc;

-- ===============================
-- Tabela: Usuario
-- ===============================
CREATE TABLE IF NOT EXISTS sisdoc.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha CHAR(60),
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    dt_ultima_atualizacao TIMESTAMP
);

-- ===============================
-- Tabela: Pasta
-- ===============================
CREATE TABLE IF NOT EXISTS sisdoc.pasta (
    id_pasta SERIAL PRIMARY KEY,
    id_usuario_ultima_atualizacao INTEGER,
    nome VARCHAR(60) UNIQUE NOT NULL,
    descricao VARCHAR(255),
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    dt_ultima_atualizacao TIMESTAMP,
    CONSTRAINT fk_pasta_usuario FOREIGN KEY (id_usuario_ultima_atualizacao) 
        REFERENCES sisdoc.usuario(id_usuario) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_pasta_usuario 
    ON sisdoc.pasta(id_usuario_ultima_atualizacao);

-- ===============================
-- Tabela: Documento
-- ===============================
CREATE TABLE IF NOT EXISTS sisdoc.documento (
    id_documento SERIAL PRIMARY KEY,
    id_pasta INTEGER NOT NULL,
    id_usuario_ultima_atualizacao INTEGER,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    dt_inicio_vigencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_fim_vigencia TIMESTAMP,
    dt_ultima_atualizacao TIMESTAMP,
    CONSTRAINT fk_documento_pasta FOREIGN KEY (id_pasta) 
        REFERENCES sisdoc.pasta(id_pasta) ON DELETE CASCADE,
    CONSTRAINT fk_documento_usuario FOREIGN KEY (id_usuario_ultima_atualizacao) 
        REFERENCES sisdoc.usuario(id_usuario) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_documento_pasta 
    ON sisdoc.documento(id_pasta);

CREATE INDEX IF NOT EXISTS idx_documento_usuario 
    ON sisdoc.documento(id_usuario_ultima_atualizacao);

-- ===============================
-- Função: Atualizar dt_ultima_atualizacao
-- ===============================
CREATE OR REPLACE FUNCTION sisdoc.set_dt_ultima_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
    NEW.dt_ultima_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===============================
-- Triggers (antes dos inserts)
-- ===============================
DROP TRIGGER IF EXISTS trg_set_pasta_dt_ultima_atualizacao ON sisdoc.pasta;
DROP TRIGGER IF EXISTS trg_set_usuario_dt_ultima_atualizacao ON sisdoc.usuario;
DROP TRIGGER IF EXISTS trg_set_documento_dt_ultima_atualizacao ON sisdoc.documento;

CREATE TRIGGER trg_set_pasta_dt_ultima_atualizacao
BEFORE INSERT OR UPDATE ON sisdoc.pasta
FOR EACH ROW
EXECUTE FUNCTION sisdoc.set_dt_ultima_atualizacao();

CREATE TRIGGER trg_set_usuario_dt_ultima_atualizacao
BEFORE INSERT OR UPDATE ON sisdoc.usuario
FOR EACH ROW
EXECUTE FUNCTION sisdoc.set_dt_ultima_atualizacao();

CREATE TRIGGER trg_set_documento_dt_ultima_atualizacao
BEFORE INSERT OR UPDATE ON sisdoc.documento
FOR EACH ROW
EXECUTE FUNCTION sisdoc.set_dt_ultima_atualizacao();

-- ===============================
-- Inserts iniciais: Usuario
-- ===============================
INSERT INTO sisdoc.usuario (nome, email) VALUES
('Admin', 'gabriel.raraujo@saude.gov.br'),
('Filipi Pedro Santos de Jesus', 'filipi.jesus@saude.gov.br');

-- ===============================
-- Inserts iniciais: Pasta
-- ===============================
INSERT INTO sisdoc.pasta (id_usuario_ultima_atualizacao, nome, descricao) VALUES
(1, 'Banco do Brasil', 'Documentos referentes a assuntos relacionados ao Banco do Brasil e suas contas bancárias de Saúde.'),
(1, 'Caixa Econômica Federal', 'Mundo Caixa Econômica'),
(1, 'CGAFI', 'Documentos CGAFI'),
(1, 'SALDO BANCÁRIO', 'Documentos sobre saldos bancários'),
(1, 'QLIK', 'Documentos QLIK');

-- ===============================
-- Inserts iniciais: Documento
-- ===============================
INSERT INTO sisdoc.documento (id_pasta, id_usuario_ultima_atualizacao, nome, descricao) VALUES
(1, 1, 'Documento 1 - BB', 'Documento teste para aplicação SISDOC'),
(1, 1, 'Documento 2 - BB', 'Documento teste para aplicação SISDOC'),
(1, 1, 'Documento 3 - BB', 'Documento teste para aplicação SISDOC'),
(2, 1, 'Documento 1 - CEF', 'Documento teste para aplicação SISDOC'),
(2, 1, 'Documento 2 - CEF', 'Documento teste para aplicação SISDOC'),
(2, 1, 'Documento 3 - CEF', 'Documento teste para aplicação SISDOC');
