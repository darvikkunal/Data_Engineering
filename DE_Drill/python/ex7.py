def ex():

    raw = input("Enter the list of numbers with ',' : ")

    try:
        #converting input to list of int
        list_num = [int(x.strip()) for x in raw.split(',')]
    except ValueError:
        print("Invalid input! Please enter only numbers separated by commas. \n")
    except UnboundLocalError:
        print("Invalid input! Please enter only numbers separated by commas. \n")

    maximum = max(list_num)
    minimum = min(list_num)
    average = sum(list_num) / len(list_num)
    total = sum(list_num)

    print(f"The Maximum is : {maximum}")
    print(f"The minimum is : {minimum}")
    print(f"The average is : {average}")
    print(f"The total is : {total}")
        
    for i in list_num:
        if i % 2 == 0:
            print(f"The even number are : {i} \n")
        else:
            print(f"The odd numbers are : {i} \n")
        if i > average:
            print(f"{i} is greater than average \n")


ex()