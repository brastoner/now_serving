require './line_man_base'

class LineManQueue < LineManBase
	attr_accessor :id, :curr_pos, :owner, :elements

	def to_hash
		h = super

		h['elements'] = @elements.map { |e| e.to_hash }

		h
	end

end