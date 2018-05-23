using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;

namespace InJeolMiService
{
    public partial class Form1 : Form
    {
        static string macAddress;
        static string server = "http://bug.lasel.kr/injeolmi/client/";
        static string askExist = server + "askExist.php";
        static string insertAddress = server + "insertAddress.php";
        static string updateState = server + "updateState.php";
        static string updateShutdown = server + "updateShutdown.php";
       
        Timer myTimer = new Timer();

        public Form1()
        {

            if (!autoStart())
            {
                return;
            }
            //while (true)
            //{
            //    if (IsInternetConnected())
            //    {
            //        MessageBox.Show("인터넷이 연결되어 있습니다.");
            //        break;
            //    }
            //    else
            //    {
            //        MessageBox.Show("연결이 안되어 있어요.");
            //        System.Threading.Thread.Sleep(5000);
            //    }
            //}
            
            macAddress = NetworkInterface.GetAllNetworkInterfaces()[0].GetPhysicalAddress().ToString();
            string resultAskExist = connect(askExist);
            string[] resultExist = resultAskExist.Split('&');

            if (resultExist[0].Equals("200")) { 
                // 처음 시작      
                InitializeComponent();
            }
            else if (resultExist[0].Equals("306"))
            {
                // 재접속
                InitializeComponent();
                Opacity = 0;
                ShowInTaskbar = false;
                string result = connect(updateShutdown, 1);
                if (result.Equals("200"))
                {
                    // 5초마다 CheckStatus를 진행한다.
                    timerSet();
                } else
                {
                    MessageBox.Show("인터넷 연결상태가 불안정합니다.");
                    return;
                }
            }
            else
            {
                MessageBox.Show("인터넷 연결상태가 불안정");
                return;
            }
        }

        

        private void btn_className_Click(object sender, EventArgs e)
        {
            // 처음 실행 시 작동
            string location = className.Text.ToString();
            string resultinsertMac = connect(insertAddress, 1, location);
            string[] resultInsert = resultinsertMac.Split('&');
            if (resultInsert[0].Equals("200"))
            {
                // 업데이트 성공 시
                Opacity = 0;
                ShowInTaskbar = false;

                // 5초마다 CheckStatus를 진행한다.
                timerSet();
            }
            else
            {
                // 업데이트 실패 및 오류처리
                MessageBox.Show(resultinsertMac);
                return;
            }
        }

        public void shutdown()
        {
            myTimer.Stop();
            // 컴퓨터가 종료될거같으면 팝업창을 띄워서 취소시킬수 있는 메뉴를 보여준다.
            Process.Start("shutdown.exe", "-s -t 120");
            string resultUpdateState = connect(updateState, 0);
            DialogResult resultShutdown = MessageBox.Show("120초 후에 컴퓨터가 자동 종료됩니다. 취소하시겠습니까?", "인절미 서비스", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
            // state = 0으로 변경 
            if (resultShutdown == DialogResult.Yes)
            {
                // state 와 shutdown을 모두 1로 바꿔야해 
                Process.Start("shutdown.exe", "-a");
                string result = connect(updateShutdown, 1);
                
                if (result.Equals("200"))
                {
                    // 5초마다 CheckStatus를 진행한다.
                    myTimer.Start();
                }
                else
                {
                    //실패시 디비 shutdown을 3으로 변경하자 
                    connect(updateState, 3);
                    MessageBox.Show("프로그램 오류가 발생했습니다.");
                }
            }
        }

        public void timerSet()
        {
            myTimer.Interval = 5000;
            myTimer.Tick += new EventHandler(CheckStatus);
            myTimer.Enabled = true;
        }

        private void CheckStatus(object sender, EventArgs e)
        {
            string resultUpdateState = connect(updateState, 1);
            if (resultUpdateState.Equals("202"))
            {
                shutdown();
            }
        }

        static public string connect(string url, int state = 1, string location = "")
        {
            while (true)
            {
                if (IsInternetConnected())
                {
                    //MessageBox.Show("인터넷이 연결되어 있습니다.");
                    break;
                }
                else
                {
                    //MessageBox.Show("연결이 안되어 있어요.");
                    System.Threading.Thread.Sleep(5000);
                }
            }

            try
            {
                string str_sendvalue = "macAddress=" + macAddress + "&state=" + state + "&location=" + location;
                HttpWebRequest hwr = (HttpWebRequest)WebRequest.Create(url); // 객체를 생성한다.
                hwr.Method = "POST"; // 포스트 방식으로 전달
                hwr.ContentType = @"application/x-www-form-urlencoded";
                byte[] buffer = Encoding.Default.GetBytes(str_sendvalue);
                hwr.ContentLength = buffer.Length;
                Stream sendStream = hwr.GetRequestStream(); // sendStream 을 생성한다.
                sendStream.Write(buffer, 0, buffer.Length); // 데이터를 전송한다.34e
                sendStream.Close(); // sendStream 을 종료한다.

                HttpWebResponse wRespFirst = (HttpWebResponse)hwr.GetResponse();

                // Response의 결과를 스트림을 생성합니다.
                Stream respPostStream = wRespFirst.GetResponseStream();
                StreamReader readerPost = new StreamReader(respPostStream, Encoding.Default);

                // 생성한 스트림으로부터 string으로 변환합니다.
                string resultPost = readerPost.ReadToEnd();
                Console.WriteLine(resultPost);
                        
                return resultPost;
            }
            catch (Exception e)
            {
                MessageBox.Show(e.ToString());
                return "500";
            }
        }

        static public bool IsInternetConnected()
        {
            const string NCSI_TEST_URL = "http://www.msftncsi.com/ncsi.txt";
            const string NCSI_TEST_RESULT = "Microsoft NCSI";
            const string NCSI_DNS = "dns.msftncsi.com";
            const string NCSI_DNS_IP_ADDRESS = "131.107.255.255";

            try
            {
                // Check NCSI test link
                var webClient = new WebClient();
                string result = webClient.DownloadString(NCSI_TEST_URL);
                if (result != NCSI_TEST_RESULT)
                {
                    return false;
                }

                // Check NCSI DNS IP
                var dnsHost = Dns.GetHostEntry(NCSI_DNS);
                if (dnsHost.AddressList.Count() < 0 || dnsHost.AddressList[0].ToString() != NCSI_DNS_IP_ADDRESS)
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
                return false;
            }

            return true;
        }

        private static DateTime Delay(int MS)
        {
            DateTime ThisMoment = DateTime.Now;
            TimeSpan duration = new TimeSpan(0, 0, 0, 0, MS);
            DateTime AfterWards = ThisMoment.Add(duration);

            while (AfterWards >= ThisMoment)
            {
                System.Windows.Forms.Application.DoEvents();
                ThisMoment = DateTime.Now;
            }

            return DateTime.Now;
        }

        public bool autoStart()
        {
            try
            {
                RegistryKey strUpKey = Registry.CurrentUser.OpenSubKey(
                                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                if (strUpKey.GetValue("InJeolMiService") == null)
                {
                    strUpKey.Close();
                    strUpKey = Registry.CurrentUser.OpenSubKey(
                                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                    strUpKey.SetValue("InJeolMiService", Application.ExecutablePath.ToString());
                    //strUpKey.DeleteValue("InJeolMiService");
                    
                }
                return true;
            }
            catch
            {
                MessageBox.Show("프로그램 오류가 발생했습니다. 프로그램을 삭제후 다시 설치해 주세요.");
                return false;
            }
        }
    }
}
