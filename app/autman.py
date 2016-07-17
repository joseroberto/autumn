# -*- coding: utf-8 -*-
"""
    Autman
    ~~~~~~
    Sistema de automanção de manobras.

    :copyright: (c) 2015 by Sergio Dias.
    :license: BSD, see LICENSE for more details.
"""
import os
import sys
from sqlite3 import dbapi2 as sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

# create our little application :)
app = Flask(__name__)

# Load default config and override config from an environment variable
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, 'autman.db'),
    DEBUG=True,
    SECRET_KEY='bZJc2sWbQLKos6GkHn/VB9oXwQt8S0R0kRvJ5/xJ89E=',
    USERNAME='admin',
    PASSWORD='default'
))
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

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