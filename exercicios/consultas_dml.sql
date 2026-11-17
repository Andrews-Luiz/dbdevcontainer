CREATE TABLE Pessoa (
    cpf        CHAR(11)     NOT NULL,
    email      VARCHAR(50)  NOT NULL,
    nome       VARCHAR(150) NOT NULL,
    data_nasc  DATE         NOT NULL,
    endereco   VARCHAR(300) NOT NULL,
    telefone   VARCHAR(15)  NULL,
    CONSTRAINT pk_pessoa PRIMARY KEY (cpf),
    CONSTRAINT pessoa_un UNIQUE (email, nome)
);
CREATE TABLE Paciente (
    cpf          CHAR(11)    NOT NULL,
    senha        VARCHAR(10) NOT NULL,
    plano_saude  BOOLEAN     NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (cpf),
    CONSTRAINT fk_paciente_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
    CONSTRAINT ck_paciente_senha CHECK (senha ~ '^[A-Za-z0-9]{5,10}$')
);
CREATE TABLE Medico (
    cpf  CHAR(11)    NOT NULL,
    crm  VARCHAR(10) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (cpf),
    CONSTRAINT medico_crm_un UNIQUE (crm),
    CONSTRAINT fk_medico_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);
CREATE TABLE Especialidade (
    id         SERIAL       NOT NULL,
    descricao  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_especialidade PRIMARY KEY (id)
);
CREATE TABLE Medico_Especialidade (
    cpf_medico        CHAR(11) NOT NULL,
    id_especialidade  INTEGER  NOT NULL,
    CONSTRAINT pk_medico_especialidade PRIMARY KEY (cpf_medico, id_especialidade),
    CONSTRAINT fk_me_medico FOREIGN KEY (cpf_medico) REFERENCES Medico (cpf) ON DELETE CASCADE,
    CONSTRAINT fk_me_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade (id)
);
CREATE TABLE Agendamento (
    cpf_paciente    CHAR(11)      NOT NULL,
    cpf_medico      CHAR(11)      NOT NULL,
    dt_consulta     TIMESTAMP     NOT NULL,
    dt_agendamento  TIMESTAMP     NOT NULL,
    valor_consulta  NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_agendamento PRIMARY KEY (cpf_paciente, cpf_medico, dt_consulta),
    CONSTRAINT fk_agend_paciente FOREIGN KEY (cpf_paciente) REFERENCES Paciente (cpf) ON DELETE CASCADE,
    CONSTRAINT fk_agend_medico FOREIGN KEY (cpf_medico) REFERENCES Medico (cpf) ON DELETE CASCADE,
    CONSTRAINT ck_agend_valor CHECK (valor_consulta >= 0)
);
