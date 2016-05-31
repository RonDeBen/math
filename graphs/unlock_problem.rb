class Hypercube
	require 'prime'
	require 'facets'

	def initialize(dimension, edge_nodes)

		@dimension = dimension
		@n = edge_nodes
		@number_of_nodes = edge_nodes ** dimension
		@number_of_bridges = number_of_bridges
		@longest_path = longest_path
		@primes = Prime.first(@number_of_nodes)
		@possible_bridges = []
		@default_valence = []

		@possible_shapes = []

		(1..@longest_path).each do |i|
			@possible_shapes[i] = {}
		end

		build_bridges

		find_all_trails

		@most_complicated_shapes = find_most_complicated_shapes
	end

	def possible_shapes
		@possible_shapes
	end

	def number_of_bridges
		triangle = what_the_fuck_triangle
		adjacencies = {}
		0.upto(@dimension) do |k|
			a_k = @dimension.choose(k)
			r = (@n-2) ** (@dimension - k)
			b = 2 ** (k)
			adjacencies[triangle[k]] = a_k * r * b#a_k*r^k*b^(n-k)
		end

		sum = 0
		adjacencies.each do |k, v|
			if(v == 1)
				puts "there is 1, #{k}-node"
			else
				puts "there are #{v}, #{k}-nodes"
			end
			sum += k * v
		end

		sum / 2
	end

	def what_the_fuck_triangle
		hypotenuse = []
		(@dimension+1).times do |k|
			hypotenuse << 3 ** k
		end

		hypotenuse[-1] -= 1

		start_row = hypotenuse

		antidiagonal = [hypotenuse[-1]]

		while (start_row.length > 1)
			new_row = []
			(start_row.length-1).times do |k|
				new_row << start_row[k+1] - start_row[k]
			end 
			antidiagonal << new_row[-1]
			start_row = new_row
		end
		antidiagonal
	end

	def longest_path
		even_nodes = (@n-2) ** @dimension
		odd_nodes = @number_of_nodes - even_nodes
		return @number_of_bridges - (odd_nodes - 2) / 2
	end

	def build_bridges
		ternary_hypercube = []
		(3 ** @dimension).times do |k|
			remainder = k
			coordinates = []
			(1..@dimension).each do |j|
				thing = 3 ** (@dimension - j)
				coordinates << (remainder / thing) - 1
				remainder %= thing
			end
			ternary_hypercube << coordinates
		end

		all_zeroes = Array.new(@dimension, 0)
		ternary_hypercube = ternary_hypercube - [all_zeroes]

		nary_hypercube = []

		@number_of_nodes.times do |k|
			remainder = k
			coordinates = []
			(1..@dimension).each do |j|
				thing = @n ** (@dimension - j)
				coordinates << (remainder / thing)
				remainder %= thing
			end
			nary_hypercube << coordinates
		end

		possible_bridges = []
		@number_of_nodes.times do |k|
			possible_bridges[k] = []
		end

		nary_hypercube.each_with_index do |node, nary_hypercube_index|
			ternary_hypercube.each_with_index do |vector, ternary_hypercube_index|
				is_inside_cube = true
				new_vector = []
				node.each_with_index do |component, index|
					component_adjacency = component - vector[index]
					new_vector << component_adjacency
					if !(component_adjacency >= 0 && component_adjacency < @n)
						is_inside_cube = false
					end
				end
				possible_bridges[nary_hypercube_index] << reconstruct_number(new_vector) if(is_inside_cube)
			end
		end

		possible_bridges.each_with_index do |valences, index|
			@default_valence[index] = valences.length
		end

		@possible_bridges = possible_bridges

		return possible_bridges
	end

	def reconstruct_number(number_array)
		sum = 0
		length = number_array.length
		number_array.each_with_index do |number, index|
			sum += number * (@n ** (length - index - 1))
		end
		return sum
	end

	def find_all_trails
		start_time = Time.now
		(1..@longest_path).each do |i|
		# (@number_of_nodes..@longest_path).each do |i|
			find_trails_of_length(i)
			end_time = Time.now
			if(@possible_shapes[i].length == 1)
				puts "There are #{@possible_shapes[i].length} possible trails of length #{i} found in #{(end_time - start_time)} seconds"
			else
				puts "There are #{@possible_shapes[i].length} possible trails of length #{i} found in #{(end_time - start_time)} seconds"
			end
			start_time = end_time
		end
	end

	def find_trails_of_length(max_length)
		i = 0
		# @number_of_nodes.times do |i|
		find_trail(i, @possible_bridges, 0, [], max_length)
		# end

		@possible_shapes[max_length].each { |k, v| @possible_shapes[max_length][k] = v.uniq }
	end

	def find_trail(current_node_number, bridges_array, number_of_bridges_crossed, path_taken, max_trail_length)

		if(number_of_bridges_crossed == max_trail_length)

			valence = get_valence_from_unused_bridges(bridges_array)
			if(@possible_shapes[max_trail_length][valence] == nil)#this valence has not been discovered yet
				@possible_shapes[max_trail_length][valence] = [path_taken.sort]
			else
				@possible_shapes[max_trail_length][valence] << path_taken.sort
			end
			return nil
		end

		if(bridges_array[current_node_number] == [])
			return nil
		end

		bridges_array[current_node_number].each do |this_way|
			new_number_of_bridges_crossed = number_of_bridges_crossed + 1

			new_path_taken = path_taken + [(@primes[current_node_number]*@primes[this_way])]

			# bridges_left = Array.new(bridges_array)
			bridges_left = bridges_array.dup
			bridges_left[current_node_number] -= [this_way]
			bridges_left[this_way] -= [current_node_number]

			find_trail(this_way, bridges_left, new_number_of_bridges_crossed, new_path_taken, max_trail_length)
		end
	end

	def get_valence_from_unused_bridges(unused_bridges)
		valence = []
		unused_bridges.each_with_index do |bridges_left, index|
			valence[index] = @default_valence[index] - bridges_left.length
		end
		return valence
	end

	def find_most_complicated_shapes
		max_complexity = 0
		max_length = 0
		most_complicated_shapes = {}
		@possible_shapes.each_with_index do |shape, length|
			if(shape != nil)
				shape.each do |valence, solutions|
					complexity = solutions.length * length
					if(complexity > max_complexity)
						max_complexity = complexity 
						max_length = length
						most_complicated_shapes = {}
						most_complicated_shapes[valence] = solutions
					elsif (complexity == max_complexity) 
						most_complicated_shapes[valence] = solutions 
					end
				end
			end
		end
		if(most_complicated_shapes.length == 1)
			puts "There is #{most_complicated_shapes.length} shape of length #{max_length} that require #{max_complexity} moves to solve"
		else
			puts "There are #{most_complicated_shapes.length} shapes of length #{max_length} that require #{max_complexity} moves to solve"
		end
		@most_complicated_shapes = most_complicated_shapes
	end

end

class Integer
  # binomial coefficient: n C k
  def choose(k)
    # n!/(n-k)!
    pTop = (self-k+1 .. self).inject(1, &:*) 
    # k!
    pBottom = (2 .. k).inject(1, &:*)
    pTop / pBottom
  end
end