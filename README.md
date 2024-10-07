# Apapacho_DB
This project will be encharged of manage, deploy and generate a pilot or engine to generate an inventory stock or something related/useful for that one.
<!--Absolutely! Below is a complete implementation of an inventory management system using Flask, SQLAlchemy, and a PostgreSQL database. The code includes all necessary components, from models to routes and the HTML frontend.

### Complete Flask Application

#### Step 1: Setup

First, ensure you have the required libraries installed. You can install them using pip:

```bash
pip install Flask Flask-SQLAlchemy psycopg2 pandas twilio
```

#### Step 2: Database Setup

Make sure you have PostgreSQL set up and a database created. Here's a sample schema for your database:

```sql
CREATE DATABASE inventory_db;

CREATE TABLE food_items (
    id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    expiration_date DATE
);

CREATE TABLE beverage_items (
    id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    volume FLOAT
);
```

#### Step 3: Flask Application Code (app.py)

```python
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
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://inventory_user:your_password@localhost/inventory_db'
db = SQLAlchemy(app)

class BaseItem(db.Model):
    __abstract__ = True
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=0)

class FoodItem(BaseItem):
    __tablename__ = 'food_items'
    expiration_date = db.Column(db.Date, nullable=False)

class BeverageItem(BaseItem):
    __tablename__ = 'beverage_items'
    volume = db.Column(db.Float, nullable=False)

@app.route('/items', methods=['GET'])
def get_items():
    food_items = FoodItem.query.all()
    beverage_items = BeverageItem.query.all()
    
    items = {
        'food': [{"id": item.id, "name": item.item_name} for item in food_items],
        'beverage': [{"id": item.id, "name": item.item_name} for item in beverage_items],
    }
    
    return jsonify(items)

@app.route('/add-item', methods=['POST'])
def add_item():
    data = request.json
    item_id = data.get('id')
    quantity = data.get('quantity')

    item = BaseItem.query.get(item_id)
    if item:
        item.quantity += int(quantity)
        db.session.commit()
        return jsonify({"message": "Item added successfully."}), 200
    return jsonify({"message": "Item not found."}), 404

@app.route('/delete-item', methods=['POST'])
def delete_item():
    data = request.json
    item_id = data.get('id')
    quantity = data.get('quantity')

    item = BaseItem.query.get(item_id)
    if item:
        if item.quantity >= int(quantity):
            item.quantity -= int(quantity)
            db.session.commit()
            return jsonify({"message": "Item deleted successfully."}), 200
        return jsonify({"message": "Not enough quantity available."}), 400
    return jsonify({"message": "Item not found."}), 404

@app.route('/generate-report', methods=['GET'])
def generate_report():
    items = FoodItem.query.all() + BeverageItem.query.all()
    report_format = request.args.get('format', 'json')  # Default to JSON
    data = [{"id": item.id, "item_name": item.item_name, "quantity": item.quantity} for item in items]
    
    if report_format == 'csv':
        df = pd.DataFrame(data)
        csv_file = 'inventory_report.csv'
        df.to_csv(csv_file, index=False)
        return send_file(csv_file, as_attachment=True)
    
    # Default to JSON
    return jsonify(data)

@app.route('/send-report', methods=['POST'])
def send_report():
    to_email = request.json.get('email')
    to_number = request.json.get('number')
    report_format = request.json.get('format', 'json')

    items = FoodItem.query.all() + BeverageItem.query.all()
    data = [{"id": item.id, "item_name": item.item_name, "quantity": item.quantity} for item in items]
    
    if report_format == 'csv':
        df = pd.DataFrame(data)
        csv_file = 'inventory_report.csv'
        df.to_csv(csv_file, index=False)
        
        # Send Email
        send_email(to_email, 'Inventory Report', 'Find the inventory report attached.', csv_file)
        
        # Send WhatsApp Message
        send_whatsapp_message(to_number, 'Your inventory report has been sent via email.')
        
        return jsonify({"message": "Report sent successfully."}), 200
    
    # Send JSON report
    json_file = 'inventory_report.json'
    with open(json_file, 'w') as f:
        json.dump(data, f)
        
    send_email(to_email, 'Inventory Report', 'Find the inventory report attached.', json_file)
    send_whatsapp_message(to_number, 'Your inventory report has been sent via email.')
    
    return jsonify({"message": "Report sent successfully."}), 200

def send_email(to_email, subject, body, attachment=None):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = 'your_email@gmail.com'
    msg['To'] = to_email

    # Configure your SMTP server
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login('your_email@gmail.com', 'your_email_password')
        server.send_message(msg)

def send_whatsapp_message(to_number, message):
    account_sid = 'your_account_sid'
    auth_token = 'your_auth_token'
    client = Client(account_sid, auth_token)
    
    client.messages.create(
        body=message,
        from_='whatsapp:+14155238886',  # Your Twilio WhatsApp number
        to=f'whatsapp:{to_number}'
    )

if __name__ == '__main__':
    app.run(debug=True)
```

### Step 4: Frontend HTML (templates/index.html)

```html
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

        <h2>Report</h2>
        <button id="generateReport" class="btn btn-info btn-block">Generate Report</button>
        <div id="report" class="mt-3"></div>
    </div>

    <script>
        async function fetchItems() {
            const response = await fetch('/items');
            const data = await response.json();

            const selectElement = document.getElementById('itemSelect');
            for (const category in data) {
                data[category].forEach(item => {
                    const option = document.createElement('option');
                    option.value = item.id; // Using the ID for submission
                    option.textContent = item.name; // Displaying the name
                    selectElement.appendChild(option);
                });
            }
        }

        document.addEventListener('DOMContentLoaded', fetchItems);

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
            }
        });

        document.getElementById('deleteButton').addEventListener('

click', async () => {
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
            }
        });
    </script>
</body>
</html>
```

### Step 5: Directory Structure

Your project directory structure should look something like this:

```
/your_project_directory
│
├── app.py
├── templates
│   └── index.html
└── requirements.txt
```

### Step 6: Running the Application

1. Make sure your PostgreSQL database is running and accessible.
2. Run the Flask app:

```bash
python app.py
```

3. Open your web browser and go to `http://127.0.0.1:5000/`.

### Conclusion

This complete implementation allows you to manage an inventory, select items, and specify quantities for addition or deletion. It also has endpoints for generating reports in CSV or JSON format and sending them via email and WhatsApp. Feel free to customize it further based on your specific requirements. If you have any questions or need more features, just let me know!-->
