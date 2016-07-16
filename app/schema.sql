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
  id integer primary key autoincrement,
  id_roteiro_manobra integer not null,
  id_comando integer null,
  descricao text not null,
  id_unidade integer not null,
  foreign key (id_comando) references comando(id),
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
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (6, 3, 10,'Disjuntor e chaves do C3 associadas fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (7, 3, 15,'Disjuntor e chaves associadas DO W1 fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (8, 3, 20,'Disjuntor e chaves associadas do D1 fechadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (9, 3, 23,'Eventos terminados em impares do B1 conectadas');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (10, 3, 6,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (11, 3, 7,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (12, 3, 8,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (13, 3, 9,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (14, 3, 11,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (15, 3, 12,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (16, 3, 13,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (17, 3, 14,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (18, 3, 16,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (19, 3, 17,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (20, 3, 18,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (21, 3, 19,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (22, 3, 21,'chave');
insert into roteiro_manobra (id, id_origem, id_equipamento, configuracao) values (23, 3, 22,'chave');


