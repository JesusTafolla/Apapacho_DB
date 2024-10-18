from flask import Flask, request, jsonify, send_file, render_template
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import pandas as pd
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost/inventory_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
CORS(app)

class InventoryItem(db.Model):
    __tablename__ = 'inventory_items'
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=0)
    category = db.Column(db.String(50), nullable=False)

class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    item_id = db.Column(db.Integer, nullable=False)
    change = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime, default=datetime.now)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/items', methods=['GET'])
def get_items():
    items = InventoryItem.query.all()
    item_list = [{"id": item.id, "name": item.item_name, "quantity": item.quantity, "category": item.category} for item in items]
    return jsonify(item_list)

@app.route('/add-item', methods=['POST'])
def add_item():
    data = request.json
    item_id = data.get('item_id')
    quantity = data.get('quantity')

    item = InventoryItem.query.get(item_id)
    if item:
        item.quantity += int(quantity)
        db.session.add(Transaction(item_id=item_id, change=int(quantity)))
        db.session.commit()
        return jsonify({"message": "Item updated successfully"}), 200
    return jsonify({"message": "Item not found"}), 404

@app.route('/delete-item', methods=['POST'])
def delete_item():
    data = request.json
    item_id = data.get('item_id')
    quantity = data.get('quantity')

    item = InventoryItem.query.get(item_id)
    if item:
        if item.quantity >= int(quantity):
            item.quantity -= int(quantity)
            db.session.add(Transaction(item_id=item_id, change=-int(quantity)))
            db.session.commit()
            return jsonify({"message": "Item updated successfully."}), 200
        return jsonify({"message": "Not enough quantity available."}), 400
    return jsonify({"message": "Item not found."}), 404

@app.route('/generate-report', methods=['GET'])
def generate_report():
    transactions = Transaction.query.all()
    if not transactions:
        return jsonify({"message": "No transactions found."}), 404
    
    data = [
        {
            "item_id": t.item_id,
            "name": InventoryItem.query.get(t.item_id).item_name,  # Get the item name
            "category": InventoryItem.query.get(t.item_id).category,  # Get the item category
            "quantity": InventoryItem.query.get(t.item_id).quantity,  # Get the quantity
            "change": t.change,
            "date": t.date.strftime('%Y-%m-%d %H:%M:%S')
        }
        for t in transactions
    ]

    df = pd.DataFrame(data)

    # Sort by quantity
    df = df.sort_values(by='quantity', ascending=False)

    report_file = 'inventory_report.xlsx'
    df.to_excel(report_file, index=False)
    
    return send_file(report_file, as_attachment=True)


@app.route('/transaction-history', methods=['GET'])
def transaction_history():
    transactions = Transaction.query.all()
    history = [
        {
            "item_id": t.item_id,
            "quantity": InventoryItem.query.get(t.item_id).quantity,
            "date": t.date.strftime('%Y-%m-%d %H:%M:%S'),
            "change": t.change,
            "name": InventoryItem.query.get(t.item_id).item_name,  # Fetch item name
            "category": InventoryItem.query.get(t.item_id).category  # Fetch item category
        }
        for t in transactions
    ]
    return jsonify(history)



@app.route('/add-new-item', methods=['POST'])
def add_new_item():
    data = request.json
    item_name = data.get('item_name')
    quantity = data.get('quantity', 0)
    category = data.get('category')

    new_item = InventoryItem(item_name=item_name, quantity=quantity, category=category)
    db.session.add(new_item)
    db.session.commit()
    
    return jsonify({"message": "New item added successfully"}), 200

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Ensure tables are created
    app.run(debug=True)
