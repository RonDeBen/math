dimension = input("Enter the dimension, pussy: ")
edge_nodes = input("Enter the number of nodes along an edge, nerd: ")
number_of_nodes = edge_nodes ** dimension

def number_of_bridges:
	triangle = what_the_fuck_triangle()
	
	
def what_the_fuck_triangle:
	hypotenuse = []
	for k in range(0, dimension + 1)
		hypotenuse.append(3 ** k)

	hypotenuse[-1] -= 1

	start_row = hypotenuse

	antidiagonal = hypotenuse[-1]

	while (len(start_row) > 1)
		new_row = []

		for k in (0, (len(start_row)-1)) 
			new_row.append(start_row[k+1] - start_row[k])

		antidiagonal.append(new_row[-1])
		start_row = new_row
	return antidiagonal
