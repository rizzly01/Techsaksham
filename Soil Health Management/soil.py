import mysql.connector
import tkinter as tk
from tkinter import ttk, messagebox
import random
from faker import Faker
from datetime import datetime, timedelta

# Initialize Faker for generating random data
fake = Faker()

# MySQL Database Connection Details
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "root",
    "database": "soilmanagement"
}

# List of sample soil types
soil_types = ["Loamy", "Sandy", "Clay", "Peaty", "Saline", "Chalky"]

# List of possible amendments for soil
soil_amendments_list = [
    "Compost",
    "Manure",
    "Lime",
    "Sulfur",
    "Fertilizers",
    "Mulch",
    "Green manure"
]

# Database Connection Function
def connect_db():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except mysql.connector.Error as e:
        messagebox.showerror("Database Error", f"Error connecting to database: {e}")
        return None

# Function to Insert Manual Soil Record
def insert_manual_record():
    conn = connect_db()
    if conn:
        cursor = conn.cursor()
        soil_type = soil_type_entry.get()
        ph_level = ph_level_entry.get()
        organic_matter = organic_matter_entry.get()
        amendments = soil_amendments_entry.get()
        planting_date = planting_date_entry.get()
        harvest_date = harvest_date_entry.get()
        yield_prediction = yield_entry.get()

        if not soil_type or not ph_level or not organic_matter or not amendments or not planting_date or not harvest_date or not yield_prediction:
            messagebox.showwarning("Input Error", "All fields must be filled!")
            return

        try:
            cursor.execute("""
                INSERT INTO soil (soil_type, ph_level, organic_matter_percentage, soil_amendments, planting_date, harvest_date, yield_prediction)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (soil_type, ph_level, organic_matter, amendments, planting_date, harvest_date, yield_prediction))
            conn.commit()
            messagebox.showinfo("Success", "Soil record inserted successfully!")
            conn.close()
            display_records()
        except mysql.connector.Error as e:
            messagebox.showerror("Database Error", f"Error inserting record: {e}")

# Function to Generate Random Data for Bulk Insert
def generate_data():
    soil_type = random.choice(soil_types)
    ph_level = round(random.uniform(5.0, 8.0), 2)  # Soil pH between 5.0 and 8.0
    organic_matter = round(random.uniform(2.0, 10.0), 2)  # Organic matter percentage between 2% and 10%
    amendments = random.choice(soil_amendments_list)
    planting_date = fake.date_between(start_date="-2y", end_date="today")  # Planting in last 2 years
    harvest_date = planting_date + timedelta(days=random.randint(60, 180))  # Harvest after 2-6 months
    yield_prediction = random.randint(500, 5000)  # Yield in kg
    return (soil_type, ph_level, organic_matter, amendments, planting_date, harvest_date, yield_prediction)

# Function to Insert 100,000 Random Records
def insert_bulk_records():
    conn = connect_db()
    if conn:
        cursor = conn.cursor()
        batch_size = 100000
        total_records = 2000000

        for i in range(0, total_records, batch_size):
            data_batch = [generate_data() for _ in range(batch_size)]
            cursor.executemany("""
                INSERT INTO soil (soil_type, ph_level, organic_matter_percentage, soil_amendments, planting_date, harvest_date, yield_prediction)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, data_batch)
            conn.commit()
            progress_label.config(text=f"{i + batch_size} records inserted...")

        messagebox.showinfo("Success", "100,000 records inserted successfully!")
        conn.close()
        display_records()

# Function to Display Records
def display_records():
    conn = connect_db()
    if conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM soil ORDER BY id DESC LIMIT 20")  # Show last 20 records
        rows = cursor.fetchall()
        conn.close()

        for row in tree.get_children():
            tree.delete(row)

        for row in rows:
            tree.insert("", "end", values=row)

# GUI Setup
root = tk.Tk()
root.title("Soil Management System")
root.geometry("900x600")
root.configure(bg="#f0f0f0")

# Custom Fonts and Colors
font_title = ('Helvetica', 16, 'bold')
font_label = ('Arial', 12)
font_entry = ('Arial', 12)
font_button = ('Arial', 12, 'bold')
font_progress = ('Courier', 10, 'italic')

# Title Label
title_label = tk.Label(root, text="Soil Management System", font=('Helvetica', 20, 'bold'), bg="#4CAF50", fg="white", pady=10)
title_label.grid(row=0, column=0, columnspan=2, sticky="ew")

# Input Fields with Padding and Styling
tk.Label(root, text="Soil Type", font=font_label, bg="#f0f0f0").grid(row=1, column=0, padx=10, pady=5)
soil_type_entry = tk.Entry(root, font=font_entry)
soil_type_entry.grid(row=1, column=1, padx=10, pady=5)

tk.Label(root, text="pH Level", font=font_label, bg="#f0f0f0").grid(row=2, column=0, padx=10, pady=5)
ph_level_entry = tk.Entry(root, font=font_entry)
ph_level_entry.grid(row=2, column=1, padx=10, pady=5)

tk.Label(root, text="Organic Matter (%)", font=font_label, bg="#f0f0f0").grid(row=3, column=0, padx=10, pady=5)
organic_matter_entry = tk.Entry(root, font=font_entry)
organic_matter_entry.grid(row=3, column=1, padx=10, pady=5)

tk.Label(root, text="Soil Amendments", font=font_label, bg="#f0f0f0").grid(row=4, column=0, padx=10, pady=5)
soil_amendments_entry = tk.Entry(root, font=font_entry)
soil_amendments_entry.grid(row=4, column=1, padx=10, pady=5)

tk.Label(root, text="Planting Date (YYYY-MM-DD)", font=font_label, bg="#f0f0f0").grid(row=5, column=0, padx=10, pady=5)
planting_date_entry = tk.Entry(root, font=font_entry)
planting_date_entry.grid(row=5, column=1, padx=10, pady=5)

tk.Label(root, text="Harvest Date (YYYY-MM-DD)", font=font_label, bg="#f0f0f0").grid(row=6, column=0, padx=10, pady=5)
harvest_date_entry = tk.Entry(root, font=font_entry)
harvest_date_entry.grid(row=6, column=1, padx=10, pady=5)

tk.Label(root, text="Yield Prediction (kg)", font=font_label, bg="#f0f0f0").grid(row=7, column=0, padx=10, pady=5)
yield_entry = tk.Entry(root, font=font_entry)
yield_entry.grid(row=7, column=1, padx=10, pady=5)

# Buttons with Styling
insert_button = tk.Button(root, text="Insert Record", font=font_button, bg="#4CAF50", fg="white", command=insert_manual_record)
insert_button.grid(row=8, column=0, columnspan=2, pady=10)

bulk_insert_button = tk.Button(root, text="Insert 100,000 Random Records", font=font_button, bg="#008CBA", fg="white", command=insert_bulk_records)
bulk_insert_button.grid(row=9, column=0, columnspan=2, pady=10)

progress_label = tk.Label(root, text="", font=font_progress, bg="#f0f0f0")
progress_label.grid(row=10, column=0, columnspan=2)

# Table to Display Records with Enhanced Style
columns = ("ID", "Soil Type", "pH Level", "Organic Matter (%)", "Soil Amendments", "Planting Date", "Harvest Date", "Yield Prediction")
tree = ttk.Treeview(root, columns=columns, show="headings", height=10)
tree.grid(row=11, column=0, columnspan=2, padx=10, pady=10)

# Style for Treeview
tree.heading("ID", text="ID")
tree.heading("Soil Type", text="Soil Type")
tree.heading("pH Level", text="pH Level")
tree.heading("Organic Matter (%)", text="Organic Matter (%)")
tree.heading("Soil Amendments", text="Soil Amendments")
tree.heading("Planting Date", text="Planting Date")
tree.heading("Harvest Date", text="Harvest Date")
tree.heading("Yield Prediction", text="Yield Prediction (kg)")

tree.column("ID", width=50, anchor="center")
tree.column("Soil Type", width=150, anchor="center")
tree.column("pH Level", width=120, anchor="center")
tree.column("Organic Matter (%)", width=150, anchor="center")
tree.column("Soil Amendments", width=180, anchor="center")
tree.column("Planting Date", width=120, anchor="center")
tree.column("Harvest Date", width=120, anchor="center")
tree.column("Yield Prediction", width=150, anchor="center")

# Load initial records
display_records()

# Run the GUI
root.mainloop()
