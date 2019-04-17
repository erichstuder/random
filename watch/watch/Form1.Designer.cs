namespace watch
{
    partial class Form1
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.time = new System.Windows.Forms.TextBox();
            this.dummy = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // time
            // 
            this.time.BackColor = System.Drawing.SystemColors.Window;
            this.time.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.time.Font = new System.Drawing.Font("Kristen ITC", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.time.Location = new System.Drawing.Point(-2, 0);
            this.time.Name = "time";
            this.time.ReadOnly = true;
            this.time.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.time.Size = new System.Drawing.Size(127, 25);
            this.time.TabIndex = 0;
            this.time.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.time.MouseLeave += new System.EventHandler(this.time_MouseLeave);
            this.time.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.time_MouseDoubleClick);
            this.time.MouseEnter += new System.EventHandler(this.time_MouseEnter);
            // 
            // dummy
            // 
            this.dummy.Location = new System.Drawing.Point(-2, 26);
            this.dummy.Name = "dummy";
            this.dummy.Size = new System.Drawing.Size(100, 20);
            this.dummy.TabIndex = 1;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(124, 23);
            this.Controls.Add(this.dummy);
            this.Controls.Add(this.time);
            this.MaximumSize = new System.Drawing.Size(132, 57);
            this.MinimumSize = new System.Drawing.Size(132, 57);
            this.Name = "Form1";
            this.Opacity = 0.2;
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.TopMost = true;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox time;
        private System.Windows.Forms.TextBox dummy;


    }
}

