defmodule InputTest do
  use ExUnit.Case

  # test "get_integer_correctly" do
  #   input = "1"
  #   result = Input.parse_line(input) |> IO.inspect() 
  #   assert result == [1]
  # end

  test "get_single_integer_array_correctly" do
    input = "[1]"
    result = Input.parse_line(input) |> IO.inspect() 
    assert result == [1]
  end

  test "get_empty_array_correctly" do
    input = "[]"
    assert Input.parse_line(input) == []
  end

  test "get_multiple_empty_array_correctly" do
    input = "[[]]"
    assert Input.parse_line(input) == [[]]
  end

  test "get_filled_array_correctly" do
    input = "[1,2,3,4,5]"
    assert Input.parse_line(input) == [1, 2, 3, 4, 5]
  end

  test "get_nested_array_correctly" do
    input = "[1,2,[3,4,5]]"
    assert Input.parse_line(input) == [1, 2, [3, 4, 5]]
  end

  test "get_nested_array_2_correctly" do
    input = "[[3,4,5]]"
    assert Input.parse_line(input) == [[3, 4, 5]]
  end

  test "get_nested_array_with_empty_array_correctly" do
    input = "[[3,4,5], [[]]]"
    assert Input.parse_line(input) == [[3, 4, 5], [[]]]
  end
end
