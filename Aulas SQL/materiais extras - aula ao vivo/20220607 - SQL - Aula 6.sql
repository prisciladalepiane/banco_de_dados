-- Comando enviado ao MySQL para utilizar o BD 'hospital'.
USE hospital;


-- Sub-transações ou nested transactions?
-- NÃO É POSSÍVEL.
START TRANSACTION;
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  START TRANSACTION;
    SELECT * FROM contatos_pacientes;
    SELECT * FROM tipos_contato;
  ROLLBACK;
COMMIT;

-- Alternativa: SAVEPOINTS.
START TRANSACTION;
  DELETE FROM contatos_pacientes;
  SAVEPOINT parte_1;
    DELETE FROM tipos_contato;
    SAVEPOINT parte_2;
      SELECT * FROM contatos_pacientes;
      SELECT * FROM tipos_contato;
      ROLLBACK TO parte_1;
COMMIT;


-- LIKE é case sensitive?
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'An%';
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'AN%';
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE BINARY 'AN%';

-- LIKE com caracteres acentuados.
INSERT INTO pacientes VALUES (88776655443, 'José', '1970-01-01', 'Bárbara', 'César');
SELECT nome, nome_mae FROM pacientes WHERE nome LIKE '%jose%';

-- CHARSET e COLLATION?
SHOW TABLE STATUS WHERE name LIKE 'pacientes';
-- utf8mb4_0900_ai_ci:
   -- utf8mb4: 4 bytes por caracter em UTF8.
   -- 0900: versão do algoritmo utilizado para comparação de caracteres.
   -- ai: accent insensitivity (letras acentuadas e não acentuadas são consideradas iguais 
   --     em comparações e ordenações).
   -- ci: case insensitivity (letras maiúsculas e minúsculas são consideradas iguais
   --     em comparações e ordenações).


-- -------------------------------------------------------------------------------------------------
-- Produto cartesiano.
-- -------------------------------------------------------------------------------------------------
-- Relembrar operações matemáticas: multiplicação como sequência de somas,
-- divisão como sequência de subtrações.
SELECT * FROM pacientes, contatos_pacientes;
SELECT * FROM pacientes, contatos_pacientes, tipos_contato;
SELECT *
  FROM pacientes
 CROSS JOIN contatos_pacientes
 CROSS JOIN tipos_contato;


-- Produto cartesiano com condições (chave primária x chave estrangeira).
SELECT *
  FROM pacientes, contatos_pacientes
 WHERE pacientes.cpf = contatos_pacientes.cpf_paciente;

-- Produto cartesiano com condições + apelidos (alias) (chave primária x chave estrangeira).
SELECT *
  FROM pacientes AS p, contatos_pacientes AS cp, tipos_contato AS tc
 WHERE p.cpf = cp.cpf_paciente
   AND cp.id_tipo_contato = tc.id;

-- INCORRETO: produto cartesiano com condições (outros campos).
SELECT *
  FROM pacientes AS p, contatos_pacientes AS cp
 WHERE p.nome = cp.contato;


-- -------------------------------------------------------------------------------------------------
-- Junções (JOINs).
-- -------------------------------------------------------------------------------------------------
-- INNER JOIN (duas tabelas).
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;

-- INNER JOIN (três tabelas).
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
 INNER JOIN tipos_contato AS tc ON cp.id_tipo_contato = tc.id;

-- INCORRETO: comparação que não é de igualdade.
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
 INNER JOIN tipos_contato AS tc ON cp.id_tipo_contato > tc.id;

-- LEFT JOIN.
SELECT *
  FROM pacientes AS p
 LEFT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;

-- RIGHT JOIN.
SELECT *
  FROM contatos_pacientes AS cp
 RIGHT JOIN pacientes AS p ON cp.cpf_paciente = p.cpf;

-- FULL JOIN - não é suportado pelo  MySQL.
-- Como resolver: união entre LEFT JOIN e RIGHT JOIN.
SELECT *
  FROM pacientes AS p
 LEFT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
UNION
SELECT *
  FROM pacientes AS p
 RIGHT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;
