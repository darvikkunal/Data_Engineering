def st_grade_cal():

    raw_marks = input("Enter the grades of 5 subjects out of 100: ").split(',')
    try:
        marks = [int(x.strip()) for x in raw_marks]
    except ValueError:
        print("Please enter only numbers seperated by commas")
    total = sum(marks)
    print(f"The total marks are {total} / 500")
    total_percentage = sum(marks) / len(marks)
    if total_percentage >= 90:
        print(f"Grade A :{total_percentage:.2f}% ")
    elif total_percentage >= 75:
        print(f"Grade B : {total_percentage:.2f}%")
    elif total_percentage >= 60:
        print(f"Grade C : {total_percentage:.2f}%")
    elif total_percentage >= 45:
        print(f"Grade D : {total_percentage:.2f}%")
    else :
        print(f"Grade F : {total_percentage:.2f}%")
    return


st_grade_cal()

