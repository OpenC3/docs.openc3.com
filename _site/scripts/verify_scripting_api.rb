def parse_file(filename, methods)
  File.open(filename) do |file|
    file.each do |line|
      if line.strip =~ /^def /
        next if line.include?('def _')
        next if line.include?('initialize')
        method = line.strip.split(' ')[1]
        if method.include?('(')
          methods[method.split('(')[0]] = filename
        else
          methods[method] = filename
        end
      end
    end
  end
end

api_methods = {}
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/lib/openc3/script/*.rb')].each do |filename|
  next if filename.include?('extract')
  parse_file(filename, api_methods)
end
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/lib/openc3/api/*.rb')].each do |filename|
  parse_file(filename, api_methods)
end
# api_methods.uniq!

documented_methods = []
File.open(File.join(File.dirname(__FILE__),'../_docs_v5/4_guides/scripting_api.md')) do |file|
  apis = false
  file.each do |line|
    if line.strip.include?('###')
      if line.include?("Migration")
        apis = true
        next
      end
      next unless apis
      line = line.strip[4..-1]
      # Split off comments like '(since 5.0.0)'
      line = line.split('(')[0].strip if line.include?('(')
      if line.include?(",") # Split lines like '### check, check_raw'
        line.split(',').each do |method|
          documented_methods << method.strip
        end
      else
        documented_methods << line
      end
    end
  end
end
documented_methods.uniq!

DEPRECATED = %w(require_utility get_all_target_info check_tolerance_raw wait_raw wait_check_raw wait_tolerance_raw wait_check_tolerance_raw)
puts "Documented but doesn't exist:"
puts documented_methods - api_methods.keys
puts "\nExists but not documented:"
puts api_methods.keys - documented_methods - DEPRECATED
