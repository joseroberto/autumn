import os
import yaml
from flask import Flask, url_for
from flask_login import LoginManager


# create our little application :)
app = Flask(__name__)

#login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

with open("conf/config.yaml", 'r') as stream:
    try:
        config = yaml.load(stream)
    except yaml.YAMLError as exc:
        print(exc)


app.config.update(config)

# Load default config and override config from an environment variable
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, 'autman.db')
))

app.config.from_envvar('FLASKR_SETTINGS', silent=True)

from app import autman