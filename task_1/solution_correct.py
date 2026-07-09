"""
Домашнє завдання: Python — списки, словники, функції.
Версія: правильне виконання.
"""

students = [
    {"name": "anna", "course": "Python", "score": 92, "active": True},
    {"name": "oleh", "course": "SQL", "score": 78, "active": True},
    {"name": "ira", "course": "Python", "score": 85, "active": False},
    {"name": "max", "course": "Power BI", "score": 64, "active": True},
    {"name": "natalia", "course": "SQL", "score": 88, "active": True},
    {"name": "dmytro", "course": "Python", "score": 73, "active": True},
]


# 2. Імена активних студентів
active_names = [student["name"] for student in students if student["active"]]
print("2. Активні студенти:", active_names)


# 3. Середній бал усіх студентів
average_score = round(
    sum(student["score"] for student in students) / len(students),
    2,
)
print("3. Середній бал:", average_score)


# 4. Студент з найвищим балом
best_student = max(students, key=lambda student: student["score"])
print("4. Найкращий студент:", best_student)


# 5. Кількість студентів на кожному курсі
course_counts = {}
for student in students:
    course = student["course"]
    course_counts[course] = course_counts.get(course, 0) + 1

print("5. Кількість студентів на курсах:", course_counts)


# 6. Активні студенти з балом 80 або вище
active_high_score_students = [
    student for student in students
    if student["active"] and student["score"] >= 80
]
print("6. Активні студенти з балом 80+:", active_high_score_students)


# 7. Нормалізація імен
def normalize_names(students_list):
    normalized_students = []

    for student in students_list:
        normalized_student = student.copy()
        normalized_student["name"] = normalized_student["name"].capitalize()
        normalized_students.append(normalized_student)

    return normalized_students


normalized_students = normalize_names(students)
print("7. Студенти з нормалізованими іменами:", normalized_students)


# 8. Додавання категорії оцінки
def add_grade_category(students_list):
    students_with_categories = []

    for student in students_list:
        updated_student = student.copy()
        score = updated_student["score"]

        if score >= 90:
            category = "A"
        elif score >= 80:
            category = "B"
        elif score >= 70:
            category = "C"
        else:
            category = "D"

        updated_student["grade_category"] = category
        students_with_categories.append(updated_student)

    return students_with_categories


students_with_categories = add_grade_category(normalized_students)
print("8. Студенти з категоріями:", students_with_categories)


# 9. Сортування студентів за балом у порядку спадання
sorted_students = sorted(
    students_with_categories,
    key=lambda student: student["score"],
    reverse=True,
)
print("9. Відсортовані студенти:", sorted_students)


# 10. Текстовий звіт
report_lines = [
    f'{student["name"]} — {student["course"]} — {student["score"]} — {student["grade_category"]}'
    for student in sorted_students
]

report = "\n".join(report_lines)
print("10. Звіт:")
print(report)
