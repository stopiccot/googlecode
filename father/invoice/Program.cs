using System;
using System.Collections.Generic;
using System.Windows.Forms;

//==============================================================
// 1.0.5
// [+] Deleting invoices rewritten from scratch
// [*] SettingsForm design slightly changed
// [*] EditBillForm priceComboBox and billCompany maxDropDown is now 20
// [-] MainForm menuStrip removed
// [*] NumberComboBox.cs Paste bug fixed
// [?] So many changes that I decided to skip 1.0.4 version :)
//
// 1.0.3
// [*] Utils.cs - fixed small bug in ConvertToString 
// [*] MainForm.cs - change text in deletePayed notification
// [*] "Bookeep" namespace renamed to "Invoice"
//
// 1.0.2 - 1.0.1
// [*] Some fixes
//
// 1.0.0
// [+] Initial release
//==============================================================
namespace Invoice
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}