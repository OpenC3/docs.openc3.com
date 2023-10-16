def parse_file(filename, methods)
  File.open(filename) do |file|
    data = file.read
    lines = data.split("\n")
    # Check for our API indicator and strip out the excess
    if data.include?("START PUBLIC API")
      start = 0
      end_line = -1
      lines.each_with_index do |line, index|
        start = index if line.include?("START PUBLIC API")
        end_line = index if line.include?("END PUBLIC API")
      end
      lines = lines[start..end_line]
    end
    lines.each do |line|
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

ruby_api_methods = {}
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/lib/openc3/script/*.rb')].each do |filename|
  next if filename.include?('extract')
  next if filename.include?('web_socket_api')
  next if filename.include?('suite_results')
  next if filename.include?('suite_runner')
  next if filename.include?('script_runner')
  parse_file(filename, ruby_api_methods)
end
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/lib/openc3/api/*.rb')].each do |filename|
  parse_file(filename, ruby_api_methods)
end

python_api_methods = {}
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/python/openc3/script/*.py')].each do |filename|
  next if filename.include?('authorization')
  next if filename.include?('decorators')
  next if filename.include?('server_proxy')
  next if filename.include?('stream')
  next if filename.include?('suite_results')
  next if filename.include?('suite_runner')
  parse_file(filename, python_api_methods)
end
Dir[File.join(File.dirname(__FILE__),'../../cosmos/openc3/python/openc3/api/*.py')].each do |filename|
  parse_file(filename, python_api_methods)
end

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

exit_code = 0
deprecated = %w(require_utility get_all_target_info check_tolerance_raw wait_raw wait_check_raw wait_tolerance_raw wait_check_tolerance_raw)
deprecated += %w(tlm_variable play_wav_file status_bar)
deprecated += %w(method_missing self.included write puts) # shouldn't be included
deprecated += %w(get_cmd_cnts) # internal APIs
if (documented_methods - ruby_api_methods.keys - python_api_methods.keys).length > 0
  puts "Documented but doesn't exist:"
  puts documented_methods - ruby_api_methods.keys - python_api_methods.keys
  exit_code = -1
end
if (ruby_api_methods.keys - documented_methods - deprecated).length > 0
  puts "\nRuby exists but not documented:"
  puts ruby_api_methods.keys - documented_methods - deprecated
  exit_code = -1
end
if (python_api_methods.keys - documented_methods - deprecated).length > 0
  puts "\nPython exists but not documented:"
  puts python_api_methods.keys - documented_methods - deprecated
  exit_code = -1
end
ruby_api_massaged = []
ruby_api_methods.keys.each do |key|
  # Remove ? and ! from method names as python can't use them
  if key.include?('?') or key.include?('!')
    ruby_api_massaged << key[0..-2]
  else
    ruby_api_massaged << key
  end
end
if (ruby_api_massaged - python_api_methods.keys - deprecated).length > 0
  puts "\nRuby but not Python:"
  puts ruby_api_massaged - python_api_methods.keys - deprecated
  exit_code = -1
end
if (python_api_methods.keys - ruby_api_massaged).length > 0
  puts "\nPython but not Ruby:"
  puts python_api_methods.keys - ruby_api_massaged
  exit_code = -1
end
exit exit_code
