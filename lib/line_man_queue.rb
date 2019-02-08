require 'securerandom'
require 'date'


class LineManQueue < LineManBase
	attr_accessor :id, :curr_pos, :owner, :elements

	def initialize(repository)
		@repository = repository

		@curr_pos = -1
		@elements = Array.new
	end

	def to_hash
		h = super

		h.delete('repository')

		h['elements'] = @elements.map { |e| e.to_hash }

		h
	end

	def create_next_queue_element(owner)
		
		#last_pos = @repository.db[:queue_element].max(:pos)
		new_pos = @elements.length

		elem = LineManQueueElement.new
		elem.id = SecureRandom.uuid
		elem.queue_id = @id
		elem.owner = owner
		elem.pos = new_pos

		@repository.upsert_queue_element(elem)		

		@elements.push(elem)

		elem

	end

	def advance		
		new_pos = @curr_pos + 1
		move_to_position(new_pos)
	end

	def use_element(pos)

		if (pos <= @curr_pos)
			elem = @elements[pos]

			if (elem)
				d = DateTime.now				

				elem.used_ts = d.strftime('%s')

				@repository.upsert_queue_element(elem)
			end
		end
	end

	private

	def move_to_position(pos)

		e = @elements[pos]

		if (!e.nil?)
			@curr_pos = pos
			@repository.update_queue(self)
			return e
		end		

	end

end
