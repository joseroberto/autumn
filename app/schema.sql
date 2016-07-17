drop table if exists equipamento;
drop table if exists unidade;
drop table if exists roteiro_manobra;
drop table if exists roteiro_manobra_item;
drop table if exists roteiro_comando;
drop table if exists usuario;
drop table if exists execucao;
drop table if exists execucao_item;

PRAGMA foreign_keys = ON;

create table equipamento (
  id integer primary key,
  codigo text not null,
  tipo integer
);

create table unidade(
  id integer primary key autoincrement,
  codigo text not null
);

create table roteiro_manobra (
  id integer primary key,
  id_origem integer not null,
  id_equipamento integer not null,
  configuracao text not null,
  foreign key (id_equipamento) references equipamento(id),
  foreign key (id_origem) references unidade(id)
);


create table roteiro_manobra_item(
  id integer primary key,
  id_roteiro_manobra integer not null,
  descricao text not null,
  id_unidade integer not null,
  foreign key (id_roteiro_manobra) references roteiro_manobra(id),
  foreign key (id_unidade) references unidade(id)
);

create table roteiro_comando(
  id integer primary key autoincrement,
  id_roteiro_manobra_item integer not null,
  id_equipamento integer not null,
  comando not null,
  foreign key (id_roteiro_manobra_item) references roteiro_manobra_item(id),
  foreign key (id_equipamento) references equipamento(id)
);

create table usuario(
  id integer primary key autoincrement,
  usuario text not null
);

create table execucao(
  id integer primary key autoincrement,
  data date,
  id_roteiro_manobra integer not null,
  id_usuario integer,
  foreign key (id_roteiro_manobra) references roteiro_manobra(id),
  foreign key (id_usuario) references usuario(id)
);

create table execucao_item(
  id integer primary key autoincrement,
  id_execucao integer not null,
  hora_execucao text not null,
  foreign key (id_execucao) references execucao(id)
);


insert into equipamento (id, codigo, tipo) values (1, '14C1','52');
insert into equipamento (id, codigo, tipo) values (2, '14T1','52');
insert into equipamento (id, codigo, tipo) values (3, '12T5','52');
insert into equipamento (id, codigo, tipo) values (4, '13L1','52');
insert into equipamento (id, codigo, tipo) values (5, '14F8','52');
insert into equipamento (id, codigo, tipo) values (6, '34F8-1','89');
insert into equipamento (id, codigo, tipo) values (7, '34F8-2','89');
insert into equipamento (id, codigo, tipo) values (8, '34F8-5','89');
insert into equipamento (id, codigo, tipo) values (9, '34F8-6','89');
insert into equipamento (id, codigo, tipo) values (10, '14C3','52');
insert into equipamento (id, codigo, tipo) values (11, '34C3-1','89');
insert into equipamento (id, codigo, tipo) values (12, '34C3-2','89');
insert into equipamento (id, codigo, tipo) values (13, '34C3-5','89');
insert into equipamento (id, codigo, tipo) values (14, '34C3-6','89');
insert into equipamento (id, codigo, tipo) values (15, '14W1','52');
insert into equipamento (id, codigo, tipo) values (16, '34W1-1','89');
insert into equipamento (id, codigo, tipo) values (17, '34W1-2','89');
insert into equipamento (id, codigo, tipo) values (18, '34W1-5','89');
insert into equipamento (id, codigo, tipo) values (19, '34W1-6','89');
insert into equipamento (id, codigo, tipo) values (20, '14D1','52');
insert into equipamento (id, codigo, tipo) values (21, '34D1-1','89');
insert into equipamento (id, codigo, tipo) values (22, '34D1-2','89');
insert into equipamento (id, codigo, tipo) values (23, '04B1','00');

insert into unidade (id, codigo) values (1, 'JCD');
insert into unidade (id, codigo) values (2, 'CGD');
insert into unidade (id, codigo) values (3, 'CTM');

insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (1, 1, 1,'Disjuntor e chaves do C1 fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (2, 1, 2,'Disjuntor e chaves do T1 fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (3, 2, 3,'Disjuntor e chaves de T5 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (4, 2, 4,'Disjuntor e chaves do L1 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (5, 3, 5,'Disjuntor e chaves DO F8 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (10, 3, 6,'Disjuntor e chaves DO C3 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (15, 3, 12,'Disjuntor e chaves DO W1 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (20, 3, 18,'Disjuntor e chaves DO D1 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (23, 3, 22,'Eventos terminados em impares do B1 conectadas');

insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (1, 5, 'Receber do responsável solicitação liberação 14F8',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (2, 5, 'Solicitar CROL liberação 14F8.',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (3, 5, 'Solicitar COSR-NE autorização liberação 14F8/CTM.',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (4, 5, 'Autorizar CROL liberação 14F8/CTM.',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (5, 5, 'Autorizar CTM liberação 14F8.',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (6, 5, 'Colocar operação da SE no nível 2.',3)
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (7, 5, 'Colocar proteção 14F8 na posição EM TRANSFERÊNCIA',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (8, 5, 'Confirmar 14D1 fechado',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (9, 5, 'Fechar 34F8-6',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (10, 5, 'Abrir 14F8',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (11, 5, 'Abrir 34F8-2 e 34F8-5',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (12, 5, 'Colocar proteção 14F8 na posição TRANSFERIDO',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (13, 5, 'Bloquear comando elétrico 34F8-1, 34F8-2 e 34F8-5',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (14, 5, 'Entregar 14F8 isolado ao responsável.',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (15, 5, 'Retornar operação da SE para o nível 3',3);
insert into roteiro_manobra_item (id, id_roteiro_manobra, descricao, id_unidade) values (16, 5, 'Informar CROL conclusão liberação 14F8',3);

