require 'rspec/expectations'

def run_ltk_with_input(*inputs)
  shell_output = ""
  IO.popen('./license_to_kill', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    regexp_string = expected.join(".*").gsub("?","\\?")
    input = actual.delete("\n")
    /#{regexp_string}/.match(input).should_not be_nil
  end
end
