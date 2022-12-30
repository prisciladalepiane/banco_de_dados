-- Comando enviado ao MySQL para utilizar o BD 'hospital'.
USE hospital;

-- -------------------------------------------------------------------------------------------------
-- PROCEDURES.
-- -------------------------------------------------------------------------------------------------
-- Validar CPF. Fonte: https://blog.dbins.com.br/validar-cpf-com-mysql
delimiter $
CREATE PROCEDURE validar_cpf(IN cpf varchar(11), OUT retorno INT, OUT motivo VARCHAR(255))
procedimento:BEGIN
  DECLARE soma int;
  DECLARE indice int;
  DECLARE digito_1 int;
  DECLARE digito_2 int;
  DECLARE nr_documento_aux varchar(11);
  DECLARE digito_1_cpf char(2);
  DECLARE digito_2_cpf char(2);

  -- Elimina espaços em branco antes e depois do CPF.
  SET nr_documento_aux = ltrim(rtrim(cpf));

  -- Remove os CPFs onde todos os números são iguais.
  IF (nr_documento_aux IN ('00000000000',
                           '11111111111',
                           '22222222222',
                           '33333333333',
                           '44444444444',
                           '55555555555',
                           '66666666666',
                           '77777777777',
                           '88888888888',
                           '99999999999',
                           '12345678909')) THEN
    SET retorno = 0;
    SET motivo = 'CPF com todos os dígitos iguais ou formando uma sequência!';
    LEAVE procedimento;
  END IF;
  
  -- O CPF deve ter 11 caracteres.
  IF (length(nr_documento_AUX) <> 11) THEN
    SET retorno = 0;
    SET motivo = 'O tamanho do CPF informado é diferente de 11!';
    LEAVE procedimento;
  ELSE
  
    -- Armazenando os dígitos verificadores do CPF informado.
    SET digito_1_cpf = substring(nr_documento_aux, length(nr_documento_aux) - 1, 1);
    SET digito_2_cpf = substring(nr_documento_aux, length(nr_documento_aux), 1);
    
    -- Cálculo do primeiro dígito verificador.
    SET soma = 0;
    SET indice = 1;
    WHILE (indice <= 9) DO
      SET soma = soma + cast(substring(nr_documento_aux, indice, 1) AS unsigned) * (11 - indice);
      SET indice = indice + 1;
    END WHILE;
    SET digito_1 = 11 - (soma % 11);
    IF (digito_1 > 9) THEN
      SET digito_1 = 0;
    END IF;
    
    -- Cálculo do segundo dígito verificador.
    SET soma = 0;
    SET indice = 1;
    WHILE (indice <= 10) DO
      SET soma = soma + cast(substring(nr_documento_aux, indice, 1) AS unsigned) * (12 - indice);
      SET indice = indice + 1;
    END WHILE;
    SET digito_2 = 11 - (soma % 11);
    IF digito_2 > 9 THEN
      SET digito_2 = 0;
    END IF;
    
    -- Validando os dígitos verificadores calculados com os dígitos verificadores do CPF informado.
    IF (digito_1 = digito_1_cpf) AND (digito_2 = digito_2_cpf) THEN
      SET retorno = 1;
      SET motivo = 'CPF correto!';
      LEAVE procedimento;
    ELSE
      SET retorno = 0;
      SET motivo = 'Os dígitos verificadores do CPF informado estão incorretos!';
      LEAVE procedimento;
    END IF;
    
 END IF;
END;
$

-- CPF inválido.
CALL validar_cpf('1234', @retorno, @motivo);
SELECT @retorno, @motivo;

-- CPF válido.
CALL validar_cpf('92860102060', @retorno, @motivo);
SELECT @retorno, @motivo;


-- -------------------------------------------------------------------------------------------------
-- TRIGGERS.
-- -------------------------------------------------------------------------------------------------
-- Validar CPF antes da inserção.
delimiter $
CREATE TRIGGER pacientes_cpf_ins_trg
  BEFORE INSERT ON pacientes
  FOR EACH ROW
BEGIN

  SET @cpf = lpad(cast(NEW.cpf AS char), 11, '0');
  
  CALL validar_cpf(@cpf, @retorno, @motivo);
  IF @retorno = 0 THEN
    -- SQLSTATE 45000: “unhandled user-defined exception”.
    SIGNAL SQLSTATE '45000'
      SET message_text = @motivo;
  END IF;
  
END
$

-- Inserção de paciente com CPF inválido.
  -- Error Code: 1644 ("Unhandled user-defined exception condition").
INSERT INTO pacientes VALUES (11111111111, 'Aristeu', '1965-12-09', 'Maria', 'João');
