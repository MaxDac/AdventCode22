using System.Numerics;

namespace AdventOfCode.Eleven;

public class Monkey
{
    private const int ReliefConstant = 1;
    private List<BigInteger> items;
    private readonly Func<BigInteger, BigInteger> operation;
    private readonly Func<BigInteger, bool> test;
    private readonly int ifTrue;
    private readonly int ifFalse;
    private BigInteger numberOfInspection = 0;

    private Monkey[]? monkeys;

    public Monkey(
        BigInteger[] items,
        Func<BigInteger, BigInteger> operation,
        Func<BigInteger, bool> test,
        int ifTrue,
        int ifFalse
    )
    {
        this.items = new List<BigInteger>(items);
        this.operation = operation;
        this.test = test;
        this.ifTrue = ifTrue;
        this.ifFalse = ifFalse;
    }

    public void SetMonkeys(Monkey[] monkeys) =>
        this.monkeys = monkeys;

    public void PerformTurn()
    {
        if (this.monkeys == null)
        {
            throw new InvalidOperationException("No Monkeys");
        }

        foreach (var item in items)
        {
            var (receivingMonkey, worryLevel) = InspectItem(item);
            this.monkeys[receivingMonkey].ReceiveItem(worryLevel);
        }

        this.items = new List<BigInteger>();
    }

    public void ReceiveItem(BigInteger item)
    {
        this.items.Add(item);
    }

    private record struct InspectionResult(int ToMonkey, BigInteger WorryLevel);

    private InspectionResult InspectItem(BigInteger item)
    {
        this.numberOfInspection++;

        var newWorryLevel = this.operation(item);
        // double unflooredDivision = newWorryLevel / ReliefConstant;
        // var afterRelief = Convert.ToInt64(Math.Floor(unflooredDivision));
        var afterRelief = newWorryLevel;

        var receivingMonkey = 
            test(afterRelief)
                ? this.ifTrue
                : this.ifFalse;

        return new(receivingMonkey, afterRelief);
    }

    public BigInteger GetNumberOrInspection() => 
        this.numberOfInspection;
}
