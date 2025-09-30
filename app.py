#!/usr/bin/env python3
import os
from flask_bootstrap import Bootstrap5
from flask_ckeditor import CKEditor
from flask_login import LoginManager
from flask import Flask, render_template, request, redirect, abort
from db_seed import setup_db
from routes import init
from markupsafe import escape

# CREATE app FIRST
app = Flask(__name__)

# THEN configure it - use environment variable for secret key
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', os.urandom(32).hex())
app.secret_key = os.environ.get('SECRET_KEY', os.urandom(32).hex())
app.config["BOOTSTRAP_SERVE_LOCAL"] = True
app.config["CKEDITOR_SERVE_LOCAL"] = True

bootstrap = Bootstrap5(app)
login_manager = LoginManager()
login_manager.init_app(app)
ckeditor = CKEditor()
ckeditor.init_app(app)

init()
setup_db()

@login_manager.unauthorized_handler
def unauthorized():
    return redirect("/login")

@app.errorhandler(404)
def page_not_found(error):
    # Fixed SSTI vulnerability - escape user input
    safe_path = escape(request.path)
    detailed_message = f"{error}. Requested URL was {safe_path}"
    return render_template("404.html", detailed_message=detailed_message)
