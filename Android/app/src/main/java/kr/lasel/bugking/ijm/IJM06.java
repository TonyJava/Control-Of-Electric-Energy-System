package kr.lasel.bugking.ijm;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by gwongimun on 2017. 10. 5..
 */

public class IJM06 extends AppCompatActivity {
    private static String TAG = "IJM06";
    private TextView mTextViewResult;
    private String askDBURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_askdb.php";
    private String CutURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_initcut.php";
    private TimerTask mTask;
    private Timer mTimer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ijm06);
        mTextViewResult = (TextView)findViewById(R.id.textView_main_result);
        InsertData task = new InsertData();
        task.execute(TAG, askDBURL);

    }

    public void btn_shutdown(View v){
        Toast.makeText(this, "컴퓨터 꺼버리기 테스트", Toast.LENGTH_SHORT).show();
        InsertData task = new InsertData();
        task.execute(TAG, CutURL);

        Handler mHandler = new Handler();
        mHandler.postDelayed(new Runnable()  {
            public void run() {
                InsertData task = new InsertData();
                task.execute(TAG, askDBURL);
            }
        }, 500);

        btn_refresh();
    }

    public void btn_refresh(View v){
        InsertData task = new InsertData();
        task.execute(TAG, askDBURL);
    }

    public void btn_refresh(){
        InsertData task = new InsertData();
        task.execute(TAG, askDBURL);
    }


    // 데이터 전송 php7
    class InsertData extends AsyncTask<String, Void, String> {
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressDialog = ProgressDialog.show(IJM06.this, "Please Wait", null, true, true);
        }


        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            progressDialog.dismiss();

            mTextViewResult.setText(result);

            Log.d(TAG, "POST response  - " + result);
        }


        @Override
        protected String doInBackground(String... params) {
            String table = (String)params[0];
            String serverURL = (String)params[1];

            String postParameters = "table=" + table;

            try {

                URL url = new URL(serverURL);
                HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();

                httpURLConnection.setReadTimeout(5000);
                httpURLConnection.setConnectTimeout(5000);
                httpURLConnection.setRequestMethod("POST");
                //httpURLConnection.setRequestProperty("content-type", "application/json");
                httpURLConnection.setDoInput(true);
                httpURLConnection.connect();


                OutputStream outputStream = httpURLConnection.getOutputStream();
                outputStream.write(postParameters.getBytes("UTF-8"));
                outputStream.flush();
                outputStream.close();


                int responseStatusCode = httpURLConnection.getResponseCode();
                Log.d(TAG, "POST response code - " + responseStatusCode);

                InputStream inputStream;
                if(responseStatusCode == HttpURLConnection.HTTP_OK) {
                    inputStream = httpURLConnection.getInputStream();
                }
                else{
                    inputStream = httpURLConnection.getErrorStream();
                }


                InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "UTF-8");
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                StringBuilder sb = new StringBuilder();
                String line = null;

                while((line = bufferedReader.readLine()) != null){
                    sb.append(line);
                }


                bufferedReader.close();
                return sb.toString();


            } catch (Exception e) {

                Log.d(TAG, "InsertData: Error ", e);

                return new String("Error: " + e.getMessage());
            }

        }
    }
}