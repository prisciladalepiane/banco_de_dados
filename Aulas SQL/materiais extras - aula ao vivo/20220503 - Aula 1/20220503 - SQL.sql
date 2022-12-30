-- Criação de um BD chamado 'hospital'.
CREATE DATABASE hospital;

-- Comando enviado ao MySQL para utilizar o BD 'hospital'.
USE hospital;

-- Dentro do BD 'hospital', criar um esquema (schema) chamado 'cadastros'.
-- Objetivo: agrupar e organizar todas as tabelas utilizadas para cadastros no sistema.
CREATE SCHEMA cadastros;
-- PROBLEMA: o SGBD criou outro BD, chamado 'cadastros'.
-- MOTIVO: para o MySQL, DATABASE e SCHEMA são sinônimos.

-- Exclui o BD 'cadastros'.
DROP DATABASE cadastros;

-- Cria tabela para o cadastro de pacientes.
CREATE TABLE pacientes
(
  cpf BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  data_nascimento DATE NOT NULL,
  nome_mae VARCHAR(255) NOT NULL,
  nome_pai VARCHAR(255)
);

-- Descreve a estrutura da tabela 'pacientes'.
DESCRIBE pacientes;
