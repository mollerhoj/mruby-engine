require "arbitrary"
require "bigdecimal"
require "bigdecimal/util"
require "mruby_engine"
require "property"
require "spec_helper"

describe "Decimal" do
  include EngineSpecHelper
  include PropertyTesting
  using Arbitrary

  def reasonable_memory_quota
    8 * MEGABYTE
  end

  let(:engine) { make_test_engine }

  def eval_test(source)
    engine.sandbox_eval("test.rb", source)
  end

  describe :json do

    it "hashes" do
      eval_test(<<-SOURCE)
        assert(JSON.generate({'a' => ['c', 2.3]}) != '{"a":"b"}', "hashes not the same")

        assert(JSON.generate({'a' => ['b', 2.3]}) == '{"a":["b",2.3]}', "hashes are the same")
      SOURCE
    end


    it "json parse error" do
      eval_test(<<-SOURCE)
        assert_raises(JSON::ParserError, "invalid json") { JSON.parse("{2}") }
      SOURCE
    end

    it "float" do
      eval_test(<<-SOURCE)
        assert_equal("3.8245728934572", JSON.generate(3.8245728934572)) do
        end
      SOURCE
    end
  end
end
