using System;
using System.Collections.Generic;
using System.Windows.Forms;

//==============================================================
// 2.2.0 - 01.04.2022
// [+] Adding Bill.Price1
//
// 2.1.0 - 29.01.2017
// [+] Template from resources
// [+] Subprices
//
// 2.0.0 - 02.07.2016
// [+] BYN currency support
//
// 1.1.8 - 23.03.2015
// [*] Upgrading to .NET Framework 3.5
// [*] Minor text fixes
//
// 1.1.7 - xx.12.2014
// [*] Bugfix for opening in Word
// [+] Support for *.docx
// 
// 1.1.6 - 16.12.2014
// [*] Bugfix
//
// 1.1.5 - 16.12.2014
// [+] New highres icon
// [+] New Bill.workDone option
// [*] Changing update URL one more time
//
// 1.1.4 - 15.12.2014
// [*] New github update URL
//
// 1.1.3
// [*] Two new checkboxes in EditBillForm
//
// 1.1.2
// [*] Update url changed because of google code's cache too long update
//
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