require 'sequel'

class LineManQueueManager

	def initialize

		@db = Sequel.connect('jdbc:sqlite:bar2.db')

	end

	def get_queue(id)

		r = @db['select * from queue where id = ?', id].first

		q = LineManQueue.new
		q.id = r[:id]
		q.curr_pos = r[:curr_pos]
		q.owner = r[:owner]

		elements = Array.new

		@db['select * from queue_element where queue_id = ? order by pos', id].each do |row|
			p = LineManQueueElement.new
			p.queue_id = row[:queue_id]
			p.pos = row[:pos]
			p.owner = row[:owner]
			p.used_ts = row[:used_ts]

			elements.push(p)
		end

		q.elements = elements

		q
	end
end