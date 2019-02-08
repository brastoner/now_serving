require 'rubygems'
require 'json'
require 'sequel'

require '../lib/line_man_base'
require '../lib/line_man_queue'
require '../lib/line_man_queue_element'
require '../lib/line_man_repository'

db = Sequel.connect('jdbc:sqlite:../db/bar2.db')

repo = LineManRepository.new(db)

#q = repo.create_queue("red", "me")
#new_elem = q.create_next_queue_element('newOwner1')
q = repo.get_queue('red')



puts q.to_hash



__END__

