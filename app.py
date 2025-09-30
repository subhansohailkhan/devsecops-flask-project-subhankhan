#!/usr/bin/env python3
import os
from flask_bootstrap import Bootstrap5
from flask_ckeditor import CKEditor
from flask_login import LoginManager
from flask import Flask, render_template, request, redirect
from db_seed import setup_db
from routes import init

app = Flask(__name__)

# Load secret key from environment variable (do NOT hardcode in repo)
secret_key = os.environ.get("FLASK_SECRET_KEY")
if not secret_key:
    raise RuntimeError("Missing FLASK_SECRET_KEY environment variable")
app.config["SECRET_KEY"] = secret_key

# Security: Serve static assets locally
app.config["BOOTSTRAP_SERVE_LOCAL"] = True
app.config["CKEDITOR_SERVE_LOCAL"] = True

bootstrap = Bootstrap5(app)
login_manager = LoginManager()
login_manager.init_app(app)
ckeditor = CKEditor()
ckeditor.init_app(app)

# Initialize routes and DB
init()
setup_db()


@login_manager.unauthorized_handler
def unauthorized():
    return redirect("/login")


@app.errorhandler(404)
def page_not_found(error):
    # Avoid render_template_string with user input → use safe context variables
    return render_template("404.html", error=str(error), path=request.path)
