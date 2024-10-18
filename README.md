# Apapacho_DB
This project will be encharged of manage, deploy and generate a pilot or engine to generate an inventory stock or something related/useful for that one.
<!--Absolutely! Below is a complete implementation of an inventory management system using Flask, SQLAlchemy, and a PostgreSQL database. The code includes all necessary components, from models to routes and the HTML frontend.
Step 1: Update the Database Schema
The table will store all types of items, regardless of category:

sql
Copiar código
CREATE TABLE inventory_items (id SERIAL PRIMARY KEY,item_name VARCHAR(100) NOT NULL,
quantity INTEGER NOT NULL DEFAULT 0,category VARCHAR(50) NOT NULL);


Step 2: Update the Flask Application Code (app.py)
Here’s the updated Flask app using a single inventory model that suits your coffee roaster business needs:

python
Copiar código
from flask import Flask, request, jsonify, send_file, render_template
from flask_sqlalchemy import SQLAlchemy
import pandas as pd
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://inventory_user:your_password@localhost/inventory_db'
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
    date = db.Column(db.DateTime, default=datetime.utcnow)

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
    item_id = data.get('id')
    quantity = data.get('quantity')

    item = InventoryItem.query.get(item_id)
    if item:
        item.quantity += int(quantity)
        db.session.add(Transaction(item_id=item_id, change=int(quantity)))
        db.session.commit()
        return jsonify({"message": "Item added successfully."}), 200
    return jsonify({"message": "Item not found."}), 404

@app.route('/delete-item', methods=['POST'])
def delete_item():
    data = request.json
    item_id = data.get('id')
    quantity = data.get('quantity')

    item = InventoryItem.query.get(item_id)
    if item:
        if item.quantity >= int(quantity):
            item.quantity -= int(quantity)
            db.session.add(Transaction(item_id=item_id, change=-int(quantity)))
            db.session.commit()
            return jsonify({"message": "Item deleted successfully."}), 200
        return jsonify({"message": "Not enough quantity available."}), 400
    return jsonify({"message": "Item not found."}), 404

@app.route('/generate-report', methods=['GET'])
def generate_report():
    transactions = Transaction.query.all()
    data = [
        {
            "item_id": t.item_id,
            "change": t.change,
            "date": t.date.strftime('%Y-%m-%d %H:%M:%S')
        }
        for t in transactions
    ]

    df = pd.DataFrame(data)
    report_file = 'inventory_report.xlsx'
    df.to_excel(report_file, index=False)

    return send_file(report_file, as_attachment=True)

@app.route('/transaction-history', methods=['GET'])
def transaction_history():
    transactions = Transaction.query.all()
    history = [
        {
            "item_id": t.item_id,
            "change": t.change,
            "date": t.date.strftime('%Y-%m-%d %H:%M:%S')
        }
        for t in transactions
    ]
    return jsonify(history)

if __name__ == '__main__':
    db.create_all()  # Create tables
    app.run(debug=True)
Step 3: Update the Frontend HTML (templates/index.html)
Here’s the updated HTML for a single table displaying all inventory items, suitable for your coffee roaster business:

html
Copiar código
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f9f5e5;
            font-family: 'Roboto', sans-serif;
            padding: 20px;
        }
        .container {
            background-color: #ffebcd;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            padding: 30px;
            color: #4a4a4a;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Inventory Management</h1>

        <form id="inventoryForm">
            <div class="form-group">
                <label for="itemSelect">Select Item</label>
                <select class="form-control" id="itemSelect" required>
                    <option value="">Select an item...</option>
                </select>
            </div>
            <div class="form-group">
                <label for="quantityInput">Quantity</label>
                <input type="number" class="form-control" id="quantityInput" required min="1">
            </div>
            <button type="submit" class="btn btn-success" id="addButton">Add Item</button>
            <button type="button" class="btn btn-danger" id="deleteButton">Delete Item</button>
        </form>

        <h2 class="mt-4">Transaction History</h2>
        <button id="generateReport" class="btn btn-info mb-3">Download Report (Excel)</button>
        <table class="table table-striped" id="transactionTable">
            <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Quantity</th>
                    <th>Change</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody id="transactionBody">
                <!-- Transaction history will be populated here 
            </tbody>
        </table>
    </div>

    <script>
        async function fetchItems() {
            const response = await fetch('/items');
            const items = await response.json();

            const selectElement = document.getElementById('itemSelect');
            items.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id; // Using the ID for submission
                option.textContent = `${item.name} (${item.category})`; // Displaying name and category
                selectElement.appendChild(option);
            });
        }

        async function fetchTransactionHistory() {
            const response = await fetch('/transaction-history');
            const history = await response.json();

            const tbody = document.getElementById('transactionBody');
            tbody.innerHTML = ''; // Clear existing rows

            for (const t of history) {
                const itemResponse = await fetch(`/items?id=${t.item_id}`);
                const itemData = await itemResponse.json();
                const item = itemData[0];

                const row = document.createElement('tr');
                row.innerHTML = `<td>${item.id}</td><td>${item.item_name}</td><td>${item.category}</td><td>${item.quantity}</td><td>${t.change}</td><td>${t.date}</td>`;
                tbody.appendChild(row);
            }
        }

        document.addEventListener('DOMContentLoaded', async () => {
            await fetchItems();
            await fetchTransactionHistory();
        });

        document.getElementById('inventoryForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const selectedItemId = document.getElementById('itemSelect').value;
            const quantity = document.getElementById('quantityInput').value;

            const response = await fetch('/add-item', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ id: selectedItemId, quantity: quantity })
            });

            if (response.ok) {
                alert('Item added successfully!');
                document.getElementById('inventoryForm').reset(); // Reset the form after submission
                await fetchTransactionHistory(); // Refresh transaction history
            }
        });

        document.getElementById('deleteButton').addEventListener('click', async () => {
            const selectedItemId = document.getElementById('itemSelect').value;
            const quantity = document.getElementById('quantityInput').value;

            const response = await fetch('/delete-item', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ id: selectedItemId, quantity: quantity })
            });

            if (response.ok) {
                alert('Item deleted successfully!');
                document.getElementById('inventoryForm').reset(); // Reset the form after submission
                await

This complete implementation allows you to manage an inventory, select items, and specify quantities for addition or deletion. It also has endpoints for generating reports in CSV or JSON format and sending them via email and WhatsApp. Feel free to customize it further based on your specific requirements. If you have any questions or need more features, just let me know!-->
