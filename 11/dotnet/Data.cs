using System.Numerics;

namespace AdventOfCode.Eleven;

public static class Data
{
    public static Monkey[] GetTestData() =>
        new Monkey[]
        {
            // Monkey 0
            new Monkey(
                new BigInteger[] {79, 98},
                x => x * 19,
                x => x % 23 == 0,
                ifTrue: 2,
                ifFalse: 3
            ),

            // Monkey 1
            new Monkey(
                new BigInteger[] {54, 65, 75, 74},
                x => x + 6,
                x => x % 19 == 0,
                ifTrue: 2,
                ifFalse: 0
            ),

            // Monkey 2
            new Monkey(
                new BigInteger[] {79, 60, 97},
                x => x * x,
                x => x % 13 == 0,
                ifTrue: 1,
                ifFalse: 3
            ),

            // Monkey 3
            new Monkey(
                new BigInteger[] {74},
                x => x + 3,
                x => x % 17 == 0,
                ifTrue: 0,
                ifFalse: 1
            ),
        };

    public static Monkey[] GetData() => 
        new Monkey[]
        {
            // Monkey 0
            new Monkey(
                new BigInteger[] { 73, 77 },
                x => x * 5,
                x => x % 11 == 0,
                ifTrue: 6,
                ifFalse: 5
            ),

            // Monkey 1
            new Monkey(
                new BigInteger[] { 57, 88, 80 },
                x => x + 5,
                x => x % 19 == 0,
                ifTrue: 6,
                ifFalse: 0
            ),

            // Monkey 2
            new Monkey(
                new BigInteger[] { 61, 81, 84, 69, 77, 88 },
                x => x * 19,
                x => x % 5 == 0,
                ifTrue: 3,
                ifFalse: 1
            ),

            // Monkey 3
            new Monkey(
                new BigInteger[] { 78, 89, 71, 60, 81, 84, 87, 75 },
                x => x + 7,
                x => x % 3 == 0,
                ifTrue: 1,
                ifFalse: 0
            ),

            // Monkey 4
            new Monkey(
                new BigInteger[] { 60, 76, 90, 63, 86, 87, 89 },
                x => x + 2,
                x => x % 13 == 0,
                ifTrue: 2,
                ifFalse: 7
            ),

            // Monkey 5
            new Monkey(
                new BigInteger[] { 88 },
                x => x + 1,
                x => x % 17 == 0,
                ifTrue: 4,
                ifFalse: 7
            ),

            // Monkey 6
            new Monkey(
                new BigInteger[] { 84, 98, 78, 85 },
                x => x + x,
                x => x % 7 == 0,
                ifTrue: 5,
                ifFalse: 4
            ),

            // Monkey 7
            new Monkey(
                new BigInteger[] { 98, 89, 78, 73, 71 },
                x => x + 4,
                x => x % 2 == 0,
                ifTrue: 3,
                ifFalse: 2
            ),
        };
}