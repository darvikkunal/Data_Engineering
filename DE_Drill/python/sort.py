'''What sort.py does overall:                                                                                                                                                                 
  Defines a function that finds the N largest numbers from a list, then calls it with nums to get the 2 largest.                                                                             
                                                                                                                                                                                             
  ---                                                                                                                                                                                        
  numbers[-n:] — negative slicing                                                                                                                                                            
                                                                                                                                                                                             
  Python lists can be sliced with negative indices, which count from the end:                                                                                                                
                                                                                                                                                                                             
  numbers = [1, 1, 2, 4, 34, 123, 321]  # after sort()
  numbers[-2:]  # → [123, 321]                                                                                                                                                               
                  
  - -2 means "start 2 positions from the end"                                                                                                                                                
  - : means "take everything from there to the end"
  - So numbers[-n:] = last n elements = the n largest (since list is sorted ascending)                                                                                                       
                                                                                                                                                                                             
  ---                                                                                                                                                                                        
  get_largest_number(nums, 2)                                                                                                                                                                
                                                                                                                                                                                             
  Step by step:
  nums = [2, 4, 1, 34, 123, 321, 1]                                                                                                                                                          
                                   
  # Step 1: numbers.sort() sorts in place (ascending)                                                                                                                                        
  # nums becomes → [1, 1, 2, 4, 34, 123, 321]        
                                                                                                                                                                                             
  # Step 2: return numbers[-2:]                                                                                                                                                              
  # → [123, 321]               
                                                                                                                                                                                             
  One thing to note: .sort() mutates the original list in place. That's why the second print(nums) on line 12 prints the sorted version [1, 1, 2, 4, 34, 123, 321], not the original — even
  though nums was never explicitly reassigned.     '''

def get_largest_number(numbers,n):
    numbers.sort()

    return numbers[-n:]


nums=[2,4,1,34, 123, 321, 1]

print(nums)

largest = get_largest_number(nums,2)
print(nums)
print(largest)