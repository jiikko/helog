module Logging
  def log(txt)
    if ENV["DEBUG"]
      puts txt
    end
  end
end
