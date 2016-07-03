using System;
using System.Collections.Generic;
using System.Text;

namespace Invoice
{
    public class Bill
    {
        public Bill()
        {
            Payed = false;
            Date = DateTime.Now;
            WorkDone = 1;
            Number = (Base.billList.Count == 0 || Base.lastBill.Date.Month < Date.Month) ? 1 : Base.lastBill.Number + 1;
            Company = Company.nullCompany;
        }

        public void Add()
        {
            Base.billList.Add(this);
        }

        public Bill Copy()
        {
            return (Bill)MemberwiseClone();
        }

        public int Number;
        public int WorkDone;
        public decimal Price;
        public bool Payed;        
        public string Car;
        public Company Company;
        public DateTime Date;        
    }
}
