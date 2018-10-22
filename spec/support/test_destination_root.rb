module TestDestinationRoot
  def initialize(*args)
    super(*args)

    self.destination_root = File.expand_path('../tmp', __dir__)
  end
end
