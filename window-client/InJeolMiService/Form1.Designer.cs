namespace InJeolMiService
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btn_className = new System.Windows.Forms.Button();
            this.className = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(27, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(193, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "안녕하세요. 인절미 서비스입니다. ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(27, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(233, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "이 팝업창은 처음 실행시에만 작동합니다. ";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(28, 63);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(281, 12);
            this.label3.TabIndex = 3;
            this.label3.Text = "현재 작업 중이신 컴퓨터의 강의실을 입력해주세요.";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(28, 85);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(359, 12);
            this.label4.TabIndex = 5;
            this.label4.Text = "(예시: 6109, 6201, 3301, 3302, 나머지 문자는 입력되지 않습니다.)";
            // 
            // btn_className
            // 
            this.btn_className.Location = new System.Drawing.Point(234, 114);
            this.btn_className.Name = "btn_className";
            this.btn_className.Size = new System.Drawing.Size(75, 23);
            this.btn_className.TabIndex = 0;
            this.btn_className.Text = "확인";
            this.btn_className.UseVisualStyleBackColor = true;
            this.btn_className.Click += new System.EventHandler(this.btn_className_Click);
            // 
            // className
            // 
            this.className.Location = new System.Drawing.Point(30, 115);
            this.className.Name = "className";
            this.className.Size = new System.Drawing.Size(190, 21);
            this.className.TabIndex = 4;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(410, 160);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.className);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btn_className);
            this.Name = "Form1";
            this.Text = "인절미 서비스";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btn_className;
        private System.Windows.Forms.TextBox className;
    }
}

