using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace watch
{
    public partial class Form1 : Form
    {
        private System.Threading.Timer reduceOpacityTimer;
        private bool mouseIn = false;
        private Thread doTextThread;
        private Thread increaseOpacityThread;
        //private Thread reduceOpacityThread;


        private const double OPACITY_MIN = 0.05;



        public Form1()
        {
            InitializeComponent();

            dummy.Focus();//damit der cursor verschwindet

            Rectangle screen = Screen.PrimaryScreen.WorkingArea;
            Point point = new Point(screen.Width-this.Width,screen.Height-this.Height);


            this.Location = point;
            this.StartPosition = FormStartPosition.Manual;

            time.ForeColor = Color.White;
            //damit this.time.BeginInvoke(doText); funktioniert

            doTextThread = new Thread(delegate()
            {
                MethodInvoker doText = new MethodInvoker(delegate()
                {
                    if (mouseIn == true | Math.Round(this.Opacity,2) > OPACITY_MIN)
                    {

                        time.ForeColor = Color.Black;
                        
                        time.Text = DateTime.Now.ToString();

                        //time.ForeColor = Color.Black;
                    }
                    else
                    {
                        time.ForeColor = Color.White;
                        
                        time.Text = "";
                    }
                    //this.Text = this.Opacity.ToString();
                });


                while (this.IsHandleCreated == false) Thread.Sleep(100);

                while (true)
                {
                    
                    this.time.BeginInvoke(doText);
                    Thread.Sleep(100);
                }
            });
            doTextThread.Start();

        }

        private void time_MouseEnter(object sender, EventArgs e)
        {
            mouseIn = true;
            
            dummy.Focus();//damit der cursor verschwindet

            MethodInvoker increaseOpacity = new MethodInvoker(delegate()
            {
                this.Opacity += 0.05;
                time.Text = DateTime.Now.ToString();
                this.Text = DateTime.Now.DayOfWeek.ToString().ToLower();
            });

            increaseOpacityThread = new Thread(delegate()
                {
                    while (this.Opacity < 1)
                    {
                        this.time.Invoke(increaseOpacity);
                        Thread.Sleep(25);
                    }
                });
            increaseOpacityThread.Start();
        }

        private void time_MouseLeave(object sender, EventArgs e)
        {
            mouseIn = false;
            //mouseWasIn = false;
            if (reduceOpacityTimer != null)
            {
                reduceOpacityTimer.Change(2000,System.Threading.Timeout.Infinite);
            }
            else
            {
                reduceOpacityTimer = new System.Threading.Timer(doTimer,null,2000,System.Threading.Timeout.Infinite);
            }
        }

        private void doTimer(object o)
        {
            MethodInvoker reduceOpacity = new MethodInvoker(delegate()
            {
                this.Opacity -= 0.05;
            });




            while (Math.Round(this.Opacity,2) > OPACITY_MIN & mouseIn == false)
            {   
                
                this.time.Invoke(reduceOpacity);
                Thread.Sleep(50);
            }
            //mouseWasIn = false;
        }

        private void time_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            Clipboard.SetText(time.Text.Split(' ')[0]);
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            try{ doTextThread.Abort(); }
            catch (Exception) { }

            try { reduceOpacityTimer.Dispose(); }
            catch (Exception) { }

            try { increaseOpacityThread.Abort(); }
            catch (Exception) { }


        }
    }
}
