require 'xmlrpc/client'

def symbolize_keys(hash)
  sym_hash = {}
  hash.each do |k, v|
      sym_hash[k.to_sym] = v
  end
  sym_hash
end

class RpcClient < XMLRPC::Client
  def call(*args)
    res = super(*args)
    symbolize_keys res
  end
end
