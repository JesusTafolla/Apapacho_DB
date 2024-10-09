#Creating Backend to manage the DB
from flask import Flask, request, jsonify, send_file, render_template
from flask_sqlalchemy import SQLAlchemy
import pandas as pd
from datetime import datetime


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://apapacho:1234@localhost/inventory_db'
db = SQLAlchemy(app)

class InventoryItem(db.Model):
    __tablename__ = 'inventory_items'
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=0)
    category = db.Column(db.String(50), nullable=False)  # E.g., 'supplies', 'labels', etc.

class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    item_id = db.Column(db.Integer, nullable=False)
    change = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime, default=datetime.datetime.now())
    
    
@app.route('/')
def index():
    return render_template('index.html')

def get_items():
    items = InventoryItem.query.all()
    item_list = [{"id": item.id, "name": item.item_name, "quantity": item.quantity, "category": item.category} for item in items]
    return jsonify(item_list)
    