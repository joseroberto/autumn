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
  id integer primary key autoincrement,
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

insert into roteiro_manobra (origem, equipamento, configuracao) values ('JCD', '14C1','Disjuntor e chaves do C1 fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('JCD', '14T1','Disjuntor e chaves do T1 fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CGD', '12T5','Disjuntor e chaves de T5 associadas fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CGD', '13L1','Disjuntor e chaves do L1 associadas fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CTM', '14F8','Disjuntor e chaves DO F8 associadas fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CTM', '14C3','Disjuntor e chaves do C3 associadas fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CTM', '14W1','Disjuntor e chaves associadas DO W1 fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CTM', '14D1','Disjuntor e chaves associadas do D1 fechadas');
insert into roteiro_manobra (origem, equipamento, configuracao) values ('CTM', '04B1','Eventos terminados em impares conectadas');


