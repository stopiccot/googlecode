using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Stopiccot.VisualComponents;

namespace counter
{
    public partial class MainForm : Stopiccot.SavePositionForm
    {
        public MainForm()
        {
            InitializeComponent();
            Base.Load();
            this.Position = Base.formPosition;
            myPanel.Minimized = Base.panelMinimized;
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            Base.formPosition = this.Position;
            Base.panelMinimized = myPanel.Minimized;
            Base.Save();
        } 

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            noOutRB.Enabled = registrationDate.Enabled = noInRB.Checked;

            if (!noInRB.Checked)
            {
                registrationDate.Value = crashDate.Value;
                noOutRB.Checked = false;
            }
        }

        private void noOutRB_CheckedChanged(object sender, EventArgs e)
        {
            if (noOutRB.Checked)
                registrationDate.Value = createDate.Value;
        }

        private void MainForm_Shown(object sender, EventArgs e)
        {
            createDate.Value = new DateTime(DateTime.Now.Year, 7, 1);

            #region Fill Grids

            Font boldFont = new Font("Tahoma", 8.25F, FontStyle.Bold, GraphicsUnit.Point, ((byte)(204)));

            outputGrid.Items.AddRange(new OutputGridItem[] {
                new OutputGridItem( 
                    new string[] { "Срок эксплуатации", "" }),
                new OutputGridItem(
                    new string[] { "Срок эксплуатации зарубежом", "" }),
                new OutputGridItem(
                    new string[] { "Срок эксплуатации в РБ", "" }),
                new OutputGridItem(
                    new string[] { "Расчётный пробег", "" }, false),
                new OutputGridItem(
                    new string[] { "Среднестатический пробег", "" }),
                new OutputGridItem(
                    new string[] { "Перепробег\\Недопробег", "" }),
                new OutputGridItem(
                    new string[] { "Скорректированный пробег", "" }, true),
                new OutputGridItem(
                    new string[] { "Износ частей", "" }) });

            outputGrid.Items[0].Font = 
            outputGrid.Items[3].Font =
            outputGrid.Items[6].Font = boldFont;

            outputGrid.Items[0].FontColor =
            outputGrid.Items[3].FontColor =
            outputGrid.Items[6].FontColor = Color.DarkRed;              

            infoGrid.Columns = new int[] { 80, 70, 80, 90 };

            infoGrid.Items.AddRange(new OutputGridItem[] {
                new OutputGridItem(
                    new string[] {"Марка","Части, %","Сис. без., %","Двигатель, %","КПП, %"} ),
                new OutputGridItem(
                    new string[] {"Volkswagen", "27", "30", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"Audi", "24", "30", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"Ford", "17", "30", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"Mercedes", "27", "30", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"Opel", "23", "24", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"BMW", "9", "16", "11", "18" } ),
                new OutputGridItem(
                    new string[] {"Mazda", "8", "0", "10", "30" } ),
                new OutputGridItem(
                    new string[] {"Peugeot", "4", "2", "9", "26" } ),
                new OutputGridItem(
                    new string[] {"Honda", "6", "10", "30", "30" } ),
                new OutputGridItem(
                    new string[] {"Другие", "30", "30", "30", "30" } )
            });

            #endregion
        }

        private int getDays(DateTime d)
        {
            int[] daysInMounth = new int[] { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

            int s = d.Day;

            for (int i = 0; i < d.Month - 1; i++)
                s += daysInMounth[i];

            return s;
        }

        private double f(DateTime d1, DateTime d2)
        {
            int dd = getDays(d1) - getDays(d2);
            double d = dd / 365.0;
            return (double)(d1.Year - d2.Year) + d;
        }

        private int[] eurotax = new int[] { 9500, 11000, 12800, 15200, 16700, 18500, 20300 };
        private double yearsDouble, yearsInRB, yearsOutRB;
        private int yearsInt, Run, staticRun, overRun, correctedRun;

        private void setPartsWear()
        {
            int R = outputGrid.Items[3].Checked ? Run : correctedRun;
            
            outputGrid.Items[7].SubItems[1] =
                Base.partsWear[Math.Min((R + 2500) / 5000, 70)][Math.Min(yearsInt, 20)] + " %";
        }

        private void countButton_Click(object sender, EventArgs e)
        {
            yearsDouble = f(crashDate.Value, createDate.Value);
            yearsInt = (int)(yearsDouble + 0.5);

            yearsOutRB = f(registrationDate.Value, createDate.Value);
            yearsInRB = f(crashDate.Value, registrationDate.Value);

            Run = (int)(yearsOutRB * eurotax[categoryChooser.SelctedIndex] + yearsInRB * 13500);
            staticRun = yearsInt * eurotax[categoryChooser.SelctedIndex];
            overRun = odometr.Value - staticRun;
            correctedRun = yearsInt * 13500 + overRun;

            #region outputGrid
            outputGrid.Items[0].SubItems[1] = yearsDouble.ToString("0.000") + " лет";
            outputGrid.Items[1].SubItems[1] = yearsOutRB.ToString("0.000") + " лет";
            outputGrid.Items[2].SubItems[1] = yearsInRB.ToString("0.000") + " лет";
            outputGrid.Items[3].SubItems[1] = Run.ToString() + " км";      
            outputGrid.Items[4].SubItems[1] = staticRun.ToString() + " км";
            outputGrid.Items[5].SubItems[0] = overRun >= 0 ? "Перепробег" : "Недопробег";
            outputGrid.Items[5].SubItems[1] = Math.Abs(overRun).ToString() + " км";
            outputGrid.Items[6].SubItems[1] = correctedRun.ToString() + " км";
            #endregion

            outputGrid.Items[3].Checked = !(outputGrid.Items[6].Checked = correctedRun >= Run);

            setPartsWear();
            outputGrid.Refresh();
        }

        private void outputGrid_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            int n = e.Index == 6 ? 3 : 6;
            outputGrid.Items[n].Checked = !outputGrid.Items[n].Checked;            
        }

        private void myPanel_Resize(object sender, EventArgs e)
        {
            int n = myPanel.Height + myPanel.Top + 40;
            int m = countButton.Top + countButton.Height + 40;
            this.Height = n > m ? n : m; 
        }

        private void outputGrid_ItemChecked()
        {
            setPartsWear();
        }               
    }
}
