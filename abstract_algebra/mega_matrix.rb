require 'Matrix'
I = Matrix[[1, 0], [0, 1]]
R = Matrix[[0, -1], [1, 0]]
R2 = R * R
R3 = R2 * R
H = Matrix[[1, 0], [0, -1]]
V = Matrix[[-1, 0], [0, 1]]
D = Matrix[[0, 1], [1, 0]]
T = Matrix[[0, -1], [-1, 0]]
matricies = [I, R, R2, R3, H, V, D, T]

matricies.each do |matrix|
	matricies.each do |other_matrix|
		puts "#{matrix} * #{other_matrix} = #{matrix*other_matrix}"
	end
	puts ""
end