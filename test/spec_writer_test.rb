require 'test_helper'

class SpecWriterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SpecWriter::VERSION
  end
end
