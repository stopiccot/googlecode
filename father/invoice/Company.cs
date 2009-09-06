using System;
using System.Collections.Generic;
using System.Text;

namespace Invoice
{
    public struct Company
    {
        public static Company nullCompany;

        static Company()
        {
            nullCompany.ContractDate = DateTime.Parse("10.08.2008");
        }

        public static Company NewCompany()
        {
            Company Result;
            Result.ShortName = "Компания"; 
            Result.FullName  = Result.Director = Result.ContractNumber = "";
            Result.ContractDate = DateTime.Now;
            Base.companyList.Add(Result);
            return Result;
        }
        
        public string ShortName;
        public string FullName;
        public string Director;
        public string ContractNumber;
        public DateTime ContractDate;
    }
}
