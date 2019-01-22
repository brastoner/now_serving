require 'rubygems'
require 'json'

require './line_man_queue'
require './line_man_queue_element'
require './line_man_queue_manager'



manager = LineManQueueManager.new

#q = manager.get_queue('foo')
#puts q.to_hash

manager.create_next_queue_element("bar", "bar")
