rails Mash.new unless attribute?("rails")

rails[:version] = '2.3.8' unless rails.has_key?(:version)
rails[:max_pool_size] = 4 unless rails.has_key?(:max_pool_size)
rails[:a_new_attribute] = 'a new value from a custom recipe'