using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Office.Interop.Word;

namespace Invoice
{
    static class Word
    {
        private static ApplicationClass wordApplication;
        private static Document document;
        private static object Null;
        private static object True;
        private static object False;

        private static void Reset()
        {
            Null = System.Reflection.Missing.Value;
            True = true;
            False = false;
            if (wordApplication == null) StartWord();
        }

        private static void StartWord()
        {
            wordApplication = new ApplicationClass();
            wordApplication.Visible = false;
            wordApplication.WindowState = WdWindowState.wdWindowStateMaximize;
        }

        static Word()
        {
            document = null; 
        }

        public static void OpenDocument(string fileToOpen, bool readOnly)
        {
            if (document != null) CloseDocument();
            
            object File = fileToOpen;
            object ReadOnly = readOnly;

            Reset();

            try
            {
                document = wordApplication.Documents.Open(ref File,
                    ref Null, ref ReadOnly, ref Null, ref Null, ref Null,
                    ref Null, ref Null, ref Null, ref Null, ref Null,
                    ref Null, ref Null, ref Null, ref Null);                
            }
            catch (System.Runtime.InteropServices.COMException e)
            {
                switch ((uint)e.ErrorCode)
                {
                    case 0x800706BA: 
                    // Word seems to be closed outside application.
                    // Restart it and try once again.
                    {
                        StartWord();
                        OpenDocument(fileToOpen, readOnly);
                        break;
                    }
                }
            }
        }

        public static void Replace(string oldString, string newString)
        {
            Reset();
            wordApplication.Selection.Find.Replacement.ClearFormatting();
            wordApplication.Selection.Find.Replacement.Text = newString;

            object Replace = Microsoft.Office.Interop.Word.WdReplace.wdReplaceAll;
            object OldStr = oldString;

            wordApplication.Selection.Find.Execute(ref OldStr, ref True, ref True, 
                ref False, ref False, ref False, ref True, ref False, ref False,
                ref Null, ref Replace, ref False, ref False,
                ref False, ref False);
        }

        public static void SaveAs(string fileToSave)
        {
            Reset();
            object file = fileToSave;
            try
            {
                document.SaveAs(ref file, ref Null, ref Null, ref Null, ref Null, ref Null, 
                    ref Null, ref Null, ref Null, ref Null, ref Null, ref Null, ref Null,
                    ref Null, ref Null, ref Null);
            }
            catch (System.Runtime.InteropServices.COMException e)
            {
                switch ((uint)e.ErrorCode)
                {
                    case 0x800A14EC: 
                    // File is already opened by some application so
                    // we can't save it. Send notification to user.
                    {
                        //System.Windows.Forms.MessageBox.Show("Нель");
                        break;
                    }
                }
            }
        }

        public static void PrintDocument()
        {
            if ( document != null )
                try
                {
                    Reset();
                    document.PrintOut(ref True, ref Null, ref Null, ref Null, ref Null, ref Null,
                        ref Null, ref Null, ref Null, ref Null, ref Null, ref Null, ref Null,
                        ref Null, ref Null, ref Null, ref Null, ref Null);
                }
                catch //(System.Runtime.InteropServices.COMException e)
                {
                    //...
                }
        }

        public static void CloseDocument()
        {
            if ( document != null )
                try
                {
                    Reset();
                    document.Close(ref Null, ref Null, ref Null);
                }
                catch //(System.Runtime.InteropServices.COMException e)
                {
                    return;
                }
            
            document = null;
        }

        public static void Close()
        {
            if (wordApplication != null)
                try
                {
                    Reset();
                    wordApplication.Quit(ref Null, ref Null, ref Null);
                }
                catch (System.Runtime.InteropServices.COMException e)
                {
                    switch ((uint)e.ErrorCode)
                    {
                        case 0x800706BA:
                        // Word seems to be closed outside application.
                        // So it is no need to close it
                            break;                    
                    }
                }
        }
   }
}
