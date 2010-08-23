using System;
using System.Collections.Generic;
using System.Windows.Forms;

//==============================================================
// 1.1.1
// [*] Small fix when Cancel button haven't worked in new bill dialog
//     when it was called second+ time
// [*] Fixed bug when priceComboBox in EditBillForm haven't updated it's
//     value for second+ time
//
// 1.1
// [*] Another fix in deletion. When I'll eventually write it without bugs?
// [*] Little fix with doc creation path
//
// 1.0.8
// [*] Small fix in new invoice creation
//
// 1.0.7
// [+] Update is made in BackgroundWorker due to high lag of
//     WebClient.DownloadStringAsync
// [*] Utls.cs refactored
//     UpFirstLetter -> Capitalize
//     new ToStringWithoutZeroes function
// [+] prevYear and currYear fields in SettingsForm
// [+] Deleting invoices rewritten once again with new SelectDateForm
// [*] Total MainForm.cs refactor with adding a lot of comments
// [*] MyListView is now BillListView
//
// 1.0.6
// [+] Updater added
//
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