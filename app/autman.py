# -*- coding: utf-8 -*-

import sys
import yaml
from sqlite3 import dbapi2 as sqlite3
from flask import Flask, request, session, g, jsonify, redirect, url_for, abort, \
     render_template, flash
from time import gmtime, strftime, localtime, strptime
import paramiko
from app import app, login_manager

def connect_db():
    """Conecta a um banco de dados."""
    rv = sqlite3.connect(app.config['DATABASE'])
    rv.row_factory = sqlite3.Row
    return rv


def init_db():
    """Initializes the database."""
    db = get_db()
    with app.open_resource('schema.sql', mode='r') as f:
        linha = f.read()
        try:
            db.cursor().executescript(linha)
        except:
            print "Unexpected error:", sys.exc_info()[0]
            print ('Erro:', linha) 
    db.commit()

def query_db(query, args=(), one=False):
    """Busca um conjunto e dados."""
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    return (rv[0] if rv else None) if one else rv

@app.cli.command('initdb')
def initdb_command():
    """Cria as tabelas do banco de dados."""
    init_db()
    print('Banco de dados inicializado.')


def get_db():
    """Abre uma conexao com o banco de dados
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db


@app.teardown_appcontext
def close_db(error):
    """Fecha conexao com o banco de dados"""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()

def u(s, encoding='utf8'):
    """cast bytes or unicode to unicode"""
    if isinstance(s, bytes):
        try:
            return s.decode(encoding)
        except UnicodeDecodeError:
            return s.decode('ISO-8859-1')
    elif isinstance(s, str):
        return s
    else:
        raise TypeError("Expected unicode or bytes, got %r" % s)


@app.route('/')
def lista_roteiros():
    entries = query_db('select a.id as id, b.codigo as origem, c.codigo as equipamento from roteiro_manobra a inner join unidade b on a.id_origem=b.id inner join equipamento c on c.id=a.id_equipamento order by 2,3 desc')
    return render_template('index.html', entries=entries)

@app.route('/roteiro/<int:roteiro_id>')
def detalha_roteiro(roteiro_id):
    return render_template('item.html', 
        roteiro = query_db('select a.id as id, b.codigo as origem, c.codigo as equipamento, configuracao from roteiro_manobra a inner join unidade b on a.id_origem=b.id inner join equipamento c on c.id=a.id_equipamento where a.id=? order by 2,3 desc',[roteiro_id], one=True),
        liberacoes = query_db('select a.id as id, b.codigo as unidade, descricao from roteiro_manobra_item a inner join unidade b on b.id=a.id_unidade where id_roteiro_manobra=? and procedimento=1 order by 1', [roteiro_id]),
        normalizacoes = query_db('select a.id as id, b.codigo as unidade, descricao from roteiro_manobra_item a inner join unidade b on b.id=a.id_unidade where id_roteiro_manobra=? and procedimento=2 order by 1', [roteiro_id])
        )

@app.route('/execute')
def executa_roteiro():
    id = request.args.get('id', 0, type=int)
    tempo = localtime()

    comandos = query_db('select c.codigo as equipamento, c.tipo as tipo, a.comando as comando, d.codigo as unidade from roteiro_comando a inner join roteiro_manobra_item b on b.id=a.id_roteiro_manobra_item inner join equipamento c on c.id=a.id_equipamento inner join unidade d on d.id=b.id_unidade  where id_roteiro_manobra_item=?',[id])

    if comandos:
        comandocat = ("cat %s/%s.alr" % (app.config['DIR_SAGE'], strftime("%b%d%y", tempo))).lower()
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.connect(app.config['IP_SAGE'], username=app.config['USER_SAGE'], password=app.config['PASS_SAGE'])
        ultimo_equipamento = ''
        ultimo_comando = ''
        for item_comando in comandos:
            app.logger.info(item_comando)
            equipamento = "%s:%s:%d" % (item_comando['unidade'], item_comando['equipamento'],item_comando['tipo'])
            
            app.logger.info("sage_ctrl %s %d" % (equipamento, item_comando['comando']))
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("sage_ctrl %s:%s:%d %d" % (item_comando['unidade'], item_comando['equipamento'],item_comando['tipo'], item_comando['comando']))            
            
            ultimo_equipamento = equipamento
            ultimo_comando = 'Abriu' if item_comando['comando']==0 else 'Fechou'

        app.logger.info(comandocat)
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(comandocat)
            
        linhas = ssh_stdout.readlines()

        ind_ocorrencia = next(i for i,v in zip(range(len(linhas)-1, 0, -1), reversed(linhas)) if (ultimo_equipamento in v) and (ultimo_comando in v)) 
            
        horastr = linhas[ind_ocorrencia].split()[0]
        app.logger.info(horastr)
        tempo = strptime(horastr, '%H:%M:%S')

        ssh.close()

    hora = strftime("%H:%M", tempo)
    return jsonify(hora=hora)


 