require 'contest'

class Test::Unit::TestCase

  def assert_valid(data=@data, &blk)
    check = create_check(data, &blk)
    assert check.call
  end

  def assert_invalid(data=@data, &blk)
    check = create_check(data, &blk)
    assert !check.call
  end

  def create_check(data, &blk)
    check = self.check.new(data)
    blk.call(check) if blk
    check
  end

  module Headerize
    attr_accessor :headers
  end

  def to_json(data, headers={})
    body = Yajl::Encoder.encode(data)
    add_headers(body, headers)
  end

  def add_headers(o, headers={})
    o.extend Headerize
    o.headers = {}
    o.headers["Content-Type"] ||= "application/json"
    o.headers.merge!(headers)
    o
  end

  def stub(meth, o, returns)
    o.instance_eval { @returns = returns }
    eval <<-EVAL
    def o.#{meth}(*args)
      @returns
    end
    EVAL
  end

end