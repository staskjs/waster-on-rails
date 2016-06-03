class WorkDay < Hash
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::MethodAccess

  def check_out
    intervals.last.update_attributes(time_out: Time.now)
  end
end
