require './line_man_base'

class LineManQueueElement < LineManBase
	attr_accessor :queue_id, :pos, :owner, :used_ts

end