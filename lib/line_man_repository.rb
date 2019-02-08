class LineManRepository
	attr_reader :db

	def initialize(db)

		@db = db

	end

	def get_queue(id)

		r = @db['select * from queue where id = ?', id].first

		q = LineManQueue.new(self)
		q.id = r[:id]
		q.curr_pos = r[:curr_pos]
		q.owner = r[:owner]

		elements = Array.new

		@db['select * from queue_element where queue_id = ? order by pos', id].each do |row|
			p = LineManQueueElement.new
			p.id = row[:id]
			p.queue_id = row[:queue_id]
			p.pos = row[:pos]
			p.owner = row[:owner]
			p.used_ts = row[:used_ts]

			elements.push(p)
		end

		q.elements = elements

		q
	end

	def upsert_queue_element(element)

		elements = @db[:queue_element]
		matching_elems = elements.where(id: element.id)		

		if (matching_elems.count > 0)
			puts "Updating q elem"
			matching_elems.update(queue_id: element.queue_id, pos: element.pos, owner: element.owner, used_ts: element.used_ts)
		else
			puts "Inserting q elem"
			elements.insert(id: element.id, queue_id: element.queue_id, pos: element.pos, owner: element.owner, used_ts: element.used_ts)
		end
		
	end

	def create_queue(id, owner)

		q = LineManQueue.new(self)
		q.id = id
		q.owner = owner

		queues = @db[:queue]
		queues.insert(id: q.id, curr_pos: q.curr_pos, owner: q.owner)

		q
	end

	def update_queue(queue)

		queues = @db[:queue]
		matching_queues = queues.where(id: queue.id)		

		if (matching_queues.count > 0)
			puts "Updating q"
			matching_queues.update(curr_pos: queue.curr_pos, owner: queue.owner)
		end		
	end
	
end

__END__

