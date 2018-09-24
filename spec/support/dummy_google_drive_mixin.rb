module DummyGoogleDriveMixin
  class NullNull
    def method_missing(x, y)
      nil
    end
  end

  def session
    NullNull.new
  end
end
