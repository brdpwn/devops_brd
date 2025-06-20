import requests

BASE = "http://127.0.0.1:5000"

with open("results.txt", "w") as f:
    def log(response):
        output = response.text
        print(output)
        f.write(output + "\n\n")

    # 1. GET all students
    log(requests.get(f"{BASE}/students"))

    # 2. POST - create 3 students
    log(requests.post(f"{BASE}/students", json={"first_name": "Alice", "last_name": "Smith", "age": 20}))
    log(requests.post(f"{BASE}/students", json={"first_name": "Bob", "last_name": "Brown", "age": 22}))
    log(requests.post(f"{BASE}/students", json={"first_name": "Carol", "last_name": "Taylor", "age": 21}))

    # 3. GET all again
    log(requests.get(f"{BASE}/students"))

    # 4. PATCH - update age of second student
    log(requests.patch(f"{BASE}/students/2", json={"age": 25}))

    # 5. GET second student
    log(requests.get(f"{BASE}/students/2"))

    # 6. PUT - update third student
    log(requests.put(f"{BASE}/students/3", json={"first_name": "Carla", "last_name": "Thompson", "age": 30}))

    # 7. GET third student
    log(requests.get(f"{BASE}/students/3"))

    # 8. GET all again
    log(requests.get(f"{BASE}/students"))

    # 9. DELETE first student
    log(requests.delete(f"{BASE}/students/1"))

    # 10. GET all again
    log(requests.get(f"{BASE}/students"))

