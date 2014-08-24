def string_shuffle(s)
	puts s
	s.split('').to_a.shuffle[0..7].join
end