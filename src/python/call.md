# Call Data Analysis

You are given two DataFrames, `calls_df` and `customers_df`, which contain information about calls made by customers of a telecommunications company and information about the customers, respectively.

## Schema

### `calls_df`

| Column   | Type    | Description |
| :------- | :------ | :---------- |
| call_id  | integer | The unique identifier of each call. |
| cust_id  | integer | The unique identifier of the customer who made the call. |
| date     | string  | The date when the call was made in the format "yyyy-MM-dd". |
| duration | integer | The duration of the call in seconds. |

### `customers_df`

| Column     | Type    | Description |
| :--------- | :------ | :---------- |
| cust_id    | integer | The unique identifier of each customer. |
| name       | string  | The name of the customer. |
| state      | string  | The state where the customer lives. |
| tenure     | integer | The number of months the customer has been with the company. |
| occupation | string  | The occupation of the customer. |

## Task

Write a function that returns the number of distinct customers who made calls on each date, along with the total duration of calls made on each date.

The output DataFrame should have the following schema:

| Column         | Type    | Description |
| :------------- | :------ | :---------- |
| date           | string  | The date when the calls were made in the format "yyyy-MM-dd". |
| num_customers  | integer | The number of distinct customers who made calls on that date. |
| total_duration | integer | The total duration of calls made on that date in seconds. |

*You may assume that the upstream DataFrames are not empty.*

## Example

### Input

**calls_df**
```text
+---------+---------+------------+----------+
| call_id | cust_id | date       | duration |
+---------+---------+------------+----------+
| 1       | 1       | 2022-01-01 | 100      |
| 2       | 2       | 2022-01-01 | 200      |
| 3       | 1       | 2022-01-02 | 150      |
| 4       | 3       | 2022-01-02 | 300      |
| 5       | 2       | 2022-01-03 | 50       |
+---------+---------+------------+----------+
```

**customers_df**
```text
+---------+---------+-------+--------+------------+
| cust_id | name    | state | tenure | occupation |
+---------+---------+-------+--------+------------+
| 1       | Alice   | NY    | 10     | doctor     |
| 2       | Bob     | CA    | 12     | lawyer     |
| 3       | Charlie | TX    | 6      | engineer   |
+---------+---------+-------+--------+------------+
```

### Output

```text
+------------+---------------+----------------+
| date       | num_customers | total_duration |
+------------+---------------+----------------+
| 2022-01-01 | 2             | 300            |
| 2022-01-02 | 2             | 450            |
| 2022-01-03 | 1             | 50             |
+------------+---------------+----------------+
```

## Notes

### What does `return agg_df.reset_index()` do?

**Step 1: `groupby()` changes the index**
When you do `.groupby("date")`, pandas makes "date" the index (row labels), not a regular column.

**Step 2: `reset_index()` converts the index to a column**
It moves "date" from the index back into a regular column and creates a default numeric index.

**Step 3: `return` sends it back**
`return` gives the DataFrame back to whoever called the function, so you can use it.

### Difference between `return` and `print` (with analogy)

**Analogy: Restaurant order**
Think of a function like a kitchen, `return` like giving food to a server, and `print` like showing it on a receipt.

```python
def make_sandwich():
    sandwich = "Ham and Cheese"
    return sandwich  # Give it to whoever called the function

food = make_sandwich()  # You receive the sandwich
print(food)             # Now you can see it
# Output: Ham and Cheese
```

**Quick reference:**

| Action | What it does | When to use |
| :----- | :----------- | :---------- |
| `return` | Sends a value back to the caller | When you want to use the result later |
| `print` | Displays text to the console | When you want to see output immediately |
