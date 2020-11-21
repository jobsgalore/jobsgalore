def a
  if ['qwe', 'fre','sdf', 'werwrw', 'werwrewe', 'werwre'].include?('werwre')
    true
  end
end

def b
  if 'qwe'=='werwre' or 'fre'=='werwre' or'sdf'=='werwre' or 'werwrw'=='werwre' or 'werwrewe'=='werwre' or 'werwre'=='werwre'
    true
  end
end

def c
  if ['qwe', 'fre','sdf', 'werwrw', 'werwrewe', 'werwre']&['werwre']
    true
  end
end

def d
  if ['qwe', 'fre','sdf', 'werwrw', 'werwrewe', 'werwre'].find_all{|elem| elem == 'werwre'}.size!=0
    true
  end
end

t = Time.now
1000000.times do
  a
end
puts "A = #{(Time.now - t)*1000}"
t = Time.now
1000000.times do
  b
end
puts "B = #{(Time.now - t)*1000}"
t = Time.now
1000000.times do
  c
end
puts "C = #{(Time.now - t)*1000}"
t = Time.now
1000000.times do
  d
end
puts "D = #{(Time.now - t)*1000}"