-- ==========================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ==========================================

CREATE DATABASE IF NOT EXISTS rpg_online
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE rpg_online;


-- ==========================================
-- 2. TABELA USUARIOS
-- ==========================================

CREATE TABLE IF NOT EXISTS USUARIOS (
    UsuarioId INT UNSIGNED AUTO_INCREMENT,
    Email VARCHAR(150) NOT NULL,
    Senha VARCHAR(255) NOT NULL,

    PRIMARY KEY (UsuarioId),
    UNIQUE (Email)
) ENGINE=InnoDB;


-- ==========================================
-- 3. TABELA CLASSES
-- ==========================================

CREATE TABLE IF NOT EXISTS CLASSES (
    ClasseId INT UNSIGNED AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,

    PRIMARY KEY (ClasseId)
) ENGINE=InnoDB;


-- ==========================================
-- 4. TABELA HABILIDADES
-- ==========================================

CREATE TABLE IF NOT EXISTS HABILIDADES (
    HabilidadeId INT UNSIGNED AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,

    PRIMARY KEY (HabilidadeId)
) ENGINE=InnoDB;


-- ==========================================
-- 5. TABELA PERSONAGENS
-- ==========================================

CREATE TABLE IF NOT EXISTS PERSONAGENS (
    PersonagemId INT UNSIGNED AUTO_INCREMENT,
    NomePersonagem VARCHAR(100) NOT NULL,
    UsuarioId INT UNSIGNED NOT NULL,
    ClasseId INT UNSIGNED NOT NULL,

    PRIMARY KEY (PersonagemId),

    FOREIGN KEY (UsuarioId)
        REFERENCES USUARIOS(UsuarioId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (ClasseId)
        REFERENCES CLASSES(ClasseId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ==========================================
-- 6. TABELA CLASSES_HABILIDADES
-- ==========================================

CREATE TABLE IF NOT EXISTS CLASSES_HABILIDADES (
    ClasseId INT UNSIGNED NOT NULL,
    HabilidadeId INT UNSIGNED NOT NULL,

    PRIMARY KEY (ClasseId, HabilidadeId),

    FOREIGN KEY (ClasseId)
        REFERENCES CLASSES(ClasseId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (HabilidadeId)
        REFERENCES HABILIDADES(HabilidadeId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 7. CRIAÇÃO DOS NÍVEIS DE ACESSO
-- ==========================================

CREATE ROLE IF NOT EXISTS 'rpg_leitor';
CREATE ROLE IF NOT EXISTS 'rpg_jogador';
CREATE ROLE IF NOT EXISTS 'rpg_admin';


-- ==========================================
-- 8. PERMISSÕES DO LEITOR
-- ==========================================

GRANT SELECT ON rpg_online.*
TO 'rpg_leitor';


-- ==========================================
-- 9. PERMISSÕES DO JOGADOR
-- ==========================================

-- O jogador herda as permissões de leitura.
GRANT 'rpg_leitor'
TO 'rpg_jogador';

-- Permite gerenciar personagens.
GRANT INSERT, UPDATE
ON rpg_online.PERSONAGENS
TO 'rpg_jogador';


-- ==========================================
-- 10. PERMISSÕES DO ADMINISTRADOR
-- ==========================================

-- O administrador herda os níveis inferiores.
GRANT 'rpg_jogador'
TO 'rpg_admin';

-- Permite acesso completo ao banco.
GRANT ALL PRIVILEGES
ON rpg_online.*
TO 'rpg_admin';

-- Exemplos de associação de permissões:
-- GRANT 'rpg_jogador' TO 'app_jogador'@'localhost';
-- GRANT 'rpg_admin' TO 'app_admin'@'localhost';

-- Definir o papel padrão:
-- SET DEFAULT ROLE 'rpg_jogador'
-- TO 'app_jogador'@'localhost';