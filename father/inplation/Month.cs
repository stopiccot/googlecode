using System;
using System.Collections.Generic;
using System.Text;

namespace Inplation
{
    public struct Month
    {
        public DateTime FirstDay;
        public int Days;
        public string Name;

        public static Month LastMonth()
        {
            Month month = new Month();
            month.Name = "Последний месяц";
            month.FirstDay = DateTime.Now.AddDays(-29.0);
            month.Days = 30;
            return month;
        }

        public Month Previous()
        {
            Month month = new Month();
            if (this.FirstDay.Day == 1)
            {
                month.FirstDay = this.FirstDay.AddDays(-1.0);
                month.Days = month.FirstDay.Day;
                month.FirstDay = month.FirstDay.AddDays(-month.FirstDay.Day + 1);
            }
            else
            {
                month.FirstDay = this.FirstDay.AddDays(-this.FirstDay.Day + 1);
                month.Days = month.FirstDay.AddMonths(1).AddDays(-1.0).Day;
            }
            month.Name = month.FirstDay.ToString("MMMM yyyy");
            return month;
        }

        public Month Next()
        {
            if (this.FirstDay.AddMonths(1) > DateTime.Now.AddDays(-30.0))
                return LastMonth();
            else
            {
                Month month = new Month();
                month.FirstDay = this.FirstDay.AddMonths(1);
                month.Days = month.FirstDay.AddMonths(1).AddDays(-1.0).Day;
                month.Name = month.FirstDay.ToString("MMMM yyyy");
                return month;
            }
        }
    }
}
