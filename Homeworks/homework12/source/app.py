from flask import Flask, jsonify, request
import csv
import os

app = Flask(__name__)
CSV_FILE = 'students.csv'
FIELDS = ["id", "first_name", "last_name", "age"]

# Створення CSV з заголовками, якщо не існує
if not os.path.exists(CSV_FILE):
    with open(CSV_FILE, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()

# Допоміжна функція для читання всіх студентів
def read_students():
    with open(CSV_FILE, newline='') as f:
        return list(csv.DictReader(f))

# Допоміжна функція для запису студентів
def write_students(students):
    with open(CSV_FILE, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(students)

@app.route("/")
def index():
    return "Student Management API is running."

@app.route("/students", methods=["GET"])
def get_all_students():
    students = read_students()
    if not students:
        return jsonify({"error": "No students found"}), 404
    return jsonify(students)

@app.route("/students/<int:student_id>", methods=["GET"])
def get_student_by_id(student_id):
    students = read_students()
    for s in students:
        if int(s["id"]) == student_id:
            return jsonify(s)
    return jsonify({"error": "Student not found"}), 404

@app.route("/students", methods=["GET"])
def get_students_by_lastname():
    last_name = request.args.get("last_name")
    if not last_name:
        return get_all_students()

    matches = [s for s in read_students() if s["last_name"].lower() == last_name.lower()]
    if matches:
        return jsonify(matches)
    return jsonify({"error": "No student with this last name"}), 404

@app.route("/students", methods=["POST"])
def add_student():
    data = request.get_json()
    if not data or set(data.keys()) != {"first_name", "last_name", "age"}:
        return jsonify({"error": "Missing or invalid fields"}), 400

    students = read_students()
    new_id = max([int(s["id"]) for s in students], default=0) + 1

    new_student = {
        "id": str(new_id),
        "first_name": data["first_name"],
        "last_name": data["last_name"],
        "age": str(data["age"])
    }

    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

@app.route("/students/<int:student_id>", methods=["PUT"])
def update_student(student_id):
    data = request.get_json()
    if not data or set(data.keys()) != {"first_name", "last_name", "age"}:
        return jsonify({"error": "Missing or invalid fields"}), 400

    students = read_students()
    for s in students:
        if int(s["id"]) == student_id:
            s["first_name"] = data["first_name"]
            s["last_name"] = data["last_name"]
            s["age"] = str(data["age"])
            write_students(students)
            return jsonify(s)

    return jsonify({"error": "Student not found"}), 404

@app.route("/students/<int:student_id>", methods=["PATCH"])
def patch_student_age(student_id):
    data = request.get_json()
    if not data or "age" not in data or len(data.keys()) != 1:
        return jsonify({"error": "Missing or invalid age field"}), 400

    students = read_students()
    for s in students:
        if int(s["id"]) == student_id:
            s["age"] = str(data["age"])
            write_students(students)
            return jsonify(s)

    return jsonify({"error": "Student not found"}), 404

@app.route("/students/<int:student_id>", methods=["DELETE"])
def delete_student(student_id):
    students = read_students()
    updated_students = [s for s in students if int(s["id"]) != student_id]
    if len(updated_students) == len(students):
        return jsonify({"error": "Student not found"}), 404

    write_students(updated_students)
    return jsonify({"message": f"Student with ID {student_id} deleted"}), 200

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")


