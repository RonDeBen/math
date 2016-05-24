class DirectSum

	def initialize(cycles)
		@sums = cycles
		@number_of_elements = @sums.inject(:*)#multiplies the numbers in the array together
		@phi_tree = []
		@sums.reverse.each_with_index do |cycle, index|
			if(index == 0)
				@phi_tree[@sums.length-1] = 1
			else
				@phi_tree[@sums.length-1-index] = @sums[@sums.length-index] * @phi_tree[@sums.length-index]
			end
		end
		highest_order
		check_elements
	end

	def highest_order
		all_ones = Array.new(@sums.length, 1)
		@highest_order = generate(all_ones)
		puts "the highest order is #{@highest_order}"
	end

	def check_elements
		number_of_working_elements = 0
		@number_of_elements.times do |n|
			remainder=n
			element = []
			@phi_tree.each_with_index do |branch, index|
				element[index] = remainder / @phi_tree[index]
				remainder %= @phi_tree[index]
			end
			if(generate(element) == @highest_order)
				number_of_working_elements += 1
				p element
			end
		end
		puts "there are #{number_of_working_elements} elements in #{@sums} of order #{@highest_order}"
	end

	def generate(generator)
		identity = Array.new(@sums.length, 0)
		a = Array.new(@sums.length, 0)
		n = 0
		while(n == 0 || a != identity)
			n += 1
			a.each_index do |index|
				a[index] = (generator[index]*n) % @sums[index]
			end
		end
		return n
	end
end