namespace AdventOfCode.Eleven;

public static class Extensions
{
    public static int Product(this IEnumerable<int> collection)
    {
        int product = 1;

        foreach (var item in collection)
        {
            product *= item;
        }

        return product;
    }
}