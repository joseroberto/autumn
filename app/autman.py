# -*- coding: utf-8 -*-
"""
    Autman
    ~~~~~~
    Sistema de automanção de manobras.

    :copyright: (c) 2015 by Sergio Dias.
    :license: BSD, see LICENSE for more details.
"""
import os
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
        db.cursor().executescript(f.read())
    db.commit()

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
    db = get_db()
    cur = db.execute('select a.id as id, b.codigo as origem, c.codigo as equipamento from roteiro_manobra a inner join unidade b on a.id_origem=b.id inner join equipamento c on c.id=a.id_equipamento order by 2,3 desc')
    entries = cur.fetchall()
    return render_template('index.html', entries=entries)

@app.route('/item')
def detalha_roteiro():
    return render_template('item.html')