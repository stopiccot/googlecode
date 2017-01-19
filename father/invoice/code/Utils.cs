using System;
using System.Collections.Generic;
using System.Text;

namespace Invoice
{
    //================================================================================
    // Utils
    //    Класс, содержащий всевозможные утилитные функции
    //================================================================================
    static class Utils
    {
        //================================================================================
        // ToStringWithoutZeroes
        //    Конвертит Version в строку добавляя Build и Revision только если они не ноль
        //================================================================================
        public static string ToStringWithoutZeroes(Version version)
        {
            StringBuilder builder = new StringBuilder(version.Major.ToString() + "." + version.Minor.ToString());

            if (version.Build != 0)
                builder.Append("." + version.Build.ToString());

            if (version.Revision != 0)
                builder.Append("." + version.Revision.ToString());

            return builder.ToString();
        }

        //================================================================================
        // Capitalize
        //    Делает первую букву в строке заглавной   
        //================================================================================
        public static string Capitalize(string s)
        {
            return s.Length > 1 ? (Char.ToUpper(s[0]) + s).Remove(1, 1) : s;
        }

        //================================================================================
        // IsUpper
        //================================================================================
        public static bool IsUpper(Char c)
        {
            return c == Char.ToUpper(c);
        }

        private static string[] coins = { "", "копейка", "копейки", "копеек" };
        private static string[] rub = { "рублей ", "рубль ", "рубля ", "рублей " };
        private static string[] thousand = { "", "тысяча ", "тысячи ", "тысяч " };
        private static string[] million = { "", "миллион ", "миллиона ", "миллионов " };
        private static string[] _100 = { "", "сто ", "двести ", "триста ", "четыреста ", "пятьсот ", "шестьсот ", "семьсот ", "восемьсот ", "девятьсот " };
        private static string[] _10 = { "", "", "двадцать ", "тридцать ", "сорок ", "пятьдесят ", "шестьдесят ", "семьдесят ", "восемьдесят ", "девяносто " };
        private static string[] _1 = { "три ", "четыре ", "пять ", "шесть ", "семь ", "восемь ", "девять ", "десять ", "одиннадцать ", "двенадцать ", "тринадцать ", "четырнадцать ", "пятнадцать ", "шестнадцать ", "семнадцать ", "восемнадцать ", "девятнадцать " };
        private static string[] __1 = { "", "один ", "два ", "", "одна ", "две " };
        private static byte[] _suffix = { 3, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 };

        private static string convert(long number, string[] suffix, bool sex)
        {
            string result = "";

            if (number == 0)
                return suffix[0];

            if (number > 99)
                result += _100[ number / 100 ];

            number = number % 100;
            if (number > 19)
            {
                result += _10[number / 10];
                number %= 10;
            }

            if (number > 2)
            {
                result += _1[number - 3];
            }
            else
            {
                result += __1[sex ? number : number + 3];
            }       
            
            return result + suffix[_suffix[number]];
        }
        
        public static string ConvertToString(long number)
        {
            return Capitalize(
                    convert(number / 1000000, million, true) +
                    convert((number / 1000) % 1000, thousand, false) +
                    convert(number % 1000, rub, true));
        }

        public static string ConvertToString(decimal number)
        {
            return Capitalize(
                    convert((long)(number / 1000000), million, true) +
                    convert((long)((number / 1000) % 1000), thousand, false) +
                    convert((long)(number % 1000), rub, true) + 
                    convert((long)(number * 100) % 100, coins, true)
            );
        }

        public static string ExtractDirectorName(string s)
        {

            for (int i = 0, prevSpace = 0; i < s.Length - 4; ++i)
            {
                if (s[i] == ' ')
                {
                    if (IsUpper(s[i + 1]) && s[i + 2] == '.' && IsUpper(s[i + 3]) && s[i + 4] == '.')
                        return s.Substring(prevSpace + 1, i - prevSpace + 4);
                    else
                        prevSpace = i;
                }
            }

            return "";
        }

        public static decimal ConvertToDecimal(string s)
        {
            try
            {
                return Convert.ToDecimal(s);
            }
            catch { }
            
            try
            {
                return Convert.ToDecimal(s.Replace(".", ","));
            }
            catch { }

            try
            {
                return Convert.ToDecimal(s.Replace(",", "."));
            }
            catch { }

            return 0;
        }
    }
}

