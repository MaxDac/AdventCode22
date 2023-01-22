using AdventOfCode.Eleven;
using System.Linq;

Console.WriteLine("Hello, World!");

var monkeys = Data.GetData();

foreach (var monkey in monkeys)
{
    monkey.SetMonkeys(monkeys);
}

for (int i = 0; i < 10_000; i++)
{
    for (int j = 0; j < monkeys.Length; j++)
    {
        monkeys[j].PerformTurn();
    }
}

var points = 
    monkeys
        .Select(m => m.GetNumberOrInspection())
        .ToArray();

var betterTwo =
    points
        .OrderByDescending(x => x)
        .Take(2)
        .ToArray();

var result = betterTwo[0] * betterTwo[1];

Console.WriteLine($"Result: {result}");
