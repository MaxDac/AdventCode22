defmodule CalcTest do
  use ExUnit.Case
  doctest Calc
  
  setup do
    data = [
      %{step: 1, valve_name: "AA", pressure: 0, releasing: false},
      %{step: 2, valve_name: "DD", pressure: 20, releasing: true},
      %{step: 3, valve_name: "DD", pressure: 20, releasing: false}, # 20 # 20
      %{step: 4, valve_name: "CC", pressure: 2, releasing: false}, # 20 # 40
      %{step: 5, valve_name: "BB", pressure: 13, releasing: true}, # 20 # 60
      %{step: 6, valve_name: "BB", pressure: 13, releasing: false}, # 33 # 93
      %{step: 7, valve_name: "AA", pressure: 0, releasing: false}, # 33 # 126
      %{step: 8, valve_name: "II", pressure: 0, releasing: false}, # 33 # 159
      %{step: 9, valve_name: "JJ", pressure: 21, releasing: true}, # 33 # 192
      %{step: 10, valve_name: "JJ", pressure: 21, releasing: false}, # 54 # 246
      %{step: 11, valve_name: "II", pressure: 0, releasing: false}, # 54 # 300
      %{step: 12, valve_name: "AA", pressure: 0, releasing: false}, # 54 # 354
      %{step: 13, valve_name: "DD", pressure: 20, releasing: false}, # 54 # 408
      %{step: 14, valve_name: "EE", pressure: 3, releasing: false}, # 54 # 462
      %{step: 15, valve_name: "FF", pressure: 0, releasing: false}, # 54 # 516
      %{step: 16, valve_name: "GG", pressure: 0, releasing: false}, # 54 # 570
      %{step: 17, valve_name: "HH", pressure: 22, releasing: true}, # 54 # 624
      %{step: 18, valve_name: "HH", pressure: 22, releasing: false}, # 76 # 700
      %{step: 19, valve_name: "GG", pressure: 0, releasing: false}, # 76 # 776
      %{step: 20, valve_name: "FF", pressure: 0, releasing: false}, # 76 # 852
      %{step: 21, valve_name: "EE", pressure: 3, releasing: true}, # 76 # 928
      %{step: 22, valve_name: "EE", pressure: 3, releasing: false}, # 79 # 1007
      %{step: 23, valve_name: "DD", pressure: 0, releasing: false}, # 79 # 1086
      %{step: 24, valve_name: "CC", pressure: 2, releasing: true}, # 79 # 1165
      %{step: 25, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1246
      %{step: 26, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1327
      %{step: 27, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1408
      %{step: 28, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1489
      %{step: 29, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1570
      %{step: 30, valve_name: "CC", pressure: 2, releasing: false}, # 81 # 1651
    ]

    [data: data]
  end

  test "computation of result succeeds", %{data: data} do
    {result, path} = PathComputation.compute_released(data, data)
    assert path == data
    assert result == 1651
  end

  test "test input succeeds", %{data: data} do
    {result, path} = Calc.compute()
    assert result == 1651
    assert path == data
  end
end
