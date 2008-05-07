def convert(row)
  str = %q(
<li>
  <span class="date">{0}</span>
  <span class="avg" style="width: {1}%">Avg: {1}</span>
  <span class="min" style="width: {2}%">Min: {2}</span>
  <span class="max" style="width: {3}%">Max: {3}</span>
</li>)
  str.gsub!(/\{0\}/, row[0])
  str.gsub!(/\{1\}/, row[1])
  str.gsub!(/\{2\}/, row[2])
  str.gsub!(/\{3\}/, row[3])
end

rows = File.read('etc/temp_data.txt').split("\n").collect { |line| line.split("\t") }
output = File.open('etc/temp_data.html', 'w')
rows.each { |row| output << convert(row) }
output.close