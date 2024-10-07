#Creating Backend to manage the DB
from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
import pandas as pd
import json
import os
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
from twilio.rest import Client

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://apapacho:1234@localhost/inventory_db'
db = SQLAlchemy(app)