class Ring
	def initialize(*args)
		if(args.length == 1)
			# if(args[0].kind_of?(Array))
				#do later
			# else
				@mod = args[0]
				find_identities
		else
			@mod = args[0]
			@elements = get_elements(args[1])
			generate_table
		end
	end

	def get_elements(step)
		elements = []
		@mod.times do |i|
			elements << i if (i%step == 0)
		end
		return elements
	end

	def find_identities
		2.upto(@mod-1) do |step|
			find_identity(step)
		end
	end

	def find_identity(step)
		identity = -1
		elements = get_elements(step)
		elements.each do |top_element|
			result = []
			elements.each do |bottom_element|
				product = (top_element*bottom_element) % @mod
				result << product
			end
			identity = top_element if (result ==  elements)
		end
		if(identity != -1)
			puts "#{step} -> #{identity}"
		end
	end

	def generate_table
		identity = -1
		print "\t"
		@elements.each do |element|
			print "#{element}\t"
		end
		print "\n"
		@elements.each do |top_element|
			print "#{top_element}\t"
			result = []
			@elements.each do |bottom_element|
				product = (top_element*bottom_element) % @mod
				result << product
				print "#{product}\t"
			end
			identity = top_element if (result == @elements)
			print "\n"
		end
		if(identity != -1)
			puts "The identity is #{identity}"
		else
			puts "There is no identity"
		end
	end
end