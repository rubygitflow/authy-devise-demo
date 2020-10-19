module Auxiliary

  def random_string(length = 8)
    rand(32**length).to_s(32)
  end

end
