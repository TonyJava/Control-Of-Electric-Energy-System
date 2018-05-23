package kr.lasel.bugking.ijm;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by gwongimun on 2017. 9. 29..
 */

public class Registration extends AppCompatActivity {
    private static String TAG = "Registration";

    private EditText et_id, et_pw, et_pw_chk;
    private String sId, sPw, sPw_chk;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration);

        et_id = (EditText) findViewById(R.id.et_Id);
        et_pw = (EditText) findViewById(R.id.et_Password);
        et_pw_chk = (EditText) findViewById(R.id.et_Password_chk);
    }

    //회원 가입시 작동
    public void btn_registration(View v){
        sId = et_id.getText().toString();
        sPw = et_pw.getText().toString();
        sPw_chk = et_pw_chk.getText().toString();

        if(sId.isEmpty() || sPw.isEmpty() || sPw_chk.isEmpty()){
            Toast.makeText(this, "회원정보를 입력해주세요.", Toast.LENGTH_SHORT).show();

        } else{
            if(sPw.equals(sPw_chk))
            {
                InsertData task = new InsertData();
                task.execute(sId, sPw);

                // 공백처리
                et_id.setText("");
                et_pw.setText("");
                et_pw_chk.setText("");
            }
            else
            {
            /* 패스워드 확인이 불일치 함 또 아이디가 중복되면 안된다고 해야해*/
                Toast.makeText(this, "비밀번호를 다시 확인해주세요.", Toast.LENGTH_SHORT).show();
                et_pw.setText("");
                et_pw_chk.setText("");
            }
        }
    }

    class InsertData extends AsyncTask<String, Void, String>{
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressDialog = ProgressDialog.show(Registration.this, "Please Wait", null, true, true);
        }


        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            progressDialog.dismiss();

            // php결과가 0000이면 성공
            if(result.equals("[연결성공]0000")){
                Toast.makeText(Registration.this, "회원가입을 축하합니다.", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(Registration.this, kr.lasel.bugking.ijm.Login.class);
                startActivity(intent);
            } else if(result.equals("[연결성공]0001")){
                Toast.makeText(Registration.this, "아이디가 중복되었어요.", Toast.LENGTH_SHORT).show();
            } else{
                Toast.makeText(Registration.this, "인터넷 연결상태를 확인해 주세요.", Toast.LENGTH_SHORT).show();

            }
            Log.d(TAG, "POST response  - " + result);
        }


        @Override
        protected String doInBackground(String... params) {

            String id = (String)params[0];
            String pwd = (String)params[1];
            String serverURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_registration.php";
            String postParameters = "id=" + id + "&pwd=" + pwd;

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

