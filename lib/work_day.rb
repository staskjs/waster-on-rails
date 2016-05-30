class WorkDay < Hash
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::MethodAccess
end
