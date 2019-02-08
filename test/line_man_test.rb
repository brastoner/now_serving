require 'rubygems'
require 'test/unit'
require 'sequel'

require '../lib/line_man_base'
require '../lib/line_man_queue'
require '../lib/line_man_queue_element'
require '../lib/line_man_repository'


class LineManTest < Test::Unit::TestCase

	def setup
	end

	def teardown
	end

	def test_create_queue
		repo = get_repo
		
		q = repo.create_queue('blue', 'me')

		assert_equal('blue', q.id)
		assert_equal('me', q.owner)
		assert_equal(-1, q.curr_pos)
		assert_equal([], q.elements)

	end

	def test_create_next_element
		repo = get_repo
		
		q = repo.create_queue('blue', 'me')
		e = q.create_next_queue_element('you')		

		assert_not_nil(e.id)
		assert_equal('blue', e.queue_id)
		assert_equal('you', e.owner)
		assert_equal(0, e.pos)
		assert_nil(e.used_ts)

	end

	def test_queue_advance
		repo = get_repo
		
		q = repo.create_queue('blue', 'me')
		e = q.create_next_queue_element('you')
		e2 = q.advance

		assert_equal(e, e2)
		assert_equal(0, q.curr_pos)

		# Test that can't advance past the length of the q

		e3 = q.advance

		assert_nil(e3)

	end

	def test_use_element
		repo = get_repo
		
		q = repo.create_queue('blue', 'me')
		q.create_next_queue_element('you')
		q.create_next_queue_element('you')

		q.advance
		q.advance

		q.use_element(1)

		q2 = repo.get_queue('blue')

		assert_nil(q2.elements[0].used_ts)
		assert_not_nil(q2.elements[1].used_ts)

	end

	def get_repo
		db = create_db
		LineManRepository.new(db)
	end

	def create_db
		db = Sequel.connect('jdbc:sqlite::memory:')
		db.run("CREATE TABLE queue(id TEXT PRIMARY KEY, curr_pos INTEGER, owner TEXT)")
		db.run("CREATE TABLE queue_element(id TEXT, queue_id TEXT, pos INTEGER, owner TEXT, used_ts INTEGER)")

		db
	end
end
