class LineManBase

	def to_hash		

		self.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
		
	end
end